# Preparing for the ten-minute poster discussion

The assessment is a question-and-answer discussion, not a formal presentation. Every member must understand the complete investigation, including the work completed by others. Use this guide to explain the evidence in your own words and challenge the decisions; do not memorise answers without understanding them. A prepared document cannot demonstrate individual understanding on a member's behalf.

## A ten-minute practice round

Use the poster and a rendered report. One member asks questions, another answers, and the third checks the cited output; rotate roles in the next round.

| Practice time | Task |
|---|---|
| 0–1 minute | State the overall question, data boundary and principal conclusion. |
| 1–4 minutes | Explain one method and defend a choice using an actual table or figure. |
| 4–7 minutes | Interpret a result and answer an unexpected follow-up from another RQ. |
| 7–9 minutes | Explain a limitation and one justified next step; identify what the current analysis cannot establish. |
| 9–10 minutes | Check the answer against the output, correct errors and switch roles for the next round. |

This is a practice structure, not a required speaking schedule. Teaching staff control the actual discussion. When asked about one result, answer that question first, then give the relevant evidence and boundary.

## 1. Purpose, sampling and reproducibility

**Why study expressed responsibility and verification instead of workplace productivity?** The data are public comments. They show what selected participants say and which retained comments receive replies; they do not observe code quality, actual verification success or productivity. The related RQs examine language, a mention–reply association, lexical group structure and reply relationships.

**Why these five discussions?** Their content addresses ownership, verification costs, automated checking and human validation. Explain this topical relevance from `docs/COLLECTION_AND_LABELS_GUIDE.md` and the thread table. It is a retrospective rationale, not evidence of a systematic search. The group confirms R collection on 28 September 2026; exact request times, search queries and screening counts are not reconstructed.

**What changed from 313 raw records to 278 retained comments?** Exactly 30 dead and 5 deleted records were removed. There are five threads and 186 retained authors; 55 authors contribute more than one comment. Shared fields are checked by comment ID. The later annotation file preserves the 13 original columns and adds `verification_specific`. See `outputs/tables/data_audit.csv` and `R/00_data.R`.

**What does `received_reply` mean?** At least one direct child is also retained in the clean corpus. There are 121 positive outcomes. Counting any observed raw child would produce 122, changing one retained comment. Later, missing or deleted replies are outside this outcome; FALSE does not mean that no reply ever occurred.

**How could another member reproduce the work?** Open the project, install dependencies, run `check_project.R`, and render the Rmd sources. The code uses relative paths, character IDs, explicit logical parsing and frozen UTF-8 inputs. Knit makes no API request. Historical teammate scripts are evidence files, not scripts to source into the integrated run. Optional recollection writes a separate snapshot. Git commit time is not the collection date.

**Follow-up challenge:** If a future download contains more replies, should it replace the files silently? No. Record it as a new snapshot, preserve the original input and rerun every affected analysis. Explain which outcomes, edges and conclusions could change.

## 2. RQ1: meaning and measurement

**What do the text visuals measure?** Word frequency counts occurrences. The dictionary counts comments matching each non-exclusive candidate indicator: execution/testing 65, reading/inspection 37, understanding/trust 34, responsibility/ownership 28, static/type checks 7 and formal verification 2. Quotations, criticism and negation can match; broad and narrow patterns differ in sensitivity. These counts are not validated attitudes, practice prevalence or evidence of effectiveness.

**How was context used?** Twelve purposive examples span all five discussions and preserve the original four examples. They include contrasting responsibility claims, concrete safeguards and sarcasm. The source ID, thread, exact excerpt and interpretation are separate fields in `data/context_examples.csv`; `R/07_context.R` checks the source match. Exact matching proves traceability, not that an interpretation is objectively correct. This is not representative qualitative coding or human inter-rater validation.

**Why not replace the supplied RQ2 labels with dictionary matches?** They operationalise different things. The supplied labels reproduce the teammate's 123-ID R list; the group reports an Excel-code step whose original expression is unavailable. Comment 47290993 is FALSE despite discussing code review, while 43862196 is TRUE for a challenged quoted-review statement. These illustrate measurement uncertainty; original labels must not be silently changed.

A separate AI-assisted label sensitivity uses a declared rule to examine this uncertainty. It must remain identified as supplementary AI-assisted coding, with exact evidence, ambiguity handling and comparison to the supplied labels. It cannot establish human validation, reconstruct the missing Excel formula or become a gold standard merely because it is reproducible.

**Follow-up challenge:** Does comment 43862230 prove its author likes unit tests? Its sarcastic wording about regenerating inconvenient tests shows why a matching word is not endorsement. Read the complete text before interpreting the excerpt.

## 3. RQ2: association and design sensitivity

