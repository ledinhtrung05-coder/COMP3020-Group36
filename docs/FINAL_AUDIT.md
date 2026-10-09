# Final audit and handover — COMP3020 Group 36

Audit date: 9 October 2026. This document records the checks, integration decisions and information the group still needs to confirm. It does not promise a grade or certify work that has not been performed. Repository findings are tied to the audited commit and must not be treated as the current state after a later upload.

## 1. Overall assessment

The research scope fits the available evidence: **expressed responsibility, verification of AI-generated code and reply relationships in five selected Hacker News discussions**. These comments cannot establish actual productivity, code quality or the behaviour of programmers as a population.

The four analyses form a coherent investigation, and the main numerical results have been independently checked. The priorities are concrete interpretation, accurate documentation of collection and annotation, repository consistency and compliance with the page limit. A weak cluster solution and a large p-value remain legitimate findings when interpreted appropriately. Neither the data nor cluster names should be changed to manufacture a stronger conclusion.

**R 4.4.3 and `source("check_project.R")` ran successfully.** Snapshot checks, ID joins and invalid-input checks passed; actual results were exported to `outputs/`. These checks do not validate annotation judgements or statistical assumptions. PDF rendering and font limitations are recorded separately in section 7.

## 2. Rationale for the report structure and analytical sequence

| Stage | Research role | Reason for the approach | Interpretation boundary |
|---|---|---|---|
| Foundation and data | Explain why responsibility and verification matter; define the five-thread corpus | Empirical Copilot research and provider guidance motivate the concepts; the data audit identifies answerable questions | Prior research does not validate this corpus's dictionary or labels |
| RQ1 — Content | Identify the responsibilities and verification practices discussed | Word frequencies, overlapping lexical indicators and contextual examples combine coverage with interpretation | Mention is not endorsement or behaviour; quotations and sarcasm can produce matches |
| RQ2 — Replies | Examine whether a specific-practice mention is associated with receiving a direct reply | Two binary variables produce a 2×2 count table; preserve the teammate's Yates-corrected chi-square and add rates and assumption checks | A reply is not agreement; a large p-value does not establish absence of association; comments share authors and conversations |
| RQ3 — Content structure | Investigate whether meaningful lexical groups emerge | Log TF-IDF, L2 normalisation, cosine distance and hierarchical clustering are assessed with silhouette, sizes, examples and sensitivity checks | An algorithmic partition does not guarantee clear themes; avoid unsupported supporter/opponent labels |
| RQ4 — Relationships and content | Describe who receives replies, the network structure and the content at the receiving end | Edges use actual parent IDs; in-degree and betweenness describe different structural roles; clusters join through comment IDs | An author can contribute to several clusters; centrality does not establish expertise or causal influence |
| Synthesis | Combine content, association and reply-structure evidence | Answer the overall question using observed results while respecting each measurement's limits | Combining analyses does not remove their limitations |

RQ1 precedes RQ2 because the language being measured should be understood before its association with interaction is assessed. RQ3 adds an independent examination of lexical structure, and RQ4 connects that structure to observed replies. When RQ3 produces weak clusters, the RQ3–RQ4 bridge remains descriptive. This preserves coherence without concealing an unfavourable diagnostic result.

The foundations are recorded in `references.bib` and `docs/RESEARCH_DECISIONS.md`: Vaithilingam, Barke and O'Brien motivate the concepts; Grimmer and Stewart support contextual validation of text measures; Manning supports representation choices; and R, igraph and Hacker News documentation support computational and source definitions. The Agarwal paper is explicitly a preprint, not validated causal evidence. The group should confirm the exact algorithms against its lecture and lab materials; module titles alone do not establish that every algorithm was taught.

## 3. Assignment requirements and rubric mapping

Authoritative sources: `COMP3020_Assignment_2026(1)(1).pdf`, pages 1–3; `COMP3020_2026_Spring_Hybrid(1).pdf`, physical PDF pages 12–13; and the uploaded Ultra screenshots ending `102044`, `102101`, `102105`, `102121`, `102135` and `102145`. The task-specific brief and Ultra instructions govern this project. The final-exam AI prohibition does not apply to this group assignment.

