

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
## lumen bacterial data loading
lumen_bacterial_treat<- read_excel("lumen_bacterial_0-12m.xlsx")   
# Read the data into a data.frame
lumen_bacterial_4m<-lumen_bacterial_treat[1:6031,2:ncol(lumen_bacterial_treat)]
sample_4m <- seq(1, nrow(lumen_bacterial_4m), by=2)
lumen_bacterial_4m<-lumen_bacterial_4m[sample_4m,]
Time_4m<-lumen_bacterial_treat[1:6031,1]
Time_4m<-Time_4m[sample_4m,]
Time12m<-lumen_bacterial_treat[6032:10000,1]
Time<-rbind(Time_4m,Time12m)

lumen_bacterial_12m<-lumen_bacterial_treat[6032:10000,2:ncol(lumen_bacterial_treat)]

lumen_bacterial<-rbind(lumen_bacterial_4m,lumen_bacterial_12m)

colnames(lumen_bacterial)<-str_replace(colnames(lumen_bacterial),"L","")
colnames(lumen_bacterial)<-str_replace(colnames(lumen_bacterial),"Bacteroides_","B.")
colnames(lumen_bacterial)<-str_replace(colnames(lumen_bacterial),"Bifido_","B.")
colnames(lumen_bacterial)<-str_replace(colnames(lumen_bacterial),"Eubacterium_","E.")
colnames(lumen_bacterial)<-str_replace(colnames(lumen_bacterial),"Faecalibacterium_","F.")
colnames(lumen_bacterial)<-str_replace(colnames(lumen_bacterial),"Roseburia_","R.")
 a=cbind(Time$Time,lumen_bacterial$Eubacterium_hallii_L1,lumen_mets$BUTYRATE_L1)

# species_name<-colnames(dynamic_data_bacterial)
min(lumen_bacterial_12m)
max(lumen_bacterial_12m)
label_name<-rep(c("I", "II", "III", "IV"), 8,fontsize=12,fontface=3)
## annotation 1

color_8spc<-c(brewer.pal(n=8,"Dark2")[1:5],"#BC80BD", "#E6AB02", "#80B1D3")

annotation_col_bacteria = data.frame(
  Species = factor(rep(c("B.THETA","B.FRAGILIS","B.LONGUM","B.BREVE","B.ADOLESCENTIS","E.HALLII","F.PRAUSNITZII",
                         "R.INTESTINALIS"), rep(4,8))))
# ann_colors_bacteria = list(
#   Species = c(B.THETA="#b73276", B.FRAGILIS="#228fa0", B.LONGUM="#325780",B.BREVE="#3a8f62",B.ADOLESCENTIS="#b48939",
#               E.HALLII="#8f5360", F.PRAUSNITZII="#754577",R.INTESTINALIS="#a7624f"))
ann_colors_bacteria = list(
  Species = c(B.THETA=color_8spc[1], B.FRAGILIS=color_8spc[2], B.LONGUM=color_8spc[3],B.BREVE=color_8spc[4],B.ADOLESCENTIS=color_8spc[5],
              E.HALLII=color_8spc[6], F.PRAUSNITZII=color_8spc[7],R.INTESTINALIS=color_8spc[8]))
#8f5360", "#754577", "#a7624f
bacteria_name<-colnames(lumen_bacterial)
max_size<-max(nchar(bacteria_name))
bacteria_name<-str_pad(bacteria_name, max_size, "right")
rownames(annotation_col_spc)=bacteria_name

## annotation 2
annotation_col_tank = data.frame(
  Position = factor(rep(c("I","II","III","IV"),8)))

ann_colors_tank = list(
  Position = c(I="#c85252", II="#c1910b", III="#8ebc5d", IV="#a58bba"))
ann_colors_tank = list(
  Position = c(I="#f28e98", II="#f2ecbf", III="#9ec475", IV="#ceb5e2"))
rownames(annotation_col_tank)=bacteria_name

## one annotation do both annotation!!
annotation_row_bacteria = data.frame(
  Position=  factor(rep(c("I","II","III","IV"),8)),
  Species = factor(rep(c("B.THETA","B.FRAGILIS","B.LONGUM","B.BREVE","B.ADOLESCENTIS","E.HALLII","F.PRAUSNITZII",
                         "R.INTESTINALIS"), rep(4,8))))
# annotation_row_bacteria_color=list(
#   Position = c(I="#f28e98", II="#f2ecbf", III="#9ec475", IV="#ceb5e2"),
#   Species = c(B.THETA="#b73276", B.FRAGILIS="#228fa0", B.LONGUM="#325780",B.BREVE="#3a8f62",B.ADOLESCENTIS="#b48939",
#               E.HALLII="#8f5360", F.PRAUSNITZII="#754577",R.INTESTINALIS="#a7624f"
#               # E.HALLII="#ffcc42", F.PRAUSNITZII="#a65628",R.INTESTINALIS="#f781bf"
#               ))
annotation_row_bacteria_color=list(
  Position = c(I="#f28e98", II="#f2ecbf", III="#9ec475", IV="#ceb5e2"),
  Species = c(B.THETA=color_8spc[1], B.FRAGILIS=color_8spc[2], B.LONGUM=color_8spc[3],B.BREVE=color_8spc[4],B.ADOLESCENTIS=color_8spc[5],
              E.HALLII=color_8spc[6], F.PRAUSNITZII=color_8spc[7],R.INTESTINALIS=color_8spc[8]
              # E.HALLII="#ffcc42", F.PRAUSNITZII="#a65628",R.INTESTINALIS="#f781bf"
  ))
