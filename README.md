# COMP3020 Group 36 — Social Web Analytics project

**Responsibility and verification of AI-generated code in online discussions**

This project connects four research questions through text analysis, hypothesis testing, clustering and a directed reply network. It preserves the supplied raw and clean datasets, comment-level RQ2 labels and original group submissions. The report and one-page poster use the same analytical functions and group metadata.

Repository: https://github.com/ledinhtrung05-coder/COMP3020-Group36

## Verified status and remaining group information

The full `source("check_project.R")` workflow passed on **R 4.4.3**, with igraph 2.3.4 and cluster 2.1.8. The report and poster were actually knitted: **28 report pages** and **one A2 landscape poster page**. Word conversion also passed. The actual package environment is recorded in `outputs/session_info.txt`; detailed checks and limitations are in `docs/VALIDATION.txt` and `docs/FINAL_AUDIT.md`.

Arial was unavailable on the audit machine, so the report preview used Nimbus Sans and the poster preview used DejaVu Sans. The delivered Rmd sources still request **Arial**. The PDFs in `audit_previews/` are review copies, not final submission files. Complete the group information below, knit again on the submission machine and recheck pagination and layout.

The group has confirmed that it collected the data using R on **28 September 2026**. This records a calendar date only; no exact time or timezone has been supplied. The year follows the 2026 assignment context. The group also reports using an Excel expression/code step for the RQ2 labels; the exact original expression or workbook has not been supplied. The existing 123-ID implementation and supplied labels remain unchanged.

The remaining group actions are to enter member names, student IDs and actual contribution percentages, review the methods/results, and, if available, provide the original Excel expression or workbook so the label-generation procedure can be checked. A coder timestamp or independent-coding study is not an extra compulsory deliverable. Successful computations do not establish label validity or guarantee a mark. See [the collection and label guide](docs/COLLECTION_AND_LABELS_GUIDE.md) for the exact update locations.

## Run the project in Windows and RStudio

1. Extract the **entire ZIP**. Do not open an Rmd directly inside the ZIP.
2. Open `COMP3020_Group36.Rproj`. Keep the folder structure intact; do not replace shared paths with personal `C:/Users/...` paths.
3. Select **Session > Restart R** to begin in a fresh session.
4. Install the required packages once, or rerun this step if packages are missing:

```r
source("install_packages.R")
```

5. Run the analysis and supplied-snapshot checks:

```r
source("check_project.R")
```

This command reloads inputs from disk and reruns the analysis, avoiding stale RStudio objects. Running `run_analysis.R` separately beforehand is unnecessary. No API download occurs during analysis or knitting.

6. Render the report and poster:

```r
rmarkdown::render("Report_Group36_Integrated.Rmd", output_format = "pdf_document")
rmarkdown::render("Poster_Group36.Rmd", output_format = "pdf_document")
```

Alternatively, open each Rmd and select **Knit > Knit to PDF**. PDF output uses XeLaTeX. Use an existing working TinyTeX installation; install it only if needed, following the comments in `install_packages.R`.

For a Word report:

```r
rmarkdown::render("Report_Group36_Integrated.Rmd", output_format = "word_document")
```

After opening the result in Microsoft Word, press **Ctrl+A > F9 > Update entire table** to populate or refresh the table of contents and page numbers. Some viewers show only the TOC heading until this field is updated. The PDF contents page is compiled automatically. Do not copy fixed page numbers from an earlier document.

If a LaTeX issue prevents PDF output, inspect the report content through HTML while resolving the issue:

```r
rmarkdown::render("Report_Group36_Integrated.Rmd", output_format = "html_document")
```

HTML is a diagnostic view, not a substitute for the required submission PDF. If `Missing: igraph` appears, rerun `source("install_packages.R")`, then check `packageVersion("igraph")` before repeating the project checks. Preserve any installation error message rather than removing the package checks. A missing package does not mean the RQ2 data are missing.

The formatting was tested with Pandoc 3.1.3. Check the local version with `rmarkdown::pandoc_version()`. A missing `pandoc.zip` message concerns the Word-export tooling; update RStudio/Pandoc if necessary.

## Shared group details

Complete `docs/group_contributions.csv` once with each member's `member_name`, `student_id`, `contribution_percent` and `actual_contribution`. Contribution percentages must be numeric and sum to **100**. Record actual work; do not infer contributions from commit counts or assign equal shares without group agreement.

The report and poster read this same file, preventing inconsistent names, IDs or percentages. Complete the remaining review fields as appropriate rather than maintaining separate rosters in multiple files.

