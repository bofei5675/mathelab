con <- pool::dbPool(RMySQL::MySQL(),
                     dbname = 'biometrics',
                     username = 'root',
                     password = 'Ehe131224',
                     host = 'localhost')
tb <- dbGetQuery(con,'show tables;')
df <- dbGetQuery(con,'select * from subjects;')
df <- dbGetQuery(con,'select max(id) from subjects;')
df <- dbGetQuery(con,'select * from encoder_values;')
df <- getEncoderData()
max(df$id)

poolClose(con)

df <- rampFastCata('ATP',conpass = 'Ehe131224',dbname = 'mathelabramp',NameOrIds = 'names')
df <- rampFastCata('HMDB0000122',conpass = 'Ehe131224',dbname = 'mathelabramp',NameOrIds ='ids')
plotCataNetwork(df)

df <- rampFastCata(analytes = c('HMDB0000122','HMDBP00001'), conpass = 'Ehe131224',
                   dbname = 'mathelabramp')
# tab 5
df <- rampFastOntoFromMeta(analytes = c('Glucose','ATP'), conpass = 'Ehe131224',
                   dbname = 'mathelabramp',sourceOrName = 'name')

df <- rampFastOntoFromMeta(analytes = c('HMDB0000122','C00001'),
                           conpass = 'Ehe131224',dbname = 'mathelabramp')
df <- transform(df,sourceId =paste(IDtype,sourceId,sep = ':'))

df <- df[c('Metabolites','Ontology','biofluidORcellular','sourceId')]
df2.1 <- aggregate(df$sourceId,by = list(df$Metabolites),paste,
                collapse = ',')
df2 <- aggregate(.~Metabolites+biofluidORcellular,df,FUN = function(x){
  paste(unique(x),collapse = ',')
})
colnames(df2.1) <- c('Metabolites','sourceId')

df3 <- merge(df2,df[c('Metabolites','Ontology','biofluidORcellular')],by.x = 'Metabolites',by.y = 'Metabolites',all.x = T,all.y = T)
# ontology
df <- rampFastMetaFromOnto(c('Blood'),conpass = 'Ehe131224',dbname = 'mathelabramp')