| Requirement or criterion | Evidence in the project | Assessment or remaining action |
|---|---|---|
| Related questions and coherent investigation — 3 marks | RQ table, rationale, four analyses and synthesis in `Report_Group36_Integrated.Rmd` | Appropriate structure; the revised RQ2 and RQ4 extension are identified |
| Appropriate analytical methods — 7 marks | `R/00_data.R` through `R/04_network.R`; report methods and assumption checks | All four analysis families are present. RQ2 dependence and label validity still restrict inference |
| Interpretation, conclusions and insight — 7 marks | RQ1 examples, RQ2 rates, cluster reading, centralities and synthesis | Use concrete results and explain their meaning within the study boundaries |
| Visual communication and poster quality — 1 mark | `Poster_Group36.Rmd`, `outputs/figures/` and report formatting | The rendered A2 landscape, four-column poster was checked as one page |
| Creativity/originality — 2 marks | Responsibility/verification-to-reply connection and comment-level cluster bridge | The contribution is a transparent, bounded connection, not a claim to be the first study |
| R collection; document access, packages, variables, volume and limitations | Recovered team scripts in `original_submissions/`, supplementary code in `R/`, collection description and `data/collection_manifest.csv` | The team confirms R collection on 28 September 2026. Describe the supported method and limitations; distinguish retrospective topical justification from unrecorded search steps |
| Text analysis with at least two informative visuals, including frequent words | RQ1 figures, summaries, representation and contextual examples | Covered in the report; the poster selects the important findings rather than repeating every figure |
| Hypotheses, suitable test, justification and contextual interpretation | RQ2, `R/03_hypothesis.R` and the actual annotation CSV | Computation is reproducible. The group reports an Excel expression/code step; the original expression/workbook would clarify ambiguous cases |
| Clustering representation, distance, k, visualisation and characteristics | RQ3, `R/02_text_cluster.R`, diagnostics, profiles, examples and sensitivity | Covered; the weak primary result must remain a weak result |
| Data-derived network; full graph and justified subgraph; at least two centralities | RQ4, `R/04_network.R`, full graph/LCC, in-degree and betweenness | Definitions and analysis are present; retained-edge and missing-parent boundaries remain explicit |
| Report PDF from R Markdown, at most 30 pages; poster PDF, one page | The two Rmd files and `formatting/` | The verified rendering was 28 report pages and one poster page; recheck after later edits and on the target fonts |
| Cover: group number, names, student IDs and contribution percentages totalling 100 | `docs/group_contributions.csv` and `R/06_metadata.R` | Enter actual details; do not assume equal shares or invent identities |
| Accessible repository containing data, code and reproduction instructions | Cover URL, `README.md` and project files | The earlier audited commit had integration defects. Later uploads require a fresh commit-specific check |
| Individual Q&A: methods 4, results 3, critical response 3 marks | `docs/QA_PREPARATION.md` | Every member should understand the entire project and attend the approximately ten-minute Week 14 discussion |

The poster is the main communication assessed for the **20 group marks**, with the report as supporting evidence. The supplied documents do not give detailed HD band descriptors. Completing a checklist therefore cannot guarantee an HD. The stated deadline is **9 October 2026, 11:59 pm**, subject to any separately granted extension.

**Requirement versus internal workflow:** the brief requires collection using R and documentation of access, packages, variables, volume and limitations. It does not prescribe a separate log submission, an exact collection timestamp field or a particular manifest schema. The manifest and optional logs are project tools for traceability. The group has confirmed the collection date, 28 September 2026, and use of R. Exact time/timezone and query history remain unrecorded. The topical rationale is retrospective, not a search log. Document these boundaries rather than inventing precision or presenting our internal checklist as an extra university rule.

## 4. Verified baseline results

