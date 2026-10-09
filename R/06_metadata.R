# Shared member metadata for report and poster. No names or contributions inferred.
# Fill exactly three rows in docs/group_contributions.csv. contribution_percent
# is numeric (for example 33.3, without a percent sign); the total must be 100.
# Actual roles and sections reviewed should record work genuinely performed.
# They are retained for transparency but are not the numeric completeness gate.

.group_required_columns <- c("member_name", "student_id", "contribution_percent")

.group_trim <- function(x) {
  x <- trimws(as.character(x))
  x[is.na(x)] <- ""
  x
}

read_group_metadata <- function(path) {
  if (!file.exists(path)) stop("Missing member metadata: ", path, call. = FALSE)
  data <- utils::read.csv(path, colClasses = "character", stringsAsFactors = FALSE,
    fileEncoding = "UTF-8", na.strings = c("", "NA"), check.names = FALSE)
  if (anyDuplicated(names(data))) stop("Member metadata has duplicate column names.", call. = FALSE)
  missing <- setdiff(.group_required_columns, names(data))
  if (length(missing)) stop("Member metadata needs columns: ", paste(missing, collapse = ", "), call. = FALSE)
  for (column in names(data)) data[[column]] <- .group_trim(data[[column]])
  if (nrow(data) != 3L) {
    stop("The assignment requires exactly three group members. Keep three rows in ", path, ".", call. = FALSE)
  }
  data
}

group_metadata_complete <- function(data) {
  if (!is.data.frame(data) || nrow(data) != 3L ||
      !all(.group_required_columns %in% names(data))) return(FALSE)
  member_names <- .group_trim(data$member_name)
  student_ids <- .group_trim(data$student_id)
  contribution <- suppressWarnings(as.numeric(.group_trim(data$contribution_percent)))
  all(nzchar(member_names)) && all(nzchar(student_ids)) &&
    !anyDuplicated(student_ids) && all(is.finite(contribution)) &&
    all(contribution >= 0 & contribution <= 100) &&
    abs(sum(contribution) - 100) < 1e-8
}

group_member_lines <- function(data) {
  if (!is.data.frame(data) || nrow(data) != 3L ||
      !all(.group_required_columns %in% names(data))) {
    return("Group member details require confirmation: three names, student IDs and contribution percentages totalling 100%.")
  }
  vapply(seq_len(nrow(data)), function(index) {
    name <- .group_trim(data$member_name[index])
    sid <- .group_trim(data$student_id[index])
    value <- suppressWarnings(as.numeric(.group_trim(data$contribution_percent[index])))
    if (!nzchar(name)) name <- paste0("Member ", index, " name to confirm")
    if (!nzchar(sid)) sid <- "to confirm"
    share <- if (length(value) == 1L && is.finite(value) && value >= 0 && value <= 100) {
      paste0(format(value, trim = TRUE, scientific = FALSE), "%")
    } else "to confirm"
    paste0(name, " | Student ID: ", sid, " | Contribution: ", share)
  }, character(1))
}
