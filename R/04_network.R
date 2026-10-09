# RQ4: directed, author-level replies and the RQ3/RQ4 content bridge.
# This file defines functions only: it does not load data, change directories,
# download anything, or write output. All paths belong in the calling report.
# Required package: igraph. Other functions use base R.
#
# Design decisions preserving the supplied teammate report:
# * A -> B means A replied directly to a retained comment written by B.
# * Only authors occurring in retained between-author edges become vertices.
# * Multiple replies between the same authors become one directed edge.
# * Reply frequency is stored as `frequency`, NOT `weight`: a count is not a
#   shortest-path distance. Betweenness is explicitly unweighted and normalised.
# * Top-level story replies and unavailable comment parents produce no edge.
# * Self-replies, if present in a future dataset, remain in reply_events but are
#   excluded from this between-author graph; the supplied dataset has none.
#
# References for implementation choices:
# https://r.igraph.org/reference/betweenness.html
# https://r.igraph.org/reference/edge_density.html
# https://r.igraph.org/reference/layout_with_fr.html

.nw_require_igraph <- function() {
  if (!requireNamespace("igraph", quietly = TRUE)) {
    stop("Package 'igraph' is required. Run the project's setup instructions first.",
         call. = FALSE)
  }
}

.nw_validate_comments <- function(comments) {
  if (!is.data.frame(comments)) {
    stop("comments must be a data.frame.", call. = FALSE)
  }
  required <- c("comment_id", "parent_id", "thread_id", "author")
  absent <- setdiff(required, names(comments))
  if (length(absent)) {
    stop("Missing comment columns: ", paste(absent, collapse = ", "), call. = FALSE)
  }
  # Character IDs prevent factor-level joins and preserve identifiers as keys.
  for (column in required) comments[[column]] <- as.character(comments[[column]])
  for (column in c("comment_id", "thread_id", "author")) {
    if (anyNA(comments[[column]]) || any(!nzchar(trimws(comments[[column]])))) {
      stop(column, " must contain a non-empty value for every retained comment.",
           call. = FALSE)
    }
  }
  if (anyDuplicated(comments$comment_id)) {
    stop("comment_id must be unique before constructing replies.", call. = FALSE)
  }
  # Treat a blank parent as missing, while retaining it in the exclusions audit.
  blank_parent <- !is.na(comments$parent_id) & !nzchar(trimws(comments$parent_id))
  comments$parent_id[blank_parent] <- NA_character_
  comments
}

.nw_clean_reply_outcome <- function(comments) {
  # Outcome used throughout the project: a retained comment has at least one
  # direct reply which is ALSO in the current cleaned corpus.
  observed <- comments$comment_id %in% comments$parent_id[!is.na(comments$parent_id)]
  if ("received_reply" %in% names(comments)) {
    supplied <- toupper(trimws(as.character(comments$received_reply)))
    if (anyNA(supplied) || any(!supplied %in% c("TRUE", "FALSE"))) {
      stop("received_reply must be non-missing TRUE/FALSE values.", call. = FALSE)
    }
    if (!identical(unname(supplied == "TRUE"), unname(observed))) {
      stop("received_reply disagrees with the retained-clean direct-reply definition.",
           " Reconcile the dataset version before analysis.", call. = FALSE)
    }
  }
  observed
}

.nw_reply_matches <- function(comments) {
  parent_index <- match(comments$parent_id, comments$comment_id)
  matched <- !is.na(parent_index)
  if (any(comments$thread_id[matched] != comments$thread_id[parent_index[matched]])) {
    stop("A matched child and parent have different thread_id values.", call. = FALSE)
  }
  events <- data.frame(
    child_id = comments$comment_id[matched],
    parent_id = comments$parent_id[matched],
    thread_id = comments$thread_id[matched],
    child_author = comments$author[matched],
    parent_author = comments$author[parent_index[matched]],
    stringsAsFactors = FALSE
  )
  events$self_reply <- events$child_author == events$parent_author
  if (nrow(events)) {
    events <- events[order(events$child_id, method = "radix"), , drop = FALSE]
    rownames(events) <- NULL
  }
  unmatched <- comments[!matched, c("comment_id", "parent_id", "thread_id", "author"),
                        drop = FALSE]
  unmatched$reason <- "parent_not_in_clean"
  is_story <- !is.na(unmatched$parent_id) & unmatched$parent_id == unmatched$thread_id
  unmatched$reason[is_story] <- "story_root"
  unmatched$reason[is.na(unmatched$parent_id)] <- "missing_parent_id"
  reasons <- c("story_root", "parent_not_in_clean", "missing_parent_id")
  reason_counts <- data.frame(
    reason = reasons,
    comments = as.integer(table(factor(unmatched$reason, levels = reasons))),
    stringsAsFactors = FALSE
  )
  list(reply_events = events, unmatched = unmatched, unmatched_counts = reason_counts)
}

