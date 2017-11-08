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
