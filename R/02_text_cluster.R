# RQ1 and RQ3: transparent text descriptions and exploratory content clustering.
# Inputs are never overwritten. Additional package needed: cluster.
# Dictionary hits are candidate mentions, not hand-validated codes, endorsement,
# sentiment, or the missing RQ2 variable verification_specific.

# Frozen Snowball English list (the source used for tm::stopwords("en"));
# source: https://snowballstem.org/algorithms/english/stop.txt .
# Literal storage avoids stopword changes across package versions or machines.
.text_stopwords <- c(
  "i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your",
  "yours", "yourself", "yourselves", "he", "him", "his", "himself", "she", "her",
  "hers", "herself", "it", "its", "itself", "they", "them", "their", "theirs",
  "themselves", "what", "which", "who", "whom", "this", "that", "these", "those",
  "am", "is", "are", "was", "were", "be", "been", "being", "have", "has", "had",
  "having", "do", "does", "did", "doing", "would", "should", "could", "ought",
  "i'm", "you're", "he's", "she's", "it's", "we're", "they're", "i've", "you've",
  "we've", "they've", "i'd", "you'd", "he'd", "she'd", "we'd", "they'd", "i'll",
  "you'll", "he'll", "she'll", "we'll", "they'll", "isn't", "aren't", "wasn't",
  "weren't", "hasn't", "haven't", "hadn't", "doesn't", "don't", "didn't", "won't",
  "wouldn't", "shan't", "shouldn't", "can't", "cannot", "couldn't", "mustn't",
  "let's", "that's", "who's", "what's", "here's", "there's", "when's", "where's",
  "why's", "how's", "a", "an", "the", "and", "but", "if", "or", "because", "as",
  "until", "while", "of", "at", "by", "for", "with", "about", "against", "between",
  "into", "through", "during", "before", "after", "above", "below", "to", "from",
  "up", "down", "in", "out", "on", "off", "over", "under", "again", "further",
  "then", "once", "here", "there", "when", "where", "why", "how", "all", "any",
  "both", "each", "few", "more", "most", "other", "some", "such", "no", "nor",
  "not", "only", "own", "same", "so", "than", "too", "very"
)

.text_normalise <- function(x) {
  x <- enc2utf8(as.character(x))
  x[is.na(x)] <- ""
  # ASCII case conversion is stable across operating-system locales.
  x <- chartr("ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz", x)
  x <- gsub("https?://[^[:space:]<>]+|www\\.[^[:space:]<>]+", " ", x,
            perl = TRUE)
  x <- gsub("[\u2018\u2019]", "'", x, perl = TRUE)
  x <- gsub("\\bwon't\\b", "will not", x, perl = TRUE)
  x <- gsub("\\bcan't\\b|\\bcannot\\b", "can not", x, perl = TRUE)
  x <- gsub("\\bshan't\\b", "shall not", x, perl = TRUE)
  x <- gsub("n't\\b", " not", x, perl = TRUE)
  x <- gsub("'re\\b", " are", x, perl = TRUE)
  x <- gsub("'ve\\b", " have", x, perl = TRUE)
  x <- gsub("'ll\\b", " will", x, perl = TRUE)
  x <- gsub("'m\\b", " am", x, perl = TRUE)
  x <- gsub("'d\\b", " would", x, perl = TRUE)
  x <- gsub("'s\\b", " ", x, perl = TRUE)
  x <- gsub("[^a-z]+", " ", x, perl = TRUE)
  trimws(gsub(" +", " ", x))
}

.text_dtm <- function(tokens, ids) {
  vocabulary <- sort(unique(unlist(tokens, use.names = FALSE)))
  out <- matrix(0, nrow = length(tokens), ncol = length(vocabulary),
                dimnames = list(as.character(ids), vocabulary))
  for (i in seq_along(tokens)) {
    if (length(tokens[[i]]) > 0L) {
      counts <- table(tokens[[i]])
      out[i, match(names(counts), vocabulary)] <- as.numeric(counts)
    }
  }
  out
}

