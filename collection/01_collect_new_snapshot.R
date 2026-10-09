# OPTIONAL ENTRY POINT: collect a NEW Hacker News snapshot, outside Knit.
# This is a current helper, NOT the historical script run on 28 September 2026.
# The recovered historical source remains unchanged at:
# original_submissions/repo_01_collect_hn_a316232.R
# To reproduce the report, do not run this file; run check_project.R instead.

if (!requireNamespace("here", quietly = TRUE)) {
  stop("Open COMP3020_Group36.Rproj and run source('install_packages.R') first.")
}
here::i_am("collection/01_collect_new_snapshot.R")

# EDIT 1 -- change IDs only if deliberately defining a NEW corpus.
thread_ids <- c("43857643", "47289406", "47397367", "49321400", "49378314")

# EDIT 2 -- choose a NEW, empty output folder. Do not backdate a new download.
# No personal C:/Users/... path is required. Frozen report inputs are untouched.
snapshot_folder <- paste0("snapshot_", format(Sys.time(), "%Y%m%d_%H%M%S", tz = "UTC"), "_UTC")
output_dir <- here::here("data", "new_downloads", snapshot_folder)

# EDIT 3 -- keep FALSE for inspection. Set TRUE only to make live API requests.
run_collection <- FALSE

if (isTRUE(run_collection)) {
  source(here::here("R", "01_collect_hn.R"), encoding = "UTF-8")
  collect_hn(thread_ids, output_dir)
} else {
  message("No collection run. Read docs/COLLECTION_AND_LABELS_GUIDE.md first.")
}
