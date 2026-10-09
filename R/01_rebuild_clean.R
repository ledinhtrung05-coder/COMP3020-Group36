# OPTIONAL CLEANING OF A NEW COPY -- no work occurs on source().
# This is a transparent proposed cleaner, NOT a claim to be the original script
# used to produce hn_comments_clean.csv. Text whitespace can differ from the
# supplied historical clean file. Keep that supplied file frozen for its results.
# Dependencies: base R and xml2. No download or API call is made here.
#
# Manual example, using a NEW name and reviewing its audit before adoption:
# source("R/01_rebuild_clean.R")
# rebuilt <- rebuild_clean("data/raw/hn_comments_raw.csv",
#                          "data/processed/hn_comments_rebuilt.csv")

.hn_clean_flag <- function(value, name) {
  strings <- toupper(trimws(as.character(value)))
  blank <- is.na(strings) | strings == "" | strings == "NA"
  invalid <- !blank & !strings %in% c("TRUE", "FALSE")
  if (any(invalid)) stop("Unexpected values in ", name, "; use TRUE/FALSE/NA.", call. = FALSE)
  result <- rep(NA, length(strings))
  result[!blank] <- strings[!blank] == "TRUE"
  result
}

.hn_html_to_text <- function(value) {
  if (is.na(value)) return(NA_character_)
  # Insert separators at block boundaries BEFORE parsing, so adjacent paragraphs
  # and list items do not become concatenated words. Keep original text_raw too.
  fragment <- gsub("(?i)<br\\s*/?\\s*>", "\n", value, perl = TRUE)
  fragment <- gsub("(?i)</?(p|div|li|blockquote|pre|h[1-6])\\b[^>]*>",
                   "\n", fragment, perl = TRUE)
  document <- xml2::read_html(paste0("<html><body>", fragment, "</body></html>"),
                              encoding = "UTF-8", options = c("RECOVER", "NOERROR", "NOWARNING", "NONET"))
  body <- xml2::xml_find_first(document, ".//body")
  text <- xml2::xml_text(body, trim = FALSE)
  text <- gsub("\r\n?", "\n", text, perl = TRUE)
  text <- gsub("\u00a0", " ", text, fixed = TRUE)
  text <- gsub("[\t ]+", " ", text, perl = TRUE)
  text <- gsub(" *\n *", "\n", text, perl = TRUE)
  text <- gsub("\n{3,}", "\n\n", text, perl = TRUE)
  enc2utf8(trimws(text))
}