.text_dictionary <- function() {
  data.frame(
    category = c("reading_inspection", "execution_testing", "static_type",
                 "formal_verification", "responsibility_ownership",
                 "understanding_trust"),
    label = c("Reading / inspection", "Execution / testing", "Static / type checks",
              "Formal verification", "Responsibility / ownership",
              "Understanding / trust"),
    pattern = c(
      paste0("\\b(?:read|reading|review|reviewing|inspect|inspecting|inspection)\\b",
             "(?:\\s+[a-z]+){0,3}\\s+\\b(?:code|diffs?|patch(?:es)?|",
             "implementations?|pull requests?)\\b|",
             "\\bcode\\s+(?:reviews?|reviewing|inspection)\\b|\\bpeer\\s+review\\b"),
      paste0("\\b(?:tests?|testing|tested|debug|debugging|debugged|benchmarks?)\\b|",
             "\\b(?:run|running|execute|executing)\\b(?:\\s+[a-z]+){0,3}\\s+",
             "\\b(?:code|programs?|scripts?|tests?)\\b"),
      paste0("\\b(?:static\\s+(?:analysis|analy[sz]ers?|checking)|",
             "type\\s+check(?:s|ing|er|ers)?|linters?|linting|mypy|pyright)\\b"),
      paste0("\\b(?:formal\\s+(?:verification|methods?|proofs?)|model\\s+checking|",
             "theorem\\s+prov(?:ers?|ing)|proof\\s+assistants?)\\b"),
      paste0("\\b(?:responsib(?:le|ility|ilities)|accountab(?:le|ility)|",
             "liability|liable|ownership|owning)\\b|",
             "\\b(?:own|owns)\\s+(?:the\\s+)?code\\b"),
      paste0("\\b(?:understand|understands|understanding|understood|trust|",
             "trusting|trusted|distrust|confidence|confident)\\b")
    ), stringsAsFactors = FALSE
  )
}

# Returns: frequencies(term, frequency, documents); dictionary(category,label,
# pattern); candidate_flags(comment_id + six logical columns); candidate_hits
# (long form, first matching phrase); candidate_summary; document_summary;
# tokens (named, aligned to comments); normalised_text; stopwords; settings.
analyse_text <- function(comments) {
  if (!all(c("comment_id", "text") %in% names(comments))) {
    stop("Text analysis requires comment_id and text.")
  }
  ids <- as.character(comments$comment_id)
  if (anyNA(ids) || anyDuplicated(ids)) stop("comment_id must be unique and non-missing.")
  normalised <- .text_normalise(comments$text)
  # Expand contractions before removing stopwords, retaining explicit negators.
  stop_words <- setdiff(unique(c(.text_stopwords, "re", "ve", "ll")),
                        c("no", "not", "never", "nor"))
  tokens <- strsplit(normalised, " +", perl = TRUE)
  tokens <- lapply(tokens, function(z) z[nchar(z) >= 2L & !z %in% stop_words])
  names(tokens) <- ids
  dtm <- .text_dtm(tokens, ids)
  frequencies <- data.frame(term = colnames(dtm),
                            frequency = as.integer(colSums(dtm)),
                            documents = as.integer(colSums(dtm > 0)),
                            stringsAsFactors = FALSE)
  frequencies <- frequencies[order(-frequencies$frequency, frequencies$term), ]
  rownames(frequencies) <- NULL
  dictionary <- .text_dictionary()
  flags <- data.frame(comment_id = ids, stringsAsFactors = FALSE)
  hit_rows <- vector("list", nrow(dictionary))
  for (j in seq_len(nrow(dictionary))) {
    hit <- grepl(dictionary$pattern[j], normalised, perl = TRUE)
    flags[[dictionary$category[j]]] <- hit
    matches <- rep(NA_character_, length(ids))
    if (any(hit)) {
      matches[hit] <- regmatches(normalised[hit],
                                regexpr(dictionary$pattern[j], normalised[hit],
                                        perl = TRUE))
    }
    hit_rows[[j]] <- data.frame(comment_id = ids, category = dictionary$category[j],
                                hit = hit, first_match = matches,
                                stringsAsFactors = FALSE)
  }
  candidate_summary <- dictionary[, c("category", "label")]
  candidate_summary$n_comments <- vapply(dictionary$category,
                                         function(z) sum(flags[[z]]), integer(1))
  candidate_summary$total_comments <- nrow(comments)
  candidate_summary$percentage <- 100 * candidate_summary$n_comments / nrow(comments)
  original_text <- as.character(comments$text)
  original_text[is.na(original_text)] <- ""
  document_summary <- data.frame(
    comment_id = ids, n_tokens = lengths(tokens),
    n_unique_tokens = vapply(tokens, function(z) length(unique(z)), integer(1)),
    has_quote_marker = grepl(">|[\u201c\u201d]", original_text,
                             perl = TRUE),
    has_url = grepl("https?://|www\\.", original_text, perl = TRUE),
    stringsAsFactors = FALSE
  )
  list(frequencies = frequencies, dictionary = dictionary, candidate_flags = flags,
       candidate_hits = do.call(rbind, hit_rows), candidate_summary = candidate_summary,
       document_summary = document_summary, tokens = tokens,
       normalised_text = stats::setNames(normalised, ids), stopwords = sort(stop_words),
       settings = list(language = "English ASCII word tokens", minimum_token_length = 2L,
                       stemming = FALSE, quotes = "retained",
                       candidate_categories = "non-exclusive unvalidated mentions",
                       n_comments = nrow(comments),
                       n_nonempty_documents = sum(lengths(tokens) > 0L)))
}

