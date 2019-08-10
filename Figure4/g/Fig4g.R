#!/usr/bin/env Rscript
#
##############################
# Name: 
# Author: Boyang JI
# Todo: 
# Version:
# Reference
#
##############################

#-----------------------------
# load related library
#-----------------------------

# data import, tidy
library(tidyverse)
library(stringr)

# plotting
library(ggsci)
library(scales)
show_col(pal_npg("nrc", alpha = 0.6)(10))

library(ggpubr)

# fonts
library(extrafont)
fonts()

library(RColorBrewer)
library(ggthemes)

#-----------------------------
# load data
#-----------------------------

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

col_8 <- brewer.pal(8, "Set1")
col_8 <- add.alpha(col_8, alpha = 0.9)
col_used_4 <- as.character(col_8[c(1:3)])
col_used_3 <- as.character(col_8[c(4, 5, 7, 8)])
color_7spc<-c(brewer.pal(n=8,"Dark2")[1:5],"#BC80BD", "#E6AB02", "#80B1D3")

species_main5_sondii<-c("#b73276", "#228fa0", "#325780", "#3a8f62", "#b48939")
species_other3_sondii<-c("#8f5360", "#754577", "#a7624f")

col_8<-c(as.character(species_main5_sondii),as.character(species_other3_sondii))
# col_8<-col_8[c(6,4,5,3,1,8,7,2)]
# col_8<-color_7spc

data_file <- "./data/Bac7_sample_ra.txt"
all_data <- read_tsv(data_file)
all_data$Time<-all_data$Time*24
Exp_data <- aggregate(RA~ Time+strain, mean, data=all_data)
Exp_data$strain <- factor(Exp_data$strain, levels = c("Bfr", "Blg", "Bbr", "Bad", "Ehal", "Fpr", "Rint"))
Exp_data$Type<-"Experiment"

prediction_file <- "./prediction/RA_prediction_TimeSeries.csv"
prediction_data <- read.csv(prediction_file)
prediction_data_all<-gather(prediction_data,strain,RA,Bfr:Rint,factor_key = TRUE)
prediction_data_all$strain <- factor(prediction_data_all$strain, levels = c("Bfr", "Blg", "Bbr", "Bad", "Ehal", "Fpr", "Rint"))
prediction_data_all$Type="Prediction"

# All_exp_prediction<-rbind(Exp_data,prediction_data_all)
# All_exp_prediction$strain<- factor(All_exp_prediction$strain, levels = c("Bfr", "Blg", "Bbr", "Bad", "Ehal", "Fpr", "Rint"))
species <- as.character(unique(Exp_data[, c("strain")]))
species_col_set <- data.frame(strain=species)
species_col_set$Time <- species_col_set$RA <- 1
species_col_set$strain <- factor(species_col_set$strain)
# species_col_set$yl<-c(0,0,0,0,0,0.02,0.003)
# species_col_set$ym<-c(0.02,0.001,0.01,0.01,0.03,0.1,0.02)
species_col_set$yl<-c(-0.01,-0.01,-0.003,-0.004,-0.01,0.02,-0.01) ## Bad, Bbr, Bfr, Blg, Ehal, Fpr, Rint
species_col_set$ym<-c(0.03,0.02,0.018,0.015,0.06,0.12,0.02)
species_col_set$xl<-c(-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf)
species_col_set$xm<-c(Inf,Inf,Inf,Inf,Inf,Inf,Inf)



line_plot <- ggplot(data=Exp_data, aes(x=Time, y=RA,  group=Type)) +
  
  geom_point(aes(fill=strain), size=3, pch=21, alpha=1,stroke=0.1) +
  # scale_fill_brewer(palette="Dark2")+
  scale_color_manual(values=as.character(col_8[2:8])) +
  #geom_point(aes(color=strain)) +
  geom_line(data=prediction_data_all, aes(x=Time, y=RA), 
          linetype = "dashed",
          # linetype = 5,
          # color="black", 
          color="#1a1a1a", 
          lwd=0.325) +
  # facet_grid(strain ~.) +
  facet_grid(strain ~., scales="free_y") +
  geom_rect(data = species_col_set, inherit.aes=FALSE,
            aes(fill = species,xmin = xl,xmax = xm,ymin = yl,ymax = ym),
            alpha = 0.06) +
  
  scale_fill_manual(values=as.character(col_8[2:8]))+
  # geom_rect(data = species_col_set, inherit.aes=FALSE,
  #           aes(xmin = xl,xmax = xm,ymin = yl,ymax = ym),fill = "transparent",
  #           alpha = 0.1) +
  xlab("Intervention Days") +
#   # ylab("Relative abundance") +
ylab("Relative Abundance")+
  # labs(title="",
  #      # title = "Relative abundance", 
  #      x="Intervention Days",
  #      y="")+
    scale_y_continuous(labels = scales::number_format(accuracy=0.001,decimal.mark = '.'))+
  scale_x_continuous(breaks = c(0, 24, 72, 168,336), labels = c("D0", "D1", "D3", "D7", "D14"))+
  
  #geom_smooth(method='lm') +
  theme_pander(base_family = "Helvetica", base_size = 6) +
  #   theme(
  #   legend.title = element_blank(), legend.position = "none",
  #   panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #   #panel.background = element_blank(),
  #   panel.border = element_rect(colour = "black", fill = NA, size = 1),
  #   text = element_text(size = 10, family = "Arial"),
  #   plot.title = element_text(hjust = 0.5),
  #   axis.line = element_line(color = "black", size = 0),
  #   axis.text = element_text(size = 10, family = "Arial"),
  #   axis.title = element_text(size = 10, face = "bold", family = "Arial"),
  #   axis.text.x = element_text(size = 10, family = "Arial")
# )
theme(legend.position = "none",
      plot.title = element_text(size=12),panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      plot.margin = unit( c(0.5,0.5,0.5,0.5) , units = "lines" ),
      panel.spacing = unit(0.15, "lines"),
      panel.border = element_rect(colour = "black", size=0.4),
      panel.grid = element_line(size = 0.00001, linetype = 2, color="#fcfcfc"),
      # axis.line = element_line(size = 0.01),
      strip.background = element_rect(fill="#F2F3F4",size=7),
      # strip.text.x = element_text(margin = margin(0.03,0,0.03,0, "cm"), size=6),
      strip.text.x = element_text(margin = margin(0,0.03,0,0.03, "pt"), size = 8),
      # axis.title=element_text(size=24),
      axis.text.x = element_text(size=10),
      axis.text.y = element_text(size=10),
      
      axis.title.y = element_text(vjust=1.3,size=14),
      axis.title.x = element_text(vjust=2.3,size=14),
      axis.ticks = element_line(colour = "black", size = 0.25),
      axis.ticks.length=unit(1.5, "pt"),
      axis.line = element_line(colour = 'black', size = 0.15)
      # axis.ticks.y = element_blank(),
      # axis.text.y = element_blank()
    
      # axis.title = element_text(family = "helvetica", size=11)
      # axis.text.y=element_text()
)

line_plot

# ggsave("line_prediction_exp.pdf", line_plot, height = 10, width = 9, units = "cm")
# ggsave("line_prediction_exp.svg", line_plot, height = 10, width = 9, units = "cm")






