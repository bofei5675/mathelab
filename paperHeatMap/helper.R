# After finding all pathwayID: Analyte IDs pair 
# Write them to File 
# not necessary
# writeToFile(listOfData = listOfHmdb,database = 'hmdb')
# writeToFile(listOfData = listOfKegg,database = 'kegg')
# writeToFile(listOfData = listOfWiki,database = 'wiki')
# writeToFile(listOfData = listOfReac,database = 'reactome')
# Define function for writing a file
writeToFile <- function(listOfData,database){
  for(pid in names(listOfData)){
    id <- listOfData[[pid]]
    pid <- gsub("\"","",pid)
    cid <- id[grepl("RAMP_C",id)]
    gid <- id[grepl("RAMP_G",id)]
    cid <- paste(cid,collapse = ",")
    gid <- paste(gid,collapse = ",")
    toComp <- paste(pid,cid,collapse = "\t")
    toGene <- paste(pid,gid,collapse = "\t")
    write(toComp,file = paste0("paper/",database,"compound.text"),append = T)
    write(toGene,file = paste0("paper/",database,"gene.text"),append = T)
    
    
  }
}


# Find table of analyte has pathway from given pathway IDs
# Aggregate ramp Id to ramp pathway Id 
# GC is C or G
findAnalyteHasPathway <- function(pathwayRampId,GC = "C",n = 10){
  con <- dbConnect(MySQL(),
                   user = 'root',
                   dbname='mathelabramp',
                   password = 'Ehe131224',
                   host = 'localhost')
  on.exit(dbDisconnect(con))
  p_id <- unique(pathwayRampId)
  p_id <- sapply(p_id,shQuote)
  p_id <- paste(p_id,collapse = ",")
  query <-paste0("select * from analytehaspathway where pathwayRampId in (",
                 p_id,
                 ");")
  df <- dbGetQuery(con,
                       query)
  df2 <- aggregate(df$rampId,list(df$pathwayRampId),FUN = function(x){
    x <- x[grepl(paste0("RAMP_",GC,"_"),x)]
    if(length(x) >= n ){
      paste(x,collapse = ",")
    } else {
      x <- 0
    }
  })
  fdf <- df2[df2$x!=0,]
  fdf2 <- data.frame(fdf[,-1],row.names = fdf[,1],stringsAsFactors = F)
  df.list <- setNames(split(fdf2, seq(nrow(fdf2))), rownames(fdf2))
  df.list <- lapply(df.list,FUN = function(x){
    text <- x[[1]]
    text <- strsplit(text,split = ",")
  })
  df.list <- lapply(df.list,unlist)
}