# Deterministic average-link hierarchical clustering on cosine dissimilarity.
# No arbitrary semantic cluster names are assigned: terms and examples are
# exported for human inspection. An analyst may override k only after reviewing
# diagnostics and recording the reason in the report.
# Returns assignments for ALL input IDs (NA for excluded documents), diagnostics,
# cluster_terms, examples, cluster_summary, cluster_thread, exclusions,
# dendrogram, distance, silhouette, tfidf, settings, and selected_k.
analyse_clusters <- function(comments, text_analysis, k_override = NULL) {
  if (!requireNamespace("cluster", quietly = TRUE)) {
    stop("Package 'cluster' is required. Run the project setup script first.")
  }
  if (!all(c("comment_id", "thread_id", "text") %in% names(comments))) {
    stop("Clustering requires comment_id, thread_id and text.")
  }
  ids <- as.character(comments$comment_id)
  if (!setequal(ids, names(text_analysis$tokens))) {
    stop("Text-analysis IDs and comment IDs differ; do not join by row position.")
  }
  # These broad corpus terms are omitted ONLY for clustering, never from RQ1.
  domain_stopwords <- c("ai", "code", "llm", "llms", "model", "models",
                        "generated", "generative")
  tokens <- lapply(text_analysis$tokens[ids], function(z) z[!z %in% domain_stopwords])
  lengths_before_df <- lengths(tokens)
  eligible <- lengths_before_df >= 5L
  exclusions <- data.frame(comment_id = ids[!eligible],
                            reason = rep("Fewer than five retained cluster tokens",
                                         sum(!eligible)), stringsAsFactors = FALSE)
  eligible_ids <- sort(ids[eligible])
  if (length(eligible_ids) < 3L) stop("Fewer than three texts are eligible for clustering.")
  counts <- .text_dtm(tokens[eligible_ids], eligible_ids)
  initial_n <- nrow(counts)
  document_frequency <- colSums(counts > 0)
  keep_terms <- document_frequency >= 2L & document_frequency <= 0.8 * initial_n
  counts <- counts[, keep_terms, drop = FALSE]
  if (!ncol(counts)) stop("No terms remain after document-frequency filtering.")
  nonempty <- rowSums(counts) > 0
  if (any(!nonempty)) {
    exclusions <- rbind(exclusions, data.frame(
      comment_id = rownames(counts)[!nonempty],
      reason = "No retained vocabulary after document-frequency filtering",
      stringsAsFactors = FALSE))
    counts <- counts[nonempty, , drop = FALSE]
  }
  n <- nrow(counts)
  if (n < 3L) stop("Fewer than three non-empty vectors remain after filtering.")
  # Recompute IDF for the final document set, while retaining the stated initial
  # frequency-screen vocabulary. No omitted author/thread field enters vectors.
  document_frequency <- colSums(counts > 0)
  idf <- log(n / document_frequency)
  counts <- counts[, idf > 0, drop = FALSE]
  idf <- idf[idf > 0]
  if (!length(idf)) stop("All retained words occur in every retained document.")
  tf <- counts
  tf[counts > 0] <- 1 + log(counts[counts > 0])
  tfidf <- sweep(tf, 2L, idf, "*")
  norms <- sqrt(rowSums(tfidf^2))
  if (any(norms == 0)) stop("A zero TF-IDF vector remains; inspect vocabulary filtering.")
  tfidf <- tfidf / norms
  cosine <- tcrossprod(tfidf)
  distance_matrix <- 1 - cosine
  distance_matrix[distance_matrix < 0] <- 0
  distance_matrix[distance_matrix > 1] <- 1
  diag(distance_matrix) <- 0
  dimnames(distance_matrix) <- list(rownames(tfidf), rownames(tfidf))
  distance <- stats::as.dist(distance_matrix)
  attr(distance, "method") <- "cosine dissimilarity"
  tree <- stats::hclust(distance, method = "average")
  candidate_k <- seq.int(2L, min(8L, n - 1L))
  diagnostic_rows <- lapply(candidate_k, function(k) {
    groups <- stats::cutree(tree, k = k)
    sil <- cluster::silhouette(groups, distance)
    sizes <- table(groups)
    data.frame(k = k, mean_silhouette = mean(sil[, "sil_width"]),
               minimum_size = min(sizes), maximum_size = max(sizes),
               admissible = min(sizes) >= 5L)
  })
  diagnostics <- do.call(rbind, diagnostic_rows)
  candidates <- which(diagnostics$admissible)
  used_fallback <- !length(candidates)
  if (used_fallback) candidates <- seq_len(nrow(diagnostics))
  # In a tie, the smaller k is selected because candidates are in ascending order.
  selected_row <- candidates[which.max(diagnostics$mean_silhouette[candidates])]
  selected_k <- diagnostics$k[selected_row]
  selection_reason <- if (used_fallback) {
    "No tested k had all clusters of at least five documents; highest silhouette fallback."
  } else {
    "Highest average silhouette among tested k with every cluster containing at least five documents."
  }
  if (!is.null(k_override)) {
    if (length(k_override) != 1L || is.na(k_override) ||
        !k_override %in% candidate_k) stop("k_override must be one of the tested k values.")
    selected_k <- as.integer(k_override)
    selection_reason <- "Analyst override; a written reason is required in the report."
  }
  diagnostics$selected <- diagnostics$k == selected_k
  groups <- stats::cutree(tree, k = selected_k)
  sil <- cluster::silhouette(groups, distance)
  assignments <- data.frame(comment_id = ids,
                            cluster = unname(groups[ids]),
                            retained_tokens = as.integer(lengths_before_df),
                            silhouette_width = NA_real_, stringsAsFactors = FALSE)
  assignments$silhouette_width[match(names(groups), ids)] <- sil[, "sil_width"]
  cluster_ids <- sort(unique(groups))
  term_rows <- vector("list", length(cluster_ids))
  example_rows <- vector("list", length(cluster_ids))
  summary_rows <- vector("list", length(cluster_ids))
  for (j in seq_along(cluster_ids)) {
    g <- cluster_ids[j]
    index <- which(groups == g)
    mean_weights <- colMeans(tfidf[index, , drop = FALSE])
    top <- order(-mean_weights, names(mean_weights))
    top <- head(top[mean_weights[top] > 0], 6L)
    term_rows[[j]] <- data.frame(cluster = g, rank = seq_along(top),
                                 term = names(mean_weights)[top],
                                 mean_tfidf = unname(mean_weights[top]),
                                 stringsAsFactors = FALSE)
    medoid <- index[which.min(rowMeans(distance_matrix[index, index, drop = FALSE]))]
    boundary <- index[which.min(sil[index, "sil_width"])]
    example_index <- c(medoid, boundary)
    example_ids <- names(groups)[example_index]
    original_index <- match(example_ids, ids)
    example_rows[[j]] <- data.frame(
      cluster = g, role = c("medoid", "lowest_silhouette"), comment_id = example_ids,
      thread_id = as.character(comments$thread_id[original_index]),
      silhouette_width = sil[example_index, "sil_width"],
      text = as.character(comments$text[original_index]), stringsAsFactors = FALSE
    )
    summary_rows[[j]] <- data.frame(
      cluster = g, n_comments = length(index),
      percentage = 100 * length(index) / n,
      mean_silhouette = mean(sil[index, "sil_width"]),
      median_retained_tokens = stats::median(lengths_before_df[match(names(groups)[index], ids)]),
      top_terms = paste(names(mean_weights)[top], collapse = ", "),
      stringsAsFactors = FALSE
    )
  }
  grouped_ids <- names(groups)
  thread_lookup <- as.character(comments$thread_id[match(grouped_ids, ids)])
  cluster_thread <- as.data.frame(table(cluster = groups, thread_id = thread_lookup),
                                   stringsAsFactors = FALSE)
  names(cluster_thread)[3L] <- "n_comments"
  cluster_thread$cluster <- as.integer(as.character(cluster_thread$cluster))
  cluster_thread$thread_id <- as.character(cluster_thread$thread_id)
  list(assignments = assignments, diagnostics = diagnostics,
       cluster_terms = do.call(rbind, term_rows), examples = do.call(rbind, example_rows),
       cluster_summary = do.call(rbind, summary_rows), cluster_thread = cluster_thread,
       exclusions = exclusions, dendrogram = tree, distance = distance,
       silhouette = sil, tfidf = tfidf, selected_k = selected_k,
       settings = list(n_input = nrow(comments), n_initial_eligible = initial_n,
                       n_clustered = n, n_excluded = nrow(exclusions),
                       n_terms = ncol(tfidf), minimum_tokens = 5L,
                       minimum_document_frequency = 2L,
                       maximum_document_proportion = 0.8,
                       tf = "1 + log(count) for nonzero counts", idf = "log(n / df)",
                       normalisation = "L2 row norm", distance = "cosine dissimilarity",
                       linkage = "average", candidate_k = candidate_k,
                       domain_stopwords = domain_stopwords,
                       selection_reason = selection_reason,
                       used_fallback = used_fallback,
                       selected_mean_silhouette = mean(sil[, "sil_width"]),
                       seed_required = FALSE))
}

