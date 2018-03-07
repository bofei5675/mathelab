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
  if(GC == 'both'){
    df2 <- aggregate(df$rampId,list(df$pathwayRampId),FUN = function(x){
      if(length(x) >= n){
        paste(x,collapse = ',')
      } else{
        x <- 0
      }
    })
  }
  else if (GC %in% c('G','C')){
    df2 <- aggregate(df$rampId,list(df$pathwayRampId),FUN = function(x){
      x <- x[grepl(paste0("RAMP_",GC,"_"),x)]
      if(length(x) >= n ){
        paste(x,collapse = ",")
      } else {
        x <- 0
      }
    })
  }
  fdf <- df2[df2$x!=0,]
  fdf2 <- data.frame(fdf[,-1],row.names = fdf[,1],stringsAsFactors = F)
  df.list <- setNames(split(fdf2, seq(nrow(fdf2))), rownames(fdf2))
  df.list <- lapply(df.list,FUN = function(x){
    text <- x[[1]]
    text <- strsplit(text,split = ",")
  })
  df.list <- lapply(df.list,unlist)
}


#'Computer for overlaping matrix based on given data
#'
#'@param pathwayid a vector that has all ramp pathway id in it
#'@param pathwaysWithAnalytes a list that has pathways ramp Id as name, analytes (ramp compound id only
#' or gene id only) as content.
#' @param methods must be in c('balanced','weighted') to determine which way to calculate this matrix
compute_overlap_matrix <- function(pathwayid,
                                   pathwaysWithAnalytes,
                                   methods){
  if(!(methods %in% c('balanced','weighted')))
    stop('Wrong option for the input')
  metabolite_result <- matrix(NA,nrow = length(pathwayid),ncol = length(pathwayid))
  colnames(metabolite_result) <- pathwayid
  rownames(metabolite_result) <- pathwayid
  # First method compute intersection over the union
  if(methods == 'balanced'){
    for(i in 1:length(pathwayid)){
      id <- pathwayid[i]
      cid <- pathwaysWithAnalytes[[i]]
      for (j in 1:length(pathwayid)) {
        if(is.na(metabolite_result[i,j])){
          if(i==j){
            metabolite_result[i,j] <- 1
          }else{
            cid2 <- pathwaysWithAnalytes[[j]]
            shared_metabolite <- unique(intersect(cid,cid2))
            total <- unique(union(cid,cid2))
            metabolite_result[i,j] <- length(shared_metabolite)/length(total)
            print(metabolite_result[i,j])
            if(is.na(metabolite_result[j,i])){
              metabolite_result[j,i] <- metabolite_result[i,j]
            }
          }
        }
        print(paste("Compute for ",i,",",j))
      }
    }
  }else if (methods == 'weighted'){
      # second method
      for(i in 1:length(pathwayid)){
        id <- pathwayid[i]
        cid <- pathwaysWithAnalytes[[i]]
        for (j in 1:length(pathwayid)) {
          if(is.na(metabolite_result[i,j])){
            if(i==j){
              metabolite_result[i,j] <- 1
            }else{
              cid2 <- pathwaysWithAnalytes[[j]]
              shared_metabolite <- unique(intersect(cid,cid2))
              total <- unique(union(cid,cid2))
              metabolite_result[i,j] <- length(shared_metabolite)/length(unique(cid2))
              print(metabolite_result[i,j])
              if(is.na(metabolite_result[j,i])){
                metabolite_result[j,i] <- length(shared_metabolite)/length(unique(cid))
              }
            }
          }
          print(paste("Compute for ",i,",",j))
        }
      }
  }
  
  return(metabolite_result)
}