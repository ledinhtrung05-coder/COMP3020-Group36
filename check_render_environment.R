# Run after install_packages.R, from the extracted .Rproj folder.
# Checks only: no installation, download, data modification or rendering.
# source("check_render_environment.R")
# To call the function with output = "word" only, source with auto-run disabled:
# options(comp3020.render_preflight_autorun = FALSE)
# source("check_render_environment.R")
# check_render_environment(output = "word")

check_render_environment <- function(output = c("pdf", "word"), project_root = getwd()) {
  output <- match.arg(output, c("pdf", "word"), several.ok = TRUE)
  checks <- list()
  add <- function(check, passed, detail, action = "") {
    checks[[length(checks) + 1L]] <<- data.frame(check = check,
      status = if (isTRUE(passed)) "PASS" else "ACTION REQUIRED",
      detail = detail, action = if (isTRUE(passed)) "" else action,
      stringsAsFactors = FALSE)
  }
  expected <- c("COMP3020_Group36.Rproj", "Report_Group36_Integrated.Rmd",
    "Poster_Group36.Rmd", "references.bib", "R/00_data.R", "R/02_text_cluster.R",
    "R/03_hypothesis.R", "R/04_network.R", "R/05_export.R", "R/06_metadata.R",
    "formatting/report-layout.lua", "formatting/report-style.tex", "formatting/poster-style.tex", "formatting/reference.docx",
    "data/raw/hn_comments_raw.csv", "data/processed/hn_comments_clean.csv",
    "data/annotations/verification_labels.csv", "data/collection_manifest.csv",
    "docs/group_contributions.csv")
  missing_files <- expected[!file.exists(file.path(project_root, expected))]
  add("Project files", !length(missing_files),
    if (length(missing_files)) paste(missing_files, collapse = ", ") else "Required project files found.",
    "Extract the WHOLE ZIP and open COMP3020_Group36.Rproj. Do not run directly inside the ZIP or move only the Rmd.")

  required_packages <- c("here", "rmarkdown", "knitr", "cluster", "igraph", "xml2", "jsonlite")
  missing_packages <- required_packages[!vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)]
  add("R packages", !length(missing_packages),
    if (length(missing_packages)) paste(missing_packages, collapse = ", ") else "Required R packages load.",
    "Run source('install_packages.R') and read any installation error; then rerun this check.")

  pandoc_version <- NULL
  if (requireNamespace("rmarkdown", quietly = TRUE)) {
    pandoc_version <- tryCatch({
      if (rmarkdown::pandoc_available()) rmarkdown::pandoc_version() else NULL
    }, error = function(e) NULL)
  }
  if (is.null(pandoc_version) && nzchar(Sys.which("pandoc"))) {
    version_line <- tryCatch(system2(Sys.which("pandoc"), "--version", stdout = TRUE, stderr = TRUE)[1L],
      error = function(e) "")
    match <- regmatches(version_line, regexpr("[0-9]+[.][0-9]+([.][0-9]+)*", version_line))
    if (length(match) && nzchar(match)) pandoc_version <- package_version(match)
  }
  pandoc_ok <- !is.null(pandoc_version) && pandoc_version >= package_version("3.1.3")
  add("Pandoc >= 3.1.3", pandoc_ok,
    if (is.null(pandoc_version)) "Pandoc was not found." else paste("Detected", as.character(pandoc_version)),
    "Update RStudio or install a current Pandoc, restart RStudio, and check rmarkdown::pandoc_version(). The Word table filter needs pandoc.zip support.")

  if ("pdf" %in% output) {
    xelatex <- unname(Sys.which("xelatex"))
    if (!nzchar(xelatex) && requireNamespace("tinytex", quietly = TRUE)) {
      tiny_root <- tryCatch(tinytex::tinytex_root(), error = function(e) "")
      if (length(tiny_root) == 1L && nzchar(tiny_root)) {
        candidates <- list.files(file.path(tiny_root, "bin"),
          pattern = "^xelatex([.]exe)?$", recursive = TRUE, full.names = TRUE)
        if (length(candidates)) xelatex <- candidates[1L]
      }
    }
    add("XeLaTeX", nzchar(xelatex),
      if (nzchar(xelatex)) xelatex else "xelatex executable not found.",
      "Use your existing TinyTeX/TeX installation. If none is installed, manually run install.packages('tinytex'); tinytex::install_tinytex(), then restart RStudio. This check never installs software.")

    # Check Arial itself; a substituted font such as Nimbus Sans is not Arial.
    font_paths <- c(file.path(Sys.getenv("WINDIR", "C:/Windows"), "Fonts"),
      file.path(Sys.getenv("LOCALAPPDATA"), "Microsoft/Windows/Fonts"),
      "/Library/Fonts", "/System/Library/Fonts/Supplemental", path.expand("~/Library/Fonts"))
    font_paths <- unique(font_paths[dir.exists(font_paths)])
    arial_files <- unlist(lapply(font_paths, function(path)
      list.files(path, pattern = "^Arial([ ._-]|[.]ttf$|[.]otf$)",
        ignore.case = TRUE, full.names = TRUE)), use.names = FALSE)
    arial_ok <- length(arial_files) > 0L
    arial_detail <- if (arial_ok) arial_files[1L] else "Arial was not confirmed."
    if (!arial_ok && nzchar(Sys.which("fc-match"))) {
      family <- tryCatch(system2(Sys.which("fc-match"), c("-f", shQuote("%{family}"), "Arial"),
        stdout = TRUE, stderr = FALSE), error = function(e) character())
      arial_ok <- any(grepl("(^|,)[[:space:]]*Arial([[:space:]]|,|$)", family, ignore.case = TRUE))
      if (length(family)) arial_detail <- paste("Arial request resolves to:", paste(family, collapse = " "))
    }
    if (!arial_ok && requireNamespace("systemfonts", quietly = TRUE)) {
      installed <- tryCatch(systemfonts::system_fonts(), error = function(e) NULL)
      if (!is.null(installed)) {
        arial_ok <- any(tolower(installed$family) == "arial")
        if (arial_ok) arial_detail <- "Arial confirmed by systemfonts."
      }
    }
    add("Arial font", arial_ok, arial_detail,
      "Confirm Arial is installed and available to XeLaTeX (Windows Settings > Fonts). Restart RStudio after installing a legitimately obtained Arial font. Do not label a substitute as Arial.")
  }
  result <- do.call(rbind, checks)
  for (i in seq_len(nrow(result))) {
    message(result$status[i], " - ", result$check[i], ": ", result$detail[i])
    if (nzchar(result$action[i])) message("  Action: ", result$action[i])
  }
  if (any(result$status != "PASS")) {
    stop("Render prerequisites are incomplete. Follow the actions above; no software or data was changed.", call. = FALSE)
  }
  message("Render prerequisites passed. This does not replace check_project.R, an actual Knit, or visual/page-count review.")
  invisible(result)
}

if (isTRUE(getOption("comp3020.render_preflight_autorun", TRUE))) {
  check_render_environment()
}