rownames(annotation_row_bacteria)=bacteria_name


# E.HALLII="#8f5360", F.PRAUSNITZII="#754577",R.INTESTINALIS="#a7624f"



# ann_colors_bacteria = list(
#   Species = c(B.THETA="#228fa0", B.FRAGILIS="#b73276", B.LONGUM="#b48939",B.BREVE="#3a8f62",B.ADOLESCENTIS="#325780",
#               E.HALLII="#8f5360", F.PRAUSNITZII="#754577",R.INTESTINALIS="#a7624f"))
col_8<-c("#BC80BD","#FDB462","#B3DE69","#FB8072","#8DD3C7","#FFFFB3","#80B1D3","#fecde4")


breaklist1<-c(seq(0,0.28,length=6),seq(0.28001,0.5,length=4),seq(0.5001,1,length=15),seq(1.0001,1.25,length=5),
              seq(1.25001,1.45,length=12),seq(1.45001,1.75,length=8),seq(1.75001,2,length=3))

breaklist2<-c(seq(0,0.28,length=8),seq(0.28001,0.5,length=6),seq(0.5001,1,length=12),seq(1.0001,1.25,length=4),
              seq(1.25001,1.45,length=8),seq(1.45001,1.75,length=9),seq(1.75001,2,length=6))
# color_break<-colorRampPalette(jet.colors(21))(n=length(breaklist)-1)
color_78<-colorRampPalette(c("#2397db","#f5f9f4","#f77a07"))(n=599)
color_78_1<-colorRampPalette(c("#2397db","#f5f9f4","#f75f07"))(n=599)  ## decide!!
color_78_2<-colorRampPalette(c("#187eba","#f5f9f4","#ce4f00"))(n=599)

color_break1<-colorRampPalette(c("#4d0033","#225ea8","#f8edb0","#fe9929","#e28114","#662506"))(n=length(breaklist1)-1)
color_break11<-colorRampPalette(c("#7570B3","#225ea8","#f8edb0","#fe9929","#e28114","#662506"))(n=length(breaklist1)-1)
color_break12<-colorRampPalette(c("#7570B3","#984ea3","#f8edb0","#fe9929","#e28114","#662506"))(n=length(breaklist1)-1)
color_break13<-colorRampPalette(c("#7570B3","#8e3e99","#fff6c6","#66c2a5","#225ea8","#08004d"))(n=length(breaklist1)-1)   
# color_break14<-colorRampPalette(c("#4d0033","#225ea8","#f8edb0","#7570B3","#8e3e99","#56061c"))(n=length(breaklist1)-1)   
color_break15<-colorRampPalette(c("#4d0033","#225ea8","#f8edb0","#fa9fb5","#f768a1","#ae017e"))(n=length(breaklist1)-1)   
color_break16<-colorRampPalette(c("#c994c7","#4d004b","#ffffe5","#fee391","#ec7014","#662506"))(n=length(breaklist1)-1)   
color_break161<-colorRampPalette(c("#8e3e99","#4d004b","#ffffe5","#fec44f","#cc4c02","#662506"))(n=length(breaklist1)-1)   
color_break162<-colorRampPalette(c("#4d004b","#8e3e99","#f8edb0","#fe9929","#e28114","#662506"))(n=length(breaklist1)-1)   
color_break163<-colorRampPalette(c("#093b6d","#5395cc","#f8edb0","#e59592","#96194f","#6b0b17"))(n=length(breaklist1)-1)   
color_break164<-colorRampPalette(c("#093b6d","#5395cc","#fff5f0","#e59592","#D95F02","#6b0b17"))(n=length(breaklist1)-1)   
color_break165<-colorRampPalette(c("#093b6d","#5395cc","#fff5f0","#fa9fb5","#dd3497","#7a0177"))(n=length(breaklist1)-1)   

color_break166<-colorRampPalette(c("#225ea8","#41b6c4","#f4f4f9","#c994c7","#df65b0","#980043"))(n=length(breaklist1)-1)  
color_break1671<-colorRampPalette(c("#225ea8","#41b6c4","#ece6ed","#edb4af","#e87b71","#d62f20"))(n=length(breaklist1)-1)   

