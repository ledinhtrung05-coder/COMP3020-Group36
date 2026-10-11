# Final review of the investigation and submission package

**Revision note:** This document preserves the preceding audit and baseline results. Subsequent methodological improvements are documented in `docs/CRITERIA_AND_IMPROVEMENTS.md`; the latest execution and pagination evidence is in `docs/VALIDATION.txt`. Original numerical results and limitations below remain distinguishable from the new sensitivity analyses.
Review scope: the integrated report, poster, all supplied data, preserved teammate work, the assignment brief, Ultra instructions/rubric screenshots, the edited report reference, the poster examples and the freshly fetched GitHub repository. This document explains the findings; it is not a guarantee of a mark or evidence of an unperformed group review.

## 1. Is the outline suitable, and does it use the available evidence well?

**Yes, within the stated exploratory scope.** The investigation narrows the broad topic of AI at work to responsibility and verification of AI-generated code. This matches the supplied discussions and avoids unsupported conclusions about all occupations or actual software quality.

| Part | Reason for its position | Evidence used |
|---|---|---|
| Purpose and related RQs | Define the problem and explain why all four analyses belong to the same study. | Verification literature; one overall question and four related RQs. |
| Data and boundaries | Establish what was observed before interpreting measurements or relations. | Group-confirmed R collection on 28 September 2026; recovered collector/cleaner; raw, clean and labelled CSVs; thread/parent IDs. |
| RQ1: text | Establish visible vocabulary and contextual examples of ownership, review and testing. | Word frequencies, two text visualisations, overlapping candidate indicators and inspected examples. |
| RQ2: association | Connect a comment's supplied practice-mention label with its observed reply outcome. | The teammate's complete comment-level labels and test; keyed joins, expected counts, rates and thread breakdown. |
| RQ3: clusters | Test whether lexical similarity supports meaningful content groups before treating clusters as themes. | Explicit representation/distance/k rule, diagnostics, dendrogram, actual comment readings and sensitivity checks. |
| RQ4: network and content link | Describe who replies to whom and connect receiving comments to their content partitions. | The teammate's directed network, full graph/subgraph, two centralities and a comment-ID-based cluster bridge. |
| Synthesis and limits | Answer the overall question with results that the design can support. | Observed rates, weak cluster separation and network structure, with sampling/measurement/dependence limits. |

The sequence uses earlier analyses to inform later interpretation without pretending that the study was preregistered. RQ2 replaces the earlier reading-versus-testing proposal with the teammate's completed question. RQ4 retains the teammate's structural results and adds the content connection. These are documented integration decisions, not four independent exercises joined only by a title.

## 2. Is the reasoning and use of theory sound?

The literature motivates studying verification and responsibility; it does not validate the project's dictionary or prove that specific-practice mentions cause replies. The report distinguishes conceptual motivation from empirical evidence.

The source audit confirmed the main author/title/year/DOI records and checked the associated claims. Barke et al. and Vaithilingam et al. provide empirical motivation for studying generated-code validation. O'Brien's interviews and interaction logs support distinguishing reported confidence from observed verification success. Agarwal et al. is explicitly treated as a preprint proposing explanatory theory, not as established causal evidence. The methodological references support TF-IDF, silhouette, chi-square interpretation and network definitions.

Primary records rechecked in the closing review include:

- Barke et al. (2023): https://cseweb.ucsd.edu/~npolikarpova/publications/oopsla23-copilot.pdf
- Vaithilingam et al. (2022): https://tianyi-zhang.github.io/files/chi2022-lbw-copilot.pdf
- O'Brien (2025): https://arxiv.org/abs/2502.17348 and https://arxiv.org/html/2502.17348v1
- Agarwal et al. (2026): https://arxiv.org/abs/2607.07980 and https://arxiv.org/pdf/2607.07980

The following limits are substantive and remain in the final sources:

1. **RQ2 measurement:** 123 TRUE IDs reproduce the supplied labels, but the original Excel expression is unavailable. Matching an ID list is not proof that every semantic decision is correct. The operational intention is documented; ambiguous examples are disclosed.
2. **RQ2 inference:** expected cell counts exceed five, but repeated authors and nested threads violate a simple independent-comment interpretation. The test is reported as an exploratory reference calculation. Its p-value does not prove no association, causality or population generalisability. This remains a limitation of test suitability, not something removed by an explanatory sentence.
3. **RQ3 substance:** the 262/2 partition has very weak separation. The tiny pair shares the word “hand” in different senses. Reporting this failure is more defensible than inventing two attractive theme names. It limits the substantive value of the cluster-to-reply comparison.
4. **Sampling:** five selected discussions are not representative of Hacker News, programmers or workplaces. The available topical justification is retrospective; exact historical queries and exclusion decisions are not reconstructed.

These boundaries prevent an honest guarantee of HD or full marks. They do not indicate invented numerical results or require discarding the coherent four-RQ structure.

## 3. Does the execution match the plan and preserve the team's work?

