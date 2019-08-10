
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

lumen_bacterial_treat<- read_excel("Mucus_bacterial.xlsx")   

# Read the data into a data.frame
lumen_bacterial_4m<-lumen_bacterial_treat[1:6031,2:ncol(lumen_bacterial_treat)]
sample_4m <- seq(1, nrow(lumen_bacterial_4m), by=2)
lumen_bacterial_4m<-lumen_bacterial_4m[sample_4m,]
  
lumen_bacterial_12m<-lumen_bacterial_treat[6032:10000,2:ncol(lumen_bacterial_treat)]
lumen_bacterial<-rbind(lumen_bacterial_4m,lumen_bacterial_12m)

# species_name<-colnames(dynamic_data_bacterial)
min(lumen_bacterial_12m)
max(lumen_bacterial_12m)
colnames(lumen_bacterial)<-str_replace(colnames(lumen_bacterial),"L","")
colnames(lumen_bacterial)<-str_replace(colnames(lumen_bacterial),"Bacteroides_","B.")
colnames(lumen_bacterial)<-str_replace(colnames(lumen_bacterial),"Bifido_","B.")
colnames(lumen_bacterial)<-str_replace(colnames(lumen_bacterial),"Eubacterium_","E.")
colnames(lumen_bacterial)<-str_replace(colnames(lumen_bacterial),"Faecalibacterium_","F.")
colnames(lumen_bacterial)<-str_replace(colnames(lumen_bacterial),"Roseburia_","R.")
# a=cbind(Time$Time,lumen_bacterial$Eubacterium_hallii_L1,lumen_mets$BUTYRATE_L1)
bacteria_name<-colnames(lumen_bacterial)
max_size<-max(nchar(bacteria_name))
bacteria_name<-str_pad(bacteria_name, max_size, "right")
rownames(annotation_col_spc)=bacteria_name

label_name<-rep(c("I", "II", "III", "IV"), 8,fontsize=12,fontface=3)
annotation_row_bacteria = data.frame(
  Position=  factor(rep(c("I","II","III","IV"),8)),
  Species = factor(rep(c("B.THETA","B.FRAGILIS","B.LONGUM","B.BREVE","B.ADOLESCENTIS","E.HALLII","F.PRAUSNITZII",
                         "R.INTESTINALIS"), rep(4,8))))
annotation_row_bacteria_color=list(
  Position = c(I="#f28e98", II="#f2ecbf", III="#9ec475", IV="#ceb5e2"),
  Species = c(B.THETA="#b73276", B.FRAGILIS="#228fa0", B.LONGUM="#325780",B.BREVE="#3a8f62",B.ADOLESCENTIS="#b48939",
              E.HALLII="#ffcc42", F.PRAUSNITZII="#a65628",R.INTESTINALIS="#f781bf"))
rownames(annotation_row_bacteria)=bacteria_name


breaklist1<-c(seq(0,0.28,length=6),seq(0.28001,0.5,length=4),seq(0.5001,1,length=15),seq(1.0001,1.25,length=5),
              seq(1.25001,1.45,length=12),seq(1.45001,1.75,length=8),seq(1.75001,2,length=3))
# color_break<-colorRampPalette(jet.colors(21))(n=length(breaklist)-1)
color_break1<-colorRampPalette(c("#4d0033","#225ea8","#f8edb0","#fe9929","#e28114","#662506"))(n=length(breaklist1)-1)
color_break_78_8<-colorRampPalette(c("#0c5e4b","#25894d","#e6f4ec","#f4b96b","#f98643","#a5471c"))(n=length(breaklist1)-1)    # good!
color_break_78_51<-colorRampPalette(c("#0d73a2","#50abe0","#eaf5f9","#f4b96b","#f98643","#a5471c"))(n=length(breaklist1)-1)   

pdf("Bacteria_mucus-78_51.pdf",22,6)
Bac<-pheatmap(t(lumen_bacterial),
              fontsize=9,
              cluster_row = FALSE,cluster_cols = FALSE,
              color=color_break_78_51,
              breaks=breaklist1,
              # breaks=breaklist2,
              # color=col_dark,
              cellwidth = 0.2,cellheight = 11.9,
              # annotation_row = annotation_col_tank,
              # annotation_colors = ann_colors_tank,
              annotation_row = annotation_row_bacteria,
              annotation_colors = annotation_row_bacteria_color,
              annotation_names_col = FALSE,
              labels_row =label_name,
              fontsize_col = 7,
              show_colnames = FALSE,
              # gaps_row=c(4,8,12,16,20,24,28,32),
              # gaps_row=c(4,8,12,16,20),
              fontface=1)
