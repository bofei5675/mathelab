library(xlsx)
options(stringsAsFactors = F)

microb <- read.csv("microb.csv")

microbName <- data.frame(microb[,1],stringsAsFactors = F)
names <- microbName[,1]

names[2]
dim(names)
class(names)
names <- sapply(names,strsplit,split = ";")
df <- data.frame()
for (name in names){
  name <- findLast(name)
  df <- rbind(df,name)
}
write.table(df,"microbes.txt",row.names = F,quote = F)
library(xlsx)
df2 <- read.xlsx("TAXIDfromlist.xlsx",1)

rawdf <- data.frame(microb = microbName, search = df)
colnames(rawdf) <- c("microb","search")
mdf <- merge(rawdf,df2,by.x = "search",by.y = "name")
mdf <- mdf[c("microb","search","preferred.name","taxid")]
final <- unique(mdf)
write.xlsx(final,"taxid.xlsx",row.names = F)
# str is a vector
findLast <- function(str){
  len <- length(str)
  while(len >0){
    name <- str[len]
    if(nchar(name) > 3){
      name <- gsub("\\[","",name)
      name <- gsub("\\]","",name)
      return(substring(name,4))
    }
    len <- len -1
  }
  return("Error here")
}

df <- read.xlsx("taxid.xlsx",1)
df2 <- df[is.na(df$preferred.name),]
df3 <- df2[!is.na(df$taxid),]
raw <- read.csv("microb.csv")
rawdf <- data.frame(raw[,1],stringsAsFactors = F)
colnames(rawdf) <- "microb"
rawdf$id <- 1:nrow(rawdf)
df4 <- merge(rawdf,df3,all.x = T)
n <- colnames(df4)
df4 <- df4[order(df4$id),]
df5 <- df4[c(n[1],n[5])]
df5 <- unique(df5)


write.csv(df5,"output.csv",row.names = F)
set1 <- raw$ID
set2 <- df4$microb
setdiff(set1,set2)

library(RMySQL)
meta <- read.csv("metabolites.csv",stringsAsFactors = F)
meta_order <- data.frame(metabolite = meta$ID, id = 1:nrow(meta))
meta_list <- meta$ID
con <- dbConnect(MySQL(),
                 dbname = "mathelabramp",
                 username="root",
                 host="localhost",
                 password="Ehe131224")
# First try
finalResult <- data.frame(row.names = F,stringsAsFactors = F)
item = 1
for (metabolite in meta_list){
  if(grepl("X_",metabolite)){
    next()
  }
  ex <- tolower(metabolite)
  print(item)
  print(paste("searching for",ex))
  pos = unlist(gregexpr("_",ex))
  if(pos[1] == 1){
    ex <- substring(ex,pos[1]+1)
  }
  query <- paste0("select * from analyteSynonym where synonym like '%",
                  ex,"%';")
  synonym <- dbGetQuery(con,query)
  if(nrow(synonym)<1){
    finalResult <- rbind(finalResult,data.frame(metabolite = metabolite,Synonym = NA,sourceId = NA))
    next()
  }
  sort_synonym <- synonym[order(nchar(synonym$Synonym)),]
  rampId <- unique(sort_synonym$rampId[1])
  rampId <- sapply(rampId,shQuote)
  rampId <- paste(rampId,collapse = ",")
  query2 <- paste0("select * from source where rampId in (",rampId,");")
  source <- dbGetQuery(con,query2)
  source <- source[source$IDtype=="hmdb",]
  if(nrow(source)<1){
    finalResult <- rbind(finalResult,data.frame(metabolite = metabolite,Synonym = NA,sourceId = NA))
    next()
  }
  df1 <- merge(source,sort_synonym,all.x = T)
  df1$metabolite <- metabolite
  order <- colnames(df1)
  df1 <- df1[,c(order[6],order[5],order[3])]
  print(df1)
  finalResult <- rbind(finalResult,df1)
  item <- item + 1

}

finaldf<- merge(finalResult,meta_order)
finaldf <- finaldf[!is.na(finaldf$sourceId),]
# secondary Find chebi 
df2 <- finaldf[is.na(finaldf$sourceId),]
meta_list <- df2$metabolite
item = 1
finalResult <- data.frame(stringsAsFactors = F,row.names = F)
for (metabolite in meta_list){
  ex <- tolower(metabolite)
  print(item)
  print(paste("searching for",ex))
  pos = unlist(gregexpr("_",ex))
  if(pos[1] == 1){
    ex <- substring(ex,pos[1]+1)
  }
  query <- paste0("select * from analyteSynonym where synonym like '%",
                  ex,"%';")
  synonym <- dbGetQuery(con,query)
  if(nrow(synonym)<1){
    finalResult <- rbind(finalResult,data.frame(metabolite = metabolite,Synonym = NA,sourceId = NA))
    next()
  }
  print("Find Synonym!")
  sort_synonym <- synonym[order(nchar(synonym$Synonym)),]
  rampId <- unique(sort_synonym$rampId[1:2])
  rampId <- sapply(rampId,shQuote)
  rampId <- paste(rampId,collapse = ",")
  query2 <- paste0("select * from source where rampId in (",rampId,");")
  source <- dbGetQuery(con,query2)
  source <- source[source$IDtype %in% c("hmdb","chebi"),]
  if(nrow(source)<1){
    finalResult <- rbind(finalResult,data.frame(metabolite = metabolite,Synonym = NA,sourceId = NA))
    next()
  }
  print("Find Source!!")
  df1 <- merge(source,sort_synonym,all.x = T)
  df1$metabolite <- metabolite
  order <- colnames(df1)
  df1 <- df1[,c(order[6],order[5],order[3])]
  print(df1)
  finalResult <- rbind(finalResult,df1)
  item <- item + 1
  
}