.nw_component_table <- function(component, n_vertices) {
  result <- data.frame(
    component = seq_along(component$csize),
    authors = as.integer(component$csize),
    share = if (n_vertices) as.numeric(component$csize) / n_vertices else numeric(0)
  )
  result[order(-result$authors, result$component), , drop = FALSE]
}

.nw_layout <- function(graph, seed) {
  n <- igraph::vcount(graph)
  if (!n) return(matrix(numeric(0), ncol = 2))
  if (n == 1L) return(matrix(c(0, 0), nrow = 1))
  # Preserve the caller's RNG state: plotting should not alter later clustering.
  had_seed <- exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
  if (had_seed) previous_seed <- get(".Random.seed", envir = .GlobalEnv)
  on.exit({
    if (had_seed) {
      assign(".Random.seed", previous_seed, envir = .GlobalEnv)
    } else if (exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)) {
      rm(".Random.seed", envir = .GlobalEnv)
    }
  }, add = TRUE)
  set.seed(seed)
  # No weight attribute is present. Equal edge weights explicitly ensure the
  # visual layout does not silently treat reply frequency as attraction strength.
  igraph::layout_with_fr(graph, niter = 1000L,
                        weights = rep(1, igraph::ecount(graph)), grid = "nogrid")
}

analyse_network <- function(comments, seed = 3020L) {
  .nw_require_igraph()
  comments <- .nw_validate_comments(comments)
  received_reply <- .nw_clean_reply_outcome(comments)
  matches <- .nw_reply_matches(comments)
  reply_events <- matches$reply_events
  between_authors <- reply_events[!reply_events$self_reply, , drop = FALSE]

  if (nrow(between_authors)) {
    author_edges <- stats::aggregate(
      list(frequency = rep.int(1L, nrow(between_authors))),
      by = list(from = between_authors$child_author,
                to = between_authors$parent_author), FUN = sum
    )
    author_edges <- author_edges[order(author_edges$from, author_edges$to,
                                       method = "radix"), , drop = FALSE]
    rownames(author_edges) <- NULL
  } else {
    author_edges <- data.frame(from = character(), to = character(),
                               frequency = integer(), stringsAsFactors = FALSE)
  }

  all_authors <- sort(unique(comments$author), method = "radix")
  observed_authors <- sort(unique(c(author_edges$from, author_edges$to)), method = "radix")
  # Supplying only edge participants is intentional. Adding all authors as isolates
  # would change density and normalised betweenness relative to the teammate PDF.
  graph <- igraph::graph_from_data_frame(
    author_edges, directed = TRUE,
    vertices = data.frame(name = observed_authors, stringsAsFactors = FALSE)
  )
  n_vertices <- igraph::vcount(graph)
  n_edges <- igraph::ecount(graph)
  weak <- igraph::components(graph, mode = "weak")
  strong <- igraph::components(graph, mode = "strong")
  # No graph weight attribute is created. weights = NA additionally requests the
  # unweighted calculation, making the convention explicit even if code changes.
  between <- if (n_vertices > 2L) {
    igraph::betweenness(graph, directed = TRUE, weights = NA, normalized = TRUE)
  } else {
    rep(0, n_vertices)
  }
  node_metrics <- data.frame(
    author = igraph::vertex_attr(graph, "name"),
    indegree = as.integer(igraph::degree(graph, mode = "in", loops = FALSE)),
    outdegree = as.integer(igraph::degree(graph, mode = "out", loops = FALSE)),
    instrength = as.numeric(igraph::strength(
      graph, mode = "in", loops = FALSE,
      weights = igraph::edge_attr(graph, "frequency")
    )),
    betweenness = as.numeric(between),
    weak_component = as.integer(weak$membership),
    strong_component = as.integer(strong$membership),
    stringsAsFactors = FALSE
  )
  node_metrics <- node_metrics[order(-node_metrics$indegree, -node_metrics$betweenness,
                                     node_metrics$author, method = "radix"), , drop = FALSE]
  rownames(node_metrics) <- NULL
  weak_table <- .nw_component_table(weak, n_vertices)
  strong_table <- .nw_component_table(strong, n_vertices)
  largest_weak <- if (length(weak$csize)) max(weak$csize) else 0L
  largest_strong <- if (length(strong$csize)) max(strong$csize) else 0L
  lcc_members <- if (n_vertices) which(weak$membership == which.max(weak$csize)) else integer()
  lcc_graph <- igraph::induced_subgraph(graph, vids = lcc_members)
  excluded_authors <- setdiff(all_authors, observed_authors)

  summary <- data.frame(
    metric = c("Clean comments", "Authors in clean corpus", "Matched reply events",
               "Self-reply events", "Between-author reply events", "Network authors",
               "Unique directed author pairs", "Density", "Weak components",
               "Largest weak component", "Largest weak component share",
               "Strong components", "Largest strong component", "Authors outside graph"),
    value = c(nrow(comments), length(all_authors), nrow(reply_events),
              sum(reply_events$self_reply), nrow(between_authors), n_vertices,
              n_edges, if (n_vertices > 1L) igraph::edge_density(graph, loops = FALSE) else NA_real_,
              weak$no, largest_weak, if (n_vertices) largest_weak / n_vertices else NA_real_,
              strong$no, largest_strong, length(excluded_authors)),
    stringsAsFactors = FALSE
  )
  structure(list(
    graph = graph,
    lcc_graph = lcc_graph,
    author_edges = author_edges,
    reply_events = reply_events,
    node_metrics = node_metrics,
    summary = summary,
    weak_components = weak_table,
    strong_components = strong_table,
    unmatched = matches$unmatched,
    unmatched_counts = matches$unmatched_counts,
    excluded_authors = excluded_authors,
    received_reply = data.frame(comment_id = comments$comment_id,
                                received_reply = received_reply,
                                stringsAsFactors = FALSE),
    layout_full = .nw_layout(graph, seed),
    layout_lcc = .nw_layout(lcc_graph, seed),
    seed = seed,
    definitions = c(
      direction = "replying author -> author of the parent comment",
      population = "authors appearing in retained between-author edges",
      edge_attribute = "frequency: count of reply events, not distance",
      betweenness = "directed, unweighted, normalised over the full author graph",
      outcome = "at least one direct reply retained in the clean corpus"
    )
  ), class = c("hn_reply_network", "list"))
}

