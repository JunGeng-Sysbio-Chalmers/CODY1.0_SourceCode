################################################################
# Name: figure2b_metabolic_capacity.R
# To-do: To draw heatmap of metabolic capacity of each individual bacteria in our community, 8 spc in total
# Author: Jun Geng
################################################################
#
################################
# step 1: import data
################################
# install.packages("rstudioapi")
library(rstudioapi) 
current_path <- getActiveDocumentContext()$path 
setwd(dirname(current_path ))

library(pheatmap)
filename <-"Individual_bacteria_metabolic_capacity.txt"
Spc_data <- read.table(filename, header=T, row.names=1, sep="\t", stringsAsFactors=T)
Species<-colnames(Spc_data)
Metabolites<-rownames(Spc_data)

##remove the dot between two words of each species's name
library(stringr)
new_Species<-str_replace(Species, "_"," ");
colnames(Spc_data)<-new_Species
## done!

annotation_col = data.frame(
  Phylum = factor(rep(c("Bacteroidetes", "Actinobacteria", "Firmicutes"), c(2, 3, 3)))
)
rownames(annotation_col) =new_Species   
ann_colors = list(
  Phylum = c(Bacteroidetes = "#b2abd2", Actinobacteria = "#fdae61", Firmicutes = "#74add1")
)

ann_colors = list(
  Phylum = c(Bacteroidetes = "#59b4d6", Actinobacteria = "#75ba64", Firmicutes = "#ed8325")
)

ann_colors = list(
  Phylum = c(Bacteroidetes = "#c2a5cf", Actinobacteria = "#fee090", Firmicutes = "#abd9e9")
)

 symbol_display=ifelse(Spc_data==-0.01,"#",ifelse(Spc_data==1.01,"+",ifelse(Spc_data!=0.01 || Spc_data!=1.01, "")))

fn=ifelse(Spc_data==-0.01,9,ifelse(Spc_data==1.01,11,ifelse(Spc_data!=0.01 || Spc_data!=1.01, 1)))
## Edit body of pheatmap:::draw_colnames, customizing it to your liking， to rotate colnames ##
library(grid)
draw_colnames_45 <- function (coln, ...) {
  m = length(coln)
  x = (1:m)/m - 1/2/m
  grid.text(coln, x = x, y = unit(0.96, "npc"), vjust = 0.5, 
            hjust = 1, rot =27, gp = gpar(...)) ## Was 'hjust=0' and 'rot=270'
}
assignInNamespace(x="draw_colnames", value="draw_colnames_45",
                  ns=asNamespace("pheatmap"))
## down!

library(grid)
draw_colnames_135 <- function (coln, ...) {
  m = length(coln)
  x = (1:m)/m - 1/2/m
  grid.text(coln, x = x, y = unit(0.96, "npc"), vjust = 0.5, 
            hjust = 1, rot =120, gp = gpar(...)) ## Was 'hjust=0' and 'rot=270'
}
assignInNamespace(x="draw_colnames", value="draw_colnames_45",
                  ns=asNamespace("pheatmap"))

col_8spc=colorRampPalette(c("#000000","#f7f7f7","#e58b57"))(n=599)

pdf("Idv_Spc_metabolic_Capacity.pdf",width = 8, height = 5)
pheatmap(Spc_data,cluster_row = FALSE,cluster_cols = FALSE,
         color=col_8spc,
         cellwidth = 15,cellheight = 15, 
         annotation_col = annotation_col,annotation_names_col=FALSE,
         annotation_colors = ann_colors,
         border_color="#f7f7f7",
         display_numbers = symbol_display,
         fontsize_number = fn,fontface_number=2
)
dev.off()