plot_text_frequencies <- function(text_analysis, n = 20L) {
  d <- utils::head(text_analysis$frequencies, n)
  if (!nrow(d)) { graphics::plot.new(); return(invisible(NULL)) }
  d <- d[nrow(d):1L, ]
  old <- graphics::par(mar = c(4, 8, 3, 1))
  on.exit(graphics::par(old))
  graphics::barplot(d$frequency, names.arg = d$term, horiz = TRUE, las = 1,
                    col = "#226B8E", border = NA, cex.names = 0.8,
                    xlab = "Occurrences across retained comments",
                    main = "Most frequent retained words")
  invisible(d)
}

plot_candidate_mentions <- function(text_analysis) {
  d <- text_analysis$candidate_summary
  d <- d[order(d$n_comments, d$label), ]
  old <- graphics::par(mar = c(4, 12, 3, 2))
  on.exit(graphics::par(old))
  maximum <- max(1, d$n_comments)
  mid <- graphics::barplot(d$n_comments, names.arg = d$label, horiz = TRUE,
                           las = 1, col = "#248478", border = NA, cex.names = 0.85,
                           xlim = c(0, maximum * 1.27),
                           xlab = "Comments with a candidate mention (non-exclusive)",
                           main = "Dictionary-assisted description")
  graphics::text(d$n_comments, mid,
                  labels = sprintf(" %d (%.1f%%)", d$n_comments, d$percentage),
                  pos = 4, cex = 0.75)
  invisible(d)
}

