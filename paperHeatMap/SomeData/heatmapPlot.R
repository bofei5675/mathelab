library(plotly)
webshot::install_phantomjs()
load("metabolites_gene_overlap.RData")
# metabolites pl
png()
export(p_metabolites,"metablitesOverlap.png")
p_metabolites <- plot_ly(z = metabolite_result,
                         x = pathwayid,
                         y = pathwayid,
                         #colors = colorRamp(c("blue","red")),
                         colorscale = "Greys",
                         width = 1500,
                         height = 1500,
                         type = "heatmap") %>%
  layout(title = "metabolites overlap",
         font = list(
           size = 40
         ),
         autosize = TRUE,
         margin = list(l = 150,
                       r = 100,
                       t = 100,
                       b = 200),
         xaxis = list(
           type = "category",
           autoticks = FALSE,
           ticks = "inside",
           showline = FALSE,
           zeroline = FALSE,
           showticklabels = FALSE,
           autorange = TRUE
         ),
         yaxis = list(
           type = "category",
           ticks = "inside",
           showline = FALSE,
           zeroline = FALSE,
           showticklabels =FALSE,
           autorange = TRUE
         ),
         shapes = list(
           list(
             line = list(
               color = "#000000",
               width = 2
             ),
             type = "line",
             x0 = -0.05,
             x1 = 0,
             xref = "paper",
             y0 = 0.425,
             y1 = 0.425,
             yref = "paper"
           ),
           list(
             line = list(
               color = "#000000",
               width = 2
             ),
             type = "line",
             x0 = 0.425,
             x1 = 0.425,
             xref = "paper",
             y0 = -0.05,
             y1 = 0,
             yref = "paper"
           ),
           list(
             line = list(
               color = "#000000",
               width = 2
             ),
             type = "line",
             x0 = -0.05,
             x1 = 0,
             xref = "paper",
             y0 = 0.53,
             y1 = 0.53,
             yref = "paper"
           ),
           list(
             line = list(
               color = "#000000",
               width = 2
             ),
             type = "line",
             x0 = 0.53,
             x1 = 0.53,
             xref = "paper",
             y0 = -0.05,
             y1 = 0,
             yref = "paper",
             color = "#000000"
           ),
           list(
             line = list(
               color = "#000000",
               width = 2
             ),
             type = "line",
             x0 = -0.05,
             x1 = 0,
             xref = "paper",
             y0 = 0.56,
             y1 = 0.56,
             yref = "paper"
           ),
           list(
             line = list(
               color = "#000000",
               width = 2
             ),
             type = "line",
             x0 = 0.56,
             x1 = 0.56,
             xref = "paper",
             y0 = -0.05,
             y1 = 0,
             yref = "paper"
           )
         )
  ) %>%
  add_annotations(x = 0.21,
                  y = -0.1,
                  text = "hmdb",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 36
                  )) %>%
  add_annotations(x = -0.1,
                  y = 0.21,
                  text = "hmdb",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 36
                  )) %>%
  add_annotations(x = -0.1,
                  y = 0.48,
                  text = "kegg",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 36
                  )) %>%
  add_annotations(x = 0.48,
                  y = -0.1,
                  text = "kegg",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 36
                  )) %>%
  add_annotations(x = -0.1,
                  y =  0.545,
                  text = "wiki",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 36
                  )) %>%
  add_annotations(x = 0.545,
                  y = -0.1,
                  text = "wiki",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 36
                  )) %>%
  add_annotations(x = -0.1,
                  y =  0.80,
                  text = "reac",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 36
                  )) %>%
  add_annotations(x = 0.80,
                  y = -0.1,
                  text = "reac",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 36
                  )) 
