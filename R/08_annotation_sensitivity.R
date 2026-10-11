# A separate AI-assisted reading under an explicit rule. This is NOT a gold
# standard, an Excel-rule reconstruction, or replacement of teammate labels.
analyse_annotation_sensitivity <- function(comments, rq2, path) {
  if (!file.exists(path)) stop("Missing separate AI-assisted audit: ", path)
  a <- read.csv(path, colClasses = "character", stringsAsFactors = FALSE,
                fileEncoding = "UTF-8", check.names = FALSE)
  required <- c("comment_id", "assistant_label", "evidence", "rationale",
                "audit_rule_version", "reviewer_type")
  if (!all(required %in% names(a)) || anyNA(a[, required]) ||
      anyDuplicated(a$comment_id) ||
      !setequal(a$comment_id, comments$comment_id)) {
    stop("The separate annotation audit must cover each clean comment exactly once.")
  }
  a <- a[match(comments$comment_id, a$comment_id), , drop = FALSE]
  if (!all(a$assistant_label %in% c("TRUE", "FALSE", "AMBIGUOUS")) ||
      !all(a$audit_rule_version == "AI-SENS-v1") ||
      any(!nzchar(trimws(a$evidence))) || any(!nzchar(trimws(a$rationale)))) {
    stop("Invalid labels, rule versions or evidence in separate annotation audit.")
  }
  normalise <- function(x) trimws(gsub("[[:space:]]+", " ", enc2utf8(x), perl = TRUE))
  source <- normalise(comments$text)
  evidence <- normalise(a$evidence)
  matches <- vapply(seq_len(nrow(a)), function(i) {
    grepl(evidence[i], source[i], fixed = TRUE)
  }, logical(1))
  if (!all(matches)) stop("Audit evidence does not match source IDs: ",
                          paste(a$comment_id[!matches], collapse = ", "))
  if (!identical(rq2$joined$comment_id, comments$comment_id)) {
    stop("Annotation sensitivity requires the validated original ID join.")
  }
  a$original_label <- rq2$joined$verification_specific
  a$received_reply <- rq2$joined$received_reply
  a$thread_id <- comments$thread_id
  a$author <- comments$author
  a$source_text <- comments$text
  determinate <- a$assistant_label != "AMBIGUOUS"
  a$differs_from_original <- ifelse(determinate,
    a$assistant_label != as.character(a$original_label), NA)
  # These are declared scenarios, not guaranteed mathematical bounds.
  scenarios <- list(
    "Supplied labels: all comments" = a$original_label,
    "AI rule: determinate only" = ifelse(determinate, a$assistant_label == "TRUE", NA),
    "AI rule: ambiguous as FALSE" = a$assistant_label == "TRUE",
    "AI rule: ambiguous as TRUE" = a$assistant_label != "FALSE")
  summary <- do.call(rbind, lapply(names(scenarios), function(name) {
    x <- scenarios[[name]]
    keep <- !is.na(x)
    tab <- table(factor(x[keep], levels = c(FALSE, TRUE)),
                 factor(a$received_reply[keep], levels = c(FALSE, TRUE)))
    n <- rowSums(tab)
    rates <- ifelse(n > 0, tab[, 2] / n, NA_real_)
    data.frame(scenario = name, n = sum(keep), excluded = sum(!keep),
      no_practice_n = as.integer(n[1]), no_practice_replies = as.integer(tab[1, 2]),
      no_practice_reply_rate = as.numeric(rates[1]),
      specific_n = as.integer(n[2]), specific_replies = as.integer(tab[2, 2]),
      specific_reply_rate = as.numeric(rates[2]),
      difference_pp = as.numeric(100 * (rates[2] - rates[1])),
      stringsAsFactors = FALSE, row.names = NULL)
  }))
  comparison <- as.data.frame(table(
    supplied_label = factor(a$original_label, levels = c(FALSE, TRUE)),
    assistant_label = factor(a$assistant_label, levels = c("FALSE", "TRUE", "AMBIGUOUS"))))
  list(joined = a, summary = summary, comparison = comparison,
    n_reviewed = nrow(a), n_determinate = sum(determinate),
    n_ambiguous = sum(!determinate),
    n_differences = sum(a$differs_from_original, na.rm = TRUE),
    note = paste("AI-assisted sensitivity only; original labels remain primary.",
      "Disagreement is not an error rate, accuracy, human reliability or proof",
      "that one operationalisation is correct. No additional significance tests."))
}