plot_cluster_diagnostics <- function(cluster_analysis) {
  d <- cluster_analysis$diagnostics
  old <- graphics::par(mfrow = c(1, 2), mar = c(4, 4, 3, 1))
  on.exit(graphics::par(old))
  graphics::plot(d$k, d$mean_silhouette, type = "b", pch = 16,
                 col = "#226B8E", xaxt = "n", xlab = "Number of clusters (k)",
                 ylab = "Average silhouette width", main = "Separation diagnostic")
  graphics::axis(1, at = d$k)
  graphics::points(d$k[!d$admissible], d$mean_silhouette[!d$admissible],
                   pch = 4, col = "#A14832", cex = 1.4, lwd = 2)
  graphics::points(d$k[d$selected], d$mean_silhouette[d$selected],
                   pch = 21, bg = "#248478", cex = 1.6)
  graphics::plot(d$k, d$minimum_size, type = "b", pch = 16, col = "#226B8E",
                 xaxt = "n", xlab = "Number of clusters (k)",
                 ylab = "Smallest cluster size", main = "Size diagnostic",
                 ylim = range(c(0, 5, d$minimum_size)))
  graphics::axis(1, at = d$k)
  graphics::abline(h = 5, lty = 2, col = "#A14832")
  invisible(d)
}