The collection manifest records the group-confirmed date, archived collector path, topic scope and observable limitations. The topical rationale in `docs/COLLECTION_AND_LABELS_GUIDE.md` is a **retrospective justification** based on the project direction, five discussion titles and literature; it is not a recovered historical search log. Exact search queries were not recorded and are not an expressly required separate submission. The original scripts remain archived unchanged. Review the intended RQ2 definition in `docs/CODEBOOK.md`; provide the original Excel expression/workbook if available, rather than inventing missing formula details.

Set `group_review_confirmed` and `final_mode` only after completing the corresponding review and required information. Every member should be able to explain the whole investigation; `docs/QA_PREPARATION.md` provides discussion prompts.

## Report and poster presentation

Keep the complete `formatting/` directory. The Rmd files depend on its Word reference, PDF styles and caption/page-break rules.

The report requests Arial 12, 1.5 body line spacing, 16-point headings, justified prose, Letter paper, **1.2-inch left/right margins** and 1-inch top/bottom margins. Tables and figures are centred with captions below. Code has no outer block indentation; meaningful indentation inside code is preserved.

The report retains the three-level TOC, title-page GitHub link, the **Research question** section containing RQ1–RQ4, and the 20 agreed page-start locations from the edited Word reference. Table proportions follow the reference, with widths constrained to the text area. See `docs/FORMATTING_MAP.md` for details. The report must remain within the **30-page maximum**; the subject outline gives a 10–30-page range. Recheck the complete PDF after any change to content, fonts, member details or data.

The poster uses **one A2 landscape page with four columns**. `Poster_Group36.Rmd` shares the report's computations and uses vector figures from `outputs/figures/`; retain `formatting/poster-style.tex`. Check text, figure labels, captions, references and member details at the intended display size. Keep editable sources and the final PDF consistent.

Interpretation must remain consistent across both outputs: the RQ2 test did not provide evidence of association under its assumptions; it did not prove no association. RQ3 produced weak, unbalanced lexical partitions. The network contains 144 authors participating in retained edges, whereas the corpus contains 186 authors in total.

## Inputs, outputs and RQ2 traceability

The supplied `hn_comments_clean(after add true false).csv` is preserved byte-for-byte under the portable filename `data/annotations/verification_labels.csv`. It contains **278 comments and 14 columns**, including **123 TRUE and 155 FALSE** values of `verification_specific`. The 13 original columns match the frozen clean dataset. The raw and clean input snapshots remain unchanged.

No relabelling, column extraction or additional label file is needed when using the complete package. The analysis joins on `comment_id`, validates shared fields and recomputes `received_reply` from retained parent–child relationships. Missing or mismatched annotation input stops execution; there is no fallback to the old aggregate table.

| `verification_specific` | No retained direct reply | Retained direct reply | Total |
|---|---:|---:|---:|
| FALSE | 86 | 69 | 155 |
| TRUE | 71 | 52 | 123 |

Actual R output gives Yates-corrected chi-square approximately 0.063666 and **p = 0.8007927**. Reply rates are 42.2764% for TRUE and 44.5161% for FALSE, a difference of −2.2397 percentage points. The by-thread table describes composition; it adds no further test and does not resolve comment/author dependence.

The recovered original script, `original_submissions/repo_03_hypothesis_labeling_a316232.R`, assigns TRUE to 123 listed IDs and FALSE to the remainder. Its ID list exactly matches the supplied labels. The intended definition is a mention of a specific way to check or test AI-generated code. The group reports an Excel expression/code step, but its exact original expression/workbook is unavailable. Neither a hard-coded ID list nor matching counts reconstructs that expression or establishes the semantic correctness of every label. The most useful additional evidence is the original Excel expression or workbook, with its handling of quotations and ambiguous cases. This is a measurement-validity check, not a new compulsory separate submission. If a justified review changes a label, preserve the original version, record the reason, update the relevant snapshot checks and rerun all affected outputs.

Generated outputs are:

- `outputs/tables/`: data audits, word frequencies, dictionary matches, RQ2 results and thread summaries, cluster diagnostics/examples, network metrics and the cluster–reply link.
- `outputs/figures/`: vector PDF figures for the report and poster.
- `outputs/session_info.txt`: actual R, operating-system and package versions.
- `outputs/analysis_results.rds`: an internal results object, excluded from Git.

Changes to shared input data can affect every analysis. Coordinate dataset changes rather than maintaining separate member-specific copies.

## Archived scripts and optional recollection

Three original scripts recovered from the repository are preserved unchanged in `original_submissions/`. Its `REPO_SOURCE_PROVENANCE.md` records the audited commit, source paths and SHA-256 hashes. The collector uses R/jsonlite to traverse `kids` for the five discussions; the cleaner removes dead/deleted records, processes HTML and derives `received_reply`; the RQ2 script applies the recorded TRUE-ID list.