sdf <- unique(finalResult[,c(1,3)])

# Third try
df <- read.csv("metaboliteid.csv",stringsAsFactors = F)
df_nf <- df[is.na(df$sourceId),]
meta_list <- df_nf$metabolite
item = 1
finalResult <- data.frame(stringsAsFactors = F,row.names = F)
for (metabolite in meta_list){
  ex <- tolower(metabolite)
  print(item)
  print(paste("searching for",ex))
  pos = unlist(gregexpr("_",ex))
  #if(pos[1] == 1){
  #  ex <- substring(ex,pos[1]+1)
  #}
  if(length(pos) >2){
    ex <- substring(ex,pos[2]+1)
  }
  query <- paste0("select * from analyteSynonym where synonym like '%",
                  ex,"%';")
  synonym <- dbGetQuery(con,query)
  if(nrow(synonym)<1){
    finalResult <- rbind(finalResult,data.frame(metabolite = metabolite,Synonym = NA,sourceId = NA))
    next()
  }
  print("Find Synonym!")
  sort_synonym <- synonym[order(nchar(synonym$Synonym)),]
  rampId <- unique(sort_synonym$rampId[1])
  rampId <- sapply(rampId,shQuote)
  rampId <- paste(rampId,collapse = ",")
  query2 <- paste0("select * from source where rampId in (",rampId,");")
  source <- dbGetQuery(con,query2)
  source <- source[source$IDtype %in% c("hmdb","chebi"),]
  if(nrow(source)<1){
    finalResult <- rbind(finalResult,data.frame(metabolite = metabolite,Synonym = NA,sourceId = NA))
    next()
  }
  print("Find Source!!")
  df1 <- merge(source,sort_synonym,all.x = T)
  df1$metabolite <- metabolite
  order <- colnames(df1)
  df1 <- df1[,c(order[6],order[5],order[3])]
  print(df1)
  finalResult <- rbind(finalResult,df1)
  item <- item + 1
}

# Four try 
# Third try
df <- read.csv("metaboliteid.csv",stringsAsFactors = F)
df_nf <- df[is.na(df$hmdb)&is.na(df$chebi)&is.na(df$pubchem),]
meta_list <- df_nf$metabolite

finalResult <- data.frame(stringsAsFactors = F,row.names = F)
item <- 1

for (metabolite in meta_list){
  ex <- tolower(metabolite)
  ex <- unlist(strsplit(ex,"_"))
  ex <- ex[nchar(ex) == max(nchar(ex))]
  print(item)
  print(paste("searching for",ex))
  query <- paste0("select * from analyteSynonym where synonym like '%",
                  ex,"%';")
  synonym <- dbGetQuery(con,query)
  if(nrow(synonym)<1){
    finalResult <- rbind(finalResult,data.frame(metabolite = metabolite,Synonym = NA,sourceId = NA,IDtype = NA))
    next()
  }
  print("Find Synonym!")
  sort_synonym <- synonym[order(nchar(synonym$Synonym)),]
  rampId <- unique(sort_synonym$rampId[1])
  rampId <- sapply(rampId,shQuote)
  rampId <- paste(rampId,collapse = ",")
  query2 <- paste0("select * from source where rampId in (",rampId,");")
  source <- dbGetQuery(con,query2)
  source <- source[source$IDtype %in% c("hmdb","chebi","pubchem"),]
  if(nrow(source)<1){
    finalResult <- rbind(finalResult,data.frame(metabolite = metabolite,Synonym = NA,sourceId = NA,IDtype =NA))
    next()
  }
  print("Find Source!!")
  df1 <- merge(source,sort_synonym,all.x = T)
  df1$metabolite <- metabolite
  order <- colnames(df1)
  print(df1)
  df1 <- df1[,c(order[6],order[5],order[3],order[4])]
  
  finalResult <- rbind(finalResult,df1)
  item <- item + 1
}
meta_order <- data.frame(metabolite = df$metabolite, id = 1:nrow(df),stringsAsFactors = F)

df2 <- merge(meta_order,finalResult,all.y = T)
df2 <- df2[order(df2$id),]
df2 <- df2[!is.na(df2$sourceId),]
hmdb <- unique(df2[df2$IDtype == "hmdb",])
fidata <- df2[nchar(df2$metabolite)< nchar(df2$Synonym)+3,]
