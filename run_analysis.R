# Open COMP3020_Group36.Rproj, then source("run_analysis.R"). No API download.
needed <- c("here", "cluster", "igraph")
missing <- needed[!vapply(needed, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) stop("Run source('install_packages.R') first. Missing: ", paste(missing, collapse = ", "))
here::i_am("run_analysis.R")
project_root <- here::here()
for (file in c("00_data.R", "02_text_cluster.R", "03_hypothesis.R", "04_network.R", "05_export.R", "07_context.R", "08_annotation_sensitivity.R")) {
  source(file.path(project_root, "R", file), encoding = "UTF-8")
}
raw <- read_comments(here::here("data", "raw", "hn_comments_raw.csv"))
comments <- read_comments(here::here("data", "processed", "hn_comments_clean.csv"), clean = TRUE)
audit <- audit_comments(raw, comments)
context_examples <- validate_context_examples(comments, here::here("data", "context_examples.csv"))
context_reply_links <- build_context_reply_links(comments)
text_result <- analyse_text(comments)
rq2 <- analyse_hypothesis(comments,
  here::here("data", "annotations", "verification_labels.csv"))
label_sensitivity <- analyse_annotation_sensitivity(comments, rq2,
  here::here("data", "annotations", "verification_audit_AI_SENS_v1.csv"))
clusters <- analyse_clusters(comments, text_result)
clusters$sensitivity <- cluster_linkage_sensitivity(clusters)
clusters$representation_sensitivity <- cluster_representation_sensitivity(comments, text_result, clusters)
clusters$geometry <- cluster_geometry_diagnostics(clusters)
network <- analyse_network(comments, seed = 3020)
bridge <- analyse_cluster_replies(comments, clusters$assignments)
results <- list(audit = audit, text = text_result, rq2 = rq2, clusters = clusters,
                network = network, bridge = bridge, context_examples = context_examples,
                context_reply_links = context_reply_links, label_sensitivity = label_sensitivity)
export_results(results, project_root)
save_project_figures(results, project_root)
message("Analysis outputs written to outputs/. RQ2 row labels available: ", rq2$row_labels_available)
message("Read outputs/tables/rq2_test_and_provenance.csv before interpreting its test.")
