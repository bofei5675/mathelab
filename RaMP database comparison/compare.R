

df <- read.table('SMPDB.txt')
df2 <- read.table('hmdbmetabolitesWithSynonymsDictionary.txt',fill = T
                  )
smpidfromhmdb <- df2$V1[grepl('SMP',df2$V1)]
smpidfromsmp <- as.vector(df$V1)

length(unique(df2$V1))


library(plotly)

plot_ly(mtcars,x= ~mpg,y = ~cyl,type ='scatter')

plot_ly(x = mtcars['mpg'],y = mtcars$cyl,type = 'scatter')
mtcars['mpg']
plot_ly(x = c(1,2,3),y = c(2,4,6),type = 'scatter')

typeof(unlist(mtcars['mpg']))
