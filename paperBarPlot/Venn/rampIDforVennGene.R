setwd("~/RProject/matheLab/paperBarPlot/Venn")
library(RMySQL)
source("helper.R")
source("fourVenn.R")

con <- dbConnect(MySQL(),
                 dbname ="mathelabramp",
                 host ="localhost",
                 password = "Ehe131224",
                 username = "root")
# Find source ID from each database
hmdb <- dbGetQuery(con,"select sourceId from source where IDtype = 'hmdb';")
hmdb <- data.frame(V1 = as.character(hmdb$sourceId[grepl("HMDBP",hmdb$sourceId)]))

colnames(hmdb)[1] <- "V1"

kegg <- read.table("dataG/keggGenesID.txt")
wiki <- read.table("dataG/wikiGenesId.txt")
wiki$V1 <- as.character(wiki$V1)
wiki$V1 <- sapply("HMDB",gsub,replacement = "HMDB00",x = wiki$V1)

reac <- read.table("dataG/reactomeGenesId.txt")
# Find ramp Id that has at least one pathway
query <- "select * from analytehaspathway;"
analyteHasPathway <- unique(dbGetQuery(con,query))


rampIdHasPathway <- unique(analyteHasPathway$rampId)


# Find ramp Id from each database
rampIdForHMDB <- finderPathways(hmdb,rampIdHasPathway,F)
rampIdForKEGG <- finderPathways(kegg,rampIdHasPathway,F)
rampIdForWIKI <- finderPathways(wiki,rampIdHasPathway,F)
rampIdForREAC <- finderPathways(reac,rampIdHasPathway,F)
# Find overlap .
# each database
keggnum <- length(rampIdForKEGG)
hmdbnum <- length(rampIdForHMDB)
wikinum <- length(rampIdForWIKI)
reacnum <- length(rampIdForREAC)
# Two overlap
khnum <- length(intersect(rampIdForHMDB,rampIdForKEGG))
krnum <- length(intersect(rampIdForREAC,rampIdForKEGG))
kwnum <- length(intersect(rampIdForWIKI,rampIdForKEGG))
hrnum <- length(intersect(rampIdForHMDB,rampIdForREAC))
hwnum <- length(intersect(rampIdForHMDB,rampIdForWIKI))
rwnum <- length(intersect(rampIdForREAC,rampIdForWIKI))
# Three overlap
khrnum <- length(Reduce(intersect,list(rampIdForKEGG,rampIdForHMDB,rampIdForREAC)))
krwnum <- length(Reduce(intersect,list(rampIdForKEGG,rampIdForREAC,rampIdForWIKI)))
khwnum <- length(Reduce(intersect,list(rampIdForKEGG,rampIdForHMDB,rampIdForWIKI)))
hrwnum <- length(Reduce(intersect,list(rampIdForHMDB,rampIdForREAC,rampIdForWIKI)))
# Four overlap 
khrwnum <- length(Reduce(intersect,list(rampIdForHMDB,rampIdForKEGG,rampIdForREAC,rampIdForWIKI)))


# Define the types of rampID
type <- "genes"

# fourVenn Diagram

fourVenn(kegg = keggnum,
         hmdb = hmdbnum,
         reactome = reacnum,
         wiki = wikinum,
         kh = khnum,
         kr = krnum,
         kw = kwnum,
         hr = hrnum,
         hw = hwnum,
         rw = rwnum,
         khr = khrnum,
         krw = krwnum,
         hrw = hrwnum,
         khw = khwnum,
         khrw = khrwnum,
         type = type)
dbDisconnect(con)
