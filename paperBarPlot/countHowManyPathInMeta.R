library(RMySQL)
source("helper.R")
con <- dbConnect(MySQL(),
                 dbname ="mathelabramp",
                 host ="localhost",
                 password = "Ehe131224",
                 username = "root")
hmdb <- read.table("data/HMDBmetabolitesIds.txt")
kegg <- read.table("data/KEGGmetabolitesIds.txt")
wiki <- read.table("data/WIKImetabolitesIds.txt")
reac <- read.table("data/REACmetabolitesIds.txt")

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


# Find synonyms and source ids 
hmdbrampId <- finderSynonymAndSource(rampIdForHMDB,
                                     db = "hmdb")

# Try melt them 
library(reshape2)
df <- melt(hmdbrampId, id.vars = "rampId",
           measure.vars = c("sourceId"))
df <- unique(df)
# Show number of metabolites that only has one pathway
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

