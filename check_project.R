# Meaningful regression checks for the SUPPLIED snapshot. Run after run_analysis.R.
here::i_am("check_project.R")
if (!exists("results") || !exists("comments") || !exists("raw")) {
  source(here::here("run_analysis.R"), encoding = "UTF-8")
}
close_enough <- function(x, y, tolerance = 1e-7) isTRUE(all.equal(as.numeric(x), as.numeric(y), tolerance = tolerance))
stopifnot(nrow(raw) == 313L, nrow(comments) == 278L,
          length(unique(comments$thread_id)) == 5L,
          length(unique(comments$author)) == 186L,
          sum(comments$received_reply) == 121L,
          results$audit$removed_exactly_dead_deleted,
          all(results$audit$shared_fields_unchanged))
stopifnot(nrow(results$network$reply_events) == 198L,
          nrow(results$network$author_edges) == 193L,
          igraph::vcount(results$network$graph) == 144L,
          close_enough(igraph::edge_density(results$network$graph, loops = FALSE), 193/(144*143)),
          nrow(results$network$weak_components) == 9L,
          max(results$network$weak_components$authors) == 128L)
simon <- results$network$node_metrics[results$network$node_metrics$author == "simonw", ]
stopifnot(nrow(simon) == 1L, simon$indegree == 14L,
          close_enough(simon$betweenness, 0.01910765, tolerance = 1e-6))
stopifnot(sum(results$rq2$table) == nrow(comments),
          identical(as.integer(colSums(results$rq2$table)), c(157L, 121L)))
if (!results$rq2$row_labels_available) {
  stopifnot(close_enough(results$rq2$test$p.value, 0.8007927, tolerance = 1e-6))
}
stopifnot(nrow(results$clusters$assignments) == nrow(comments),
          !anyDuplicated(results$clusters$assignments$comment_id),
          setequal(results$clusters$assignments$comment_id, comments$comment_id),
          all(is.finite(results$clusters$tfidf)),
          max(abs(rowSums(results$clusters$tfidf^2) - 1)) < 1e-8,
          all(results$clusters$distance >= 0), all(results$clusters$distance <= 1))
# The bridge must retain the original outcome, including unclustered replies.
stopifnot(sum(results$bridge$receiver_rates$comments) == sum(!is.na(results$clusters$assignments$cluster)),
          all(results$bridge$receiver_rates$comments_receiving_reply <= results$bridge$receiver_rates$comments),
          sum(results$bridge$content_reply_matrix) <= 198L)
# Failed joins must stop, rather than silently dropping comments.
bad <- comments
bad$comment_id[2] <- bad$comment_id[1]
failed <- inherits(try(analyse_network(bad), silent = TRUE), "try-error")
stopifnot(failed)
message("Supplied-snapshot regression checks passed. This does not validate annotation judgements or causal/statistical assumptions.")