**What are H0 and H1?** H0 states that the supplied specific-practice mention label and retained direct-reply outcome are independent; H1 states an association without specifying its direction. The test uses a 2-by-2 count table and an explicit Yates correction.

| Analysis view | FALSE with reply / total | TRUE with reply / total | TRUE minus FALSE | Yates reference p |
|---|---:|---:|---:|---:|
| All 278 retained comments | 69/155 = 44.52% | 52/123 = 42.28% | −2.24 percentage points | 0.8008 |
| First retained comment per author, n = 186 | 47/99 = 47.47% | 42/87 = 48.28% | +0.80 percentage points | 1.0000 |

Evidence: `outputs/tables/rq2_design_sensitivity.csv`, `rq2_first_author_comments.csv`, and `R/03_hypothesis.R`. The original contingency table has FALSE counts 86 without / 69 with reply, and TRUE counts 71 without / 52 with reply. Its chi-square is 0.063666 and smallest expected count is 53.536. The reduced view has minimum expected count 41.629.

**Does a large p-value prove no relationship?** No. It does not establish equivalence, independence, causality or population generalisability. Expected cell counts above five address a different issue from dependence. Repeated authors and conversations undermine a simple independent-comment interpretation. Both p-values are reference calculations rather than dependence-adjusted population tests.

**Why select the first retained comment per author?** Timestamp, then numeric comment ID, selects one observation per author without using its label or reply outcome. It limits repeated-author weighting but changes the target to first retained comments. Shared threads and interacting authors remain dependent. The rule was added after the original analysis; it was not preregistered.

**Why must the reply outcome use the full corpus?** Selecting observations changes which comments are analysed, not which recorded children existed. Recomputing replies only inside the 186 selected comments would wrongly erase 37 positive reply flags: 89 observed positives would become 52. Keep every selected comment's outcome from the full 278-comment snapshot.

**Why is p exactly 1 in the reduced view?** R's Yates correction is capped at the absolute observed–expected deviation; here the corrected statistic becomes zero. This is valid computational output, not proof that the groups are identical or that assumptions hold.

**What did omitting threads show?** All five omit-one-thread contrasts are reported descriptively, ranging from −6.34 to +0.13 percentage points. Combined with the author-weighting reversal, this shows that the observed direction is not stable across these design choices. These are not five additional significance tests or a correction for dependence. See `outputs/tables/rq2_leave_one_thread_out.csv`.

**Follow-up challenge:** Would Fisher's exact test or a Monte Carlo p-value solve the dependence problem? No. Changing the reference calculation does not remove repeated or interacting observations. A stronger study needs a justified unit of analysis and adequate independent groups, not merely another p-value.

## 4. RQ3: why the lexical partition is weak

**How is the representation constructed?** Nonzero term frequency is `1 + log(count)`, multiplied by `log(N/document frequency)`, then each vector is L2-normalised. Cosine dissimilarity compares the resulting vocabulary profiles. Broad domain words are omitted for clustering only. Author, thread and reply outcomes are not input features.

**How were linkage and k chosen?** Average linkage uses mean pairwise dissimilarity. Test k = 2–8, choosing the highest mean silhouette among cuts with at least five comments per cluster. No primary cut meets the size guard, so k = 2 is explicitly a diagnostic fallback. The primary fit has 264 comments, 1,250 terms, sizes 262/2 and mean silhouette 0.0151.

**Why does this not establish two meaningful themes?** The large group is heterogeneous. The tiny pair uses “hand” in different senses: “hand in hand” (43877106) and “hand crafted” (47289697). A numerical grouping is not a semantic theme or a social community. Explain the medoid and lowest-silhouette examples using `outputs/tables/rq3_context_examples.csv`.

**What explains the weak separation?** The TF-IDF matrix has 97.85% zero entries, median pairwise cosine dissimilarity 0.990, and 31.88% of comment pairs share no retained term. Approximately 99.24% of primary silhouette values lie within ±0.05; that band is a descriptive diagnostic, not a universal validity threshold. See `outputs/tables/rq3_geometry_diagnostics.csv`.

| Representation check | Comments retained | Terms | Selected sizes | Mean silhouette |
|---|---:|---:|---|---:|
| Primary: at least 5 tokens, document frequency at least 2 | 264 | 1,250 | 262/2 | 0.0151 |
| At least 10 tokens | 227 | 1,223 | 226/1 | 0.0157 |
| At least 20 tokens | 167 | 1,127 | 165/2 | 0.0184 |
| Document frequency at least 3 | 264 | 767 | 262/2 | 0.0196 |

**What do these checks establish?** Each of the three post-hoc alternatives changes one filter while retaining the weighting, distance, linkage and selection rule. All selected cuts still fail the five-comment guard. Stronger length filtering discards more comments without producing convincing separation. These results limit the specified representations; they do not prove that the discussions contain no meaningful ideas. The primary assignment remains the one used by RQ4. See `outputs/tables/rq3_representation_sensitivity.csv`.