The following baseline results were independently recalculated and checked against actual R 4.4.3 output in `outputs/tables/`. `outputs/session_info.txt` records the execution environment. If the analytical specification is subsequently changed, regenerate the outputs and update the corresponding interpretation.

| Item | Result |
|---|---|
| Data | 313 raw → 278 retained comments; 30 dead and 5 deleted removed; 5 threads; 186 authors |
| RQ2 labels | 123 TRUE and 155 FALSE; all 13 existing fields match by ID; no missing or duplicate IDs |
| RQ2 table | FALSE: 86 without reply / 69 with reply; TRUE: 71 / 52 |
| RQ2 result | TRUE reply rate 42.2764%, FALSE 44.5161%; difference −2.2397 percentage points; Yates χ²=0.063666, df=1, p=0.800793 |
| Clustering representation | 264 comments and 1,250 terms; 14 comments unassigned |
| Primary partition | k=2, sizes 262/2, mean silhouette≈0.01507; no k=2–8 satisfies the five-comments-per-cluster guard |
| Network | 198 reply events → 193 directed author pairs; 144 nodes; density≈0.00937 |
| Components | 9 weak components, largest 128; 102 strong components, largest 10 |
| Centrality | simonw and fishtoaster both have in-degree 14; normalised betweenness≈0.019108 and 0.003004, respectively |
| Content–reply bridge | Large cluster: 118/262 comments receive replies and 195 incoming events; two-comment cluster: no replies |

The small cluster contains comments 43877106 and 47289697, which use “hand” with different meanings. That does not establish a common code-verification theme. In RQ2, expected counts above five address the expected-count check only; 55 authors with multiple comments and nested discussions still challenge the independent-observation assumption.

## 5. Integration of the team's work and historical repository findings

**RQ2:** the integrated analysis preserves the question, hypotheses, supplied labels, 2×2 table and Yates-corrected test. It adds ID-based joins, file checks, expected counts, rates, the rate difference and per-thread descriptions. The unsupported claim of “no effect” was replaced with a bounded interpretation under the reference model. The RQ1 dictionary does not replace the teammate's labels. The recovered labelling script lists 123 TRUE IDs, exactly matching the supplied annotation file. The group subsequently reported using an Excel expression/code step. Its exact original expression/workbook has not been supplied, so the remaining uncertainty concerns that generation process and ambiguous cases, not missing TRUE/FALSE decisions. No independent manual-coding process is inferred.

**RQ4:** the integrated analysis preserves the definitions and main numerical results in the teammate's PDF. The reconstructed code uses child-author→parent-author edges, separates event frequency from path distance and calculates unweighted betweenness. The comment-level cluster–reply bridge extends rather than replaces the original network analysis. The original submissions and recovered scripts remain in `original_submissions/`; they are archived evidence, not modules to source in place of the integrated functions.

### Historical inspection: commit a316232

An earlier read-only inspection covered `main` at **`a316232f509d1e283f048a0e62d5ccfffa1886ba`**. Unauthenticated access succeeded. At that specific commit:

1. `R/03_hypothesis.R` was a standalone script reading the absent `data/clean/hn_comments_clean.csv` and did not define `analyse_hypothesis()`, which the report called. This was an interface/path integration defect.
2. Only an annotation template was tracked; the actual `data/annotations/verification_labels.csv` was absent.
3. The report and formatting were outdated: no `formatting/` assets, disabled TOC, incomplete group/repository fields, and a mismatch between the poster PDF and source.
4. The historical cleaner used `data/clean`, while the integrated project uses `data/processed`. The original script was preserved and the integrated paths standardised.

**These are historical findings, not claims about the repository after the user's later upload.** A fresh inspection should identify the current commit and check whether each item is resolved. No remote write or push was made during the earlier audit. A Git commit date records repository activity, not the collection date.

## 6. Information requiring the group's confirmation

