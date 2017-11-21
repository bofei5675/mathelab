library(RMySQL)

con <- dbConnect(MySQL(),
                 user = 'root',
                 dbname='mathelabramp',
                 password = 'Ehe131224',
                 host = 'localhost')

pathways<- dbGetQuery(con,'select * from pathway;')

pathway_list <- unique(pathways$pathwayName)

dbname <- unique(pathways$type)

pathwayInHmdb <- pathways[pathways$type == 'hmdb',]
pathwayInKegg <- pathways[pathways$type == 'kegg',]
pathwayInWiki <- pathways[pathways$type == 'wiki',]
pathwayInReac <- pathways[pathways$type == 'reactome',]

listOfHmdb <- list()
listOfKegg <- list()
listOfWiki <- list()
listOfReac <- list()
# Find hmdb
for(pathid in pathwayInHmdb$pathwayRampId){
  print(pathid)
  path <- pathwayInHmdb[pathwayInHmdb$pathwayRampId == pathid,]$pathwayName
  pathid <- shQuote(pathid)
  query <- paste0("select * from analytehaspathway where pathwayRampId =",
                  pathid,
                  ";")
  df <- dbGetQuery(con,query)
  listOfHmdb[[pathid]] <- df$rampId

}

# Find kegg
for(pathid in pathwayInKegg$pathwayRampId){
  print(pathid)
  pathid <- shQuote(pathid)
  query <- paste0("select * from analytehaspathway where pathwayRampId =",
                  pathid,
                  ";")
  df <- dbGetQuery(con,query)
  listOfKegg[[pathid]] <- df$rampId
  
}

# Find wiki
for(pathid in pathwayInWiki$pathwayRampId){
  print(pathid)
  path <- pathwayInWiki[pathwayInWiki$pathwayRampId == pathid,]$pathwayName
  pathid <- shQuote(pathid)
  query <- paste0("select * from analytehaspathway where pathwayRampId =",
                  pathid,
                  ";")
  df <- dbGetQuery(con,query)
  listOfWiki[[pathid]] <- df$rampId
  
}

# Find reactome
for(pathid in pathwayInReac$pathwayRampId){
  print(pathid)
  pathid <- shQuote(pathid)
  query <- paste0("select * from analytehaspathway where pathwayRampId =",
                  pathid,
                  ";")
  df <- dbGetQuery(con,query)
  listOfReac[[pathid]] <- df$rampId
  
}
writeToFile(listOfData = listOfHmdb,database = 'hmdb')
writeToFile(listOfData = listOfKegg,database = 'kegg')
writeToFile(listOfData = listOfWiki,database = 'wiki')
writeToFile(listOfData = listOfReac,database = 'reactome')

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

pathid <- pathwayInReac[pathwayInReac$pathwayName == "Notch Signaling Pathway",]
result <- matrix(0,nrow = nrow(pathways),ncol = nrow(pathways))

a <- listOfHmdb[[1]]
a
names(listOfHmdb)[1]
b <- listOfHmdb[[12]]
b
intersect(a,b)
colnames(result) <- sapply(c(names(listOfHmdb),names(listOfKegg),names(listOfWiki),
                      names(listOfReac)),function(x) gsub("\"","",x))
rownames(result) <- sapply(c(names(listOfHmdb),names(listOfKegg),names(listOfWiki),
                             names(listOfReac)),function(x) gsub("\"","",x))
