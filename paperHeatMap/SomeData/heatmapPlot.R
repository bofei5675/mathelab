library(plotly)
library(magrittr)
webshot::install_phantomjs()
load("metabolites_gene_overlap.RData")
# metabolites pl
png()
dim(metabolite_result)
export(p_metabolites,"metablitesOverlap.png")
p_metabolites <- plot_ly(z = metabolite_result,
                         x = pathwayid,
                         y = pathwayid,
                         colors = c('#ece7f2','#2b8cbe'),
                         width = 1200,
                         height = 1200,
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
         )
  )
         # shapes = list(
         #   list(
         #     line = list(
         #       color = "#000000",
         #       width = 2
         #     ),
         #     type = "line",
         #     x0 = -0.05,
         #     x1 = 0,
         #     xref = "paper",
         #     y0 = 0.425,
         #     y1 = 0.425,
         #     yref = "paper"
         #   ),
           # list(
           #   line = list(
           #     color = "#000000",
           #     width = 2
           #   ),
           #   type = "line",
           #   x0 = 0.425,
           #   x1 = 0.425,
           #   xref = "paper",
           #   y0 = -0.05,
           #   y1 = 0,
           #   yref = "paper"
           # ),
           # list(
           #   line = list(
           #     color = "#000000",
           #     width = 2
           #   ),
           #   type = "line",
           #   x0 = -0.05,
           #   x1 = 0,
           #   xref = "paper",
           #   y0 = 0.53,
           #   y1 = 0.53,
           #   yref = "paper"
           # ),
           # list(
           #   line = list(
           #     color = "#000000",
           #     width = 2
           #   ),
           #   type = "line",
           #   x0 = 0.53,
           #   x1 = 0.53,
           #   xref = "paper",
           #   y0 = -0.05,
           #   y1 = 0,
           #   yref = "paper",
           #   color = "#000000"
           # ),
           # list(
           #   line = list(
           #     color = "#000000",
           #     width = 2
           #   ),
           #   type = "line",
           #   x0 = -0.05,
           #   x1 = 0,
           #   xref = "paper",
           #   y0 = 0.56,
           #   y1 = 0.56,
           #   yref = "paper"
           # ),
           # list(
           #   line = list(
           #     color = "#000000",
           #     width = 2
           #   ),
           #   type = "line",
           #   x0 = 0.56,
           #   x1 = 0.56,
           #   xref = "paper",
           #   y0 = -0.05,
           #   y1 = 0,
           #   yref = "paper"
           # )
         
  #)# %>%
  # add_annotations(x = 0.21,
  #                 y = -0.1,
  #                 text = "hmdb",
  #                 showarrow = FALSE,
  #                 xref = "paper",
  #                 yref = "paper",
  #                 font = list(
  #                   size = 36
  #                 )) %>%
  # add_annotations(x = -0.1,
  #                 y = 0.21,
  #                 text = "hmdb",
  #                 showarrow = FALSE,
  #                 xref = "paper",
  #                 yref = "paper",
  #                 font = list(
  #                   size = 36
  #                 )) %>%
  # add_annotations(x = -0.1,
  #                 y = 0.48,
  #                 text = "kegg",
  #                 showarrow = FALSE,
  #                 xref = "paper",
  #                 yref = "paper",
  #                 font = list(
  #                   size = 36
  #                 )) %>%
  # add_annotations(x = 0.48,
  #                 y = -0.1,
  #                 text = "kegg",
  #                 showarrow = FALSE,
  #                 xref = "paper",
  #                 yref = "paper",
  #                 font = list(
  #                   size = 36
  #                 )) %>%
  # add_annotations(x = -0.1,
  #                 y =  0.545,
  #                 text = "wiki",
  #                 showarrow = FALSE,
  #                 xref = "paper",
  #                 yref = "paper",
  #                 font = list(
  #                   size = 36
  #                 )) %>%
  # add_annotations(x = 0.545,
  #                 y = -0.1,
  #                 text = "wiki",
  #                 showarrow = FALSE,
  #                 xref = "paper",
  #                 yref = "paper",
  #                 font = list(
  #                   size = 36
  #                 )) %>%
  # add_annotations(x = -0.1,
  #                 y =  0.80,
  #                 text = "reac",
  #                 showarrow = FALSE,
  #                 xref = "paper",
  #                 yref = "paper",
  #                 font = list(
  #                   size = 36
  #                 )) %>%
  # add_annotations(x = 0.80,
  #                 y = -0.1,
  #                 text = "reac",
  #                 showarrow = FALSE,
  #                 xref = "paper",
  #                 yref = "paper",
  #                 font = list(
  #                   size = 36
  #                 )) 
p_metabolites
# Try to plot gene plot
p_genes <- plot_ly(z = gene_result,
                         x = pathwayidG,
                         y = pathwayidG,
                         width = 2000,
                         height = 2000,
                         colors = c('#ece7f2','#2b8cbe'),
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
         )
  )

p_genes
export(p_genes,"genesoverlap.png")