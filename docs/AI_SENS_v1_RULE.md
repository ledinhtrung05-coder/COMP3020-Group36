# AI-SENS-v1: prospective AI-assisted textual-mention sensitivity rule

Frozen before inspecting the complete comment texts on 2026-10-09 UTC. Original labels and reply outcomes will not be read for this audit. Reviewer is an AI assistant, not an independent human coder; this is not human validation, inter-rater reliability, a gold standard, or reconstruction of the original Excel rule.

Unit: one retained comment. Read its complete supplied clean text. Thread ID/title establish the AI-code discussion context; do not consult other comments or parent/reply outcomes. Text within the comment, including quotations, is eligible. Do not inherit a parent's verification activity.

TRUE: explicitly names at least one concrete activity for checking AI-generated software/code or its behaviour, whether proposed, performed, criticised, questioned, negated, quoted or hypothetical. Examples: reading/inspecting/reviewing code or diffs; running a program to inspect behaviour; unit/integration/property tests; type/static checks; comparison with stated requirements/documentation; formal proof; a specified review by human or agent. An explicit code-review action is sufficiently concrete. Actor need not be human. Textual mention does not establish endorsement, use, efficacy or successful verification.

FALSE: no such concrete activity. Generic verification/correctness/quality/confidence, unspecified understanding/thinking, workload complaints, or general caution do not suffice. Code generation, training/model benchmarking, programming problem solving and non-code website troubleshooting alone do not suffice. Direct code-review context can be supplied by the thread title, but the comment must itself name an activity.

AMBIGUOUS: the text names a potentially relevant action but its referent or verification purpose cannot be resolved from the comment and title alone, or interpretation depends on absent context. Do not silently coerce to FALSE.

For each decision record comment ID, TRUE/FALSE/AMBIGUOUS, an exact short evidence substring, a comment-specific rationale, rule version and reviewer type. Inspect every comment in ascending numeric ID order. Freeze the completed CSV and hash before the original labels or outcomes are compared. Downstream analyses must preserve originals, identify this annotation as AI-assisted sensitivity, report exclusions/disagreement and bound AMBIGUOUS both ways. This audit does not resolve uncertainty about the teammate's original measurement procedure.