rebuild_clean <- function(raw_path, output_path) {
  if (!requireNamespace("xml2", quietly = TRUE)) {
    stop("Install package 'xml2' using the project setup instructions first.", call. = FALSE)
  }
  if (length(raw_path) != 1L || is.na(raw_path) || !file.exists(raw_path)) {
    stop("raw_path must identify an existing CSV file.", call. = FALSE)
  }
  if (length(output_path) != 1L || is.na(output_path) || !nzchar(output_path)) {
    stop("Provide one output CSV path.", call. = FALSE)
  }
  # No overwrite switch: adopting a revised dataset should be an explicit group
  # decision, after comparing it with the old copy and rerunning affected results.
  if (file.exists(output_path)) {
    stop("Refusing to overwrite an existing output. Choose a NEW filename.", call. = FALSE)
  }
  audit_path <- paste0(output_path, ".audit.csv")
  summary_path <- paste0(output_path, ".summary.csv")
  note_path <- paste0(output_path, ".notes.txt")
  if (any(file.exists(c(audit_path, summary_path, note_path)))) {
    stop("A proposed audit/summary/notes file already exists. Choose a NEW filename.",
         call. = FALSE)
  }
  if (identical(normalizePath(raw_path, winslash = "/", mustWork = TRUE),
                normalizePath(output_path, winslash = "/", mustWork = FALSE))) {
    stop("The output cannot be the supplied raw input.", call. = FALSE)
  }
  raw <- utils::read.csv(raw_path, stringsAsFactors = FALSE, check.names = FALSE,
                         colClasses = "character", fileEncoding = "UTF-8",
                         na.strings = "NA")
  required <- c("thread_id", "comment_id", "parent_id", "author", "time", "text_raw",
                "type", "dead", "deleted", "thread_title")
  absent <- setdiff(required, names(raw))
  if (length(absent)) {
    stop("Raw CSV is missing columns: ", paste(absent, collapse = ", "), call. = FALSE)
  }
  if (anyDuplicated(raw$comment_id[!is.na(raw$comment_id) & nzchar(raw$comment_id)])) {
    stop("Duplicate non-missing comment IDs found. Resolve these before cleaning.",
         call. = FALSE)
  }
  dead <- .hn_clean_flag(raw$dead, "dead")
  deleted <- .hn_clean_flag(raw$deleted, "deleted")
  reasons <- rep(NA_character_, nrow(raw))
  add_reason <- function(flag, description) {
    selected <- !is.na(flag) & flag & is.na(reasons)
    reasons[selected] <<- description
  }
  # Exclusions have a mutually exclusive priority; the row audit retains flags so
  # a record marked both dead and deleted can still be identified accurately.
  add_reason(!is.na(deleted) & deleted, "deleted")
  add_reason(!is.na(dead) & dead, "dead")
  if ("fetch_status" %in% names(raw)) {
    add_reason(is.na(raw$fetch_status) | raw$fetch_status != "ok", "fetch_unavailable")
  }
  add_reason(is.na(dead) | is.na(deleted), "missing_status_flags")
  missing_required <- function(column) is.na(raw[[column]]) | !nzchar(trimws(raw[[column]]))
  for (column in c("thread_id", "comment_id", "parent_id", "author", "time", "text_raw", "type")) {
    add_reason(missing_required(column), paste0("missing_", column))
  }
  add_reason(!is.na(raw$type) & raw$type != "comment", "non_comment_item")
  unix_time <- suppressWarnings(as.numeric(raw$time))
  add_reason(!is.finite(unix_time) | unix_time < 0, "invalid_unix_time")

  parsed_text <- rep(NA_character_, nrow(raw))
  candidate_rows <- which(is.na(reasons))
  for (index in candidate_rows) {
    parsed_text[index] <- tryCatch(.hn_html_to_text(raw$text_raw[index]),
                                    error = function(error) NA_character_)
  }
  add_reason(is.na(parsed_text), "text_parse_failed")
  add_reason(!is.na(parsed_text) & !nzchar(trimws(parsed_text)), "blank_decoded_text")
  retained <- is.na(reasons)
  clean <- raw[retained, , drop = FALSE]
  clean$dead <- dead[retained]
  clean$deleted <- deleted[retained]
  clean$time <- unix_time[retained]
  clean$created_at <- format(as.POSIXct(clean$time, origin = "1970-01-01", tz = "UTC"),
                              tz = "UTC", format = "%Y-%m-%d %H:%M:%S")
  clean$text <- parsed_text[retained]
  # Compute only after all filtering: reply children must themselves be retained.
  clean$received_reply <- clean$comment_id %in% clean$parent_id
  for (column in names(clean)) {
    if (is.character(clean[[column]])) clean[[column]] <- enc2utf8(clean[[column]])
  }
  rownames(clean) <- NULL
  audit <- data.frame(
    input_row = seq_len(nrow(raw)), comment_id = raw$comment_id,
    thread_id = raw$thread_id, dead = dead, deleted = deleted,
    decision = ifelse(retained, "retained", "excluded"),
    primary_reason = ifelse(retained, "retained", reasons),
    stringsAsFactors = FALSE
  )
  reason_counts <- table(audit$primary_reason)
  summary <- data.frame(reason = names(reason_counts), rows = as.integer(reason_counts),
                         stringsAsFactors = FALSE)
  output_dir <- dirname(output_path)
  if (!dir.exists(output_dir) && !dir.create(output_dir, recursive = TRUE)) {
    stop("Could not create output directory.", call. = FALSE)
  }
  for (path in c(output_path, audit_path, summary_path, note_path)) {
    if (file.exists(path)) stop("Output appeared during processing; refusing to overwrite: ", path,
                                call. = FALSE)
  }
  utils::write.csv(clean, output_path, row.names = FALSE, na = "NA", fileEncoding = "UTF-8")
  utils::write.csv(audit, audit_path, row.names = FALSE, na = "NA", fileEncoding = "UTF-8")
  utils::write.csv(summary, summary_path, row.names = FALSE, na = "NA", fileEncoding = "UTF-8")
  writeLines(c(
    "SUPPLEMENTARY CLEANER -- a new output, not the original historical cleaning script.",
    paste("Input:", normalizePath(raw_path, winslash = "/")),
    paste("Built UTC:", format(Sys.time(), tz = "UTC", format = "%Y-%m-%dT%H:%M:%SZ")),
    paste("Input rows:", nrow(raw), "| Retained rows:", nrow(clean)),
    "Raw HTML is retained in text_raw. XML parsing decodes HTML entities.",
    "Paragraph/list boundaries are retained as newlines where possible.",
    "created_at is UTC; received_reply means a direct reply also retained in this clean copy.",
    "This step does not label verification practices, remove quotations, or decide topic relevance.",
    "Rows are not deleted merely because their comment parent is absent from this clean copy.",
    "Compare retained IDs, text and outcome counts before adopting this file for analysis.",
    "Do not overwrite the team's supplied raw/clean snapshots."
  ), note_path, useBytes = TRUE)
  message("New cleaned copy saved: ", output_path,
          " (", nrow(clean), " of ", nrow(raw), " rows retained).")
  invisible(list(clean = clean, audit = audit, summary = summary,
                 output_path = output_path, audit_path = audit_path,
                 summary_path = summary_path, notes_path = note_path))
}