.nw_plot_graph <- function(graph, layout, main, labels = NULL) {
  if (!igraph::vcount(graph)) {
    graphics::plot.new()
    graphics::title(main = main)
    graphics::text(0.5, 0.5, "No between-author replies in this subset.")
    return(invisible(NULL))
  }
  old_par <- graphics::par(mar = c(1.2, 1, 3.2, 1))
  on.exit(graphics::par(old_par), add = TRUE)
  if (is.null(labels)) labels <- rep(NA_character_, igraph::vcount(graph))
  plot(graph, layout = layout, main = main,
       vertex.size = 4.2, vertex.color = "#287C8E", vertex.frame.color = "#FFFFFF",
       vertex.label = labels, vertex.label.cex = 0.72,
       vertex.label.color = "#173442", vertex.label.dist = 0.7,
       edge.color = "#73838E88", edge.width = 0.7,
       edge.arrow.size = 0.24, edge.arrow.width = 0.6,
       edge.curved = 0.08, margin = 0.15)
  graphics::mtext("Arrow: replying author -> parent author; nodes have equal size.",
                  side = 1, line = 0.15, cex = 0.7, col = "#465462")
  invisible(layout)
}

plot_network_full <- function(network, main = NULL) {
  .nw_require_igraph()
  if (is.null(main)) {
    main <- sprintf("Full reply network: %s authors, %s directed pairs",
                    igraph::vcount(network$graph), igraph::ecount(network$graph))
  }
  .nw_plot_graph(network$graph, network$layout_full, main)
}

plot_network_lcc <- function(network, label_count = 6L, main = NULL) {
  .nw_require_igraph()
  graph <- network$lcc_graph
  vertex_names <- igraph::vertex_attr(graph, "name")
  ranked <- network$node_metrics$author[network$node_metrics$author %in% vertex_names]
  labelled <- utils::head(ranked, max(0L, as.integer(label_count)))
  labels <- ifelse(vertex_names %in% labelled, vertex_names, NA_character_)
  if (is.null(main)) {
    main <- sprintf("Largest weak component: %s authors", igraph::vcount(graph))
  }
  # Label selection uses full-network indegree, then full-network betweenness.
  # Uniform node size avoids suggesting an author has one unique content cluster.
  .nw_plot_graph(graph, network$layout_lcc, main, labels)
}

