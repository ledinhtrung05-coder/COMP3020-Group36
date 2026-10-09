# Shared analytical definitions and annotation handoff

## Corpus and units

One row = one retained Hacker News comment. `comment_id` is unique; all IDs are character keys. Authors are account names, not verified individuals or occupations. Five selected discussion trees form the corpus. Raw/clean files are frozen; changes require a new documented version and rerunning affected analyses.

`received_reply = comment_id %in% clean$parent_id`: at least one retained direct child. The flag includes self-replies if present, although none occur here. It does not mean ever received any reply, nor agreement. Network self-loops are separately excluded by design. Root stories are not comment rows.

## RQ2: specific verification practice

This is the teammate's variable. The supplied `hn_comments_clean(after add true false).csv` is preserved byte-for-byte as `data/annotations/verification_labels.csv`: all 278 comment IDs are present exactly once, with 123 TRUE and 155 FALSE labels. Its 13 original fields match the frozen clean CSV. The analysis uses these supplied labels without recoding them; the RQ1 dictionary is not their source.

**Group-reported origin:** the group reports creating the labels using code in Excel. The original Excel workbook and exact expression or tool rule were not available for inspection. This records the group's account of the preparation step; it does not establish a particular formula, keyword list, automation method or completed human review.

**Recovered R implementation:** `original_submissions/repo_03_hypothesis_labeling_a316232.R` assigns TRUE to 123 explicitly listed comment IDs and FALSE to the remainder. Every listed ID matches the supplied annotation. The script describes TRUE broadly as mentioning a specific way to check or test AI-generated code. It reproduces the assignments but does not contain the original Excel expression or explain how the 123 IDs were selected. Receipt of labels and a matching ID-list implementation establishes computational traceability, not semantic validity.

### What the existing files establish

The saved labels and recovered ID-list script establish the binary assignments and their R implementation. The group-reported Excel step supplies additional provenance, but the formula and detailed decision rule cannot be reconstructed reliably from the output labels alone. The report therefore describes them as **supplied comment-level labels created through a group-reported Excel code step**, not as independently validated manual coding.

- **Intended TRUE meaning:** the comment is classified as mentioning a specific way to check or test AI-generated code. A TRUE value does not establish endorsement, actual use of the practice, or successful verification.
- **Observed FALSE meaning:** the comment was not assigned TRUE under the supplied classification. Without inspecting the original Excel rule, this is not proof that the text contains no relevant practice or that its author rejects verification.

Treatment of quotations, implicit references, sarcasm, agent-performed checks and borderline cases remains unverified. The detailed guidance below is a proposed review framework, not a retroactive description of the original Excel procedure.

A clear operational definition and honest measurement limitations belong in the report. A formal inter-rater reliability study, coding timestamp or separate annotation log is not stated as an additional compulsory deliverable in the supplied brief. Such records can strengthen the work, but must only be claimed if they actually exist.

### Proposed review guidance — not the original Excel codebook

If the group reviews or revises the operational rule, the following is a proposed starting point. These rules have not been used to replace the supplied labels:

- TRUE: text explicitly mentions a concrete verification activity, such as reading/inspecting code, running code/tests, static/type checks, checking documentation against implementation, or a formal proof/checking procedure.
- FALSE: no specific activity is mentioned. General calls to be careful or generic confidence are insufficient without an activity.
- Missing/ambiguous: keep unresolved until reviewed; never silently convert to FALSE.
- Mention does not mean endorsement. A criticism of unit tests can mention unit tests.
- Quote-only cases: the team must document whether any textual mention counts or the author must discuss it in their own response. Do not silently change the teammate's rule to obtain preferred counts.
- Inspect parent context for elliptical replies, but do not silently label a comment TRUE solely because its parent contains a method. Record the exact rule.
- Multiple practices may occur in one comment. The binary variable records at least one, not mutually exclusive practice categories.

An independent check of a documented sample by another member is recommended to assess whether the intended meaning matches the labels. If that review is undertaken, record who reviewed it, the rule version, disagreements and any changes. This is a recommended quality improvement, not a completed activity or an extra compulsory deliverable imposed by the brief. No reliability statistic or manual-review completion is claimed.

### Cases for the group's coding-rule review

The following supplied texts were inspected during integration. They are prompts for clarifying the original rule, not confirmed coding errors or a completed reliability assessment. **All supplied labels remain unchanged.**

| Comment ID | Supplied label | Question to resolve |
|---|---|---|
| 47290993 | FALSE | The author prefers reviewing generated code to reviewing a specification. Does this explicit preference count as a specific verification-practice mention? |
| 47418127 | FALSE | The author describes an agent reviewing itself and testing within an AI-built project. Does the rule include agent-performed verification, or only human actions? |
| 43863440; 43861845 | FALSE; TRUE | Both discuss a second pair of human eyes; the latter explicitly refers to a pull request. Document how much context or detail makes a human-review mention specific. |
| 43862196 | TRUE | The LLM-review practice appears in a quotation that the author criticises. Does any mention count, or must the author describe a practice in their own words? |
| 43874486; 43862230 | TRUE; TRUE | Sarcasm concerns review/testing and regenerated tests. A mention may count even when the author rejects the practice; the label must not be interpreted as endorsement. |
| 47292925 | FALSE | The author asks another user to refresh and test a webpage. Exclusion may be defensible if the rule requires verification of AI-generated code rather than general website troubleshooting. |

The supplied labels reproduce the original 2-by-2 table, but matching counts cannot settle these interpretive questions. Clarify the Excel expression and intended rule with the member who prepared the labels. If reconciliation changes a label, record the ID, previous/new values and reason, retain the original file/version, and rerun all affected outputs and snapshot checks.

## RQ1 dictionary

`R/02_text_cluster.R` holds exact patterns. Six overlapping candidate categories: reading/inspection, execution/testing, static/type checks, formal verification, responsibility/ownership, understanding/trust. They are lexical screens, not substitutes for the supplied RQ2 labels, validated categories or sentiment scores. Example failure modes: sarcasm, quotations, non-code uses of 'test', implicit practices missed by a dictionary. All matches and first matching phrases are exported for inspection.

Quoted text is retained in the primary text view. `has_quote_marker` is only a potential formatting signal; '>' can also be an arrow/comparison. Clean text has flattened paragraphs, so removing everything after '>' would discard valid author text. Original HTML is preserved.

## Clustering

Frozen stopwords; preserve negators; no stemming. Remove generic AI/code/model terms for clustering only. At least five retained tokens; df>=2 and df<=80% vocabulary screen. Log TF-IDF, L2 normalisation, cosine dissimilarity, average linkage. Examine k2:8; maximise mean silhouette among partitions with minimum cluster size5. If none passes, retain the highest-silhouette fallback only as a diagnostic failure. These numerical cutoffs are pragmatic choices.

Top terms are lexical descriptors. Read medoid and lowest-silhouette comments; inspect thread composition/length. Do not equate cluster IDs with stances, communities or author types. Complete/cosine and Ward.D2/Euclidean-L2 are exploratory sensitivity checks, not attempts to manufacture a desirable result.

## Network

A->B means replying author to retained parent-comment author. Collapse duplicate ordered pairs. `frequency` is reply-event count; it is never used as shortest-path distance. In-degree counts distinct incoming authors. Betweenness is directed, unweighted and normalised across the full graph. Include only authors participating in retained between-author edges. Content linkage joins the receiving parent comment's cluster; an author can contribute to multiple clusters.
