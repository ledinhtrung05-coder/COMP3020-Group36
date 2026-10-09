# Archived scripts recovered from the group's repository

These are exact byte copies recovered during the final read-only audit on 9 October 2026.

- Repository: https://github.com/ledinhtrung05-coder/COMP3020-Group36
- Branch: `main`
- Audited commit: `a316232f509d1e283f048a0e62d5ccfffa1886ba`
- Commit timestamp: `2026-10-09T21:15:57+11:00`
- The scripts were already present in the initial commit, `3228ec0` (`2026-10-09T19:32:59+11:00`). Commit timestamps document repository history, not data collection dates.

| Archived file | Path in the audited repository | SHA-256 |
|---|---|---|
| `repo_01_collect_hn_a316232.R` | `R/01_collect_hn.R` | `f355ef3bc1f01999eae945514d666eb625909a1e3bb70de39956f29f56d1816c` |
| `repo_01_clean_hn_a316232.R` | `R/01_clean_hn.R` | `e3d65fc7af40301c063481e044aa9b06adf4df769cfa8766c7ee7c329166a02f` |
| `repo_03_hypothesis_labeling_a316232.R` | `R/03_hypothesis.R` | `4b0f39097215a3870a9566e05a430947d648e8c7394d1f7069b87c3b39bd561c` |

The collector traverses `kids` for the five discussion IDs in the dataset, uses the official Hacker News item endpoint through `jsonlite`, and writes a raw CSV. The cleaner removes dead/deleted records, strips HTML tags, decodes a specified list of entities, and computes `received_reply` using retained clean child IDs. Their presence supplies actual group-repository code to inspect, but does not by itself establish when that code was executed or the original thread-selection procedure. No execution logs or collection timestamp were present in the audited repository.

The standalone RQ2 script records 123 unique IDs as TRUE and all remaining comments as FALSE. Those 123 IDs exactly match the TRUE labels in the supplied `verification_labels.csv`. It documents how the saved coding decisions are applied, not the full judgement process: coder identity, coding date, treatment of quotations/ambiguous cases and independent reconciliation were not recorded. These details must be confirmed by the group, not inferred from the ID list.

**Do not source these archived scripts during the integrated analysis.** They contain immediate reads/writes, and the cleaner/RQ2 script use the historical `data/clean/` path. In the audited remote repository, replacing the integrated `R/03_hypothesis.R` function module with the standalone script broke the caller contract. The integrated project uses its callable module and the supplied row-level labels; the originals remain here for attribution and inspection.

## Subsequent group confirmation

After the inspection above, the group confirmed that it collected the data using R on **28 September 2026**. This supplements the historical repository evidence; it does not alter the archived scripts or their checksums. Only a calendar date was supplied, with 2026 taken from the assignment context. Exact time/timezone, request logs and historical search queries were not supplied and are not inferred. The topical justification in `docs/COLLECTION_AND_LABELS_GUIDE.md` is retrospective, not a reconstructed search log.

The group also reports an Excel expression/code step for RQ2 labels. The exact original expression or workbook is not available, so the hard-coded ID list is treated as evidence of the saved assignments rather than a reconstruction of that expression or proof of independent manual coding. The original expression/workbook, if recovered, would support a more specific account. No separate coder log or reliability study is imposed as an additional brief requirement.