plot_indegree_distribution <- function(network) {
  degree_values <- network$node_metrics$indegree
  if (!length(degree_values)) {
    graphics::plot.new()
    graphics::title("In-degree distribution: no network authors")
    return(invisible(NULL))
  }
  counts <- table(factor(degree_values, levels = 0:max(degree_values)))
  graphics::barplot(counts, col = "#287C8E", border = NA,
                    xlab = "Distinct authors replying to an author (in-degree)",
                    ylab = "Number of network authors", main = "In-degree distribution",
                    las = 1)
  invisible(counts)
}

analyse_cluster_replies <- function(comments, cluster_labels) {
  # Descriptive bridge between RQ3 and RQ4; it is not an additional hypothesis test.
  # Required label-table columns: comment_id, cluster. Missing labels are allowed
  # for comments excluded from text clustering. IDs must still be unique.
  comments <- .nw_validate_comments(comments)
  received_reply <- .nw_clean_reply_outcome(comments)
  if (!is.data.frame(cluster_labels) ||
      !all(c("comment_id", "cluster") %in% names(cluster_labels))) {
    stop("cluster_labels must be a data.frame with comment_id and cluster columns.",
         call. = FALSE)
  }
  labels <- cluster_labels[, c("comment_id", "cluster"), drop = FALSE]
  labels$comment_id <- as.character(labels$comment_id)
  labels$cluster <- as.character(labels$cluster)
  if (anyNA(labels$comment_id) || any(!nzchar(trimws(labels$comment_id))) ||
      anyDuplicated(labels$comment_id)) {
    stop("Cluster-label comment_id values must be non-missing and unique.", call. = FALSE)
  }
  if (any(!labels$comment_id %in% comments$comment_id)) {
    stop("Cluster-label IDs not found in the clean comments: check dataset versions.",
         call. = FALSE)
  }
  blank <- !is.na(labels$cluster) & !nzchar(trimws(labels$cluster))
  labels$cluster[blank] <- NA_character_
  comment_clusters <- labels$cluster[match(comments$comment_id, labels$comment_id)]
  groups <- sort(unique(comment_clusters[!is.na(comment_clusters)]), method = "radix")
  # All retained children contribute to a labelled receiver's outcome/event count,
  # even if that child itself was not eligible for clustering.
  child_counts <- tabulate(match(comments$parent_id, comments$comment_id),
                           nbins = nrow(comments))
  by_receiver <- lapply(groups, function(group) {
    keep <- !is.na(comment_clusters) & comment_clusters == group
    data.frame(
      cluster = group,
      comments = sum(keep),
      comments_receiving_reply = sum(received_reply[keep]),
      reply_rate = mean(received_reply[keep]),
      incoming_reply_events = sum(child_counts[keep]),
      stringsAsFactors = FALSE
    )
  })
  receiver_rates <- if (length(by_receiver)) do.call(rbind, by_receiver) else {
    data.frame(cluster = character(), comments = integer(),
               comments_receiving_reply = integer(), reply_rate = numeric(),
               incoming_reply_events = integer(), stringsAsFactors = FALSE)
  }

  reply_events <- .nw_reply_matches(comments)$reply_events
  reply_events$sender_cluster <- comment_clusters[match(reply_events$child_id, comments$comment_id)]
  reply_events$receiver_cluster <- comment_clusters[match(reply_events$parent_id, comments$comment_id)]
  eligible <- !is.na(reply_events$sender_cluster) & !is.na(reply_events$receiver_cluster)
  content_reply_matrix <- table(
    sender_cluster = factor(reply_events$sender_cluster[eligible], levels = groups),
    receiver_cluster = factor(reply_events$receiver_cluster[eligible], levels = groups)
  )
  list(
    receiver_rates = receiver_rates,
    content_reply_matrix = content_reply_matrix,
    reply_events_with_clusters = reply_events,
    coverage = data.frame(
      metric = c("Clean comments", "Comments with a cluster label",
                 "Comments without a cluster label", "Matched clean reply events",
                 "Reply events with both comments labelled",
                 "Reply events missing one or both labels"),
      value = c(nrow(comments), sum(!is.na(comment_clusters)), sum(is.na(comment_clusters)),
                nrow(reply_events), sum(eligible), sum(!eligible)),
      stringsAsFactors = FALSE
    ),
    definitions = c(
      rate = "labelled receiver comments with any retained direct reply / all comments in receiver cluster",
      matrix = "row = replying comment cluster; column = parent comment cluster; both labels required",
      inference = "descriptive results within the selected corpus; no causal claim or extra test"
    )
  )
}
