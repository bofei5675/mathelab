library(RMySQL)
source("helper.R")
setwd("~/Documents/Rproject/matheLab/paperHeatMap")
dbDisconnect(con)
con <- dbConnect(MySQL(),
                 user = 'root',
                 dbname='mathelabramp',
                 password = 'Ramp340!',
                 host = 'localhost')

pathways<- dbGetQuery(con,'select * from pathway;')
source <- dbGetQuery(con,'select * from source;')


dbname <- unique(pathways$type)

# pathwayInHmdb <- pathways[pathways$type == 'hmdb',]
pathwayInKegg <- pathways[pathways$type == 'kegg',]
pathwayInWiki <- pathways[pathways$type == 'wiki',]
pathwayInReac <- pathways[pathways$type == 'reactome',]

# define the minimum metabolites/genes
min_analyte <- 5

# Store Compound Ids in List
# listOfHmdbC <- findAnalyteHasPathway(pathwayInHmdb$pathwayRampId)
listOfKeggC <- findAnalyteHasPathway(pathwayInKegg$pathwayRampId,n = min_analyte)
listOfWikiC <- findAnalyteHasPathway(pathwayInWiki$pathwayRampId,n = min_analyte)
listOfReacC <- findAnalyteHasPathway(pathwayInReac$pathwayRampId,n = min_analyte)
# Store Gene Ids in List
# listOfHmdbG <- findAnalyteHasPathway(pathwayInHmdb$pathwayRampId,GC="G")
listOfKeggG <- findAnalyteHasPathway(pathwayInKegg$pathwayRampId,GC="G",n = min_analyte)
listOfWikiG <- findAnalyteHasPathway(pathwayInWiki$pathwayRampId,GC="G",n = min_analyte)
listOfReacG <- findAnalyteHasPathway(pathwayInReac$pathwayRampId,GC="G",n = min_analyte)
# Setup minimum number of analytes that will be considered

# May need to filter out that pathway that has less than 5 metabolites 
# Output to a matrix
# In order of HMDB Kegg Wiki Reac

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
metabolite_result2 <- compute_overlap_matrix(pathwayid = pathwayid,
                                             pathwaysWithAnalytes = pathToanalC,
                                             methods = 'weighted')

# Output to a matrix
### Part for genes ...
pathwayidG <- c(#names(listOfHmdbG),
               names(listOfKeggG),
               names(listOfWikiG),
               names(listOfReacG))



pathToanalG <- do.call(c,list(#listOfHmdbG,
                             listOfKeggG,
                             listOfWikiG,
                             listOfReacG))
# compute for matrix
gene_result <- compute_overlap_matrix(pathwayid = pathwayidG,pathToanalG,methods = 'balanced')
gene_result2 <- compute_overlap_matrix(pathwayid = pathwayidG,pathToanalG,methods = 'weighted')

