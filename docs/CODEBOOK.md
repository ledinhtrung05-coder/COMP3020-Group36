# Shared analytical definitions and annotation handoff

## Corpus and units

One row = one retained Hacker News comment. `comment_id` is unique; all IDs are character keys. Authors are account names, not verified individuals or occupations. Five selected discussion trees form the corpus. Raw/clean files are frozen; changes require a new documented version and rerunning affected analyses.

`received_reply = comment_id %in% clean$parent_id`: at least one retained direct child. The flag includes self-replies if present, although none occur here. It does not mean ever received any reply, nor agreement. Network self-loops are separately excluded by design. Root stories are not comment rows.

## RQ2: specific verification practice

This is the teammate's variable. **Original annotation method remains to be supplied.** The following guidance is proposed for reconciliation, not a claim about how existing labels were made.

- TRUE: text explicitly mentions a concrete verification activity, such as reading/inspecting code, running code/tests, static/type checks, checking documentation against implementation, or a formal proof/checking procedure.
- FALSE: no specific activity is mentioned. General calls to be careful or generic confidence are insufficient without an activity.
- Missing/ambiguous: keep unresolved until reviewed; never silently convert to FALSE.
- Mention does not mean endorsement. A criticism of unit tests can mention unit tests.
- Quote-only cases: the team must document whether any textual mention counts or the author must discuss it in their own response. Do not silently change the teammate's rule to obtain preferred counts.
- Inspect parent context for elliptical replies, but do not silently label a comment TRUE solely because its parent contains a method. Record the exact rule.
- Multiple practices may occur in one comment. The binary variable records at least one, not mutually exclusive practice categories.

Record coder, codebook version, disagreement resolution and examples. A second member should independently check a documented sample and reconcile disagreements; no reliability statistic or manual-review completion is claimed until that work occurs.

## RQ1 dictionary

`R/02_text_cluster.R` holds exact patterns. Six overlapping candidate categories: reading/inspection, execution/testing, static/type checks, formal verification, responsibility/ownership, understanding/trust. They are lexical screens, not the missing RQ2 labels, validated categories or sentiment scores. Example failure modes: sarcasm, quotations, non-code uses of 'test', implicit practices missed by a dictionary. All matches and first matching phrases are exported for inspection.

Quoted text is retained in the primary text view. `has_quote_marker` is only a potential formatting signal; '>' can also be an arrow/comparison. Clean text has flattened paragraphs, so removing everything after '>' would discard valid author text. Original HTML is preserved.

## Clustering

Frozen stopwords; preserve negators; no stemming. Remove generic AI/code/model terms for clustering only. At least five retained tokens; df>=2 and df<=80% vocabulary screen. Log TF-IDF, L2 normalisation, cosine dissimilarity, average linkage. Examine k2:8; maximise mean silhouette among partitions with minimum cluster size5. If none passes, retain the highest-silhouette fallback only as a diagnostic failure. These numerical cutoffs are pragmatic choices.

Top terms are lexical descriptors. Read medoid and lowest-silhouette comments; inspect thread composition/length. Do not equate cluster IDs with stances, communities or author types. Complete/cosine and Ward.D2/Euclidean-L2 are exploratory sensitivity checks, not attempts to manufacture a desirable result.

## Network

A->B means replying author to retained parent-comment author. Collapse duplicate ordered pairs. `frequency` is reply-event count; it is never used as shortest-path distance. In-degree counts distinct incoming authors. Betweenness is directed, unweighted and normalised across the full graph. Include only authors participating in retained between-author edges. Content linkage joins the receiving parent comment's cluster; an author can contribute to multiple clusters.