**Why also compare linkages?** This is a bounded sensitivity check, not a competition to obtain an attractive result. Complete linkage retains cosine dissimilarity; Ward.D2 uses Euclidean distances between normalised vectors, not cosine distances directly. Neither provides convincing separation. Explain the geometry before comparing numerical scores across distance scales.

**Follow-up challenge:** Why not choose the 0.0196 result because it is largest? It is still tiny, unbalanced and substantively unconvincing; selecting a preferred theme after trying alternatives would overstate the evidence. The assignment asks whether meaningful clusters can be identified, not for a guaranteed positive discovery.

## 5. RQ4: structure, attention and meaning

**What is an edge?** A directed edge runs from replying author to parent-comment author. The 198 matched reply events collapse to 193 distinct ordered author pairs. Frequency is stored separately and is not interpreted as a path distance. No self-replies occur here.

**Why are there 144 network nodes but 186 corpus authors?** Only authors in retained between-author edges enter the graph. The other 42 have no such observed edge. There are 78 story-root replies and two replies to unavailable parents, which cannot become retained author-to-author edges. Adding all 186 authors as isolates would change density and normalised centrality.

**What does the component structure mean?** Density is 0.00937. Nine weak components include a largest one of 128 authors, or 88.9% of graph nodes. The largest strong component has only ten authors. Weak connectivity ignores direction; it does not imply reciprocal exchange, one conversation or consensus. The full graph and largest weak component use the same full-network in-degree size encoding.

**How do the centralities differ?** In-degree counts distinct replying authors; incoming strength counts reply events. Directed, unweighted betweenness describes shortest-path positions. simonw and fishtoaster both have in-degree 14, but normalised betweenness is 0.0191 versus 0.0030. Their incoming event counts are 14 and 15. Structural prominence does not establish expertise, agreement or causal influence. See `outputs/tables/rq4_centrality.csv`.

**What does reading actual replies add?** simonw's responsibility comment 43861845 receives six retained direct replies; fishtoaster's verification proposals in 47290195 receive thirteen. Under the latter, 47290993 challenges specification-only review, while 47292581 offers qualified support and adds a task-scope condition. These are illustrative readings, not sentiment totals. The comment-level counts 6/13 are different from aggregate author in-degrees 14/14. Check `outputs/tables/context_reply_links.csv` and `context_examples_checked.csv`.

**How are clusters joined to replies?** Join the receiving parent comment by `comment_id`; do not assign each author a single theme. A child without a cluster can still count as a reply to an assigned parent. The sender–receiver matrix needs both labels, covering 185 of 198 events; 13 miss at least one label. Poor, unequal lexical partitions limit interpretation of the cluster reply rates.

**Follow-up challenge:** Why does a large weak component coexist with a weak text clustering result? The graph measures author reply paths, whereas clustering measures comment vocabulary. Connected interaction does not require similar wording or agreement. The two analyses answer different but related aspects of the overall question.

## 6. Team integration and the next defensible improvement

Explain that the original RQ2 labels/question/test and RQ4 principal numerical results are retained, with integrated functions, traceable contextual readings and explicit sensitivity analyses added. The archived originals use historical paths; do not confuse them with the active reproducible scripts. Report and poster read the same member/SID/contribution record. Members must enter genuine shares totalling 100% and confirm review only after it occurs.

If asked what to improve next, choose the limitation relevant to the question: documented broader sampling; a clear annotation rule reviewed by people; a design with adequate independent units; or better-delimited text units. Explain what new evidence the improvement would provide. More sophisticated modelling alone cannot repair uncertain measurement or an unrepresentative sample.

## Follow-up: the completed AI-assisted sensitivity

**What changed?** The original 123/155 labels remain unchanged. AI-SENS-v1 gives 128 TRUE, 145 FALSE and 5 AMBIGUOUS; 14 of 273 determinate decisions differ. Its observed reply-rate contrast is +1.083 points, rather than the supplied-label -2.240 points.

**Does this prove the old labels were wrong?** No. It compares explicit operationalisations and exposes uncertainty. It is neither a human gold standard nor the original Excel rule. The masked reading view omitted label/outcome columns, but inherited context exposed some labelled examples. R validates exact excerpts and recomputes tables; that is different from validating semantic judgments.

**Which case can you explain?** Compare 47290993, explicit code-review language, with 47290312, a generic prompt to verify software. Read both full comments and the frozen rule. Be prepared to defend or challenge the distinction without changing rules to obtain a preferred result.

**What do the five ambiguous cases do?** Excluding them gives +1.083 points. Uniform FALSE/TRUE scenarios give +1.865/+0.161 points. Those scenarios are not bounds over every possible assignment. They do not repair thread dependence or establish a causal relation.