- Complete `docs/group_contributions.csv`: `member_name`, `student_id`, `contribution_percent`, `actual_contribution`, `sections_reviewed`, `review_date` and `notes`. Actual percentages must total 100. `R/06_metadata.R` reads and checks the shared information for the report and poster. Do not claim unperformed contributions.
- The group has confirmed collection using R on 28 September 2026. The manifest records that date without an invented time/timezone. Review the retrospective topical rationale and limitations in `docs/COLLECTION_AND_LABELS_GUIDE.md`; they do not claim to recover exact historical queries. A new download cannot reconstruct or prove the historical snapshot.
- The intended RQ2 definition and matching 123-ID implementation are recorded. The group reports an Excel expression/code step; providing the original expression or workbook, if available, would allow that generation procedure and ambiguous cases to be checked. Do not invent an expression or independently validated manual coding. A coder timestamp/log or reliability study is not a separate compulsory deliverable. Document justified label changes and rerun affected analyses.
- Read and revise the actual results before confirming `group_review_confirmed`. AI support is permitted, but the submitted analysis must reflect the group's critical evaluation and understanding.

Missing historical information should remain explicitly unknown when it cannot be recovered. Accurate method documentation and a clear limitation are preferable to fabricated precision or a false claim that a review occurred.

## 7. Execution, rendering and final update sequence

The following records the completed verification before subsequent content changes. Recheck any outputs affected by later edits.

| Check | Verified result and limit |
|---|---|
| R and `check_project.R` | **Passed**, R 4.4.3; log reports “Supplied-snapshot regression checks passed”; actual outputs and session information were exported |
| Report PDF | **Rendered successfully: 28 total pages**, including TOC and references; local preview used Nimbus Sans |
| Poster PDF | **Rendered successfully: one A2 landscape page**; local preview used DejaVu Sans |
| Visual checks | All report pages and the poster were inspected; table headers/IDs and chart sizing were corrected. Arial was unavailable in the verification environment; the report source retains Arial |
| Report layout | 12-point text, 1.5 spacing, TOC and the 20 template page breaks were retained in the verified layout; check again with Arial after entering actual group information |
| Poster layout | A2 landscape, four columns, one page, using the same R analysis and snapshot; A2 is a design choice, not a mandated assignment size |

Final steps for the group:

1. Extract the complete ZIP and open the `.Rproj`. Complete actual member/contribution details and document the collection and annotation information available to the group.
2. Restart R. Run `source("install_packages.R")` if needed, followed by `source("check_project.R")`, from the project directory.
3. Render both PDFs following `README.md`. Check fonts, layout and consistency. The report must have at most 30 pages and the poster exactly one. Recheck after all final text and metadata changes.
4. Set review confirmations only after the review has occurred. If an internal workflow check identifies a missing field, consult its explanation and record truthful information or explicit uncertainty. Do not fabricate a timestamp, coding record or approval to pass a check.
5. Copy the **contents** of the updated project into the existing repository root, preserving `.git/`. Do not add another nested `COMP3020_Group36/` project. Keep the integrated `R/03_hypothesis.R`; archived teammate scripts belong in `original_submissions/`.
6. Review the diff, commit and push the matching data, code, formatting, documentation and final PDFs. Verify marker access. A fresh clone and README run by another member provides a useful portability check.
7. Submit the report PDF and one-page poster PDF through Ultra. The ZIP or Rmd is not a substitute for the two required PDFs. Prepare whole-project Q&A using `docs/QA_PREPARATION.md`.

This audit accompanies the project for the group's review. It need not be copied wholesale into the report or poster, which should remain focused on the investigation and its supporting evidence.

## Subsequent group clarification

R collection on 28 September 2026 is now group-confirmed. This is a calendar date, not an inferred UTC timestamp. The group will enter its own member information. The collection guide distinguishes the retrospective topic-selection rationale from an unrecorded search history, and provides precise update instructions plus the separate `collection/01_collect_new_snapshot.R` entry file. The original archived scripts remain unchanged. RQ2 labels remain preserved; the unavailable original Excel expression/workbook is the narrow outstanding method evidence, rather than an invented requirement to prove manual coding.
