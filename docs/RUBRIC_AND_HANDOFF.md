# Rubric coverage and final handoff

| Requirement | Implementation | Remaining evidence/check |
|---|---|---|
| Related RQs and coherent investigation (3 group marks) | Section1 and synthesis; revised RQ2 and RQ3->RQ4 join documented | Group agrees final wording and understands links |
| Suitable data collected using R | Frozen CSV audit; original group-repository collector/cleaner archived, supplementary robust collector/cleaner kept separate | R collection on 28 September 2026 is group-confirmed; explain the available method and limitations. The topical rationale is retrospective; exact search logs/times are not separate mandatory deliverables |
| Text analysis, >=2 visuals including frequent words | RQ1 frequency bar and dictionary-indicator bar, contextual examples | Validate dictionary interpretation; not manual coding claims |
| Hypothesis test and appropriate interpretation | RQ2 from 278 supplied row labels; H0/H1, explicit Yates, expected counts, rates/difference, descriptive by-thread counts and dependence caveat | Preserve the intended definition and supplied labels; the original Excel expression/workbook would clarify the group-reported label-generation step. Review ambiguous cases and test suitability |
| Clustering representation/distance/k/visual/themes | RQ3 complete diagnostics, hierarchy, profiles/examples/thread check and sensitivity | Read actual R output; weak partitions must remain honestly interpreted |
| Network meaningful relationships | Direct parent joins; direction and exclusion audit | Original teammate PDF retained; reconstructed module must match its definitions and R results |
| Whole graph and justified subgraph; >=2 centralities | Full/LCC, in-degree/betweenness, counts/density/components | Check actual generated figures and captions |
| Overall findings and limitations | Integrated conclusions with sample/measurement/inference/network limits | Revise against actual output |
| Report Rmd->PDF, <=30 pages | Report_Group36_Integrated.Rmd; TOC/template page starts retained | Verify actual final PDF is at most 30 pages (10–30 in the outline), as recorded in VALIDATION.txt |
| One-page scientific poster | Poster_Group36.Rmd; A2 landscape/four columns, shared computations and vector plots | Render, check exactly one page, figures/references/member contributions, readability and agreement with report |
| GitHub/GitLab code+data, accessible to marker | Existing repo audited at main/a316232; HTTP 200 and read-only clone succeeded | Replace old/broken remote files with final package contents, render and push outputs, recheck marker access |
| Member details and contributions | Shared docs/group_contributions.csv read by report/poster | Fill real names/IDs/actual contributions and contribution_percent, summing to 100 |
| Individual Q&A (10 marks) | docs/QA_PREPARATION.md | All members explain the whole project |

Methods and interpretation each carry 7 of the 20 group marks; visual quality carries1 and originality2. The poster communicates the investigation, while the report supports verification. These are priorities, not a promised grade.

## Order of remaining human checks

1. Read `docs/COLLECTION_AND_LABELS_GUIDE.md`. R collection on 28 September 2026 is now confirmed by the group. The topic-selection justification is retrospective, not a historical search log. The original Excel expression/workbook, if available, would help check the reported label-generation process; all 278 labels and the matching 123-ID script are already included.
2. Check the final audit execution record, then run install -> check_project -> report on the group's machine. check_project reruns analysis from disk, so running run_analysis separately first is unnecessary.
3. Inspect actual outputs, especially weak clusters, the row-level RQ2 table and its descriptive thread breakdown; revise interpretations if outputs differ. Computational agreement does not validate coding judgements.
4. Complete the shared member/SID/contribution record (total 100%); critically review all sections. The supplied repository URL is already included.
5. Render poster and report; confirm exactly one A2 landscape poster page and at most 30 report pages. Inspect captions, TOC, page breaks, tables, figures and citations.
6. Follow README to copy the final contents into the existing repo root, preserving .git and avoiding nested projects; commit/push after checking the diff. Clone/run on another member's machine, verify marker access, then submit the required PDFs/link via Ultra.

Do not make results look stronger by deleting inconvenient comments, changing a test to obtain significance, or assigning theme names unsupported by the text. Legitimate changes must be documented and affected outputs regenerated.

## Known repository integration defect repaired by this package

At audited commit a316232, the standalone teammate RQ2 script had been placed at R/03_hypothesis.R. It immediately reads absent data/clean/hn_comments_clean.csv and does not define the analyse_hypothesis() function used by the integrated callers. Retain the integrated function module and real data/annotations/verification_labels.csv; keep the original labeling script under original_submissions/. The remote also lacked formatting assets and held outdated report/poster sources. The final package must be uploaded as a coherent set.

Read original_submissions/REPO_SOURCE_PROVENANCE.md for the exact recovered script paths and evidential limits. No audit action pushed to GitHub or changed its history.

## Subsequent group confirmation

The group confirms R collection on 28 September 2026 and will complete its own member/SID/contribution record. Only the date is known; no time or timezone is inferred. The group reports an Excel expression/code step for RQ2, but the exact expression/workbook has not been supplied. These updates do not change the supplied data or establish independent manual coding. The brief requires collection-method documentation; an exact query history, UTC timestamp, coder log or formal reliability study is not an additional compulsory submission.
