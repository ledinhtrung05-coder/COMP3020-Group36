# Collection and RQ2 evidence: confirmed facts and exact update locations

## Confirmed in this revision

The group states that it downloaded the data on **28 September 2026 using an R script**. The supplied date was 28/9; the year is interpreted in the 2026 assignment context. No collection time or timezone was supplied. The latest retained comment is dated 25 August 2026 UTC, which does not conflict with that collection date. A comment's creation timestamp is not its download timestamp.

The date is recorded once in `data/collection_manifest.csv`, in `original_collection_date`. Both report and poster read it. `original_collection_utc` remains intentionally empty because no exact UTC timestamp is known. This is a documented precision limit, not an unfilled compulsory assignment field. The collection check now accepts a valid calendar date with its evidence source and explicit limitations.

The group also reports an Excel-code step for the RQ2 labels. The precise Excel expression, workbook, macro or other implementation was not supplied. This revision records that fact without assuming keyword matching, manual coding, AI classification or an independent human review.

## Why these discussions fit the study

The recorded project direction moved from AI in work to responsibility and verification of generated code after considering discussion platforms. The supplied five-thread corpus matches that focus. The relevance explanation below is a **retrospective justification of the available sample**, not a reconstructed search log or a claim that these exact criteria were specified before collection.

| Thread ID | Observed focus | Contribution to the study |
|---|---|---|
| 43857643 | Whether the AI-code author should also be the reviewer | Human ownership, accountability and independent review. |
| 47289406 | Verification debt and the cost of AI-generated code | The checking burden, trust and practical verification choices. |
| 47397367 | Automated verification of unreviewed generated code | Automated checking in relation to human verification. |
| 49321400 | Tools for human review of AI-assisted code | Explicit review practices and tools. |
| 49378314 | How people review and validate LLM-generated code | Concrete checking and testing discussion. |

Vaithilingam, Zhang and Glassman (2022) identify difficulties understanding and debugging generated code. Barke, James and Polikarpova (2023) study how programmers validate generated suggestions. These studies motivate the verification focus; they do not establish that these five discussions represent programmers or validate the RQ2 labels. Full bibliographic records are in `references.bib` and report Section 1.

Hacker News provides text and parent/child relationships through its documented item API. These support the shared text, hypothesis, clustering and reply-network workflow. This is a practical fit for this bounded project, not evidence that Facebook, YouTube or other platforms lack relevant conversations. No complete cross-platform search, random sampling or population coverage is claimed. Exact historical queries, search dates, numbers screened and exclusions are not recoverable from the current evidence and have not been invented.

## Separate collection files and what to update

| File | Purpose | Your exact action |
|---|---|---|
| `original_submissions/repo_01_collect_hn_a316232.R` | Unchanged collector recovered from GitHub commit a316232. It documents the five IDs, R/jsonlite calls and traversal. | Inspect as historical evidence. Do not source it during the integrated analysis: its final line writes the frozen raw-data path. |
| `collection/01_collect_new_snapshot.R` | Separate, optional entry point for a new logged download. It is not evidence of the September execution. | EDIT 1: thread IDs. EDIT 2: a new output folder. EDIT 3: set `run_collection` to TRUE only if deliberately recollecting. No download is needed to reproduce this report. |
| `R/01_collect_hn.R` | Implementation called by the optional entry point. Logs new API requests. | No routine edit is required. Logs produced now must never be described as September logs. |
| `data/collection_manifest.csv` | Collection date, script path, limitations and per-thread rationale for the analysed snapshot. | The confirmed date and rationale are already filled. Update `original_collection_R_script` only if the actual historical source differs; update date fields only from real records. Do not fill unknown UTC time with midnight. |
| `docs/group_contributions.csv` | Shared cover and poster member details. | Fill names, IDs, actual contributions and percentages yourself, as agreed. |

If your actual September collector differs from the recovered script, save the exact original as `collection/01_collect_hn_actual_20260928.R` and set `original_collection_R_script` to that path for the relevant rows. This is a suggested future filename, not a file claimed to exist in this package. Keep the recovered archive intact. Do not change raw/clean CSVs merely to tidy the collection documentation.

For optional future collection, open the project and run:

```r
source("collection/01_collect_new_snapshot.R")
```

With the delivered `run_collection <- FALSE`, the file makes no requests and writes no data. A deliberate new run writes into `data/new_downloads/`, not the report's frozen input paths. Never use a new API download to assert that the historical snapshot was complete.

## RQ2: what TRUE means and what remains unverified

The recovered teammate R script states the intended definition: **TRUE means the comment mentions a specific way to check or test AI-generated code**. The script assigns TRUE to 123 listed IDs and FALSE to the other 155. The ID list exactly matches `data/annotations/verification_labels.csv`. FALSE is the supplied complementary label; it is not independent proof that a comment contains no verification language. A mention is not endorsement or observed real-world behaviour.

The original Excel rule cannot be reconstructed uniquely from a CSV of outcomes or an R list of IDs. For example, 47290993 is FALSE despite discussing review, while 43862196 is TRUE when review appears in a criticised quotation. These could reflect different intended scope or inconsistent classification. The current evidence cannot choose between those explanations. They have not been silently relabelled. More examples and proposed review guidance appear in `docs/CODEBOOK.md`.

**The one useful follow-up item:** the original Excel formula/code, workbook, or a screenshot showing the full expression and referenced columns. If available, preserve it under `original_submissions/` and document the actual rule in `docs/CODEBOOK.md`. No placeholder Excel file is included. Without it, the report remains explicit that this implementation has not been inspected. No manual coding or reliability assessment is claimed.

## Why a nearly finished report could still have these gaps

Computational reproducibility and measurement provenance are separate. The supplied data are sufficient to recompute the contingency table, plots, clusters and network. They cannot prove when a collector ran, how threads were originally discovered, or why an Excel expression assigned a particular label. The prior review report stated these limitations; blank historical metadata were not substituted with invented dates or coding histories. Calling the package fully submission-ready before this distinction was resolved would overstate its status.

This revision fills the group-confirmed date and R execution, adds an evidence-based sample rationale and identifies the remaining Excel limitation. The report's four-RQ structure is unchanged. Raw data, clean data and labels remain byte-identical. The RQ2 table remains FALSE = 86 without / 69 with a retained reply, TRUE = 71 without / 52 with a retained reply, with reference p = 0.8007927. This numerical reproducibility does not validate every label.

If a documented review later changes labels, version the original data, record the changed IDs and reasons, and rerun RQ2 and its report/poster interpretations. If only provenance prose changes, numerical results need not change. Changes to the underlying corpus require all analyses to be rerun. No causal, representative-population or validated-manual-coding claim is warranted here.

## Final local handoff

Fill member details, review the report's disclosed limitations, run `source("check_project.R")`, and knit both Rmd files. After actual group review, set `group_review_confirmed: true` and `final_mode: true` in **both** report and poster. These flags record a review decision; they do not turn unknown historical details into known facts. Inspect the complete report for the 30-page limit and the poster for one-page layout, then upload the matching PDFs and repository files.
