library(RMySQL)

con <- dbConnect(MySQL(),
                 user = 'root',
                 dbname='mathelabramp',
                 password = 'Ramp340!',
                 host = 'localhost')

pathways<- dbGetQuery(con,'select * from pathway;')

pathway_list <- unique(pathways$pathwayName)

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
  path <- pathwayInHmdb[pathwayInHmdb$pathwayRampId == pathid,]$pathwayName
  pathid <- shQuote(pathid)
  query <- paste0("select * from analytehaspathway where pathwayRampId =",
                  pathid,
                  ";")
  df <- dbGetQuery(con,query)
  cid <- df$rampId[grepl("RAMP_C_",df$rampId)]
  gid <- df$rampId[grepl("RAMP_G_",df$rampId)]
  if(length(cid) >n){
    listOfHmdbC[[pathid]] <- cid
  }
  if(length(gid) >n){
    listOfHmdbG[[pathid]] <- gid 
  }
}

# Find kegg
for(pathid in pathwayInKegg$pathwayRampId){
  print(pathid)
  pathid <- shQuote(pathid)
  query <- paste0("select * from analytehaspathway where pathwayRampId =",
                  pathid,
                  ";")
  df <- dbGetQuery(con,query)
  cid <- df$rampId[grepl("RAMP_C_",df$rampId)]
  gid <- df$rampId[grepl("RAMP_G_",df$rampId)]
  if(length(cid) >n){
    listOfKeggC[[pathid]] <- cid
  }
  if(length(gid) >n){
    listOfKeggG[[pathid]] <- gid 
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
    listOfWikiC[[pathid]] <- cid
  }
  if(length(gid) >n){
    listOfWikiG[[pathid]] <- gid 
  }
}

# Find reactome
for(pathid in pathwayInReac$pathwayRampId){
  print(pathid)
  pathid <- shQuote(pathid)
  query <- paste0("select * from analytehaspathway where pathwayRampId =",
                  pathid,
                  ";")
  df <- dbGetQuery(con,query)
  cid <- df$rampId[grepl("RAMP_C_",df$rampId)]
  gid <- df$rampId[grepl("RAMP_G_",df$rampId)]
  if(length(cid) >n){
    listOfReacC[[pathid]] <- cid
  }
  if(length(gid) >n){
    listOfReacG[[pathid]] <- gid 
  }
}
# After finding all pathwayID: Analyte IDs pair 
# Write them to File 
writeToFile(listOfData = listOfHmdb,database = 'hmdb')
writeToFile(listOfData = listOfKegg,database = 'kegg')
writeToFile(listOfData = listOfWiki,database = 'wiki')
writeToFile(listOfData = listOfReac,database = 'reactome')
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
               names(listOfReacC),
               names(listOfWikiC))
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
library(plotly)
p_metabolites <- plot_ly(z = metabolite_result,
                         x = pathwayid,
                         y = pathwayid,
                         type = "heatmap") %>%
  layout(title = "metabolites overlap",
         margin = list(l = 10,
                       r = 10,
                       t = 10,
                       b = 10),
         xaxis = list(
           type = "category",
           showline = FALSE,
           zeroline = FALSE,
           showticklabels = FALSE,
           autorange = TRUE
         ),
         yaxis = list(
           type = "category",
           showline = FALSE,
           zeroline = FALSE,
           showticklabels =FALSE,
           autorange = TRUE
         ),
         shapes = list(
           list(
             line = list(
               color = "rgba(68,68,68,0.5)",
               width = 1
             ),
             type = "line",
             x0 = -0.3,
             x1 = 1.2
           )))
p_metabolites
# Write csv to a file
write.csv(metabolite_result,file = "metabolite_overlap.csv",quote = F)

# Output to a matrix
pathwayidG <- c(names(listOfHmdbG),
               names(listOfKeggG),
               names(listOfReacG),
               names(listOfWikiG))
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

p_genes <- plot_ly(z = gene_result,
                   x = pathwayidG,
                   y = pathwayidG,
                   type = "heatmap")
p_genes
write.csv(gene_result,file = "gene_overlap.csv",quote = F)


# Generate data for highcharter 
metabolite_result <- read.csv("metabolite_overlap.csv",row.names = 1)
gene_result <- read.csv("gene_overlap.csv",row.names = 1)


df <- c(metabolite_result)
df$RAMP_P_000001686
library(highcharter)
metadf <- data.frame(pathway1 = NULL,pathway2 = NULL,ratio = NULL)
for (i in 1:length(colnames(metabolite_result))) {
  for (j in 1:length(row.names(metabolite_result))) {
    pathway1 <- row.names(metabolite_result)[i]
    pathway2 <- colnames(metabolite_result)[j]
    ratio <- metabolite_result[i,j]
    metadf <- rbind(metadf,data.frame(pathway1 = pathway1,
                                      pathway2 = pathway2,
                                      ratio=ratio))
    print(paste(i,",",j))
  }
}
dim(gene_result)
dim(metabolite_result)
