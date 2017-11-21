library(xlsx)
library(RMySQL)

con<- dbConnect(MySQL(),user='root',
                password='Ehe131224',
                host='localhost',
                dbname = 'mathelabramp')
metabolites <- read.xlsx('refmet.xlsx',1)

metabolite_list <-as.vector(metabolites$Input.name)

pathway1 <- rampFastPathFromMeta(metabolite_list)
p<- unique(pathway1$pathwayName)
m<- unique(pathway1$metabolite)
for(each in m){
  metabolites <- metabolites[metabolites$Input.name != each,]
}

meta_list <- as.vector(metabolites$RefMet.name)

finalResult <- data.frame(row.names = F,stringsAsFactors = F)
item <- 1
for (metabolite in meta_list){
  
  ex <- tolower(metabolite)
  print(paste("searching for",ex))
  query <- paste0("select * from analyteSynonym where synonym like '%",
                  ex,"%' limit 10;")
  synonym <- dbGetQuery(con,query)
  print(synonym)
  #
  if(nrow(synonym)<1){
    finalResult <- rbind(finalResult,data.frame(pathway = NA, sourceId = NA, type = NA,
                                                metabolite = metabolite))
    next()
  }
  print("sort_synonym ...")
  sort_synonym <- synonym[order(nchar(synonym$Synonym)),]
  rampId <- unique(sort_synonym$rampId[1:length(sort_synonym$rampId)])
  rampId <- sapply(rampId,shQuote)
  rampId <- paste(rampId,collapse = ",")
  query2 <- paste0("select * from analytehaspathway where rampId in (",rampId,");")
  meta_path_pair <- dbGetQuery(con,query2)
  print(meta_path_pair)
  if(nrow(meta_path_pair)<1){
    finalResult <- rbind(finalResult,data.frame(pathway = NA, sourceId = NA, type = NA,
                                                metabolite = metabolite))
    next()
  }
  finalResult <- rbind(finalResult,data.frame(pathway = meta_path_pair$pathwayRampId,
                                              sourceId = NA,type = NA,
                                              metabolite = metabolite))
  
  
}


result <- finalResult[!is.na(finalResult$pathway),]
pid <- unique(result$pathway)
pid <- sapply(pid,shQuote)
pid <- paste(pid,collapse = ',')
query <- paste0("select * from pathway where pathwayRampId in (",pid,");")

pathway <- dbGetQuery(con,query)
length(unique(pathway$pathwayName))
length(unique(result$metabolite))
pathway2 <- merge(pathway,result, by.x = 'pathwayRampId',by.y = 'pathway')
pathway2 <- pathway2[,c(5,2,3,8)]
pathway3 <- read.csv("pathway2.csv")
path <- rbind(pathway2,pathway3)
path <- unique(path)
length(unique(path$metabolite))
write.csv(path,"pathway3.csv",row.names = F)
