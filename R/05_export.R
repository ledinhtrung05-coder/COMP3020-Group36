# Export tables and complete computation objects for checking and poster reuse.
export_results <- function(results, project_root) {
  table_dir <- file.path(project_root, "outputs", "tables")
  dir.create(table_dir, recursive = TRUE, showWarnings = FALSE)
  save_table <- function(x, name) write_csv_utf8(x, file.path(table_dir, paste0(name, ".csv")))
  save_table(results$audit$summary, "data_audit")
  save_table(results$audit$threads, "thread_summary")
  save_table(results$audit$reply_definition_changes, "reply_definition_changes")
  save_table(results$text$frequencies, "rq1_word_frequencies")
  save_table(results$text$dictionary, "rq1_dictionary_patterns")
  save_table(results$text$candidate_summary, "rq1_candidate_mentions")
  save_table(results$text$candidate_hits, "rq1_candidate_hits_for_review")
  save_table(results$text$document_summary, "text_document_summary")
  save_table(data.frame(word = results$text$stopwords), "stopwords_used")
  save_table(results$rq2$rates, "rq2_reply_rates")
  save_table(results$rq2$joined, "rq2_joined_annotations")
  save_table(results$rq2$by_thread, "rq2_reply_rates_by_thread")
  save_table(data.frame(chi_square = unname(results$rq2$test$statistic),
    df = unname(results$rq2$test$parameter), p_value = results$rq2$test$p.value,
    difference_percentage_points = results$rq2$difference_pp,
    row_labels_available = results$rq2$row_labels_available,
    provenance = results$rq2$provenance), "rq2_test_and_provenance")
  save_table(results$clusters$assignments, "rq3_cluster_assignments")
  save_table(results$clusters$diagnostics, "rq3_cluster_diagnostics")
  if (!is.null(results$clusters$sensitivity)) save_table(results$clusters$sensitivity, "rq3_linkage_sensitivity")
  save_table(results$clusters$cluster_summary, "rq3_cluster_summary")
  save_table(results$clusters$cluster_terms, "rq3_top_terms")
  save_table(results$clusters$examples, "rq3_context_examples")
  save_table(results$clusters$exclusions, "rq3_excluded_comments")
  save_table(results$clusters$cluster_thread, "rq3_cluster_by_thread")
  save_table(results$network$summary, "rq4_network_summary")
  save_table(results$network$author_edges, "rq4_author_edges")
  save_table(results$network$reply_events, "rq4_reply_events")
  save_table(results$network$node_metrics, "rq4_centrality")
  save_table(results$network$unmatched, "rq4_unmatched_parents")
  save_table(results$bridge$receiver_rates, "rq4_reply_rates_by_cluster")
  save_table(as.data.frame(results$bridge$content_reply_matrix), "rq4_cluster_reply_matrix")
  save_table(results$bridge$coverage, "rq4_cluster_bridge_coverage")
  saveRDS(results, file.path(project_root, "outputs", "analysis_results.rds"))
  capture.output(sessionInfo(), file = file.path(project_root, "outputs", "session_info.txt"))
  invisible(results)
}

save_project_figures <- function(results, project_root) {
  dest <- file.path(project_root, "outputs", "figures")
  dir.create(dest, recursive = TRUE, showWarnings = FALSE)
  draw <- function(name, fun, width = 8, height = 5) {
    grDevices::pdf(file.path(dest, paste0(name, ".pdf")), width = width, height = height,
                    useDingbats = FALSE)
    on.exit(grDevices::dev.off())
    fun()
  }
  draw("rq1_frequent_words", function() plot_text_frequencies(results$text))
  draw("rq1_candidate_mentions", function() plot_candidate_mentions(results$text))
  draw("rq2_reply_rates", function() plot_reply_rates(results$rq2))
  draw("rq3_diagnostics", function() plot_cluster_diagnostics(results$clusters))
  draw("rq3_dendrogram", function() plot_cluster_dendrogram(results$clusters))
  draw("rq3_thread_composition", function() plot_cluster_thread(results$clusters))
  draw("rq4_full_network", function() plot_network_full(results$network), height = 6)
  draw("rq4_largest_component", function() plot_network_lcc(results$network), height = 6)
  draw("rq4_indegree_distribution", function() plot_indegree_distribution(results$network))
  invisible(dest)
}
