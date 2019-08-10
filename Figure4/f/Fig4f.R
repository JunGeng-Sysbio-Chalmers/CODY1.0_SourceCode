################################################################
# Name: 02_plot_PCA.R
# To-do: plot a matrix
# Date: 07-01-2018
# Author: Boyang JI, boyangji@gmail.com | boyang.ji@chalmers.se
################################################################
#
################################
# step 1: load related packages
################################

library(dplyr)
library(corrplot)

library(ggcorrplot)
library(RColorBrewer)

library(ggsci)
library(ggpubr)

library(ComplexHeatmap)
library(extrafont)
fonts()

library(devtools)
install_github("vqv/ggbiplot")
library(ggbiplot)



matrix_file <- "TS_Data_top10_Lumen_Mucosa_Rectum_pca.csv"
matrix_data <- read.csv(matrix_file, header = T)

matrix_data <- matrix_data[, 2:3]
colnames(matrix_data) <- c("PC1", "PC2")

# matrix_data.pca <- prcomp(matrix_data[,-1], center = TRUE,scale. = TRUE)
# # PC<-mtcars.pca$x
# matrix_data <- PC[, 1:2]
# colnames(matrix_data) <- c("PC1", "PC2")

# ggbiplot(matrix_data.pca, choices = 1:2, obs.scale = 1, var.scale = 1,
#          groups = matrix_data$location, ellipse = TRUE, ellipse.prob = 0.68, 
#          circle = TRUE
#          , var.axes = F,
#          colour=location, fill=location
#          ) +
#   scale_color_discrete(name = '') +
#   scale_fill_manual(values=c("#01a037",  "#1384a7","#a8431e", "#f2e74b", "#1b764a", "#e2a053","#97e3ef" , "#eff1f2","#f4f4ef")) +
#   theme(legend.direction = 'horizontal', legend.position = 'top')
# # look for ggbiplot function and take the ellipse caculation part, redo 

matrix_data$group <- c(rep("0-4 months Lumen", 20), rep("0-4 months Mucosa", 20),rep("0-4 months Feces", 5), rep("4-12 months Lumen", 32), rep("4-12 months Mucosa", 32) , rep("4-12 months Feces", 8))
matrix_data$group <- factor(matrix_data$group, levels = c("0-4 months Lumen", "4-12 months Lumen", "0-4 months Feces"  ,"0-4 months Mucosa", "4-12 months Mucosa" , "4-12 months Feces"))

matrix_data$location <- c(rep("lumen", 20), rep("mucosa", 20), rep("feces", 5), rep("lumen", 32), rep("mucosa", 32) , rep("feces", 8))
# position<-rep()
matrix_data$location <- factor(matrix_data$location)

matrix_data$time <- c(rep("0-4 months", 45), rep("4-12 months",72))
matrix_data$time <- factor(matrix_data$time)

matrix_data_2 <- matrix_data
matrix_data_2 <- matrix_data_2 %>% filter((!(location=="mucosa" & (PC1>0.8))) & (!(location=="mucosa" & (PC2>0.4)))  )
# matrix_data_2 <- matrix_data_2 %>% filter((!(location=="lumen" & (PC1<-0.1))))
# remove one points

# function to draw ellipse
veganCovEllipse<-function (cov,l, center = c(0, 0), scale = 2, npoints = 100) 
{
  if(l=="mucosa"){
    scale=3.5
  } 
  else if(l=="feces"){
    scale=3.25
  }
  else if(l=="lumen"){
    scale=2
  }
  theta <- (0:npoints) * 2 * pi/npoints
  Circle <- cbind(cos(theta), sin(theta))
  t(center + scale * t(Circle %*% chol(cov)))
}

data_ellipse <- data.frame()

