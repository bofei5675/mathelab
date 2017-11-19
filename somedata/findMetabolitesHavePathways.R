library(RMySQL)
con <- dbConnect(MySQL(),
                 user = 'root',
                 dbname='mathelabramp',
                 password = 'Ramp340!',
                 host = 'localhost')


ramp_analyte <- dbGetQuery(con,"select * from analytehaspathway where rampId in (select rampId from analyte where type = 'hmdb');")

rampId <- unique(ramp_analyte$rampId)
cid <- rampId[grepl("RAMP_C_",rampId)]
gid <- rampId[grepl("RAMP_G_",rampId)]
meta_path <- data.frame(cid = NULL,numOfPath = NULL)
gene_path <- data.frame(gid = NULL,numOfPath = NULL)
# Get compounds id and all pathways
for (each in cid) {
  print(each)
  each2 <- shQuote(each)
  query <- paste0("select * from analytehaspathway where rampId = ",each2,";")
  pathway <- dbGetQuery(con,query)
  paths <- unique(pathway$pathwayRampId)
  meta_path <- rbind(meta_path,data.frame(cid = each,numOfPath = length(paths)))
}
# Get all genes id and all pathways ...

for (each in gid) {
  print(each)
  each2 <- shQuote(each)
  query <- paste0("select * from analytehaspathway where rampId = ",each2,";")
  pathway <- dbGetQuery(con,query)
  paths <- unique(pathway$pathwayRampId)
  gene_path <- rbind(gene_path,data.frame(gid = each,numOfPath = length(paths)))
}

max(meta_path$numOfPath)
min(meta_path$numOfPath)

max(gene_path$numOfPath)
min(gene_path$numOfPath)
# Making plot for metabolites:
nrow(meta_path[meta_path$numOfPath<5,])
nrow(meta_path[meta_path$numOfPath>=5 & meta_path$numOfPath<10,])
nrow(meta_path[meta_path$numOfPath>=10 & meta_path$numOfPath<15,])
nrow(meta_path[meta_path$numOfPath>=15 & meta_path$numOfPath<20,])