p_metabolites
# Try to plot gene plot
p_genes <- plot_ly(z = gene_result,
                         x = pathwayid,
                         y = pathwayid,
                         width = 1500,
                         height = 1500,
                         colorscale = "Greys",
                         type = "heatmap") %>%
  layout(title = "Genes overlap",
         font = list(
           size = 40
         ),
         autosize = TRUE,
         margin = list(l = 150,
                       r = 100,
                       t = 100,
                       b = 200),
         xaxis = list(
           type = "category",
           autoticks = FALSE,
           ticks = "inside",
           showline = FALSE,
           zeroline = FALSE,
           showticklabels = FALSE,
           autorange = TRUE
         ),
         yaxis = list(
           type = "category",
           ticks = "inside",
           showline = FALSE,
           zeroline = FALSE,
           showticklabels =FALSE,
           autorange = TRUE
         ),
         shapes = list(
           list(
             line = list(
               color = "#000000",
               width = 2
             ),
             type = "line",
             x0 = -0.05,
             x1 = 0,
             xref = "paper",
             y0 = 0.220,
             y1 = 0.220,
             yref = "paper"
           ),
           list(
             line = list(
               color = "#000000",
               width = 2
             ),
             type = "line",
             x0 = 0.220,
             x1 = 0.220,
             xref = "paper",
             y0 = -0.05,
             y1 = 0,
             yref = "paper"
           ),
           list(
             line = list(
               color = "#000000",
               width = 2
             ),
             type = "line",
             x0 = -0.05,
             x1 = 0,
             xref = "paper",
             y0 = 0.28,
             y1 = 0.28,
             yref = "paper"
           ),
           list(
             line = list(
               color = "#000000",
               width = 2
             ),
             type = "line",
             x0 = 0.28,
             x1 = 0.28,
             xref = "paper",
             y0 = -0.05,
             y1 = 0,
             yref = "paper"
           ),
           list(
             line = list(
               color = "#000000",
               width = 2
             ),
             type = "line",
             x0 = -0.05,
             x1 = 0,
             xref = "paper",
             y0 = 0.41,
             y1 = 0.41,
             yref = "paper"
           ),
           list(
             line = list(
               color = "#000000",
               width = 2
             ),
             type = "line",
             x0 = 0.41,
             x1 = 0.41,
             xref = "paper",
             y0 = -0.05,
             y1 = 0,
             yref = "paper"
           )
         )
  ) %>%
  add_annotations(x = 0.08,
                  y = -0.10,
                  text = "hmdb",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 30
                  )) %>%
  add_annotations(x = -0.10,
                  y = 0.08,
                  text = "hmdb",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 30
                  )
                  ) %>%
  add_annotations(x = -0.10,
                  y = 0.22,
                  text = "kegg",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 36
                  )) %>%
  add_annotations(x = 0.22,
                  y = -0.10,
                  text = "kegg",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 30
                  )) %>%
  add_annotations(x = -0.10,
                  y =  0.38,
                  text = "wiki",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 30
                  )) %>%
  add_annotations(x = 0.37,
                  y = -0.10,
                  text = "wiki",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 30
                  )) %>%
  add_annotations(x = -0.10,
                  y =  0.70,
                  text = "reac",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 30
                  )) %>%
  add_annotations(x = 0.70,
                  y = -0.10,
                  text = "reac",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper",
                  font = list(
                    size = 36
                  )) 
p_genes
export(p_genes,"genesoverlap.png")
# Try to plot single database comparing to all other databases ...
hmdbToOthers <- metabolite_result[,1:length(listOfHmdbC)]

