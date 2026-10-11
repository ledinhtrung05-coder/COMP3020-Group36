# RQ2 AI-assisted sensitivity annotation: audit notes

All 278 supplied clean comments were inspected in full, in ascending comment-ID order, using a view containing only ID, thread ID/title and text. The prospective AI-SENS-v1 rule was written before this pass. Every decision includes an exact evidence substring and a rationale. Automated checks verify 278 unique IDs, exact corpus ID coverage, nonmissing decisions and all 278 evidence substrings. The machine-readable manifest records hashes and completion time.

## Scope and independence

This is an AI-assisted full-text sensitivity exercise. The original annotation CSV and received-reply values were not opened by the reviewing assistant during the exercise. However, the assistant had already read the existing codebook and inherited earlier report context, which exposed aggregate label counts and several labelled boundary examples. Consequently, the input view was masked, but this must **not** be represented as a strictly independent blinded coding study, human validation, a new gold standard or inter-rater reliability. It does not recover the teammate's Excel formula. The original labels must remain the main supplied analysis unless the group explicitly agrees a documented re-annotation.

## Interpretive boundaries

TRUE records a concrete textual mention, not adoption, endorsement, successful verification, or a validated personal behaviour. Quoted, negated, sarcastic and incidental explicit method mentions count. Generic validation, quality, responsibility and role names do not suffice. Non-code historical/citation checking and unspecified website troubleshooting are excluded. A thread title can resolve general code context; no parent activity is inherited. The same assistant may still make interpretive errors. Human review of the prospective rule and boundary cases remains useful.

The small AMBIGUOUS group includes an unresolved advice-versus-code challenge, visual-output checking, an unresolved junior-developer analogy, and two tool-only comments. These are preserved rather than guessed from absent context or external tool knowledge.

## Downstream comparison

The CSV was frozen before any comparison with supplied labels or reply outcomes. Keep its original labels separate and join only by comment_id. Recommended sensitivity scenarios are (1) exclude AMBIGUOUS, (2) assign every AMBIGUOUS FALSE, and (3) assign every AMBIGUOUS TRUE. The last two are uniform-assignment scenarios, **not strict mathematical bounds** on a reply-rate contrast. The frozen rule's phrase "bound AMBIGUOUS both ways" was imprecise; this clarification and the R implementation use scenarios, while preserving the original rule and its hash. They do not address author/thread dependence, selection bias, the original label provenance, or AI annotation error.

Disagreement with the original labels shows sensitivity to an explicit alternative interpretation; it does not by itself prove that either set is correct. Do not tune the rule or decisions after seeing reply outcomes to obtain a preferred finding. Any later rule revision requires a new version, recorded reasons and a complete affected-case review.

## Packaged evidence paths

- Decisions: `data/annotations/verification_audit_AI_SENS_v1.csv`.
- Frozen rule: `docs/AI_SENS_v1_RULE.md`.
- Original masked reading view: `data/audit_inputs/comments_masked_AI_SENS_v1.jsonl`.
- Freeze manifest: `data/annotations/AI_SENS_v1_manifest.json`.

The manifest's historical `blinded_view_sha256` key refers to the masked input file above. The key name does not override the independence limitation explained here. R reproduces validation and calculations from the supplied decisions; it does not automatically regenerate the semantic reading.
