# What was learned and how it changes this project

Targeted reading completed 9 October 2026; this is not a systematic literature review. The full bibliographic records are in `references.bib`. Sources were checked at author/university repositories, publishers, official documentation or the original research repository.

| Evidence read | Lesson applied | Boundary |
|---|---|---|
| Barke et al. (2023), Grounded Copilot, DOI 10.1145/3586030; relevant methods/verification sections | Separate examination, execution, static checks and documentation in conceptual definitions | Observed behaviour in a small task study does not validate online mention counts |
| Vaithilingam et al. (2022), DOI 10.1145/3491101.3519665; study design and findings | Motivate code understanding and checking as substantive concerns | Early bounded study; not a universal effect of AI |
| O'Brien (2025), DOI 10.1145/3706598.3713668; recruitment, verification findings and limitations | Separate reported confidence/practice from actual successful verification | One university; exploratory/self-report limits |
| Agarwal et al. (2026), arXiv:2607.07980; corpus/coding/limits | Keep provenance, contextual examples and traceable decisions; acknowledge related discourse research | Preprint; proposed theory is not causal validation |
| GitHub Copilot official application card | Define practical responsibility expectations | Provider guidance, not proof of compliance or legal liability |
| Grimmer & Stewart (2013), DOI 10.1093/pan/mps028 | Validate automated text measures in their application context | Dictionaries/cluster labels do not interpret themselves |
| ASA (2016) official p-value statement | Report effects and design limits; avoid equating p>0.05 with no relationship | A p-value cannot repair an unsuitable sampling/independence model |
| Manning et al. (2008), Stanford-hosted IR textbook; R silhouette/hclust docs | Document vector representation, distance, linkage and validation | A clustering function always partitions; meaningful themes are not guaranteed |
| Official HN API and igraph docs | Preserve actual parent links and explicit graph settings | Counts as weights are not automatically distances; current API cannot prove past snapshot completeness |

## Source hierarchy and teaching alignment

The later assignment task PDF and Project Instructions/rubric determine deliverables: four connected analysis families, report PDF from Rmd, poster1page, accessible code/data repo. The subject outline establishes learning context and permitted AI support. It lists text weighting/metrics, clustering and graph analysis, but actual lecture/lab algorithm details were not supplied. Standard methods were selected; the group should confirm exact course coverage before submission.

The subject outline's generic allocated-topic/group-size wording differs from the later task-specific own-topic/group instructions. The task-specific instructions guide this project. Both support a report within 10–30 pages if the broader outline's lower bound is applied.

## Decisions preserved or changed

- Preserve title, overall question, RQ1/RQ3 intent and four-method architecture.
- Adopt teammate's completed RQ2 in place of the older proposed paired thread-proportions comparison; document the change.
- Preserve the RQ2 table/test as a provenance-labelled reconstruction until original annotations arrive. Never infer replacement labels to reproduce its p-value.
- Reconstruct RQ4 code because only its PDF was provided; retain original PDF and match its numerical definitions.
- Add the original cluster-to-reply connection at comment level.
- Keep a failed/weak clustering result visible rather than fabricate substantive themes.
- Distinguish supplied historical data from newly provided optional collection code.

## Research vs implementation status

The report source is fully connected to executable R functions. No R runtime was available during preparation. Independent Python checks support the numerical audit and the expectation of weak lexical clustering; actual R output and rendered-page checks remain for the group's run. Unknown collection history and missing annotations remain explicit. No full-marks guarantee follows from a design or template.