dev.off()


Bac_4m<-pheatmap(t(lumen_bacterial_4m),
                 fontsize=9,
                 cluster_row = FALSE,cluster_cols = FALSE,
                 color=color_break_78_51,
                 breaks=breaklist1,
                 cellwidth = 0.13,cellheight = 11.9,
                 annotation_row = annotation_row_bacteria,
                 annotation_colors = annotation_row_bacteria_color,
                 labels_row =label_name,
                 
                 annotation_names_col = FALSE,
                 show_rownames = FALSE,
                 # gaps_row=c(4,8,12,16,20,24,28,32),
                 # gaps_row=c(4,8,12,16,20),
                 fontface=1, silent = TRUE)
# +theme(plot.margin=unit(c(1,0,0,0.3), "cm"))
# dev.off()

Bac_12m<-pheatmap(t(lumen_bacterial_12m),
                  fontsize=9,
                  cluster_row = FALSE,cluster_cols = FALSE,
                  color=color_break_78_51,
                  breaks=breaklist1,
                  # cellwidth = 0.2,cellheight = 8,
                  annotation_row = annotation_row_bacteria,
                  annotation_colors = annotation_row_bacteria_color,
                  cellwidth = 0.24,cellheight = 11.9,
                  labels_row =label_name,
                  
                  show_rownames = FALSE,
                  # gaps_row=c(4,8,12,16,20,24,28,32),
                  # gaps_row=c(4,8,12,16,20),
                  fontface=1, silent = TRUE
                  # legend=FALSE
)
# +theme(plot.margin=unit(c(1,0.3,0,1), "cm"))
a=list()
a[[1]]<-Bac_4m[[4]]
a[[2]]<-Bac_12m[[4]]
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

ggsave(g,filename="Bac_mucus_1116_78_51.pdf", width=70, height=20, units="cm")


pdf("Bacteria_mucus_1109_1.pdf",40,12)
Bac<-pheatmap(t(lumen_bacterial),
              fontsize=9,
              cluster_row = FALSE,cluster_cols = FALSE,
              color=color_break1,
              breaks=breaklist1,
              # color=color44_7,
              cellwidth = 0.1,cellheight = 8,
              show_rownames = FALSE,
              # gaps_row=c(4,8,12,16,20,24,28,32),
              # gaps_row=c(4,8,12,16,20),
              fontface=1, legend=FALSE)
dev.off()

# pdf("Bacteria_lumen_1107_2.pdf",40,18)
# pdf("Bacteria_lumen_1107_13.pdf",20,6)
Bac<-pheatmap(t(lumen_bacterial_4m),
                           fontsize=9,
                           cluster_row = FALSE,cluster_cols = FALSE,
                           color=color_break,
                           breaks=breaklist,
                           cellwidth = 0.1,cellheight = 8,
                           show_rownames = FALSE,
                           # gaps_row=c(4,8,12,16,20,24,28,32),
                           # gaps_row=c(4,8,12,16,20),
                           fontface=1, silent = TRUE, legend=FALSE)
# dev.off()

Bac_12m<-pheatmap(t(lumen_bacterial_12m),
                  fontsize=9,
                  cluster_row = FALSE,cluster_cols = FALSE,
                  color=color_break,
                  breaks=breaklist,
                  cellwidth = 0.2,cellheight = 8,
                  show_rownames = FALSE,
                  # gaps_row=c(4,8,12,16,20,24,28,32),
                  # gaps_row=c(4,8,12,16,20),
                  fontface=1, silent = TRUE, legend=FALSE)

a[[1]]<-Bac_4m[[4]]
a[[2]]<-Bac_12m[[4]]
# g<-do.call(grid.arrange,a,ncol=2)

# g<-grid.arrange(a[[1]],a[[2]],ncol=2)
g<-grid.arrange(grobs=a,ncol=2,width=3:7,
                heights=unit(c(3,3),c("cm","cm"))
                # layout_matrix=rbind(c(1,1),
                #                     c(2,2))
                )
g

# ggsave(g,filename="Bac_lumen.pdf", width=36, height=13, units="cm")