**Do not source these archived scripts during the integrated analysis.** They contain immediate file reads/writes and historical `data/clean/` paths. They are retained for attribution and inspection. The group subsequently confirmed R collection on 28 September 2026. That confirmation does not establish an exact execution time, exhaustive collection or an undocumented search procedure.

The separate entry file is **`collection/01_collect_new_snapshot.R`**. It calls the supplementary collector in `R/01_collect_hn.R`; `R/01_rebuild_clean.R` remains a separate supplementary cleaner. These are prospective implementations, not replacements for the archived historical scripts.

To inspect or deliberately run a new collection:

1. Open the `.Rproj`, then open `collection/01_collect_new_snapshot.R`.
2. Read and edit only the clearly marked **EDIT** settings, including the discussion IDs and a new output destination when required. Follow `docs/COLLECTION_AND_LABELS_GUIDE.md` for the exact fields.
3. Save the entry file. Only when you intend to download a **new snapshot**, run:

```r
source("collection/01_collect_new_snapshot.R")
```

The entry file does not run during Knit. Keep its new output separate from `data/raw/`, `data/processed/` and `data/annotations/`; do not overwrite the analysed snapshot. **Do not run this collection step merely to reproduce the existing report.**

Use the supplied frozen inputs to reproduce the report. A fresh API download may change the comment count and cannot reconstruct previously deleted content.

## Repository audit and update procedure

The read-only audit inspected `main` at commit `a316232f509d1e283f048a0e62d5ccfffa1886ba`, dated **9 October 2026, 21:15:57 Sydney time**. At that point the URL returned HTTP 200 without sign-in, and cloning/history inspection succeeded. These findings apply to that pinned historical commit, not to later uploads. No remote writes or pushes were made during the audit.

That historical version lacked the real annotation file and formatting assets, contained an older report, and placed a standalone RQ2 script where callers expected `analyse_hypothesis()`. The integrated package keeps the function module in `R/` and the original script in `original_submissions/`. Do not overwrite `R/03_hypothesis.R` with the standalone original.

For a new package update:

1. Extract it into a temporary folder and confirm that the `.Rproj`, Rmd files, `R/`, `collection/`, `data/`, `formatting/` and `docs/` are present.
2. Copy the **contents inside the project folder** into the **existing repository root**, replacing corresponding files while preserving `.git/`. Avoid creating a nested `COMP3020-Group36/COMP3020_Group36/` project.
3. Remove the superseded `docs/FINAL_AUDIT_VI.md` if it remains from an earlier upload; the English replacement is `docs/FINAL_AUDIT.md`. Keep `data/annotations/verification_labels.csv`. An old blank `verification_labels_TEMPLATE.csv` is not analytical data. If the historical `R/01_clean_hn.R` remains, do not source it in the integrated workflow; its preserved copy belongs in `original_submissions/`.
4. Open the `.Rproj`, run `source("check_project.R")`, then knit and inspect both PDFs. Recollection is unnecessary.
5. Include the checked final report and poster PDFs with their sources, data, references and session information. Replace any outdated `docs/group36_poster.pdf` with the matching final poster rather than leaving conflicting versions. `audit_previews/` is ignored by Git and does not replace submission PDFs.
6. Review the changes in GitHub Desktop or RStudio's Git tab, commit and push. Preserve repository history. After pushing, check the exact files in a private/incognito browser window and confirm that they match the submitted PDFs.

For group work, assign an integration owner and use small, descriptive commits on branches such as `rq2`, `rq4` and `integration`. Review changes before merging into `main`; avoid simultaneous edits to the main report or frozen inputs.

Commit the required data, scripts, Rmd files, references, documentation and final outputs. Do not commit tokens, `.Renviron`, `.RData`, package libraries or caches. If adopting `renv` after a successful run, retain `renv.lock`, its initialisation `.Rprofile` and `renv/activate.R`; other members can then use `renv::restore()`.

Have another member clone into a fresh folder and run the README instructions. The marker must be able to access the repository; if it is private, explicitly grant and verify access. Before submission, confirm the final report page limit, one-page poster, group details, repository version and required course submission files.

## Language and method-record revision

All maintained project instructions and documentation are in English. Original research texts, author names and archived group submissions remain unchanged. The English audit is `docs/FINAL_AUDIT.md`. The collection manifest now records the group-confirmed R collection date of 28 September 2026 without inventing a time or timezone. The collection guide separates retrospective topical justification from unrecorded historical search steps. The annotation codebook distinguishes the supplied labels and 123-ID implementation from the group-reported Excel step whose exact expression is not yet available.
