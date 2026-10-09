# Integration changes relative to supplied work

| Area | Preserved | Added/corrected | Reason |
|---|---|---|---|
| Raw and clean data | Byte-identical originals | Full 14-column supplied annotation CSV preserved byte-for-byte under a portable filename; all 13 shared fields checked | Keep the original snapshot and preserve annotation provenance |
| RQ2 | Actual teammate question, H0/H1, supplied labels, 2x2 table and Yates test | Required annotation input, keyed join, shared-field/outcome validation, proportions/difference, descriptive by-thread table and dependence limits | Recalculate from actual rows and fail on missing or mismatched data |
| RQ2 prose | Initial cautious no-evidence interpretation and reply-not-agreement limitation | Remove 'has no bearing'; correct thread/comment unit | Non-significance is not proof of no association |
| RQ4 | Direction, 144-node boundary, 193 edges, centralities, full/LCC analysis | New reproducible implementation, frequency separate from path distance, root/missing-parent audit | Original network R code absent |
| RQ4 figures | Full graph and justified LCC purposes | Recreated seeded, legible plots | Figures are newly generated; not claimed pixel-identical to teammate PDF |
| RQ1/RQ3 | Original conceptual questions | Transparent text indicators, examples, complete clustering diagnostics | Complete missing analyses without fabricated manual labels/themes |
| Overall | Approved responsibility/verification topic | Coherent synthesis, research foundation, limitations and source references | Meet whole-investigation criterion |
| Reproducibility | Original submissions archived | Relative paths, shared definitions, exports, run checks that reload disk inputs, documentation | Allow another member/marker to reproduce without stale RStudio objects |

No original submission has been overwritten. `original_submissions/` contains the received Rmd and network PDF, plus exact original collector, cleaner and RQ2 labeling scripts recovered from the audited GitHub commit. Changes are presented in the new integrated report.

## Annotation update — 9 October 2026

The newly supplied file resolves the previous missing-input limitation. Its 278 records contain 123 TRUE and 155 FALSE verification labels; the row-level cross-tabulation is `[[86, 69], [71, 52]]`, matching the teammate's reported counts and Yates p-value (approximately 0.8008). No label was changed. The report now calculates RQ2 from these records; aggregate fallback and blank-template instructions have been removed. A descriptive breakdown by thread improves transparency without adding significance tests or changing the research question.

Original annotation rules and collection history still need documentation. Unchanged text, IDs and parent relations mean the annotation update does not change RQ1/RQ3/RQ4 inputs. R 4.4.3 is available for the final audit; actual execution/render outcomes are recorded in VALIDATION.txt. The group must still inspect the final files on its own machine.

## Presentation update from the supplied Word reference

The report now supports PDF and Word with Arial 12, 1.5 spacing, 16-point black headings, justified prose, centred figures/tables and captions below. Left/right margins are 1.2 inches (explicit interpretation of the requested unit); Letter paper and 1-inch top/bottom margins follow the sample. Page starts now follow the 20 explicit template locations, including selected minor sections, as corrected in the template-fidelity update below. Code has no outer indentation and retains its internal spaces. Captioned tables keep the caption with the final row. Three existing descriptive tables now have captions.

The supplied Word file is used as a formatting reference, not as the analytical source: it contains older RQ2 wording. Data, analytical functions, research questions and conclusions remain unchanged by this formatting update. Required formatting assets are included in the project and tracked by Git. The poster retains its separate one-page layout. Font/layout smoke tests do not establish the final report's 30-page compliance; inspect the actual R-rendered PDF.

## Template fidelity correction

Restored the native three-level TOC, the Research question wrapper and unnumbered RQ hierarchy, and all 20 explicit page-start locations from the supplied edited Word sample. Restored measured table widths/proportions, template heading colour and title alignment. Added the supplied GitHub URL before the TOC on the first page. Caption placement follows the explicit below-table/figure note. Analytical code and data remain unchanged. See FORMATTING_MAP.md for geometry and validation limits.

## Final repo, poster and metadata integration

- Audited the real repository at main/a316232; no remote changes were made. Recovered and archived the group collector/cleaner/labeling script, with commit and checksums.
- Identified the remote RQ2 integration failure: a standalone script replaced the function module and used an absent data/clean path. Keep the callable module in R/ and preserved originals under original_submissions/.
- Confirmed the recovered list of 123 TRUE IDs exactly matches the supplied annotation; detailed judgement rules still need group confirmation.
- Report and poster read one member/contribution record from docs/group_contributions.csv; contribution_percent must sum to 100.
- Revised poster delivery to one A2 landscape page with four columns, shared analytical results and vector plots; source and final PDF must remain consistent.
- Target report pagination is at most 30 pages while retaining agreed manual breaks. Record actual R-rendered page counts in VALIDATION.txt.
- Updated GitHub handoff to copy project contents into the existing repo root, preserving .git and avoiding nested projects or overwriting callable modules with standalone originals.

## English documentation and method-record update

- Rewrote README and final audit in English; replaced `docs/FINAL_AUDIT_VI.md` with `docs/FINAL_AUDIT.md` and updated internal references. Remove the superseded Vietnamese file from any existing checkout when applying this update.
- Populated the collection manifest with the archived collector path, its documented topic scope and code-observable limitations. Execution date and original search/selection steps remain unconfirmed.
- Clarified that the RQ2 ID list proves how labels are applied, not whether original decisions were manual or automated. Detailed review rules remain explicitly proposed until group confirmation.
- Distinguished official assignment requirements from optional logs and internal metadata checks. No dataset, label or analytical result was changed by this revision.

## Group-confirmed collection and Excel-label clarification

- The group confirmed collection using R on **28 September 2026**. The date is recorded at day precision; no exact time or timezone is invented. Earlier audit statements about the then-unconfirmed date are historical, not the current status.
- `docs/COLLECTION_AND_LABELS_GUIDE.md` explains the topic choice retrospectively using the agreed direction, five discussion titles and literature. It does not fabricate historical search queries or selection steps.
- The group reports an Excel expression/code step for RQ2; its exact original expression/workbook has not been supplied. The intended definition, complete labels and matching 123-ID script are preserved without adding unsupported manual-coding or reliability claims.
- Added a separate optional collection entry at `collection/01_collect_new_snapshot.R`, with EDIT settings and new-snapshot output. Archived scripts and analysed input files remain unchanged.
- Clarified that exact UTC timestamps, search logs and coder/reliability records are not additional compulsory deliverables. The group will fill its own member/SID/contribution information.