| Check | Verified result |
|---|---|
| Three supplied datasets | 313 raw comments; 278 clean comments; 278 labelled comments, including 123 TRUE and 155 FALSE. All eight frozen input/archive hashes remain unchanged. |
| Cleaning and joins | The 35 removals are 30 dead and 5 deleted records. Shared raw/clean fields and annotation fields are checked by unique comment ID, not row order. |
| RQ2 | FALSE: 86 without / 69 with a retained direct reply. TRUE: 71 without / 52 with a retained direct reply. Yates reference p = 0.8007927; observed difference = -2.2397 percentage points. |
| RQ3 | 264 eligible comments and 1,250 terms; primary k = 2, sizes 262/2, mean silhouette approximately 0.0151. The declared minimum-size rule fails, so this is explicitly a diagnostic fallback. |
| RQ4 | 198 matched reply events, 193 directed author pairs, 144 network authors, 9 weak components and largest component of 128. The corpus has 186 authors; the distinction is explained. |
| Team integration | Original RQ2 labels/test and RQ4 structural findings are preserved. Original submissions and recovered scripts remain archived. Added validation, contextual explanation and cluster bridge are identifiable. |
| Cross-machine use | Relative paths, project-root discovery, UTF-8 inputs, explicit ID/logical parsing and separate installation/collection/render steps are retained. No personal machine path is required. |
| Report and poster | Both read the same analytical functions and member CSV. Poster statements are bounded by the same assumptions and use the same computed results. |

The final runtime and page-count evidence is recorded in `docs/VALIDATION.txt`. The report requests Arial 12, 1.5 spacing, 16-point headings, justified prose, the preserved TOC, agreed page starts, 1.2-inch side margins, and captions below centred figures/tables. Preview fonts differ because Arial is absent on the audit machine; the group's final Arial PDFs must be inspected locally.

## 4. Rubric coverage and remaining quality risks

The Ultra rubric assigns the group component 3 marks for coherent RQs, 7 for application/appropriateness, 7 for interpretation, 1 for visual communication and 2 for originality. The individual discussion contributes a further 10 marks. The poster is the primary communication and the report supplies supporting evidence.

All four required analytical families are represented. The report includes two text visuals with frequent words; H0/H1, a justified reference test and assumptions; clustering representation/distance/k decisions and contextual profiles; full network plus a justified subgraph and two centralities. The poster communicates all four RQs and the principal results. The content-to-interaction link supports coherence and originality, while honest treatment of the weak clusters supports interpretation.

The principal remaining academic risks are the RQ2 measurement/dependence limits and the weak thematic clustering. Additional decorative output, stronger adjectives or a new unsupported model would not resolve them. The group must understand and be able to explain these choices at the discussion.

The report and poster are the required PDF submissions. The Rmd/code/data belong in the accessible repository. Archiving matching final PDFs in the repo is recommended for consistency; the explicit repository requirement is code and data. The supplied Ultra instructions specify three members, the report cover information and contribution percentages totalling 100. They do not require an exact UTC collection timestamp, historical query log or a separate inter-rater study.

## 5. Current GitHub audit and changes made

The fresh read-only audit at 2026-10-09T13:00:42Z inspected:

https://github.com/ledinhtrung05-coder/COMP3020-Group36/tree/b8b27020ff6a3d9dc6cebc071338f4c7bbb89f86

The public repository returned HTTP 200 and the fetch succeeded. Earlier missing-module, label-file and formatting problems are resolved. All 29 result CSVs match the integrated analysis. No remote write was performed.

The group added real names/SIDs under an unused `student id` YAML field. This revision transfers exactly those entries into `docs/group_contributions.csv`, which actually feeds both covers. It does not invent contribution percentages or claim completed group review. The group's Windows session record is preserved separately in `docs/GROUP_RUN_SESSION_INFO.txt`; `outputs/session_info.txt` describes the most recent run that generated the packaged outputs.

The old `docs/group36_poster.pdf` is still present in the audited remote commit and differs from the current poster. Replace it with the new final render. The old `R/01_clean_hn.R` and blank `verification_labels_TEMPLATE.csv` are obsolete extras; the integrated package uses the current modules and complete annotation file. They are not needed to reproduce the report.

Final presentation corrections clarify the RQ2 reference-model interpretation, add the concrete “hand” cluster explanation to the poster and make RQ3's wording match the report. Word output no longer requests the unsupported `fig.align` option. The separate Windows “permission denied” error is caused by inability to write the target DOCX; closing the open output or using a fresh filename addresses that output-file issue, not an analytical defect.

## 6. Exact remaining handoff

1. In `docs/group_contributions.csv`, check the names/SIDs already copied from your repo and enter genuine contribution percentages totalling 100. Complete actual-role fields from the group's own account.
2. Read and review the interpretations and limitations. Once the group has actually reviewed them, set `group_review_confirmed: true` and `final_mode: true` in both Rmd files.
3. Run `source("check_project.R")`, then render both Rmd files to PDF with the README commands. Do not run a new collection just to reproduce the report.
4. Inspect the final report (maximum 30 pages) and poster (one page), cover details, TOC, citations and all figures/tables. The preview PDFs still have unfinished contribution/review information and are not final submission PDFs.
5. Copy the new package contents into the existing repository root. Preserve repository history, remove obsolete extras only after checking them, and replace the old poster PDF. Keep the code/data and submitted PDFs consistent.
6. Submit the report and poster PDFs through the assignment submission link. All members should prepare for questions about the complete investigation.
