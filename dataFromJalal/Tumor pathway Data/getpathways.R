library(RMySQL)
library(xlsx)
source("rampMoreQuery.R")

con<- dbConnect(MySQL(),
                dbname = "mathelabramp",
                username = "root",
                password = "Ehe131224",
                host = "localhost")

query <- dbGetQuery(con,"select * from source;")

sourcedf <- read.xlsx("tumor.anti.corr.uniqmetab.hmdbid.bc.xls",sheetIndex = 1)
sourcedf <- rbind(sourcedf,colnames(sourcedf))
sourcedf2 <- apply(sourcedf,1,gsub,pattern = "HMDB",replacement = "HMDB00")


result <- rampFastPathFromSource(sourceid = sourcedf2)
write.xlsx(result,"outputFromHMDBid.xlsx",sheetName = "sheet1",row.names = F)
id <- result$sourceId
length(unique(result$pathwayName))
length(unique(result$sourceId2))

df <- load("bofei.list.RData")


gene.list <- data.frame(gene.list)
metab.list <- data.frame(metab.list)

write.csv(metab.list,"metabolites_list.csv")
write.csv(gene.list,"gene_list.csv")


gene_list <- read.csv("gene_list.csv",stringsAsFactors = F,row.names = 1)
gene_list<- unique(gene_list)
pathways_gene <- rampFastPathFromMeta(gene_list)
pathways_gene <- pathways_gene[pathways_gene$type=="kegg",]
length(unique(pathways_gene[pathways_gene$type=="kegg",]$metabolite))

write.csv(pathways_gene,"pathwaysFromGeneList2.csv",row.names = F)
l#ast_result <- read.csv("pathwaysFromGeneList.csv")
#length(unique(last_result$metabolite))
pathways <- rampFastPathFromMeta(gene_list)
pathways2 <- pathways[pathways$type =="kegg",]

write.csv(pathways2,"pathwaysFromGeneList.csv")
length(unique(pathways2$metabolite))


meta_list <- read.csv("metabolites_list.csv",stringsAsFactors = F,row.names = 1)
meta_list <- as.data.frame(meta_list[1:260,])
pathways <- rampFastPathFromMeta(meta_list)
pathwayskegg <- pathways[pathways$type == "kegg",]
write.csv(pathwayskegg,"pathwayFromMetaList.csv")

meta_result <- read.csv("pathwayFromMetabolites_list.csv")
length(unique(meta_result$metabolite))


dataFromJalal <- load("bofei.fData.metab.RData")


df <- read.table("KEGGLinkPM.txt")
length(unique(df$V2))
