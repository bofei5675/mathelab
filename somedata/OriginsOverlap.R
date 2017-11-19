library(RMySQL)
library(VennDiagram)
con <- dbConnect(
  drv = RMySQL::MySQL(),
  dbname = "mathelabramp",
  username = "root",
  password = "Ehe131224"
)
check <- dbGetQuery(con,"select * from ontologyhasorigin where origin = 'Drug or steroid metabolite';")
origin <- dbGetQuery(con,"select * from ontologyhasorigin;")
sourceId <- origin$sourceId
origins <- origin$origin
origins <- gsub("Drug ","Drug",origins)
origins <- gsub("Micorbial","Microbial",origins)
origins <- gsub("Drugor steroid metabolite","Drug or steroid metabolite",origins)
origins
print(unique(origins))
list_origins <- unique(origins)
tb <- table(origins[origins %in% list_origins])


df <- data.frame(tb)
origin$origin <- origins
print(length(unique(sourceId)))
length(unique(sourceId))
list_origins
id_list <- list()
for (item in list_origins){
  id_list[[item]] <- origin[origin$origin == item,1]   
}
list_origins
class(id_list$Endogenous)
length(id_list$Endogenous)
length(id_list$Food)
length(intersect(id_list$Endogenous,id_list$Food))
Reduce(intersect,list(id_list$Endogenous,id_list$Food))
Reduce(intersect,id_list[1:2])
combination <- expand.grid(names(id_list),names(id_list))
combination <- combn(names(id_list),1)
combination <- list()
overlap_possible <- data.frame(condition = character(),overlap = numeric())
for(i in 1:length(names(id_list))){
  combination[[i]] <- combn(names(id_list),i) 
  print(class(combination[[i]]))
}
combination[[2]]
names(id_list)
id_list[c("Drug","Food")]
for(item in combination){
  for(i in 1:ncol(item)){
    pair <- item[,i]
    numOfitem <- length(pair)
    overlapCondition <- Reduce(intersect,id_list[pair])
    print(length(overlapCondition))
    if(length(overlapCondition) >0){
      df <- data.frame(condition = paste(pair,collapse = " vs. "),
                       overlap = length(overlapCondition))
      overlap_possible <- rbind(overlap_possible,df)
    }
  }
}
write.csv(overlap_possible,"OriginsOverlap.csv",row.names = F)
overlap_possible<- overlap_possible[order(overlap_possible$overlap,decreasing = T),]
vennOverlap <- function(listOfOrigins){
  
}