for (l in levels(matrix_data_2$location)) {
  data_ellipse <- rbind(data_ellipse, cbind(
    as.data.frame(with(
      matrix_data_2[matrix_data_2$location == l, ],
      veganCovEllipse(cov.wt(cbind(PC1, PC2), wt = rep(1 / length(PC1), length(PC1)))$cov,l=l,center = c(mean(PC1), mean(PC2)))
    ))
    , location = l
  ))
}


pdf("pca_no_legend.pdf", width = 2.17, height = 2.1, onefile=FALSE)

print(pca_plot_no_legend <- ggplot(matrix_data) +
  geom_hline(yintercept = 0, linetype = "dashed", size=0.25, color="#b6b2af") +     ##636363
  geom_vline(xintercept = 0, linetype = "dashed", size=0.25, color="#b6b2af") +
  geom_polygon(data=data_ellipse, aes(x=PC1, y=PC2,colour=location, fill=location), size=0.25, linetype=1, alpha=0.5)+
    # , fill="gray95"    ,fill=location
  geom_point(
    aes(
      x = PC1,
      y = PC2,
      shape = time,
      # shape = group,
      fill = group
      # colour=group
    ),
    # colour="#404040",
    colour="#575757",
        # size = 1.25,
    size = 1.6,stroke=0.15,
    show.legend = T,
    alpha = 0.95
  ) +
  # scale_shape_manual(values=c(19,24,25,15)) +
    # scale_shape_manual(values=c(22,24)) +
    scale_shape_manual(values=c(21,25)) +
    # scale_shape_manual(values=c(21,1)) +
    
  # scale_x_continuous(limits = c(-2, 2.2), expand = c(0, 0)) +
  # scale_y_continuous(limits = c(-1, 1.1), expand = c(0, 0)) +
    scale_x_continuous(limits = c(-1.7, 1.8), expand = c(0, 0)) +
    scale_y_continuous(limits = c(-0.6, 0.8), expand = c(0, 0), breaks=c(-0.5, 0, 0.5)) +
  # scale_color_manual(values=c("#C8C8C8", "#C8C8C8")) +
    # scale_color_manual(values=c("white", "white")) +
    # scale_color_manual(values=c("#90933d","#e0a494")) +    ## add circle line
    # scale_color_manual(values=c("#A6CEE3","#4fb0dc","#e0a494")) +    ## add circle line
    # scale_color_manual(values=c("#666666","#A6CEE3","#DECBE4")) +    ## add circle line
    # scale_color_manual(values=c("#FFED6F","#80B1D3","#E7298A", "#A6761D", "#1384a7","#7570B3","#666666","#A6CEE3","#e0a494")) +    ## add circle line
    # scale_color_manual(values=c("#FFED6F","#80B1D3","#E7298A", "#A6761D", "#1b764a","#7570B3","#666666","#A6CEE3","#e0a494")) +    ## add circle line
    # scale_color_manual(values=c("#A6761D","#80B1D3","#E7298A", "#f2e74b", "#1384a7","#7570B3","#666666","#A6CEE3","#e0a494")) +    ## 1207
    scale_color_manual(values=c("#666666","#A6CEE3","#F4CAE4")) +    ## 1206
     # e0a494
    # scale_fill_manual(values=c("#f1e53b", "#c36031", "#1b764a", "#1384a7","#eff1f2","#f4f4ef")) +
    # scale_fill_manual(values=c("#f1e53b", "#c36031","#e2a053" ,"#1b764a", "#1384a7","#eff1f2","#f4f4ef","#4fb0dc","#f9dbe2")) +
    # scale_fill_manual(values=c("#01a037",  "#1384a7","#a8431e", "#f2e74b", "#1b764a", "#e2a053","#97e3ef" , "#eff1f2","#f4f4ef")) +
    ## 0-4feces, lumen, mucus, 4-12 feces, lumen, mucus, fill circle
    # scale_fill_manual(values=c( "#FFED6F","#D95F02","#E7298A", "#A6761D", "#80B1D3","#7570B3", "#97e3ef" , "#eff1f2","#f4f4ef")) +
    # scale_fill_manual(values=c( "#FFED6F","#80B1D3","#E7298A", "#A6761D", "#1b764a","#7570B3", "#97e3ef" , "#eff1f2","#f4f4ef")) +
    # scale_fill_manual(values=c( "#A6761D",  "#80B1D3","#E7298A","#f2e74b","#1384a7","#984EA3", "#97e3ef" , "#eff1f2","#f4f4ef")) +  ## 1207
    # scale_fill_manual(values=c( "#826012",  "#3dc5f7","#E7298A","#f2e74b","#1b764a","#640d70", "#97e3ef" , "#eff1f2","#f4f4ef")) +  ## 1207
    scale_fill_manual(values=c( "#D95F02",  "#1384a7","#E7298A","#f2e74b","#1b764a","#984EA3", "#eff2e3" , "#eff1f2","#f4f4ef")) +  ## 1207
    
      #   18706b   13635e   158799 1b764a  
  # bf1a6e
  # 0f6d51
  # 640d70  430d70   E31A1C
    
    # orange: dc6731;  yellow:f1e53b, fcf346, f2ec30 ; red: f9373f,931d22,9d5354,992027,c36031
    
  # purple:cd87f9 ;  blue: 14a3df,28beed,39ace5,38a2ff,1384a7;  green: 0a8049
    
  # "#2171b5",blue; "#e31a1c",red; "#33a02c",green; "#fdbf6f",orange; "#84bbd3",blue-circle; "#fb9a99",peach-circle
  #scale_fill_manual(name="", values=c("#5AAE61", "#e31a1c", "#8163A9", "#fdbf6f")) +
  # 5AAE61-green; e31a1c-red; 8163A9-velvet; fdbf6f-orange; 84bbd3-blue; fb9a99-pink
  # scale_fill_manual(name="", values=c("#5AAE61", "#e31a1c", "#8163A9", "#fdbf6f", "#84bbd3", "#fb9a99")) +
  xlab("PC1 (78.4%)") +
  ylab("PC2 (7.7%)") +

  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_rect(
      colour = "#5e5e5e",
      fill = NA,
      size = 0.21
    ),
    axis.ticks.length=unit(-0.07, "cm"),
    axis.ticks = element_line(size = 0.25),
    # axis.ticks.margin=unit(0.5, "cm"),    ## ticker inside
    # panel.border = element_blank(), 
    axis.line = element_line(colour = "#5e5e5e", size=0.045),
    panel.background = element_rect(fill = "transparent", colour = NA),
    text = element_text(size = 7, family = "Helvetica"),
    legend.position = "none",
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.box.background = element_rect(),
    legend.key = element_rect(fill = "transparent", colour = "transparent"),
    legend.key.height = unit(0.6, "line"),
    legend.title = element_blank(),
    legend.text = element_text(size = 8),
    legend.margin = margin(0, 2, 0, -1),
    plot.background = element_rect(fill = "transparent", colour = NA)
  ))

