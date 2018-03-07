library(RMySQL)
setwd("~/RProject/matheLab/paperBarPlot/Bar")
source("helper.R")
con <- dbConnect(MySQL(),
                 dbname ="mathelabramp",
                 host ="localhost",
                 password = "Ehe131224",
                 username = "root")
# Read all source id from Python output
hmdb <- read.table('data/hmdbmetaboliteIDDictionary.txt')
kegg <- read.table("data/keggmetaboliteIDDictionary.txt")
wiki <- read.table("data/wikimetaboliteIDDictionary.txt")
reac <- read.table("data/reactomemetaboliteIDDictionary.txt")

# Use unique ID in the first column to search
hmdb <- data.frame(V1 = as.character(unique(hmdb$V1)))
kegg <- data.frame(V1 = as.character(unique(kegg$V1)))
wiki <- data.frame(V1 = as.character(unique(wiki$V1)))
reac <- data.frame(V1 = as.character(unique(reac$V1)))

query <- "select * from analytehaspathway;"
analyteHasPathway <- unique(dbGetQuery(con,query))


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
# General conditions
nrow(resultHMDB[resultHMDB$hmdb != 0,])
?which