dim(result)
a <- dim(result)
for(i in 1:3420){
  pid1 <- unname(colnames(result)[i])
  
  for(j in 1:3420){
    print(paste0(i,',',j))
    pid2 <- unname(colnames(result)[j])
    if(i < length(listOfHmdb) + 1 &j <length(listOfHmdb)+1){
      rampid1 <- listOfHmdb[[shQuote(pid1)]]
      rampid2 <- listOfHmdb[[shQuote(pid2)]]
      #print(rampid1)
      #print(rampid2)
      if(length(grep("RAMP_C",rampid1,value = T))>0 &
         length(grep("RAMP_C",rampid2,value = T))>0){
        #print(paste0(i,',',j))
        a <-grep("RAMP_C",rampid1,value = T)
        b <-grep("RAMP_C",rampid2,value = T)
        overlap <- length(intersect(a,b))
        result[i,j] <- overlap
      }
    }
    # kegg
    if(i < length(listOfHmdb) + 1 & j %in% (717+1):(717+192)){
      rampid1 <- listOfKegg[[shQuote(pid1)]]
      rampid2 <- listOfKegg[[shQuote(pid2)]]
      #print(rampid1)
      #print(rampid2)
      if(length(grep("RAMP_C",rampid1,value = T))>0 &
         length(grep("RAMP_C",rampid2,value = T))>0){
        #print(paste0(i,',',j))
        a <-grep("RAMP_C",rampid1,value = T)
        b <-grep("RAMP_C",rampid2,value = T)
        overlap <- length(intersect(a,b))
        result[i,j] <- overlap
      }
    }
    # wiki
    if(i < length(listOfHmdb) + 1 &j %in% (717+192+1):(717+192 +379)){
      rampid1 <- listOfWiki[[shQuote(pid1)]]
      rampid2 <- listOfWiki[[shQuote(pid2)]]
      #print(rampid1)
      #print(rampid2)
      if(length(grep("RAMP_C",rampid1,value = T))>0 &
         length(grep("RAMP_C",rampid2,value = T))>0){
        #print(paste0(i,',',j))
        a <-grep("RAMP_C",rampid1,value = T)
        b <-grep("RAMP_C",rampid2,value = T)
        overlap <- length(intersect(a,b))
        result[i,j] <- overlap
      }
    }
    # reactome
    if(i < length(listOfHmdb) + 1 & j %in% (717+192+379+1):(717+192+379+2132)){
      rampid1 <- listOfReac[[shQuote(pid1)]]
      rampid2 <- listOfReac[[shQuote(pid2)]]
      #print(rampid1)
      #print(rampid2)
      if(length(grep("RAMP_C",rampid1,value = T))>0 &
         length(grep("RAMP_C",rampid2,value = T))>0){
        #print(paste0(i,',',j))
        a <-grep("RAMP_C",rampid1,value = T)
        b <-grep("RAMP_C",rampid2,value = T)
        overlap <- length(intersect(a,b))
        result[i,j] <- overlap
      }
    }
    #Sys.sleep(1)
  }
}
length(pid)
nchar(pid)
# hmdb vs. hmdb
hmdbToOther <- data.frame()
for(pid1 in names(listOfHmdb)){
  cid1 <- grep('RAMP_C',listOfHmdb[[pid1]],value = T)
  for(pid2 in names(listOfHmdb)){
    cid2 <- grep('RAMP_C',listOfHmdb[[pid2]],value = T)
    print(paste0(pid1,':',pid2))
    if(length(cid1) >0 & length(cid2) >0){
      df <- data.frame(pathway1=pid1,
                       pathway2 = pid2,
                       overlap = length(intersect(cid1,cid2))/length(union(cid1,cid2)))
      hmdbToOther <- rbind(hmdbToOther,df)
    } else{
      df <- data.frame(pathway1=pid1,
                       pathway2 = pid2,
                       overlap = 0)
      hmdbToOther <- rbind(hmdbToOther,df)
    }
  }
  
  for(pid2 in names(listOfKegg)){
    cid2 <- grep('RAMP_C',listOfKegg[[pid2]],value = T)
    print(paste0(pid1,':',pid2))
    if(length(cid1) >0 & length(cid2) >0){
      df <- data.frame(pathway1=pid1,
                       pathway2 = pid2,
                       overlap = length(intersect(cid1,cid2))/length(union(cid1,cid2)))
      hmdbToOther <- rbind(hmdbToOther,df)
    } else{
      df <- data.frame(pathway1=pid1,
                       pathway2 = pid2,
                       overlap = 0)
      hmdbToOther <- rbind(hmdbToOther,df)
    }
  }
  for(pid2 in names(listOfWiki)){
    cid2 <- grep('RAMP_C',listOfWiki[[pid2]],value = T)
    print(paste0(pid1,':',pid2))
    if(length(cid1) >0 & length(cid2) >0){
      df <- data.frame(pathway1=pid1,
                       pathway2 = pid2,
                       overlap = length(intersect(cid1,cid2))/length(union(cid1,cid2)))
      hmdbToOther <- rbind(hmdbToOther,df)
    } else{
      df <- data.frame(pathway1=pid1,
                       pathway2 = pid2,
                       overlap = 0)
      hmdbToOther <- rbind(hmdbToOther,df)
    }
  }
  for(pid2 in names(listOfReac)){
    cid2 <- grep('RAMP_C',listOfReac[[pid2]],value = T)
    print(paste0(pid1,':',pid2))
    if(length(cid1) >0 & length(cid2) >0){
      df <- data.frame(pathway1=pid1,
                       pathway2 = pid2,
                       overlap = length(intersect(cid1,cid2))/length(union(cid1,cid2)))
      hmdbToOther <- rbind(hmdbToOther,df)
    } else{
      df <- data.frame(pathway1=pid1,
                       pathway2 = pid2,
                       overlap = 0)
      hmdbToOther <- rbind(hmdbToOther,df)
    }
  }
  
}
