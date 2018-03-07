finderPathways <- function(SourceId,rampIdHasPathway){
  hmdbSourceId <- unique(SourceId$V1)
  hmdbSourceId <- sapply(hmdbSourceId,shQuote)
  hmdbSourceId <- paste(hmdbSourceId,collapse = ",")
  query <- paste0("select * from source where sourceId in (",hmdbSourceId,");")
  df <- dbGetQuery(con,query)
  #return(df)
  rampId <- intersect(df$rampId,rampIdHasPathway)
}

finderPathways2 <- function(Ids){
  Ids <- unique(Ids)
  Ids <- sapply(Ids,shQuote)
  Ids <- paste(Ids,collapse = ",")
  query <- paste0("select * from analytehasPathway where rampId in (",Ids,");")
  df <- dbGetQuery(con,query)
}

finderPathways3 <- function(dfOfIds){
  cid <- unique(dfOfIds$rampId)
  pid <- unique(dfOfIds$pathwayRampId)
  pathSource <- c("hmdb","kegg","wiki","reactome")
  output <- data.frame(metabolites = NULL,totpathways = NULL,hmdb=NULL,
                       kegg =NULL,wiki=NULL,reac = NULL) 
  for(id in cid){
    print(id)
    pathways <- dfOfIds[dfOfIds$rampId == id,]
    numOfPathway <- vector()
    for(db in pathSource){
      numOfPathway <- c(numOfPathway,nrow(unique(pathways[pathways$pathwaySource == db,])))
      # print(pathways[pathways$type == db,])
      # Sys.sleep(3)
      
    }
    output <- rbind(output,data.frame(
      metabolites = id,totpathways = nrow(pathways),
      hmdb = numOfPathway[1],
      kegg = numOfPathway[2],
      wiki = numOfPathway[3],
      reac = numOfPathway[4]
    ))
  }
  return(output)
}
finderSynonymAndSource <- function(ids,db){
  ids <- sapply(ids,shQuote)
  ids <- paste(ids,collapse = ",")
  query1 <- paste0("select * from analytesynonym where rampId in (",ids,");")
  query2 <- paste0("select * from source where rampId in (",ids,");")
  synonym <- dbGetQuery(con,query1)
  source <- dbGetQuery(con,query2)
  df <- merge(synonym,source)
  df <- df[df$IDtype == db,]
  df <-  unique(df[,c(1,3,4,5)])
}