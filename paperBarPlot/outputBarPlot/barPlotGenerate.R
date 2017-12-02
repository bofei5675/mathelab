library(plotly)

plot.hmdb <- resultHMDB[order(resultHMDB$totpathways,decreasing = T),]
m <- list(
  l = 100,
  r = 100,
  t = 100,
  b = 100
)
h <- 1000
w <- 1000
p_hmdb <- plot_ly(x = 1:length(plot.hmdb$totpathways),
                  y = plot.hmdb$totpathways,
                  type = "bar",
                  height = h,
                  width = w) %>%
  layout(title = "HMDB metabolites vs. Pathways",
         margin = m,
         font = list(
           size = 24
         ),
         yaxis = list(
           title = "Number of pathways metabolites are involved in",
           font = list(
             size = 24
           )
         ),
         xaxis = list(
           title = "Total 2508 unique metabolites have pathways",
           showticklabels = FALSE,
           font = list(
             size = 24
           )
         ))
for(i in 1:5){
  df <- plot.data[[1]]
  p_hmdb <- p_hmdb %>%
    add_annotations(
                  text = df$Synonym[i],
                  x = i,
                  y = df$totpathways[i],
                  ax = 20,
                  ay = 20,
                  xanchor = "left",
                  yanchor = "bottom"
  )
}

p_hmdb

plot.kegg <- resultKEGG[order(resultKEGG$totpathways,decreasing = T),]
p_kegg <- plot_ly(x = 1:length(plot.kegg$totpathways),
                  y = plot.kegg$totpathways,
                  type = "bar",
                  height = h,
                  width = w) %>%
  layout(title = "KEGG metabolites vs. Pathways",
         margin = m,
         font = list(
           size = 24
         ),
         yaxis = list(
           title = "Numbers of pathways metabolites are involved in",
           font = list(
             size = 24
           )
         ),
         xaxis = list(
           title = "Total 3115 unique metabolites have pathways",
           showticklabels = FALSE,
           font = list(
             size = 24
           )
         )) 

for(i in 1:5){
  df <- plot.data[[2]]
  p_kegg <- p_kegg %>%
    add_annotations(
      text = df$Synonym[i],
      x = i,
      y = df$totpathways[i],
      ax = 20,
      ay = 20,
      xanchor = "left",
      yanchor = "bottom"
    )
}
p_kegg

plot.wiki <- resultWIKI[order(resultWIKI$totpathways,decreasing = T),]
p_wiki <- plot_ly(x = 1:length(plot.wiki$totpathways),
                  y = plot.wiki$totpathways,
                  type = "bar",
                  height = h,
                  width = w) %>%
  layout(title = "Wikipathways metabolites vs. Pathways",
         margin = m,
         font = list(
           size = 24
         ),
         yaxis = list(
           title = "Numbers of pathways metabolites are involved in",
           font = list(
             size = 24
           )
         ),
         xaxis = list(
           title = "Total 1236 unique metabolites have pathways",
           showticklabels = FALSE,
           font = list(
             size = 24
           )
         )) 
for(i in 1:5){
  df <- plot.data[[3]]
  p_wiki <- p_wiki %>%
    add_annotations(
      text = df$Synonym[i],
      x = i,
      y = df$totpathways[i],
      ax = 20,
      ay = 20,
      xanchor = "left",
      yanchor = "bottom"
    )
}


p_wiki

plot.reac <- resultREAC[order(resultREAC$totpathways,decreasing = T),]
p_reac <- plot_ly(x = 1:length(plot.reac$totpathways),
                  y = plot.reac$totpathways,
                  type = "bar",
                  height = h,
                  width = w) %>%
  layout(title = "Reactome metabolites vs. Pathways",
         margin = m,
         font = list(
           size = 24
         ),
         yaxis = list(
           title = "Numbers of pathways metabolites are involved in",
           font = list(
             size = 24
           )
         ),
         xaxis = list(
           title = "Total 1781 unique metabolites have pathways",
           showticklabels = FALSE,
           font = list(
             size = 24
           )
         ))
for(i in 1:5){
  df <- plot.data[[4]]
  p_reac <- p_reac %>%
    add_annotations(
      text = df$Synonym[i],
      x = i,
      y = df$totpathways[i],
      ax = 20,
      ay = 20,
      xanchor = "left",
      yanchor = "bottom"
    )
}

p_reac

export(p_hmdb,"hmdbMetabolitesPathways.png")
export(p_kegg,"keggMetabolitesPathways.png")
export(p_wiki,"wikiMetabolitesPathways.png")
export(p_reac,"reacMetabolitesPathways.png")
