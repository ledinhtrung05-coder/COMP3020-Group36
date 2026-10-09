# Run once in the RStudio project Console. Installation is separate from knitting.
packages <- c("here", "rmarkdown", "knitr", "cluster", "igraph", "xml2", "jsonlite")
missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) install.packages(missing, repos = "https://cloud.r-project.org")
message("Packages checked. For PDF you also need a LaTeX installation (e.g. your existing TinyTeX).")
# If PDF reports no LaTeX installation, run these ONCE, not inside the report:
# install.packages("tinytex")
# tinytex::install_tinytex()
# Optional AFTER a successful run: install.packages("renv"); renv::init(); renv::snapshot()
