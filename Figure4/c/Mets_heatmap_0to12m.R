

library(pheatmap)
library(RColorBrewer)
library(stringr)
library(standardize)
library(caret)
library(recommenderlab)
library(xlsx)
library(readxl)
library(gplots)
library(gridExtra)


lumen_mets_treat<-read_excel("lumen_mets_0-12m.xlsx")
lumen_mets_4m<-lumen_mets_treat[1:6031,2:ncol(lumen_mets_treat)]
sample_4m <- seq(1, nrow(lumen_mets_4m), by=2)
lumen_mets_4m<-lumen_mets_4m[sample_4m,]

lumen_mets_12m<-lumen_mets_treat[6032:10000,2:ncol(lumen_mets_treat)]
lumen_mets<-rbind(lumen_mets_4m,lumen_mets_12m)


# species_name<-colnames(dynamic_data_bacterial)
min(lumen_mets_12m)
max(lumen_mets_12m)

annotation_row_mets = data.frame(
  Position=  factor(rep(c("I","II","III","IV"),10)),
  Mets = factor(rep(c("MACs","Hex","Succ","Act","Prop","Lac","For",
                         "Eth","Buty","H2"), rep(4,10))))
annotation_row_mets_color=list(
  Position = c(I="#f28e98", II="#f2ecbf", III="#9ec475", IV="#ceb5e2"),
  Mets = c(MACs="#8C510A",Hex ="#D7883D",Succ = "#9A96BF", Act="#D7B988",Prop="#A5C7C1",Lac="#E7A5A6",
           For="#97A6CA", Eth="#668B9F",Buty="#D1E5F0",H2="#E7D4E8"))
rownames(annotation_row_mets)=colnames(lumen_mets)



breaklist1<-c(seq(0,0.28,length=6),seq(0.28001,0.5,length=4),seq(0.5001,1,length=15),seq(1.0001,1.25,length=5),
              seq(1.25001,1.45,length=12),seq(1.45001,1.75,length=8),seq(1.75001,2,length=3))
# color_break<-colorRampPalette(jet.colors(21))(n=length(breaklist)-1)
color_break1<-colorRampPalette(c("#4d0033","#225ea8","#f8edb0","#fe9929","#e28114","#662506"))(n=length(breaklist)-1)


color_break_78_51<-colorRampPalette(c("#0d73a2","#50abe0","#eaf5f9","#f4b96b","#f98643","#a5471c"))(n=length(breaklist1)-1)  
color_break_78_51m<-colorRampPalette(c("#0d73a2","#50abe0","#eaf5f9","#f4b96b","#f79742","#8c350c"))(n=length(breaklist1)-1)   
color_break_78_51m1<-colorRampPalette(c("#0d73a2","#50abe0","#eaf5f9","#f4b96b","#f7813d","#8c350c"))(n=length(breaklist1)-1)  
color_break_78_51m2<-colorRampPalette(c("#0d73a2","#50abe0","#eaf5f9","#f4b96b","#fc8b53","#8c3f0c"))(n=length(breaklist1)-1)   


color_break2<-colorRampPalette(c("#093b6d","#5395cc","#e3f2f1","#f2d16a","#ddae40","#db8d0f"))(n=length(breaklist1)-1)

pdf("Met_lumen_1115_nolog-78_51m2.pdf",22,9)
Bac<-pheatmap(t(lumen_mets),
              fontsize=9,
              cluster_row = FALSE,cluster_cols = FALSE,
              color=color_break_78_51m2,
              breaks=breaklist1,
              # breaks=breaklist2,
              # color=color44_7,
              cellwidth = 0.2,cellheight = 11.7,
              # annotation_row = annotation_col_tank,
              # annotation_colors = ann_colors_tank,
              annotation_row = annotation_row_mets,
              annotation_colors = annotation_row_mets_color,
              annotation_names_col = FALSE,
              labels_row =label_name,
              fontsize_col = 7,
              show_colnames = FALSE,
              # gaps_row=c(4,8,12,16,20,24,28,32),
              # gaps_row=c(4,8,12,16,20),
              fontface=1)
dev.off()


Met_4m<-pheatmap(t(lumen_mets_4m),
                 fontsize=9,
                 cluster_row = FALSE,cluster_cols = FALSE,
                 color=color_break_78_51m2,
                 breaks=breaklist1,
                 # cellwidth = 0.1,cellheight = 8,
                 annotation_row = annotation_row_mets,
                 annotation_colors = annotation_row_mets_color,
                 annotation_names_col = FALSE,
                 labels_row =label_name,
                 cellwidth = 0.13,cellheight = 11.9,
                 # show_rownames = FALSE,
                 # gaps_row=c(4,8,12,16,20,24,28,32),
                 # gaps_row=c(4,8,12,16,20),
                 fontface=1, silent = TRUE, legend=FALSE)
# +theme(plot.margin=unit(c(1,0,0,0.3), "cm"))
# dev.off()

Met_12m<-pheatmap(t(lumen_mets_12m),
                  fontsize=9,
                  cluster_row = FALSE,cluster_cols = FALSE,
                  color=color_break_78_51m2,
                  breaks=breaklist1,
                  annotation_row = annotation_row_mets,
                  annotation_colors = annotation_row_mets_color,
                  annotation_names_col = FALSE,
                  labels_row =label_name,
                  # cellwidth = 0.2,cellheight = 8,
                  cellwidth = 0.24,cellheight = 11.9,
                  show_rownames = FALSE,
                  # gaps_row=c(4,8,12,16,20,24,28,32),
                  # gaps_row=c(4,8,12,16,20),
                  fontface=1, silent = TRUE
                  # legend=FALSE
)
# +theme(plot.margin=unit(c(1,0.3,0,1), "cm"))
a=list()
a[[1]]<-Met_4m[[4]]
a[[2]]<-Met_12m[[4]]
# g<-do.call(grid.arrange,a,ncol=2)

# g<-grid.arrange(a[[1]],a[[2]],ncol=2)
g<-grid.arrange(grobs=a,
                ncol=2,
                width=2:7,
                heights=unit(c(3,3),c("cm","cm"))
                # layout_matrix=rbind(c(1,1,NA,NA,NA,NA,NA,NA,NA),
                #                     c(NA,NA,2,2,2,2,2,2,2))
                # top = NULL,
)
g

# ggsave(g,filename="Fig_4c.pdf", width=80, height=30, units="cm")






