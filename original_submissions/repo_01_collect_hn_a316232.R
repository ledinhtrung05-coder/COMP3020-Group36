#COMP3020 Group Project
#Collect Hacker News comments from five selected discussions about AI-generated code, verification and responsibility

library(jsonlite)

thread_ids = c(43857643,47289406,47397367,49321400,49378314)

#get one Hacker News item
get_hn_item = function(item_id){
  item_url = paste0("https://hacker-news.firebaseio.com/v0/item/",item_id,".json")
  item = jsonlite::fromJSON(item_url)
  return(item)
}

#collect all comments from one discussion
collect_comments = function(thread_id){
  story = get_hn_item(thread_id)
  
  if(is.null(story$kids)){
    return(data.frame())
  }
  
  queue = story$kids
  comments_list = list()
  
  while(length(queue) > 0){
    current_id = queue[1]
    queue = queue[-1]
    item = get_hn_item(current_id)
    
    if(is.null(item)){
      next
    }
    
    comments_list[[length(comments_list) + 1]] = data.frame(
      thread_id = thread_id,
      comment_id = item$id,
      parent_id = ifelse(is.null(item$parent),NA,item$parent),
      author = ifelse(is.null(item$by),NA,item$by),
      time = ifelse(is.null(item$time),NA,item$time),
      text_raw = ifelse(is.null(item$text),NA,item$text),
      type = ifelse(is.null(item$type),NA,item$type),
      dead = ifelse(is.null(item$dead),FALSE,item$dead),
      deleted = ifelse(is.null(item$deleted),FALSE,item$deleted),
      stringsAsFactors = FALSE
    )
    
    if(!is.null(item$kids)){
      queue = c(queue,item$kids)
    }
  }
  
  comments_df = do.call(rbind,comments_list)
  return(comments_df)
}

#collect all five discussions
all_threads_list = list()

for(i in seq_along(thread_ids)){
  current_thread_id = thread_ids[i]
  print(paste("Collecting thread",i,"of",length(thread_ids)))
  
  story = get_hn_item(current_thread_id)
  thread_comments = collect_comments(current_thread_id)
  thread_comments$thread_title = story$title
  all_threads_list[[i]] = thread_comments
}

hn_comments_raw = do.call(rbind,all_threads_list)

#check the collected data
nrow(hn_comments_raw)
table(hn_comments_raw$thread_id)
length(unique(hn_comments_raw$comment_id))
sum(duplicated(hn_comments_raw$comment_id))
table(hn_comments_raw$dead)
table(hn_comments_raw$deleted)

#save raw data
write.csv(hn_comments_raw,"data/raw/hn_comments_raw.csv",row.names = FALSE)