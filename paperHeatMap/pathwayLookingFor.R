library(RMySQL)
source("helper.R")
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
listOfHmdbC <- findAnalyteHasPathway(pathwayInHmdb$pathwayRampId)
listOfKeggC <- findAnalyteHasPathway(pathwayInKegg$pathwayRampId)
listOfWikiC <- findAnalyteHasPathway(pathwayInWiki$pathwayRampId)
listOfReacC <- findAnalyteHasPathway(pathwayInReac$pathwayRampId)
# Store Gene Ids in List
listOfHmdbG <- findAnalyteHasPathway(pathwayInHmdb$pathwayRampId,GC="G")
listOfKeggG <- findAnalyteHasPathway(pathwayInKegg$pathwayRampId,GC="G")
listOfWikiG <- findAnalyteHasPathway(pathwayInWiki$pathwayRampId,GC="G")
listOfReacG <- findAnalyteHasPathway(pathwayInReac$pathwayRampId,GC="G")
# Setup minimum number of analytes that will be considered

# May need to filter out that pathway that has less than 5 metabolites 
# Output to a matrix
# In order of HMDB Kegg Wiki Reac

pathwayid <- c(names(listOfHmdbC),
               names(listOfKeggC),
               names(listOfWikiC),
               names(listOfReacC))


metabolite_result <- matrix(NA,nrow = length(pathwayid),ncol = length(pathwayid))
metabolite_result2 <- matrix(NA,nrow = length(pathwayid),ncol = length(pathwayid))

# Assign names on the metabolites result
colnames(metabolite_result) <- pathwayid
rownames(metabolite_result) <- pathwayid
colnames(metabolite_result2) <- pathwayid
rownames(metabolite_result2) <- pathwayid

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
# second method
for(i in 1:length(pathwayid)){
  id <- pathwayid[i]
  cid <- pathToanalC[[i]]
  for (j in 1:length(pathwayid)) {
    if(is.na(metabolite_result2[i,j])){
      if(i==j){
        metabolite_result2[i,j] <- 1
      }else{
        cid2 <- pathToanalC[[j]]
        shared_metabolite <- unique(intersect(cid,cid2))
        total <- union(cid,cid2)
        metabolite_result2[i,j] <- length(shared_metabolite)/length(unique(cid2))
        print(metabolite_result2[i,j])
        if(is.na(metabolite_result2[j,i])){
          metabolite_result2[j,i] <- length(shared_metabolite)/length(unique(cid))
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
gene_result2 <- matrix(NA,nrow = length(pathwayidG),ncol = length(pathwayidG))
# In order of HMDB Kegg Wiki Reac
# Assign names on the metabolites result
colnames(gene_result) <- pathwayidG
rownames(gene_result) <- pathwayidG
colnames(gene_result2) <- pathwayidG
rownames(gene_result2) <- pathwayidG

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
# Second method
for(i in 1:length(pathwayidG)){
  id <- pathwayidG[i]
  cid <- pathToanalG[[i]]
  
  for (j in 1:length(pathwayidG)) {
    if(is.na(gene_result2[i,j])){
      if(i==j){
        gene_result2[i,j] <- 1
      }else{
        cid2 <- pathToanalG[[j]]
        shared_metabolite <- unique(intersect(cid,cid2))
        total <- union(cid,cid2)
        gene_result2[i,j] <- length(shared_metabolite)/length(cid2)
        print(gene_result[i,j])
        if(is.na(gene_result2[j,i])){
          gene_result2[j,i] <- length(shared_metabolite) / length(cid)
        }
        
      }
    }
    print(paste("Compute for ",i,",",j))
  }
}
colnames(metabolite_result)[1215]
path1 <- pathways[pathways$pathwayRampId %in% colnames(metabolite_result),]

metabolites_path <- pathways$sourceId[pathways$pathwayRampId %in% colnames(metabolite_result)]
genes_path <- pathways$sourceId[pathways$pathwayRampId %in% colnames(gene_result)]
length(genes_path)

colnames(metabolite_result) <- path1$sourceId
row.names(metabolite_result) <- path1$sourceId

colnames(gene_result) <- genes_path
row.names(gene_result) <- genes_path

colnames(metabolite_result2) <- path1$sourceId
row.names(metabolite_result2) <- path1$sourceId
path1$sourceId
colnames(gene_result2) <- genes_path
row.names(gene_result2) <- genes_path
metabolites_path[1:5]
colnames(gene_result)
save(gene_result,file = "gene_overlap_matrix.RData")
