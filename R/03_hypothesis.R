# Preserve supplied labels and the teammate's question/test. No aggregate fallback.
analyse_hypothesis <- function(comments, annotation_path) {
  if (!file.exists(annotation_path)) {
    stop("Missing RQ2 input: ", annotation_path,
         ". Use verification_labels.csv included in the updated project; do not create replacement labels from keywords.")
  }
  a <- read.csv(annotation_path, colClasses = "character", stringsAsFactors = FALSE,
                fileEncoding = "UTF-8", check.names = FALSE, na.strings = c("", "NA"))
  if (anyDuplicated(names(a))) stop("RQ2 input has duplicate column names.")
  if (!all(c("comment_id", "verification_specific") %in% names(a))) stop("RQ2 annotation file needs comment_id and verification_specific.")
  if (anyNA(a$comment_id) || anyDuplicated(a$comment_id)) stop("RQ2 annotation IDs must be unique and complete.")
  if (!setequal(a$comment_id, comments$comment_id)) stop("RQ2 annotations must match exactly the clean comment IDs; do not silently drop rows.")
  a <- a[match(comments$comment_id, a$comment_id), , drop = FALSE]
  # The supplied file contains the full clean snapshot plus the new label.
  # Check shared fields as well as IDs, so stale text/outcomes cannot go unnoticed.
  shared <- setdiff(intersect(names(a), names(comments)),
                    c("comment_id", "verification_specific", "created_utc"))
  same <- vapply(shared, function(nm) {
    identical(as.character(a[[nm]]), as.character(comments[[nm]]))
  }, logical(1))
  if (!all(same)) stop("RQ2 source differs from the clean data in: ", paste(shared[!same], collapse = ", "))
  labels <- strict_logical(a$verification_specific, "verification_specific")
  retained_reply <- comments$comment_id %in% comments$parent_id
  if (!identical(retained_reply, comments$received_reply)) stop("RQ2 received_reply does not match retained direct children.")
  tab <- table(verification_specific = factor(labels, levels = c(FALSE, TRUE)),
               received_reply = factor(retained_reply, levels = c(FALSE, TRUE)))
  if (any(rowSums(tab) == 0) || any(colSums(tab) == 0)) stop("RQ2 requires both categories in both variables.")
  test <- chisq.test(tab, correct = TRUE)
  rates <- data.frame(verification_specific = rownames(tab), no_reply = as.integer(tab[, "FALSE"]),
    reply = as.integer(tab[, "TRUE"]), n = as.integer(rowSums(tab)),
    reply_rate = as.numeric(tab[, "TRUE"] / rowSums(tab)), stringsAsFactors = FALSE)
  joined <- data.frame(comment_id = comments$comment_id, thread_id = comments$thread_id,
    author = comments$author, verification_specific = labels, received_reply = retained_reply,
    stringsAsFactors = FALSE)
  by_thread <- do.call(rbind, lapply(sort(unique(joined$thread_id)), function(id) {
    z <- joined[joined$thread_id == id, , drop = FALSE]
    no_n <- sum(!z$verification_specific)
    yes_n <- sum(z$verification_specific)
    no_reply <- sum(!z$verification_specific & z$received_reply)
    yes_reply <- sum(z$verification_specific & z$received_reply)
    data.frame(thread_id = id, no_practice_n = no_n, no_practice_replies = no_reply,
      no_practice_reply_rate = if (no_n > 0) no_reply / no_n else NA_real_,
      specific_n = yes_n, specific_replies = yes_reply,
      specific_reply_rate = if (yes_n > 0) yes_reply / yes_n else NA_real_,
      stringsAsFactors = FALSE)
  }))
  list(table = tab, test = test, expected = test$expected, rates = rates,
       difference_pp = 100 * (rates$reply_rate[2] - rates$reply_rate[1]),
       row_labels_available = TRUE, annotations = a, joined = joined, by_thread = by_thread,
       provenance = "The group reports creating the supplied labels using code in Excel. Labels are preserved, joined by comment_id and exactly match the recovered 123-ID R script. The original Excel workbook and exact rule have not been inspected; no validated manual coding or completed human review is claimed.",
       inference_status = "Exploratory independent-comment reference model; conversation/author dependence is unresolved.")
}

plot_reply_rates <- function(rq2) {
  op <- par(mar = c(5, 4, 2, 1)); on.exit(par(op))
  b <- barplot(100 * rq2$rates$reply_rate, names.arg = c("No specific practice", "Specific practice"),
    col = c("#9BB7CB", "#256C80"), ylim = c(0, 100), ylab = "Comments receiving a retained direct reply (%)", border = NA)
  text(b, 100 * rq2$rates$reply_rate + 4, paste0(round(100 * rq2$rates$reply_rate, 1), "%"))
  mtext("Calculated from supplied comment-level labels", side = 1, line = 3.5, cex = 0.8)
}