hmdb_fig <- plot_ly(z = hmdbToOthers,
                    x = names(listOfHmdbC),
                    y = pathwayid,
                    width = 532,
                    height = 800,
                    type = "heatmap") %>%
  layout(title = "metabolites overlap",
         autosize = FALSE,
         margin = list(l = 100,
                       r = 100,
                       t = 100,
                       b = 200),
         xaxis = list(
           type = "category",
           autoticks = FALSE,
           ticks = "inside",
           showline = FALSE,
           zeroline = FALSE,
           showticklabels = FALSE,
           autorange = TRUE
         ),
         yaxis = list(
           type = "category",
           ticks = "inside",
           showline = FALSE,
           zeroline = FALSE,
           showticklabels =FALSE,
           autorange = TRUE
         ),
         shapes = list(
           list(
             line = list(
               color = "rgba(68,68,68,0.5)",
               width = 1
             ),
             type = "line",
             x0 = -0.05,
             x1 = 0,
             xref = "paper",
             y0 = 0.42,
             y1 = 0.42,
             yref = "paper"
           ),
           list(
             line = list(
               color = "rgba(68,68,68,0.5)",
               width = 1
             ),
             type = "line",
             x0 = -0.05,
             x1 = 0,
             xref = "paper",
             y0 = 0.53,
             y1 = 0.53,
             yref = "paper"
           ),
           list(
             line = list(
               color = "rgba(68,68,68,0.5)",
               width = 1
             ),
             type = "line",
             x0 = -0.05,
             x1 = 0,
             xref = "paper",
             y0 = 0.60,
             y1 = 0.60,
             yref = "paper"
           )
         )
  ) %>%
  add_annotations(x = 0.5,
                  y = -0.1,
                  text = "hmdb",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper") %>%
  add_annotations(x = -0.16,
                  y = 0.21,
                  text = "hmdb",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper") %>%
  add_annotations(x = -0.16,
                  y = 0.47,
                  text = "kegg",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper") %>%
  add_annotations(x = -0.16,
                  y =  0.58,
                  text = "wiki",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper") %>%
  add_annotations(x = -0.16,
                  y =  0.80,
                  text = "reac",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper")

hmdb_fig

# KEGG + WIKI 

keggToOthers <- metabolite_result[,(length(listOfHmdbC)+1):(length(listOfHmdbC)+length(listOfKeggC))]

kegg_fig <- plot_ly(z = keggToOthers,
                    x = names(listOfKeggC),
                    y = pathwayid,
                    width = 532,
                    height = 800,
                    type = "heatmap") %>%
  layout(title = "metabolites overlap",
         autosize = TRUE,
         margin = list(l = 100,
                       r = 100,
                       t = 100,
                       b = 100),
         xaxis = list(
           type = "category",
           autoticks = FALSE,
           ticks = "inside",
           showline = FALSE,
           zeroline = FALSE,
           showticklabels = FALSE,
           autorange = TRUE
         ),
         yaxis = list(
           type = "category",
           ticks = "inside",
           showline = FALSE,
           zeroline = FALSE,
           showticklabels =FALSE,
           autorange = TRUE
         ),
         shapes = list(
           list(
             line = list(
               color = "rgba(68,68,68,0.5)",
               width = 1
             ),
             type = "line",
             x0 = -0.05,
             x1 = 0,
             xref = "paper",
             y0 = 0.425,
             y1 = 0.425,
             yref = "paper"
           ),
           list(
             line = list(
               color = "rgba(68,68,68,0.5)",
               width = 1
             ),
             type = "line",
             x0 = -0.05,
             x1 = 0,
             xref = "paper",
             y0 = 0.53,
             y1 = 0.53,
             yref = "paper"
           ),
           list(
             line = list(
               color = "rgba(68,68,68,0.5)",
               width = 1
             ),
             type = "line",
             x0 = -0.05,
             x1 = 0,
             xref = "paper",
             y0 = 0.60,
             y1 = 0.60,
             yref = "paper"
           )
         )
  ) %>%
  add_annotations(x = 0.5,
                  y = -0.1,
                  text = "hmdb",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper") %>%
  add_annotations(x = -0.16,
                  y = 0.21,
                  text = "hmdb",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper") %>%
  add_annotations(x = -0.16,
                  y = 0.47,
                  text = "kegg",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper") %>%
  add_annotations(x = -0.16,
                  y =  0.58,
                  text = "wiki",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper") %>%
  add_annotations(x = -0.16,
                  y =  0.80,
                  text = "reac",
                  showarrow = FALSE,
                  xref = "paper",
                  yref = "paper")

kegg_fig
