# OPTIONAL FUTURE COLLECTION -- never run automatically when this file is sourced.
# This is a NEW collector, not evidence of how the supplied historical CSV was
# collected. The live API may now return edited, deleted or additional comments;
# running this cannot recover or prove completeness of the earlier snapshot.
#
# Official API documentation: https://github.com/HackerNews/API
# Endpoint: https://hacker-news.firebaseio.com/v0/item/<id>.json
# The public endpoint needs no API key. Each returned `kids` list must be followed
# to obtain descendants; the story's `descendants` count is not the comments.
#
# Manual example (run separately after deciding to collect a NEW snapshot):
# source("R/01_collect_hn.R")
# ids <- unique(read.csv("data/raw/hn_comments_raw.csv",
#                        colClasses = "character")$thread_id)
# collect_hn(ids, "data/new_snapshot_2026_10_09")
# Never put the collect_hn() call inside the report's knit pipeline.

.hn_utc_now <- function() {
  format(Sys.time(), tz = "UTC", format = "%Y-%m-%dT%H:%M:%SZ")
}

.hn_scalar <- function(item, field, default = NA_character_) {
  value <- item[[field]]
  if (is.null(value) || !length(value) || is.null(value[[1L]])) return(default)
  value[[1L]]
}

.hn_write_csv <- function(value, path) {
  utils::write.csv(value, file = path, row.names = FALSE, na = "NA",
                   fileEncoding = "UTF-8")
}

