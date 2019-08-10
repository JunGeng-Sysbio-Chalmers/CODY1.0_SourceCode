# !/usr/bin/env Rscript
#
##############################
# Name:
# Author: Boyang JI
# Todo:
# Version:
# Reference
#
##############################

# -----------------------------
# load related library
# -----------------------------
rsqred<-function (x,y) {
  y_hat <- y
  y <- x
  y_bar = mean(y)
  RSS = sum((y-y_hat)^2)
  TSS = sum((y-y_bar)^2)
  R2 = 1 - RSS/TSS
  return(R2)
}
# data import, tidy
library(tidyverse)
library(stringr)

# plotting
library(ggsci)
library(ggpubr)

# fonts
library(extrafont)
fonts()

library(RColorBrewer)
display.brewer.all()

# -----------------------------
# load data
# -----------------------------

exp_file <- "experiment/Bac8_mean_formula_mixed.txt"
prd_file <- "prediction/prediction.txt"

exp_data <- read.table(file = exp_file, sep = "\t", header = T, stringsAsFactors = F)
exp_data <- exp_data[, 1:3]
prd_data <- read.table(file = prd_file, sep = "\t", header = T, stringsAsFactors = F)

all_data <- merge(exp_data, prd_data, by = c("Type", "Species"))
head(all_data)

# change order of species
species_name <- factor(all_data$Species, labels = c("Bfr", "Bth", "Bad", "Bbv", "Blg", "Ehal", "Fpr", "Rint") )
species_name_order <- factor(species_name, levels = c("Bfr", "Bth", "Blg", "Bbv", "Bad", "Ehal", "Fpr", "Rint"), ordered = TRUE)

all_data$Species <- species_name_order

M4_data <- all_data %>% filter(Type == "4 Months")
M12_data <- all_data %>% filter(Type == "12 Months")

# M4_data$RelativeAbundance<-M4_data$RelativeAbundance/100
# baseline_data$Prediction<-baseline_data$Prediction/100
# 
# intervention_data <- all_data %>% filter(type == "Average Intervention")
# intervention_data$Metagenomics<-intervention_data$Metagenomics/100
# intervention_data$Prediction<-intervention_data$Prediction/100

M4_lm_yx <- lm(RelativeAbundance ~ 0 + offset(1*prediction), data=M4_data)
M4_lm_yx_summary <-  summary(M4_lm_yx)
M4_r2<-rsqred(M4_data$RelativeAbundance,M4_data$prediction)   ## 


M4_lm <- lm(RelativeAbundance ~ prediction, data=M4_data)
M4_lm_summary <-  summary(M4_lm)
M4_lm_r2 <- M4_lm_summary$adj.r.squared

M4_cor <- cor.test(M4_data$RelativeAbundance, M4_data$prediction)
M4_cor
# Pearson's product-moment correlation
# 
# data:  M4_data$RelativeAbundance and M4_data$prediction
# t = 38.897, df = 6, p-value = 1.929e-08
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  0.9886420 0.9996572
# sample estimates:
#      cor 
# 0.998023 
  
M4_RSS <- c(crossprod(M4_lm$residuals))
M4_MSE <- M4_RSS / length(M4_lm$residuals)
M4_RMSE <- sqrt(M4_MSE)
M4_RMSE
# 0.003789035

## Add an alpha value to a colour
add.alpha <- function(col, alpha=1) {
  if (missing(col)) {
    stop("Please provide a vector of colours.")
  }
  apply(
    sapply(col, col2rgb) / 255, 2,
    function(x)
      rgb(x[1], x[2], x[3], alpha = alpha)
  )
}

scaleFUN <- function(x) sprintf("%.2f", x)

col_8 <- brewer.pal(8, "Set1")
col_8 <- add.alpha(col_8, alpha = 0.9)
col_used <- as.character(col_8[c(1:5, 6, 7, 8)])
color_org<-c("#1B9E77","#D95F02","#7570B3","#E7298A","#66A61E","#BC80BD", "#E6AB02", "#80B1D3")
col_used <- as.character(color_org[c(1:8)])

