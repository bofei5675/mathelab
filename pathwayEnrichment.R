library(xlsx)
library(RMySQL)
con <- dbConnect(MySQL(),
                 user = 'root',
                 dbname='mathelabramp',
                 password = 'Ehe131224',
                 host = 'localhost')
hmdb<- list()
hmdb[[1]] <- read.xlsx('Compiled_results.xlsx',
                     sheetIndex = 1)
hmdb[[2]] <- read.xlsx('Compiled_results.xlsx',
                     sheetIndex = 2)
hmdb[[3]] <- read.xlsx('Compiled_results.xlsx',
                     sheetIndex = 3)
hmdb[[4]] <- read.xlsx('Compiled_results.xlsx',
                     sheetIndex = 4)
hmdb[[5]] <- read.xlsx('Compiled_results.xlsx',
                     sheetIndex = 5)
result<- list()
result[[1]] <- rampFindPathway(hmdb[[1]])
result[[2]] <- rampFindPathway(hmdb[[3]])
result[[3]] <- rampFindPathway(hmdb[[4]])
result[[4]] <- rampFindPathway(hmdb[[5]])

wb <- createWorkbook()
sheetName <- c("Treated_DMEM","Untreated_DMEM","Untreated_STDP","Full")
i<- 1
sheet <- list()
for(name in sheetName){
  sheet[[name]] <-createSheet(wb,name)
}
for(i in 1:4){
   addDataFrame(result[[i]],sheet = sheet[[i]],startColumn = 1,row.names = F)
}
saveWorkbook(wb,"pathways.xlsx")

write.xlsx(result,file = "pathways.xlsx",sheetName = 'Treated_DMEM',row.names = F)
write.xlsx(result,file = "pathways.xlsx",sheetName = 'Treated_STDP',row.names = F)
write.xlsx(result,file = "pathways.xlsx",sheetName = 'Untreated_DMEM',row.names = F)
write.xlsx(result,file = "pathways.xlsx",sheetName = 'Untreated_STDP',row.names = F)
write.xlsx(result,file = "pathways.xlsx",sheetName = 'Full',row.names = F)
?write.xlsx



# Using function below....
rampFindPathway<- function(hmdb){
  hmdbid1 <- unique(as.character(hmdb$HMDB.ID[hmdb$HMDB.ID != "Not Found"]))
  hmdbid1 <- sapply(hmdbid1,shQuote)
  hmdbid1 <- paste(hmdbid1,collapse = ',')
  query <- paste0("select * from source where sourceId in (",hmdbid1,");")
  
  source <- dbGetQuery(con,query)
  
  rampId <- unique(source$rampId)
  #return(rampId)
  rampId <- sapply(rampId,shQuote)
  rampId <- paste(rampId,collapse = ',')
  query2 <- paste0("select * from analytehaspathway where rampId in (",rampId,");")
  
  pathway <- dbGetQuery(con,query2)
  #return(pathway)
  pid <- unique(pathway$pathwayRampId)
  pid <- sapply(pid,shQuote)
  pid <- paste(pid,collapse = ',')
  query3 <- paste("select * from pathway where pathwayrampId in (",pid,");")
  
  pname <- dbGetQuery(con,query3)
  result <- merge(pname,pathway)
  
  result2 <- merge(result,source,by.x = 'rampId',by.y = 'rampId')
  result2 <- result2[,c(6,4,3,7)]
}