plot_cluster_dendrogram <- function(cluster_analysis) {
  old <- graphics::par(mar = c(3, 4, 3, 1))
  on.exit(graphics::par(old))
  graphics::plot(cluster_analysis$dendrogram, labels = FALSE, hang = -1,
                 main = "Average-link hierarchy of comment vocabulary",
                 xlab = "Retained comments (leaf labels omitted)",
                 ylab = "Cosine dissimilarity", sub = "")
  stats::rect.hclust(cluster_analysis$dendrogram, k = cluster_analysis$selected_k,
                    border = grDevices::hcl.colors(cluster_analysis$selected_k, "Dark 3"))
  invisible(cluster_analysis$dendrogram)
}

plot_cluster_silhouette <- function(cluster_analysis) {
  graphics::plot(cluster_analysis$silhouette, nmax.lab = 0,
                 main = "Silhouette widths for the selected partition",
                 col = grDevices::hcl.colors(cluster_analysis$selected_k, "Dark 3"),
                 border = NA)
  invisible(cluster_analysis$silhouette)
}

plot_cluster_thread <- function(cluster_analysis) {
  d <- cluster_analysis$cluster_thread
  counts <- stats::xtabs(n_comments ~ thread_id + cluster, data = d)
  proportions <- sweep(counts, 2L, colSums(counts), "/")
  colours <- grDevices::hcl.colors(nrow(proportions), "Dark 3")
  old <- graphics::par(mar = c(4, 4, 3, 7), xpd = NA)
  on.exit(graphics::par(old))
  graphics::barplot(proportions, col = colours, border = NA, ylim = c(0, 1),
                    xlab = "Cluster", ylab = "Share of comments within cluster",
                    main = "Thread composition of each cluster")
  graphics::legend("topright", inset = c(-0.35, 0),
                    legend = rownames(proportions), fill = colours,
                    title = "Thread ID", bty = "n", cex = 0.7)
  invisible(proportions)
}

# Sensitivity is descriptive. Ward.D2 uses Euclidean distance on L2-normalised
# vectors, NOT cosine dissimilarity as a drop-in distance for Ward's criterion.
cluster_linkage_sensitivity <- function(cluster_analysis) {
  cosine <- cluster_analysis$distance
  euclidean <- stats::dist(cluster_analysis$tfidf, method = "euclidean")
  methods <- list(
    average_cosine = list(method = "average", distance = cosine),
    complete_cosine = list(method = "complete", distance = cosine),
    ward_euclidean = list(method = "ward.D2", distance = euclidean))
  rows <- lapply(names(methods), function(name) {
    spec <- methods[[name]]
    tree <- stats::hclust(spec$distance, method = spec$method)
    do.call(rbind, lapply(cluster_analysis$settings$candidate_k, function(k) {
      groups <- stats::cutree(tree, k = k)
      sil <- cluster::silhouette(groups, spec$distance)
      sizes <- table(groups)
      data.frame(method = name, k = k, mean_silhouette = mean(sil[, "sil_width"]),
        minimum_size = min(sizes), maximum_size = max(sizes),
        sizes = paste(sort(as.integer(sizes), decreasing = TRUE), collapse = "/"),
        admissible = min(sizes) >= 5L, stringsAsFactors = FALSE)
    }))
  })
  result <- do.call(rbind, rows)
  rownames(result) <- NULL
  result$selected_within_method <- FALSE
  for (name in names(methods)) {
    ix <- which(result$method == name)
    good <- ix[result$admissible[ix]]
    if (!length(good)) good <- ix
    result$selected_within_method[good[which.max(result$mean_silhouette[good])]] <- TRUE
  }
  result
}
