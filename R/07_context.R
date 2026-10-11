# Traceable contextual examples linking RQ1 language and RQ4 reply relations.
# These are purposive analyst readings, not representative qualitative codes,
# a validated dictionary, an annotation reliability study, or new RQ2 labels.
# Checking exact excerpts validates provenance, not the interpretations themselves.
# Source CSVs are read only; this module performs no collection or file writes.

.context_normalise_space <- function(x) {
  trimws(gsub("[[:space:]]+", " ", enc2utf8(as.character(x)), perl = TRUE))
}

.context_check_comments <- function(comments) {
  required <- c("comment_id", "thread_id", "parent_id", "author", "text")
  if (!is.data.frame(comments) || !all(required %in% names(comments))) {
    stop("Context checks require comment_id, thread_id, parent_id, author and text.")
  }
  if (anyNA(comments$comment_id) || anyDuplicated(as.character(comments$comment_id))) {
    stop("Context checks require unique, non-missing comment IDs.")
  }
  invisible(TRUE)
}

validate_context_examples <- function(comments, path) {
  .context_check_comments(comments)
  if (!file.exists(path)) stop("Context examples file is missing: ", path)
  examples <- utils::read.csv(path, colClasses = "character", encoding = "UTF-8",
                              stringsAsFactors = FALSE, check.names = FALSE)
  required <- c("comment_id", "thread_id", "context_role", "rq_links",
                "evidence_excerpt", "interpretation", "selection_reason", "source_file")
  if (!all(required %in% names(examples)) || !nrow(examples)) {
    stop("Context examples require the documented columns and at least one row.")
  }
  for (column in required) {
    if (anyNA(examples[[column]]) || any(!nzchar(trimws(examples[[column]])))) {
      stop("Missing values in context examples column: ", column)
    }
  }
  if (anyDuplicated(examples$comment_id)) stop("Duplicate contextual example IDs.")
  index <- match(examples$comment_id, as.character(comments$comment_id))
  if (anyNA(index)) {
    stop("Context example IDs absent from clean comments: ",
         paste(examples$comment_id[is.na(index)], collapse = ", "))
  }
  if (!identical(examples$thread_id, as.character(comments$thread_id[index]))) {
    stop("Context example thread IDs do not match the frozen comments.")
  }
  if (any(examples$source_file != "data/processed/hn_comments_clean.csv")) {
    stop("Context examples must identify the frozen clean source file.")
  }
  source_text <- .context_normalise_space(comments$text[index])
  excerpt <- .context_normalise_space(examples$evidence_excerpt)
  evidence_match <- vapply(seq_len(nrow(examples)), function(i) {
    !is.na(source_text[i]) && grepl(excerpt[i], source_text[i], fixed = TRUE)
  }, logical(1))
  if (!all(evidence_match)) {
    stop("Context evidence is not an exact whitespace-normalised excerpt for IDs: ",
         paste(examples$comment_id[!evidence_match], collapse = ", "))
  }
  examples$author <- as.character(comments$author[index])
  examples$parent_id <- as.character(comments$parent_id[index])
  examples$source_text <- as.character(comments$text[index])
  examples$retained_direct_replies <- vapply(examples$comment_id, function(id) {
    sum(as.character(comments$parent_id) == id, na.rm = TRUE)
  }, integer(1))
  examples$evidence_match <- evidence_match
  examples
}

build_context_reply_links <- function(comments,
                                      parent_ids = c("43861845", "47290195")) {
  .context_check_comments(comments)
  parent_ids <- as.character(parent_ids)
  if (anyNA(parent_ids) || anyDuplicated(parent_ids) ||
      any(!parent_ids %in% as.character(comments$comment_id))) {
    stop("Context reply parents must be unique IDs in the clean corpus.")
  }
  child_index <- which(as.character(comments$parent_id) %in% parent_ids)
  parent_index <- match(as.character(comments$parent_id[child_index]),
                        as.character(comments$comment_id))
  if (any(as.character(comments$thread_id[child_index]) !=
          as.character(comments$thread_id[parent_index]))) {
    stop("A contextual reply and its parent belong to different threads.")
  }
  links <- data.frame(
    parent_id = as.character(comments$comment_id[parent_index]),
    parent_author = as.character(comments$author[parent_index]),
    child_id = as.character(comments$comment_id[child_index]),
    child_author = as.character(comments$author[child_index]),
    thread_id = as.character(comments$thread_id[child_index]),
    parent_text = as.character(comments$text[parent_index]),
    child_text = as.character(comments$text[child_index]),
    stringsAsFactors = FALSE
  )
  links <- links[order(match(links$parent_id, parent_ids), links$child_id,
                      method = "radix"), , drop = FALSE]
  rownames(links) <- NULL
  links
}
