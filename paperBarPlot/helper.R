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
      numOfPathway <- c(numOfPathway,nrow(pathways[pathways$type == db,]))
      
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