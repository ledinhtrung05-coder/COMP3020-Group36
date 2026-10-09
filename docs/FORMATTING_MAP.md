# Mapping to the supplied edited Word template

The Word sample controls hierarchy, title/TOC order, heading colour, column proportions and explicit page-break locations. Explicit notes control Arial 12, 1.5 body spacing, section headings 16, justified prose, centred figures/tables and captions below. The sample title uses 28 pt and subtitle 14 pt. Left/right margins retain the previously disclosed 1.2-inch interpretation; the original sample itself uses 1 inch.

## Front matter

Title, subtitle, Group 36, date, clickable GitHub URL, then the native three-level table of contents. The title and TOC share the first page. The shared member names, student IDs and contribution percentages now appear on the cover before the TOC, as explicitly required by the assignment. TOC page numbers must be updated after rendering; they are not copied from the old sample.

## Table geometry

Small tables retain measured widths. Wider tables are capped at the 6.1-inch text area, with the measured column proportions preserved except for the discussion table adjustment below. The data values and table schemas remain authoritative.

| Table | Original width (in) | Column proportions (%) |
|---|---:|---|
| research_questions | 6.493 | 50.0, 50.0 |
| data_audit | 4.664 | 88.24, 11.76 |
| thread_composition | 6.705 | 9.92, 62.74, 7.21, 9.03, 11.09 |
| variable_definitions | 6.493 | 50.0, 50.0 |
| rq1_indicators | 6.168 | 52.31, 24.08, 23.61 |
| rq1_contextual_examples | 6.493 | 50.0, 50.0 |
| rq2_observed | 4.41 | 30.92, 17.48, 13.07, 11.81, 26.72 |
| rq2_expected | 1.283 | 52.9, 47.1 |
| rq3_candidate_partitions | 5.802 | 4.19, 23.67, 20.95, 21.75, 16.16, 13.29 |
| rq3_cluster_profiles | 6.493 | 10.04, 17.78, 20.72, 22.2, 29.26 |
| rq3_comment_examples | 6.44 | 10.14, 24.24, 18.05, 47.57 |
| rq3_sensitivity | 4.616 | 30.36, 5.27, 29.76, 14.31, 20.31 |
| rq4_network_metrics | 3.322 | 74.53, 25.47 |
| rq4_centrality | 6.493 | 22.55, 14.11, 30.97, 32.37 |
| rq4_receiver_clusters | 6.493 | 14.48, 17.26, 24.37, 17.08, 26.8 |
| session_info | 1.69 | 57.67, 42.33 |

The current RQ2 expected-count table includes a label column absent from the older sample. It uses three columns rather than reverting to the ambiguous two-column form. The new RQ2 thread breakdown has five columns and no earlier visual counterpart. The Lua filter records their chosen widths explicitly.

## Page breaks

All seven top-level headings begin a page. Additional breaks reproduce the sample before Connected research questions; Cleaning audit; the thread-composition table; Variables; RQ1 Contextual reading; RQ2; RQ2 Test and interpretation; RQ3; Cluster profiles; Sensitivity; RQ4; Centrality; and Which content receives replies. Other pagination remains automatic.

The added RQ2 descriptive check remains part of RQ2. Its additional content means the report cannot have exactly the same page numbers as the earlier template without changing the content.

## Final content and layout audit

The discussion table now uses16/46/10/12/16percent widths within6.1in, so eight-digit IDs and Raw/Clean/Authors headings remain readable at12pt. Profile headers were shortened without changing values. These are deliberate readability corrections to the narrow original columns. Other surviving table layouts keep their template-derived widths.

Redundant indicator/diagnostic/example/version tables and the degree/thread-composition charts are omitted from the printed report; complete CSVs/figures remain exported. This preserves required analytical evidence and all20explicit page starts while meeting the page limit. Full network and LCC visuals remain separately readable.

## Validation limits

Actual R4.4.3 Knit produced a28-page report and a1-page poster. The report uses Nimbus Sans only for the audit preview, and the poster preview uses DejaVu Sans, because Arial is absent locally. Delivered sources explicitly request Arial. The group must check pagination again after entering real member/provenance information and knitting with Arial. No page count is guaranteed across those changes.
