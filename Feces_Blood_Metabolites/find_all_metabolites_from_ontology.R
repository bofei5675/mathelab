library(RMySQL)

con <- dbConnect(MySQL(),
                 username = 'root',
                 password = 'Ramp340!',
                 dbname = 'mathelabramp')

sql <- paste('select * from ontology;')

df <- dbGetQuery(con,sql)
target <- c('Feces' = 'RAMP_OL_000000014',
            'Plasma'= 'RAMP_OL_000000119',
            'Blood' = 'RAMP_OL_000000013')
ontology <- sapply(target, shQuote)
sql <- paste0('select * from analytehasontology where rampOntologyIdLocation in (',paste(ontology,
                                                                                         collapse = ','),
              ');')

rampid.df <- dbGetQuery(con,sql)

rampid <- unique(rampid.df$rampCompoundId)
rampid <- sapply(rampid, shQuote)
rampid <- paste0('select * from source where rampId in (',paste(rampid,collapse = ','),');')

sourceid.df <- dbGetQuery(con,rampid)

mdf <- merge(sourceid.df,rampid.df,by.x = 'rampId',by.y = 'rampCompoundId',all = T)
mdf <- mdf[c('sourceId','commonName','rampOntologyIdLocation')]
colnames(mdf) <- c('sourceId','Metabolites','ontologyId')
mdf <- merge(mdf,df,by.x = 'ontologyId',by.y = 'rampOntologyIdLocation',all = T)
colnames(mdf)
mdf <- mdf[c('sourceId','Metabolites','commonName')]
mdf <- mdf[rowSums(is.na(mdf)) == 0,]
mdf <- unique(mdf)
colnames(mdf) <- c('source_id','metabolites',
                   'ontology')
write.csv(mdf,file='metabolitesWithOntology.csv',row.names = F)

overlap.df <- aggregate(rampid.df$rampCompoundId,by = list(rampid.df$rampOntologyIdLocation),
                        FUN = paste)
overlap.df <- overlap.df[1:2,]
feces <- overlap.df[1,2][[1]]
blood <- overlap.df[2,2][[1]]
library(VennDiagram)
dev.new()
draw.pairwise.venn(area1 = length(unique(feces)),area2 = length(unique(blood)),
                   cross.area = length(unique(intersect(feces,blood))),
                   category = c('Feces','Blood'),ext.text = F,
                   col = c('blue','red'),
                   fill = c('blue','red'),
                   margin = c(0.1,0.1,0.1,0.1))