color_break168<-colorRampPalette(c("#093b6d","#5395cc","#ece6ed","#efafaa","#e8665a","#a02419"))(n=length(breaklist1)-1)   
color_break169<-colorRampPalette(c("#093b6d","#5395cc","#f9f9f7","#f2d16a","#cc952f","#a02419"))(n=length(breaklist1)-1)   
color_break170<-colorRampPalette(c("#084c8c","#53b1cc","#e8efe8","#ddcf63","#e8aa19","#a02419"))(n=length(breaklist1)-1)   
color_break_78_1<-colorRampPalette(c("#115da0","#3fbdfc","#f2f4ef","#e29c9c","#fc7e3f","#e24006"))(n=length(breaklist1)-1)   
color_break_78_2<-colorRampPalette(c("#115da0","#3fbdfc","#f2f4ef","#e0b1a3","#f98643","#a5471c"))(n=length(breaklist1)-1)   
color_break_78_3<-colorRampPalette(c("#115da0","#5ccaf2","#f2f4ef","#edb195","#f98643","#a5471c"))(n=length(breaklist1)-1)    # ok!
color_break_78_4<-colorRampPalette(c("#115da0","#61b9ed","#f2f4ef","#f2b59d","#f98643","#a5471c"))(n=length(breaklist1)-1)   
color_break_78_5<-colorRampPalette(c("#115da0","#50abe0","#eaf5f9","#f4b96b","#f98643","#a5471c"))(n=length(breaklist1)-1)    # good!
color_break_78_6<-colorRampPalette(c("#115da0","#50abe0","#d3c9e2","#f4b96b","#f98643","#a5471c"))(n=length(breaklist1)-1)   
color_break_78_7<-colorRampPalette(c("#0c5e4b","#25894d","#d6e8ce","#f4b96b","#f98643","#a5471c"))(n=length(breaklist1)-1)   
color_break_78_8<-colorRampPalette(c("#0c5e4b","#25894d","#e6f4ec","#f4b96b","#f98643","#a5471c"))(n=length(breaklist1)-1)    # good!
color_break_78_51<-colorRampPalette(c("#0d73a2","#50abe0","#eaf5f9","#f4b96b","#f98643","#a5471c"))(n=length(breaklist1)-1)   
color_break_78_51m1<-colorRampPalette(c("#0d73a2","#50abe0","#eaf5f9","#f4b96b","#f7813d","#8c350c"))(n=length(breaklist1)-1)  
color_break_78_51m2<-colorRampPalette(c("#0d73a2","#50abe0","#eaf5f9","#f4b96b","#fc8b53","#8c3f0c"))(n=length(breaklist1)-1)   

# 

color_break2<-colorRampPalette(c("#aa0a52","#280414","#084c47","#fe9929","#e28114","#662506"))(n=length(breaklist1)-1)
color_break4<-colorRampPalette(c("#aa0a52","#280414","#08484c","#14ad70","#f7ffd3","#db8d0f"))(n=length(breaklist1)-1)

color_break3<-colorRampPalette(c("#aa0a52","#280414","#093b6d","#5395cc","#f9f9f7","#f2d16a","#db8d0f"))(n=length(breaklist1)-1)

color44_7 <- colorRampPalette(c("#093b6d","#5395cc","#f9f9f7","#f2d16a","#db8d0f"))(n = 599)
color44_71 <- colorRampPalette(c("#093b6d","#5395cc","#66c2a5","#f9f9f7","#f2d16a","#db8d0f","#664208"))(n = 599)
color44_72 <- colorRampPalette(c("#062051","#093b6d","#5395cc","#66c2a5","#f7ffe2","#f2d16a","#db8d0f"))(n = 599)
# col_1<-colorRampPalette(c("#2f2f30","#4b388c","#093b6d","#5395cc","#f9f9f7","#f2d16a","#db8d0f"))(n = 599)
col_2<-colorRampPalette(c("#2f2f30","#0570b0","#2f2560","#603b82","#f8f7f9","#9b4247","#80292e"))(n = 599)
col_3<-colorRampPalette(c("#0570b0","#2f2f30","#22186d","#593b91","#f8f7f9","#9b4247","#80292e"))(n = 599)
col_4<-colorRampPalette(c("#4b0082","#080c4f","#093b6d","#2a8de0","#f4fff9","#c6851b","#9b3c09"))(n = 599)
col_dark<-colorRampPalette(c("#7570B3","#5395cc","#1B9E77","#db8d0f","#D95F02"))(n = 599)
pdf("Bacteria_lumen_1119-78_51-0526.pdf",22,6)
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
                           # cellwidth = 0.1,cellheight = 8,
                           cellwidth = 0.13,cellheight = 11.9,
                           show_rownames = FALSE,
                           # gaps_row=c(4,8,12,16,20,24,28,32),
                           # gaps_row=c(4,8,12,16,20),
                           fontface=1, silent = TRUE, legend=FALSE)
                            # +theme(plot.margin=unit(c(1,0,0,0.3), "cm"))
# dev.off()

Bac_12m<-pheatmap(t(lumen_bacterial_12m),
                  fontsize=9,
                  cluster_row = FALSE,cluster_cols = FALSE,
                  color=color_break_78_51,
                  breaks=breaklist1,
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

# ggsave(g,filename="Fig_4b.pdf", width=70, height=17, units="cm")












