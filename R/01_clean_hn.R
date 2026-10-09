#COMP3020 Group Project
#Clean the collected Hacker News comments

hn_raw = read.csv("data/raw/hn_comments_raw.csv",stringsAsFactors = FALSE)

#check raw data
nrow(hn_raw)
table(hn_raw$thread_id)
sum(duplicated(hn_raw$comment_id))

#remove dead and deleted comments
hn_clean = hn_raw[hn_raw$dead == FALSE & hn_raw$deleted == FALSE,]

nrow(hn_clean)
table(hn_clean$thread_id)

#check missing values
sum(is.na(hn_clean$author))
sum(is.na(hn_clean$text_raw))
sum(is.na(hn_clean$parent_id))

#convert time
hn_clean$created_at = as.POSIXct(hn_clean$time,origin = "1970-01-01",tz = "UTC")

#remove HTML tags and extra spaces
hn_clean$text = gsub("<[^>]+>"," ",hn_clean$text_raw)
hn_clean$text = gsub("\\s+"," ",hn_clean$text)
hn_clean$text = trimws(hn_clean$text)

#decode
decode_entities = function(x){
  x = gsub("&quot;","\"",x,fixed = TRUE)
  x = gsub("&#x27;","'",x,fixed = TRUE)
  x = gsub("&#39;","'",x,fixed = TRUE)
  x = gsub("&#x2F;","/",x,fixed = TRUE)
  x = gsub("&gt;",">",x,fixed = TRUE)
  x = gsub("&lt;","<",x,fixed = TRUE)
  x = gsub("&amp;","&",x,fixed = TRUE)
  return(x)
}

hn_clean$text = decode_entities(hn_clean$text)

#check remaining
remaining_entities = grep("&(#x?[0-9A-Fa-f]+|[A-Za-z]+);",hn_clean$text,value = TRUE)
length(remaining_entities)

#create received_reply
hn_clean$received_reply = hn_clean$comment_id %in% hn_clean$parent_id
table(hn_clean$received_reply)

#final checks
nrow(hn_clean)
sum(duplicated(hn_clean$comment_id))
sum(is.na(hn_clean$author))
sum(is.na(hn_clean$text))
sum(trimws(hn_clean$author) == "")
sum(trimws(hn_clean$text) == "")

#save clean data
write.csv(hn_clean,"data/processed/hn_comments_clean.csv",row.names = FALSE)

#check saved clean data
hn_clean = read.csv("data/processed/hn_comments_clean.csv",stringsAsFactors = FALSE)

nrow(hn_clean)
length(unique(hn_clean$comment_id))
table(hn_clean$thread_id)
table(hn_clean$received_reply)
sum(duplicated(hn_clean$comment_id))