dev.off()

## plot with legend

pdf("pca_legend.pdf", width = 5, height = 4, onefile=FALSE)
print(pca_plot_no_legend <- ggplot(matrix_data) +
        geom_hline(yintercept = 0, linetype = "dashed", size=0.25, color="#b6b2af") +     ##636363
        geom_vline(xintercept = 0, linetype = "dashed", size=0.25, color="#b6b2af") +
        geom_polygon(data=data_ellipse, aes(x=PC1, y=PC2,colour=location, fill=location), size=0.25, linetype=1, alpha=0.5,show.legend = FALSE)+
        # , fill="gray95"    ,fill=location
        geom_point(
          aes(
            x = PC1,
            y = PC2,
            shape = time,
            # shape = group,
            fill = group
            # colour=group
          ),
          colour="#404040",
          # size = 1.25,
          # size = 1.3,stroke=0.25,
          size = 1.6,stroke=0.15,
          
          show.legend = T,
          alpha = 0.95
        ) +
        # scale_shape_manual(values=c(19,24,25,15)) +
        # scale_shape_manual(values=c(22,24)) +
        scale_shape_manual(values=c(21,25)) +
        
        scale_x_continuous(limits = c(-2, 2.2), expand = c(0, 0)) +
        scale_y_continuous(limits = c(-1, 1.1), expand = c(0, 0)) +
        # scale_color_manual(values=c("#C8C8C8", "#C8C8C8")) +
        # scale_color_manual(values=c("#aa44ea", "#ed1e28",  "#44d3ff", "#ffd80a","white", "white")) +
        # scale_color_manual(values=c("white", "white")) +
        # scale_color_manual(values=c("#90933d","#e2682f")) +    ## add circle line
        scale_color_manual(values=c("#666666","#A6CEE3","#F4CAE4")) +    ## 1206
        
        
        # scale_fill_manual(values=c("#238b45", "#4eb3d3", "#e31a1c", "#fdbf6f")) +
        # scale_fill_manual(values=c("#0c6028", "#ff2923", "#6bf0ff", "#ffdd28","#daecf2","#fbe2d2")) +
        # scale_fill_manual(values=c("#0c6028", "#ff2923", "#6bf0ff", "#ffdd28","#eaf3f7","#ead9d3")) +
        # scale_fill_manual(values=c("#aa44ea", "#ed1e28", "#44d3ff", "#ffd80a","#e3ebef","#f7e6de")) +
        # scale_fill_manual(values=c("#14a3df", "#931d22", "#1b764a", "#fcf346 931d22","#e3ebef","#f7e6de")) +
        # scale_fill_manual(values=c("#14a3df", "#f1e53b", "#1b764a", "#f9373f","#eff1f2","#f4f4ef")) +
        # scale_fill_manual(values=c("#f1e53b", "#c36031", "#1b764a", "#1384a7","#eff1f2","#f4f4ef")) +
        scale_fill_manual(values=c( "#D95F02",  "#1384a7","#E7298A","#f2e74b","#1b764a","#984EA3", "#eff2e3" , "#eff1f2","#f4f4ef")) +  ## 1207
        
        # orange: dc6731;  yellow:f1e53b, fcf346, f2ec30 ; red: f9373f,931d22,9d5354,992027,c36031
        
        # purple:cd87f9 ;  blue: 14a3df,28beed,39ace5,38a2ff,1384a7;  green: 0a8049
        
        # "#2171b5",blue; "#e31a1c",red; "#33a02c",green; "#fdbf6f",orange; "#84bbd3",blue-circle; "#fb9a99",peach-circle
        #scale_fill_manual(name="", values=c("#5AAE61", "#e31a1c", "#8163A9", "#fdbf6f")) +
        # 5AAE61-green; e31a1c-red; 8163A9-velvet; fdbf6f-orange; 84bbd3-blue; fb9a99-pink
        # scale_fill_manual(name="", values=c("#5AAE61", "#e31a1c", "#8163A9", "#fdbf6f", "#84bbd3", "#fb9a99")) +
        xlab("PC1 (89.0%)") +
        ylab("PC2 (4.6%)") +
theme(
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  panel.border = element_rect(
    colour = "black",
    fill = NA,
    size = 0.5
  ),
  panel.background = element_rect(fill = "transparent", colour = NA),
  text = element_text(size = 10, family = "Arial"),
  legend.position="bottom", 
  legend.box = "vertical",
  legend.background = element_blank(),
  #legend.key = element_blank(),
  #legend.position = c(.9, .9)
  #legend.justification = c("right", "top"),
  #legend.box.just = "right",
  #legend.box.background = element_blank(),
  legend.key = element_rect(fill = NA, colour=NA),
  #legend.key.height = unit(0.6, "line"),
  legend.title = element_blank()
  #legend.text = element_text(size = 6),
  #legend.margin = margin(0, 2, 0, -1)
))

dev.off()



