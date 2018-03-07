require(visNetwork, quietly = TRUE)
library(visNetwork)


query1="select * from catalyzed where rampCompoundId in ('RAMP_C_000000024','RAMP_C_000000212')";

con <- RaMP::connectToRaMP(dbname="mathelabramp",username="root",conpass="Ehe131224",
                     
                     host = "localhost")

df1 <- DBI::dbGetQuery(con,query1)

DBI::dbDisconnect(con)



colnames(df1)<-c("from","to")



colopts <-  RColorBrewer::brewer.pal(12,"Set3")

mycol=rep("black")

mysize<-rep(8,nrow(df1))

mynames<-rep(NA,nrow(df1))



myedges <- cbind(df1,mycol,mysize,mynames)



# Now set nodes

mynodes=unique(c(df1$from,df1$to))

mycol=mynodes

j=1

for (i in unique(mynodes)) {
  
  mycol[which(mycol==i)]=colopts[j]
  
  j=j+1
  
}

mysize <- rep(8,length(mynodes))

mynames <- mynodes



mynodes=data.frame(color=mycol,size=mysize,id=mynames,label=mynames)



# Now plot

visNetwork(mynodes, myedges, width = "100%")