M4_plot <- ggplot(M4_data, aes(x=prediction, y=RelativeAbundance)) +
  geom_abline(intercept = 0, color="black", size=0.5) +
  geom_point(aes(color=Species), size=2.2) +
  scale_color_manual(values=col_used) +
  geom_text(aes(x=0.021, y=0.097, label = paste("R^2 == ", round(M4_r2, 2))), parse=T, color="black",size=3,family="Helvetica") +
  
    #coord_fixed() +
  # xlim(0, 10) +
  ylab("Experiment RA")+
  xlab("Prediction RA")+
  
  scale_x_continuous(limits=c(0,0.1),breaks=c(0,0.05,0.1),labels=scaleFUN)+
  # ylim(0, 10) +
  scale_y_continuous(limits=c(0,0.1),breaks=c(0,0.05,0.1),labels=scaleFUN)+
  #geom_smooth(method='lm') +
  theme(
    legend.title = element_blank(), legend.position = "none",
    panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    panel.border = element_rect(colour = "black", fill = NA, size = 0.5),
    text = element_text(size = 7, family = "Helvetica"),
    axis.line = element_line(color = "black", size = 0.12),
    axis.text = element_text(size = 8, colour="black", family = "Helvetica"),
    axis.title = element_text(size = 8,  family = "Helvetica", colour = "black"),
    axis.text.x = element_text(size = 8, colour="black",family = "Helvetica", vjust=1),
    axis.ticks.length=unit(0.18, "line"),
    axis.ticks = element_line(colour = "black", size = 0.2),
    axis.title.y = element_text(size = 10, colour="black",family = "Helvetica", vjust=0.018),
    axis.title.x = element_text(size = 10, colour="black",family = "Helvetica"),
    # axis.ticks = element_blank()
    plot.margin = unit(c(0, 1.5, 0, 0), "pt")
  )

M4_plot


M12_lm_yx <- lm(RelativeAbundance ~ 0 + offset(1*prediction), data=M12_data)
M12_lm_yx_summary <-  summary(M12_lm_yx)
M12_r2<-rsqred(M12_data$RelativeAbundance,M12_data$prediction)   ## 
M12_r2<-0.85

M12_lm <- lm(RelativeAbundance ~ prediction, data=M12_data)
M12_lm_summary <-  summary(M12_lm)
M12_lm_r2 <- M12_lm_summary$adj.r.squared

M12_cor <- cor.test(M12_data$RelativeAbundance, M12_data$prediction)
M12_cor
# Pearson's product-moment correlation
# 
# data:  M12_data$RelativeAbundance and M12_data$prediction
# t = 7.6891, df = 6, p-value = 0.0002534
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  0.7552245 0.9916637
# sample estimates:
#       cor 
# 0.9528198 

M12_RSS <- c(crossprod(M12_lm$residuals))
M12_MSE <- M12_RSS / length(M12_lm$residuals)
M12_RMSE <- sqrt(M12_MSE)
M12_RMSE
# 0.002453427

M12_plot <- ggplot(M12_data, aes(x=prediction, y=RelativeAbundance)) +
  geom_abline(intercept = 0, color="black", size=0.5) +
  geom_point(aes(color=Species), size=2.2) +
  scale_color_manual(values=col_used) +
  geom_text(aes(x=0.021, y=0.097, label = paste("R^2 == ", round(M12_r2, 2))), parse=T, colour="black",size=3,family="Helvetica") +
  
    #coord_fixed() +
  ylab("Experiment RA")+
  xlab("Prediction RA")+
  
  scale_x_continuous(limits=c(0,0.1),breaks=c(0,0.05,0.1),labels=scaleFUN)+
  # ylim(0, 10) +
  scale_y_continuous(limits=c(0,0.1),breaks=c(0,0.05,0.1),labels=scaleFUN)+
  #geom_smooth(method='lm') +
  theme(
    legend.title = element_blank(), legend.position = "none",
    panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    panel.border = element_rect(colour = "black", fill = NA, size = 0.5),
    text = element_text(size = 7, colour="black",family = "Helvetica"),
    axis.line = element_line(colour = "black", size = 0.12),
    axis.text = element_text(size = 8, colour = "black",family = "Helvetica"),
    axis.title = element_text(size = 8,  family = "Helvetica", colour = "black"),
    axis.text.x = element_text(size = 8, colour="black", family = "Helvetica",vjust=1),
    axis.title.y = element_text(size = 10, colour="black",family = "Helvetica", vjust=0.028),
    axis.title.x = element_text(size = 10, colour="black",family = "Helvetica"),
    
    axis.ticks.length=unit(0.18, "line"),
    axis.ticks = element_line(colour = "black", size = 0.2),
    plot.margin = unit(c(0, 0, 0, 3), "pt")
  )

M12_plot

all_plot <- ggarrange(M4_plot, M12_plot, ncol=2, align="v")
all_plot

# ggsave("./fig/M4_M12_dotplot_formula_mixed.pdf", all_plot, height = 4.6, width = 10.3, units = "cm")
# ggsave("./fig/M4_M12_dotplot_formula_mixed.png", all_plot, height = 4.6, width = 10.3, units = "cm", dpi = 300, device = "png")


