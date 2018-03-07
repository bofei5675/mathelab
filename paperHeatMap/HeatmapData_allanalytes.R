library(RMySQL)
source("helper.R")
setwd("~/RProject/matheLab/paperHeatMap")
dbDisconnect(con)
con <- dbConnect(MySQL(),
                 user = 'root',
                 dbname='mathelabramp',
                 password = 'Ehe131224',
                 host = 'localhost')

pathways<- dbGetQuery(con,'select * from pathway;')



dbname <- unique(pathways$type)

# pathwayInHmdb <- pathways[pathways$type == 'hmdb',]
pathwayInKegg <- pathways[pathways$type == 'kegg',]
pathwayInWiki <- pathways[pathways$type == 'wiki',]
pathwayInReac <- pathways[pathways$type == 'reactome',]

# define the minimum metabolites/genes
min_analyte <- 10

# Store Compound Ids in List
# listOfHmdbC <- findAnalyteHasPathway(pathwayInHmdb$pathwayRampId)
listOfKeggC <- findAnalyteHasPathway(pathwayInKegg$pathwayRampId,GC = 'both',n = min_analyte)
listOfWikiC <- findAnalyteHasPathway(pathwayInWiki$pathwayRampId,GC = 'both',n = min_analyte)
listOfReacC <- findAnalyteHasPathway(pathwayInReac$pathwayRampId,GC = 'both',n = min_analyte)

pathwayid <- c(#names(listOfHmdbC),
                names(listOfKeggC),
                names(listOfWikiC),
                names(listOfReacC))

pathToanalC <- do.call(c,list(#listOfHmdbC,
                              listOfKeggC,
                              listOfWikiC,
                              listOfReacC))
metabolite_result <- compute_overlap_matrix(pathwayid = pathwayid,
                                            pathwaysWithAnalytes =  pathToanalC,
                                            methods = 'balanced')
