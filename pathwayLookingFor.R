library(RMySQL)

con <- dbConnect(MySQL(),
                 user = 'root',
                 dbname='mathelabramp',
                 password = 'Ehe131224',
                 host = 'localhost')

pathways<- dbGetQuery(con,'select * from pathway;')



dbname <- unique(pathways$type)

pathwayInHmdb <- pathways[pathways$type == 'hmdb',]
pathwayInKegg <- pathways[pathways$type == 'kegg',]
pathwayInWiki <- pathways[pathways$type == 'wiki',]
pathwayInReac <- pathways[pathways$type == 'reactome',]

# Store Compound Ids in List
listOfHmdbC <- list()
listOfKeggC <- list()
listOfWikiC <- list()
listOfReacC <- list()
# Store Gene Ids in List
listOfHmdbG <- list()
listOfKeggG <- list()
listOfWikiG <- list()
listOfReacG <- list()
# Setup minimum number of analytes that will be considered
n <- 10
# Find hmdb
# May need to filter out that pathway that has less than 5 metabolites 
for(pathid in pathwayInHmdb$pathwayRampId){
  print(pathid)
  pid <- pathid
  path <- pathwayInHmdb[pathwayInHmdb$pathwayRampId == pathid,]$pathwayName
  pathid <- shQuote(pathid)
  query <- paste0("select * from analytehaspathway where pathwayRampId =",
                  pathid,
                  ";")
  df <- dbGetQuery(con,query)
  cid <- df$rampId[grepl("RAMP_C_",df$rampId)]
  gid <- df$rampId[grepl("RAMP_G_",df$rampId)]
  if(length(cid) >n){
    listOfHmdbC[[pid]] <- cid
  }
  if(length(gid) >n){
    listOfHmdbG[[pid]] <- gid 
  }
}

# Find kegg
for(pathid in pathwayInKegg$pathwayRampId){
  print(pathid)
  pid <- pathid
  pathid <- shQuote(pathid)
  query <- paste0("select * from analytehaspathway where pathwayRampId =",
                  pathid,
                  ";")
  df <- dbGetQuery(con,query)
  cid <- df$rampId[grepl("RAMP_C_",df$rampId)]
  gid <- df$rampId[grepl("RAMP_G_",df$rampId)]
  if(length(cid) > n){
    listOfKeggC[[pid]] <- cid
  }
  if(length(gid) > n){
    listOfKeggG[[pid]] <- gid 
  }
  
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
  cid <- df$rampId[grepl("RAMP_C_",df$rampId)]
  gid <- df$rampId[grepl("RAMP_G_",df$rampId)]
  if(length(cid) >n){
    listOfWikiC[[pid]] <- cid
  }
  if(length(gid) >n){
    listOfWikiG[[pid]] <- gid 
  }
}

# Find reactome
for(pathid in pathwayInReac$pathwayRampId){
  print(pathid)
  pid <- pathid
  pathid <- shQuote(pathid)
  query <- paste0("select * from analytehaspathway where pathwayRampId =",
                  pathid,
                  ";")
  df <- dbGetQuery(con,query)
  cid <- df$rampId[grepl("RAMP_C_",df$rampId)]
  gid <- df$rampId[grepl("RAMP_G_",df$rampId)]
  if(length(cid) >n){
    listOfReacC[[pid]] <- cid
  }
  if(length(gid) >n){
    listOfReacG[[pid]] <- gid 
  }
}
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
# Output to a matrix
# In order of HMDB Kegg Wiki Reac
pathwayid <- c(names(listOfHmdbC),
               names(listOfKeggC),
               names(listOfWikiC),
               names(listOfReacC))

pathwayid <- pathways$sourceId[pathways$pathwayRampId == pathwayid]
metabolite_result <- matrix(NA,nrow = length(pathwayid),ncol = length(pathwayid))

# Assign names on the metabolites result
colnames(metabolite_result) <- pathwayid
rownames(metabolite_result) <- pathwayid

pathToanalC <- do.call(c,list(listOfHmdbC,listOfKeggC,
                             listOfWikiC,listOfReacC))
for(i in 1:length(pathwayid)){
  id <- pathwayid[i]
  cid <- pathToanalC[[i]]
  for (j in 1:length(pathwayid)) {
    if(is.na(metabolite_result[i,j])){
      if(i==j){
        metabolite_result[i,j] <- 1
      }else{
        cid2 <- pathToanalC[[j]]
        shared_metabolite <- intersect(cid,cid2)
        total <- union(cid,cid2)
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

# Output to a matrix
### Part for genes ...
pathwayidG <- c(names(listOfHmdbG),
               names(listOfKeggG),
               names(listOfWikiG),
               names(listOfReacG))
gene_result <- matrix(NA,nrow = length(pathwayidG),ncol = length(pathwayidG))
# In order of HMDB Kegg Wiki Reac
# Assign names on the metabolites result
colnames(gene_result) <- pathwayidG
rownames(gene_result) <- pathwayidG

pathToanalG <- do.call(c,list(listOfHmdbG,listOfKeggG,
                             listOfWikiG,listOfReacG))

for(i in 1:length(pathwayidG)){
  id <- pathwayidG[i]
  cid <- pathToanalG[[i]]
  
  for (j in 1:length(pathwayidG)) {
    if(is.na(gene_result[i,j])){
      if(i==j){
        gene_result[i,j] <- 1
      }else{
        cid2 <- pathToanalG[[j]]
        shared_metabolite <- intersect(cid,cid2)
        total <- union(cid,cid2)
        gene_result[i,j] <- length(shared_metabolite)/length(total)
        print(gene_result[i,j])
        if(is.na(gene_result[j,i])){
          gene_result[j,i] <- gene_result[i,j]
        }
        
      }
    }
    print(paste("Compute for ",i,",",j))
  }
}

