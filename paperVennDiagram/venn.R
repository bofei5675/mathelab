source('fourVenn.R')
value <- c(7298,5702,11035,8026,73,89,3090,4214,303,508,65,5,277,3,3)
value <- c(1512,10870,650,375,915,69,58,195,136,30,257,27,30,251,513)
length(value)

gene <- fourVenn(value[1],
                 value[2],
                 value[3],
                 value[4],
                 value[5],
                 value[6],
                 value[7],
                 value[8],
                 value[9],
                 value[10],
                 value[11],
                 value[12],
                 value[13],
                 value[14],
                 value[15],
                 type = 'gene')

gene
metabolite <- fourVenn(value[1],
                 value[2],
                 value[3],
                 value[4],
                 value[5],
                 value[6],
                 value[7],
                 value[8],
                 value[9],
                 value[10],
                 value[11],
                 value[12],
                 value[13],
                 value[14],
                 value[15],
                 type = 'metabolite')
metabolite
