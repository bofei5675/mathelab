library(RMySQL)
source("helper.R")
con <- dbConnect(MySQL(),
                 dbname ="mathelabramp",
                 host ="localhost",
                 password = "Ehe131224",
                 username = "root")
hmdb <- read.table("HMDBmetabolitesIds.txt")
kegg <- read.table("KEGGmetabolitesIds.txt")
wiki <- read.table("WIKImetabolitesIds.txt")
reac <- read.table("REACmetabolitesIds.txt")

query <- "select * from analytehaspathway;"
analyteHasPathway <- dbGetQuery(con,query)
rampIdHasPathway <- unique(analyteHasPathway$rampId)
# Find all unique metabolites from each database
rampIdForHMDB <- finderPathways(hmdb,rampIdHasPathway)
rampIdForKEGG <- finderPathways(kegg,rampIdHasPathway)
rampIdForWIKI <- finderPathways(wiki,rampIdHasPathway)
rampIdForREAC <- finderPathways(reac,rampIdHasPathway)
# Find how many metabolites for each metabolites

pathwaysForHMDB <- finderPathways2(rampIdForHMDB)
resultHMDB <- finderPathways3(pathwaysForHMDB)

pathwaysForKEGG <- finderPathways2(rampIdForKEGG)
resultKEGG <- finderPathways3(pathwaysForKEGG)

pathwaysForWIKI <- finderPathways2(rampIdForWIKI)
resultWIKI <- finderPathways3(pathwaysForWIKI)

pathwaysForREAC <- finderPathways2(rampIdForREAC)
resultREAC <- finderPathways3(pathwaysForREAC)



nrow(resultHMDB[resultHMDB$totpathways == 1,])
nrow(resultKEGG[resultKEGG$totpathways == 1,])
nrow(resultWIKI[resultWIKI$totpathways == 1,])
nrow(resultREAC[resultREAC$totpathways == 1,])
oneHmdb <- resultHMDB[resultHMDB$totpathways == 1,]
oneKegg <- resultKEGG[resultKEGG$totpathways == 1,]
oneWiki <- resultWIKI[resultWIKI$totpathways == 1,]
oneReac <- resultREAC[resultREAC$totpathways == 1,]
together <- c(as.character(oneHmdb$metabolites),
              as.character(oneKegg$metabolites),
              as.character(oneWiki$metabolites),
              as.character(oneReac$metabolites))
together <- unique(together)
plot.data <- list()
plot.data[[1]] <- plot.hmdb
plot.data[[2]] <- plot.kegg
plot.data[[3]] <- plot.wiki
plot.data[[4]] <- plot.reac
for(i in 1:4){
  rampId <- as.character(unique(plot.data[[i]]$metabolites))
  rampId <- sapply(rampId,shQuote)
  rampId <- paste(rampId,collapse = ",")
  query <- paste("select * from analytesynonym where rampId in(",rampId,") group by rampId;")
  synonymdf1 <- dbGetQuery(con,query)
  plot.data[[i]] <- merge(plot.data[[i]],synonymdf1[,1:2],by.x = "metabolites",by.y="rampId")
}
database <- c("hmdb",'kegg','wiki','reactome')
for(i in 1:4){
  plot.data[[i]] <- plot.data[[i]][order(plot.data[[i]]$totpathways,decreasing = T),]
}
for(i in 1:4){
  write.csv(plot.data[[i]],
            file = paste0(database[i],"promiscuous.csv"),
            row.names = F)
}
View(plot.data[[3]])