collect_hn <- function(thread_ids, output_dir) {
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("Install package 'jsonlite' using the project setup instructions first.",
         call. = FALSE)
  }
  thread_ids <- unique(as.character(thread_ids))
  if (!length(thread_ids) || anyNA(thread_ids) ||
      any(!grepl("^[1-9][0-9]*$", thread_ids))) {
    stop("thread_ids must contain positive integer Hacker News story IDs.", call. = FALSE)
  }
  if (length(output_dir) != 1L || is.na(output_dir) || !nzchar(output_dir)) {
    stop("Provide one non-empty output directory path.", call. = FALSE)
  }
  if (file.exists(output_dir) && !dir.exists(output_dir)) {
    stop("output_dir exists and is not a directory.", call. = FALSE)
  }
  if (dir.exists(output_dir) &&
      length(list.files(output_dir, all.files = TRUE, no.. = TRUE))) {
    stop("Refusing to write into a non-empty directory. Choose a NEW snapshot directory.",
         call. = FALSE)
  }
  if (!dir.exists(output_dir) && !dir.create(output_dir, recursive = TRUE)) {
    stop("Could not create output_dir.", call. = FALSE)
  }
  item_dir <- file.path(output_dir, "items")
  if (!dir.create(item_dir)) stop("Could not create the raw item directory.", call. = FALSE)
  started_utc <- .hn_utc_now()
  original_timeout <- getOption("timeout")
  options(timeout = max(30, original_timeout))
  on.exit(options(timeout = original_timeout), add = TRUE)

  # Mark every attempt, including failures and JSON nulls. A null response is NOT
  # silently converted into a valid blank comment. Logs are flushed immediately.
  request_log_path <- file.path(output_dir, "request_log.csv")
  log_template <- data.frame(
    thread_id = character(), item_id = character(), attempt = integer(),
    requested_at_utc = character(), finished_at_utc = character(),
    endpoint = character(), status = character(), detail = character(),
    stringsAsFactors = FALSE
  )
  .hn_write_csv(log_template, request_log_path)
  request_rows <- list()
  append_request <- function(row) {
    request_rows[[length(request_rows) + 1L]] <<- row
    utils::write.table(row, request_log_path, append = TRUE, sep = ",",
                       row.names = FALSE, col.names = FALSE, quote = TRUE,
                       na = "NA", fileEncoding = "UTF-8")
  }

  fetch_item <- function(item_id, thread_id) {
    endpoint <- paste0("https://hacker-news.firebaseio.com/v0/item/", item_id, ".json")
    last_status <- "request_failed"
    for (attempt in seq_len(3L)) {
      requested <- .hn_utc_now()
      error_detail <- ""
      item <- tryCatch(
        jsonlite::fromJSON(endpoint, simplifyVector = FALSE),
        error = function(error) {
          error_detail <<- conditionMessage(error)
          NULL
        }
      )
      finished <- .hn_utc_now()
      if (nzchar(error_detail)) {
        status <- "request_failed"
      } else if (is.null(item)) {
        status <- "api_null"
        error_detail <- "API returned JSON null; descendants are unavailable."
      } else if (!is.list(item) ||
                 is.na(.hn_scalar(item, "id")) ||
                 as.character(.hn_scalar(item, "id")) != item_id) {
        status <- "invalid_item"
        error_detail <- "Response was not an item with the requested ID."
      } else {
        status <- "ok"
      }
      append_request(data.frame(
        thread_id = thread_id, item_id = item_id, attempt = attempt,
        requested_at_utc = requested, finished_at_utc = finished,
        endpoint = endpoint, status = status, detail = error_detail,
        stringsAsFactors = FALSE
      ))
      last_status <- status
      if (identical(status, "ok")) {
        # Preserve every available API property, including children of dead or
        # deleted comments. JSON serialization is an archive of the parsed item,
        # not a claim to preserve the exact original HTTP response bytes.
        jsonlite::write_json(item, file.path(item_dir, paste0(item_id, ".json")),
                             auto_unbox = TRUE, pretty = TRUE, null = "null")
        Sys.sleep(0.10)
        return(list(item = item, status = status, fetched_at_utc = finished))
      }
      if (attempt < 3L) Sys.sleep(attempt)
    }
    list(item = NULL, status = last_status, fetched_at_utc = .hn_utc_now())
  }

  kids_of <- function(item) {
    kids <- as.character(unlist(item$kids, use.names = FALSE))
    if (length(kids) && anyNA(kids)) {
      stop("Unexpected missing ID in an API kids list. Inspect saved items and logs.",
           call. = FALSE)
    }
    if (length(kids) && any(!grepl("^[1-9][0-9]*$", kids))) {
      stop("Unexpected invalid ID in an API kids list. Inspect saved items and logs.",
           call. = FALSE)
    }
    unique(kids)
  }

  raw_template <- data.frame(
    thread_id = character(), comment_id = character(), parent_id = character(),
    author = character(), time = numeric(), text_raw = character(),
    type = character(), dead = logical(), deleted = logical(),
    thread_title = character(), fetched_at_utc = character(),
    fetch_status = character(), discovered_from_parent_id = character(),
    stringsAsFactors = FALSE
  )
  root_template <- data.frame(
    thread_id = character(), author = character(), time = numeric(),
    title = character(), text_raw = character(), url = character(),
    type = character(), dead = logical(), deleted = logical(),
    descendants_reported = numeric(), immediate_kids = integer(),
    fetched_at_utc = character(), fetch_status = character(),
    stringsAsFactors = FALSE
  )
  raw_rows <- list()
  root_rows <- list()
  manifest_rows <- list()
  visited <- new.env(parent = emptyenv())

  # Walk each kids tree depth-first with an explicit stack. This is recursive
  # descendant traversal without depending on R's call-stack depth. The visited
  # set prevents cycles or duplicate child references from duplicating records.
  for (thread_id in thread_ids) {
    thread_started <- .hn_utc_now()
    root_result <- fetch_item(thread_id, thread_id)
    root <- root_result$item
    assign(thread_id, TRUE, envir = visited)
    root_kids <- if (!is.null(root)) kids_of(root) else character()
    thread_title <- as.character(.hn_scalar(root, "title"))
    root_rows[[length(root_rows) + 1L]] <- data.frame(
      thread_id = thread_id,
      author = as.character(.hn_scalar(root, "by")),
      time = as.numeric(.hn_scalar(root, "time", NA_real_)),
      title = thread_title,
      text_raw = as.character(.hn_scalar(root, "text")),
      url = as.character(.hn_scalar(root, "url")),
      type = as.character(.hn_scalar(root, "type")),
      dead = if (is.null(root)) NA else isTRUE(.hn_scalar(root, "dead", FALSE)),
      deleted = if (is.null(root)) NA else isTRUE(.hn_scalar(root, "deleted", FALSE)),
      descendants_reported = as.numeric(.hn_scalar(root, "descendants", NA_real_)),
      immediate_kids = if (is.null(root)) NA_integer_ else length(root_kids),
      fetched_at_utc = root_result$fetched_at_utc,
      fetch_status = root_result$status,
      stringsAsFactors = FALSE
    )
    stack <- lapply(rev(root_kids), function(id) list(id = id, discovered_parent = thread_id))
    duplicate_references <- 0L
    failed_items <- 0L
    successful_items <- 0L
    comment_rows_this_thread <- 0L
    while (length(stack)) {
      next_item <- stack[[length(stack)]]
      stack[[length(stack)]] <- NULL
      item_id <- next_item$id
      if (exists(item_id, envir = visited, inherits = FALSE)) {
        duplicate_references <- duplicate_references + 1L
        next
      }
      assign(item_id, TRUE, envir = visited)
      result <- fetch_item(item_id, thread_id)
      item <- result$item
      comment_rows_this_thread <- comment_rows_this_thread + 1L
      if (is.null(item)) failed_items <- failed_items + 1L else successful_items <- successful_items + 1L
      # Missing API fields stay NA. In particular, inferred discovery ancestry is
      # kept separately and never presented as an observed API parent field.
      raw_rows[[length(raw_rows) + 1L]] <- data.frame(
        thread_id = thread_id, comment_id = item_id,
        parent_id = as.character(.hn_scalar(item, "parent")),
        author = as.character(.hn_scalar(item, "by")),
        time = as.numeric(.hn_scalar(item, "time", NA_real_)),
        text_raw = as.character(.hn_scalar(item, "text")),
        type = as.character(.hn_scalar(item, "type")),
        dead = if (is.null(item)) NA else isTRUE(.hn_scalar(item, "dead", FALSE)),
        deleted = if (is.null(item)) NA else isTRUE(.hn_scalar(item, "deleted", FALSE)),
        thread_title = thread_title, fetched_at_utc = result$fetched_at_utc,
        fetch_status = result$status,
        discovered_from_parent_id = next_item$discovered_parent,
        stringsAsFactors = FALSE
      )
      if (!is.null(item)) {
        child_ids <- kids_of(item)
        if (length(child_ids)) {
          stack <- c(stack, lapply(rev(child_ids), function(id) {
            list(id = id, discovered_parent = item_id)
          }))
        }
      }
    }
    manifest_rows[[length(manifest_rows) + 1L]] <- data.frame(
      thread_id = thread_id, thread_title = thread_title,
      thread_url = paste0("https://news.ycombinator.com/item?id=", thread_id),
      collection_started_utc = thread_started,
      collection_finished_utc = .hn_utc_now(),
      root_fetch_status = root_result$status,
      descendant_rows = comment_rows_this_thread,
      successful_descendant_items = successful_items,
      unavailable_descendant_items = failed_items,
      duplicate_or_visited_references = duplicate_references,
      traversal_status = if (is.null(root)) "root_unavailable" else if (failed_items) {
        "incomplete_due_to_unavailable_items"
      } else "all_discovered_kids_visited",
      scope_note = "Live API traversal; not a historical reconstruction or an atomic snapshot.",
      stringsAsFactors = FALSE
    )
    # A checkpoint after each complete tree preserves progress on later failure.
    .hn_write_csv(if (length(raw_rows)) do.call(rbind, raw_rows) else raw_template,
                  file.path(output_dir, "hn_comments_raw.csv"))
    .hn_write_csv(do.call(rbind, root_rows), file.path(output_dir, "hn_story_roots.csv"))
    .hn_write_csv(do.call(rbind, manifest_rows), file.path(output_dir, "thread_manifest.csv"))
  }

  raw_comments <- if (length(raw_rows)) do.call(rbind, raw_rows) else raw_template
  roots <- if (length(root_rows)) do.call(rbind, root_rows) else root_template
  manifest <- do.call(rbind, manifest_rows)
  requests <- if (length(request_rows)) do.call(rbind, request_rows) else log_template
  notes <- c(
    "NEW HACKER NEWS SNAPSHOT -- supplementary collector",
    paste("Started UTC:", started_utc),
    paste("Finished UTC:", .hn_utc_now()),
    "Official API: https://github.com/HackerNews/API",
    "This collector is not the original collector for the supplied assignment CSVs.",
    "It cannot recover past edits/deletions or establish the old selection criteria.",
    "The API is live: items may change while a traversal is in progress.",
    "all_discovered_kids_visited means known returned kids were visited; it does not",
    "prove that all historical comments were available or that this is a census.",
    "NA means absent/unavailable, not an observed empty text or FALSE flag.",
    "Failed/null item rows retain the requested ID and an explicit fetch_status.",
    "discovered_from_parent_id records traversal provenance, not an API parent value.",
    "dead/deleted comments are preserved here, and available children are traversed.",
    "items/ contains parsed successful API objects; request_log.csv records each attempt.",
    "Selection rationale must be documented separately by the group.",
    "Do not replace the assignment's frozen input files without reviewing all analyses."
  )
  writeLines(notes, file.path(output_dir, "COLLECTION_NOTES.txt"), useBytes = TRUE)
  message("New collection saved to: ", normalizePath(output_dir, winslash = "/"))
  invisible(list(raw_comments = raw_comments, roots = roots, manifest = manifest,
                 request_log = requests, output_dir = output_dir))
}
