#RQ2: Is mentioning at least one specific code verification practice associated with whether a comment receives a direct reply?
#Hacker News comments from five selected discussion about AI-generated code, verification and responsibility.
Hacker_News_comments = read.csv("data/clean/hn_comments_clean.csv", stringsAsFactors = FALSE)
dim(Hacker_News_comments)
table(Hacker_News_comments$received_reply)

#A variable was created to verify whether each comment mentions a specific code verification practice
Hacker_News_comments$verification_specific = NA
head(Hacker_News_comments$verification_specific)

# True= mentions a specific way to check or test AI-generated code
# False= does not mention a specific verification way

#add the new  column into the clean dataset
write.csv(Hacker_News_comments, "hn_comments_clean.csv", row.names = FALSE)
write.csv(Hacker_News_comments, "hn_comments_clean_backup.csv", row.names = FALSE)

#Assign the value True to IDs that have a comment mentioning a specific verification practice

true_ids = c(43861747,43862272,43862722,43861461,43861845,43866255,43861805,43865180,43869484,43864090,43863518,
             43866989,43863052,43867335,43862196,43874486,43862062,43863147,43862230,43862570,43863986,43863762,
             43882803,43867077,43870372,43878249,43862311,43868785,43869060,43867764,43868939,43863014,43868646,
             43862796,43862914,43877106,43869395,43864161,43862939,43869024,43863130,43863401,47290195,47292915,
             47290541,47295857,47292836,47290050,47289922,47290336,47309375,47298568,47290240,47290414,47291252,
             47290376,47290249,47388846,47294934,47290312,47292553,47290934,47292368,47300292,47293617,47292573,
             47293609,47292074,47291250,47291685,47297582,47292753,47416156,47415756,47418725,47416503,47415652,
             47417792,47418662,47418625,47415865,47420136,47418636,47417496,47417189,47416403,47417593,47419079,
             47420723,47419075,47420436,47418665,47416755,47416783,47416251,47420079,47418647,47416268,47416199,
             47421275,47420050,47419135,47420246,47418829,47420125,47420162,47420776,47419210,47427867,49431613,
             49438416,49326866,49353756,49340321,49335907,49351024,49328161,49326680,49330409,49431682,49378613,
             49391935,49388308)

#Assign False for all comments
Hacker_News_comments$verification_specific = FALSE

#change selected comments to TRUE
Hacker_News_comments$verification_specific[Hacker_News_comments$comment_id %in% true_ids] = TRUE

#check
length(true_ids)

table(Hacker_News_comments$verification_specific)

#check if any IDs in the list are missing.
sum(!true_ids %in% Hacker_News_comments$comment_id)


write.csv(Hacker_News_comments, "hn_comments_clean(after add true false).csv", row.names = FALSE)

#check the saved file
Hacker_News_comments = read.csv("hn_comments_clean(after add true false).csv", stringsAsFactors = FALSE)

table(Hacker_News_comments$verification_specific)

sum(is.na(Hacker_News_comments$verification_specific))


Hacker_News_comments=read.csv("hn_comments_clean(after add true false).csv", stringsAsFactors = FALSE)

dim(Hacker_News_comments)
table(Hacker_News_comments$received_reply)

#check verification_specific
table(Hacker_News_comments$verification_specific)
sum(is.na(Hacker_News_comments$verification_specific))

#compare verification_specific and received_reply
verification_table = table(Hacker_News_comments$verification_specific, Hacker_News_comments$received_reply)
verification_table

#show proportion of receiving a reply in each verification group
prop.table(verification_table, margin = 1)

#H0:verification_specific and received_reply are independent
#H1:verification_specific and received_reply are dependent

#Chi-square test for independence
chi_result=chisq.test(verification_table)
chi_result

#check expected counts
chi_result$expected













