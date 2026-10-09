# Shared input, validation and audit. No package installation or API calls here.
strict_logical <- function(x, name, allow_na = FALSE) {
  z <- toupper(trimws(as.character(x)))
  z[z %in% c("", "NA")] <- NA_character_
  bad <- !is.na(z) & !z %in% c("TRUE", "FALSE")
  if (any(bad)) stop(name, " must contain TRUE/FALSE only.")
  out <- ifelse(is.na(z), NA, z == "TRUE")
  if (!allow_na && anyNA(out)) stop(name, " contains missing values.")
  out
}

read_comments <- function(path, clean = FALSE) {
  if (!file.exists(path)) stop("Missing input: ", path)
  x <- read.csv(path, colClasses = "character", stringsAsFactors = FALSE,
                fileEncoding = "UTF-8", na.strings = c("", "NA"),
                check.names = FALSE)
  req <- c("thread_id", "comment_id", "parent_id", "author", "time",
           "text_raw", "type", "dead", "deleted", "thread_title")
  if (clean) req <- c(req, "text", "created_at", "received_reply")
  if (!all(req %in% names(x))) stop("Missing columns: ", paste(setdiff(req, names(x)), collapse = ", "))
  if (anyNA(x$comment_id) || anyDuplicated(x$comment_id)) stop("Comment IDs must be present and unique.")
  if (anyNA(x$thread_id) || anyNA(x$parent_id)) stop("Missing thread/parent IDs.")
  if (any(!grepl("^[0-9]+$", x$comment_id))) stop("Invalid comment IDs.")
  x$time <- suppressWarnings(as.numeric(x$time))
  if (anyNA(x$time)) stop("Invalid epoch timestamp.")
  x$dead <- strict_logical(x$dead, "dead")
  x$deleted <- strict_logical(x$deleted, "deleted")
  x$created_utc <- as.POSIXct(x$time, origin = "1970-01-01", tz = "UTC")
  if (clean) {
    x$received_reply <- strict_logical(x$received_reply, "received_reply")
    if (anyNA(x$author) || anyNA(x$text) || any(!nzchar(trimws(x$text)))) stop("Clean data has missing author/text.")
    if (any(x$dead | x$deleted)) stop("Clean data contains dead/deleted rows.")
  }
  x
}

audit_comments <- function(raw, comments) {
  idx <- match(comments$comment_id, raw$comment_id)
  if (anyNA(idx)) stop("Clean IDs are not a subset of raw IDs.")
  shared <- intersect(names(raw), names(comments))
  shared <- setdiff(shared, "created_utc")
  unchanged <- vapply(shared, function(nm) identical(as.character(comments[[nm]]), as.character(raw[[nm]][idx])), logical(1))
  if (!all(unchanged)) stop("Shared raw/clean fields differ: ", paste(shared[!unchanged], collapse = ", "))
  removed <- raw[!raw$comment_id %in% comments$comment_id, , drop = FALSE]
  clean_reply <- comments$comment_id %in% comments$parent_id
  raw_reply <- comments$comment_id %in% raw$parent_id
  if (!identical(clean_reply, comments$received_reply)) stop("received_reply does not match retained-clean reply definition.")
  threads <- do.call(rbind, lapply(sort(unique(comments$thread_id)), function(id) {
    z <- comments[comments$thread_id == id, , drop = FALSE]
    data.frame(thread_id = id, title = z$thread_title[1], raw_n = sum(raw$thread_id == id),
      clean_n = nrow(z), authors = length(unique(z$author)),
      first_comment_utc = format(min(z$created_utc), tz = "UTC", usetz = TRUE),
      last_comment_utc = format(max(z$created_utc), tz = "UTC", usetz = TRUE),
      stringsAsFactors = FALSE)
  }))
  parent_idx <- match(comments$parent_id, comments$comment_id)
  matched <- !is.na(parent_idx)
  if (any(comments$thread_id[matched] != comments$thread_id[parent_idx[matched]])) stop("Cross-thread parent link.")
  parent_type <- ifelse(matched, "retained_comment", ifelse(comments$parent_id == comments$thread_id, "root_story", "removed_or_missing_parent"))
  summary <- data.frame(metric = c("Raw comments", "Clean comments", "Removed dead", "Removed deleted", "Threads", "Clean authors", "Authors with multiple comments", "Retained comments receiving a retained reply", "Retained comments receiving any observed raw reply", "Matched comment-to-comment replies", "Replies to root story", "Replies to removed/missing parent"),
    value = c(nrow(raw), nrow(comments), sum(removed$dead), sum(removed$deleted), nrow(threads), length(unique(comments$author)), sum(table(comments$author) > 1), sum(clean_reply), sum(raw_reply), sum(matched), sum(parent_type == "root_story"), sum(parent_type == "removed_or_missing_parent")))
  list(summary = summary, threads = threads, removed = removed,
       reply_definition_changes = data.frame(comment_id = comments$comment_id[clean_reply != raw_reply], retained_reply = clean_reply[clean_reply != raw_reply], raw_reply = raw_reply[clean_reply != raw_reply]),
       parent_type = parent_type, shared_fields_unchanged = unchanged,
       removed_exactly_dead_deleted = setequal(removed$comment_id, raw$comment_id[raw$dead | raw$deleted]))
}

collection_manifest_complete <- function(manifest, comments) {
  # A group-confirmed calendar date is valid provenance; an exact UTC timestamp
  # and a historical search log are not invented merely to pass this check.
  # Retrospective relevance is kept separate from the original search history.
  fields <- c("thread_id", "original_collection_date", "collection_date_source",
    "original_collection_R_script", "collection_execution_status",
    "selection_justification", "selection_justification_basis",
    "selection_process_status", "collection_limitations")
  if (!nrow(manifest) || !all(fields %in% names(manifest))) return(FALSE)
  values <- as.matrix(manifest[, fields, drop = FALSE])
  if (anyNA(values) || any(!nzchar(trimws(values)))) return(FALSE)
  dates <- suppressWarnings(as.Date(manifest$original_collection_date, format = "%Y-%m-%d"))
  all(!is.na(dates)) &&
    all(format(dates, "%Y-%m-%d") == manifest$original_collection_date) &&
    !anyDuplicated(manifest$thread_id) &&
    setequal(manifest$thread_id, comments$thread_id)
}

write_csv_utf8 <- function(x, path) {
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  write.csv(x, path, row.names = FALSE, na = "", fileEncoding = "UTF-8")
}

fmt_pct <- function(x, digits = 1) paste0(formatC(100 * x, format = "f", digits = digits), "%")
fmt_num <- function(x, digits = 3) formatC(x, format = "f", digits = digits)
