# Rubric coverage and final handoff

| Requirement | Implementation | Remaining evidence/check |
|---|---|---|
| Related RQs and coherent investigation (3 group marks) | Section1 and synthesis; revised RQ2 and RQ3->RQ4 join documented | Group agrees final wording and understands links |
| Suitable data collected using R | Frozen CSV audit; supplementary R collector/cleaner | Original collection code/log/criteria/date still needed |
| Text analysis, >=2 visuals including frequent words | RQ1 frequency bar and dictionary-indicator bar, contextual examples | Validate dictionary interpretation; not manual coding claims |
| Hypothesis test and appropriate interpretation | RQ2 H0/H1, explicit Yates, expected counts, rates/difference, dependence caveat | Original annotations and codebook; method suitability review |
| Clustering representation/distance/k/visual/themes | RQ3 complete diagnostics, hierarchy, profiles/examples/thread check and sensitivity | Read actual R output; weak partitions must remain honestly interpreted |
| Network meaningful relationships | Direct parent joins; direction and exclusion audit | Reconcile original RQ4 script if later received |
| Whole graph and justified subgraph; >=2 centralities | Full/LCC, in-degree/betweenness, counts/density/components | Check actual generated figures and captions |
| Overall findings and limitations | Integrated conclusions with sample/measurement/inference/network limits | Revise against actual output |
| Report Rmd->PDF, <=30 pages | Report_Group36_Integrated.Rmd | Run R, knit PDF, visually review and count pages; aim 10–30 |
| One-page scientific poster | Poster_Group36.Rmd using shared computations | Render, check one page and large enough type; final group review |
| GitHub/GitLab code+data, accessible to marker | Project structure, README, .gitignore | Create/update repo, confirm access, enter real URL |
| Member details and contributions | YAML params and group_contributions.csv | Fill real names/IDs/actual contributions |
| Individual Q&A (10 marks) | docs/QA_PREPARATION.md | All members explain the whole project |

Methods and interpretation each carry 7 of the 20 group marks; visual quality carries1 and originality2. The poster communicates the investigation, while the report supports verification. These are priorities, not a promised grade.

## Order of remaining human checks

1. Obtain original annotations and collection provenance, without rewriting history.
2. Run install -> analysis -> check_project -> report on one machine.
3. Inspect actual outputs, especially weak clusters and the provisional RQ2 table; revise interpretations if outputs differ.
4. Enter member/repo information; critically review all sections and record contributions.
5. Render poster and report; confirm one-page poster and report page limit.
6. Clone/run on another member's machine, verify marker access, then submit required PDFs/link via Ultra.

Do not make results look stronger by deleting inconvenient comments, changing a test to obtain significance, or assigning theme names unsupported by the text. Legitimate changes must be documented and affected outputs regenerated.
