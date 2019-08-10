library(ggplot2)

library(grid)
library(gridExtra)
library(ggrepel)
library(ggsci)
library(cowplot)
library(ggthemes)

library(dplyr)
library(tidyr)
library(MASS)

library(extrafont)

library(ggpmisc)

####################
# loading functions for plotting
####################
source("speciesPlot_new.R")
source("metsPlot_new.R")

####################
# loading data
####################

load("./Rdata/lumen_T1.Rdata")
load("./Rdata/lumen_T2.Rdata")
load("./Rdata/lumen_T3.Rdata")
load("./Rdata/lumen_T4.Rdata")

load("./Rdata/mucosa_T1.Rdata")
load("./Rdata/mucosa_T2.Rdata")
load("./Rdata/mucosa_T3.Rdata")
load("./Rdata/mucosa_T4.Rdata")

load("./Rdata/blood.Rdata")
load("./Rdata/feces.Rdata")
# load("./Rdata/rectum.Rdata")

#############
# preprocessing data
#############

# only select 10% of samples from the dataset, and only keep 17 columns
sample_index <- seq(1, nrow(lumen_T1), by=10)
# 613

##############################
# lumen
#
##########
# lumen Tank 1 
lumen_T1_s <- lumen_T1[sample_index, 1:18]
head(lumen_T1_s)
lumen_T1_bac <- lumen_T1_s[,1:8]
head(lumen_T1_bac)
colnames(lumen_T1_bac) <- c("t",  "Bfr", "Blg", "Bbv", "Bad", "Ehal", "Fpr", "Rint")

lumen_T1_mets <- lumen_T1_s[, c(1, 9:18)]
head(lumen_T1_mets)
colnames(lumen_T1_mets) <- c("t", "macs", "hexose",  "succinate", "acetate", "propionate", "lactate", "formate", "ethanol", "butyrate", "h2")

speciesPlot(lumen_T1_bac, "./fig/lumen_T1_species", "Ascending Lumen")
metsPlot(lumen_T1_mets, "./fig/lumen_T1_mets", "Ascending Lumen")

##########
# lumen Tank 2
lumen_T2_s <- lumen_T2[sample_index, 1:18]
lumen_T2_bac <- lumen_T2_s[,1:8]
colnames(lumen_T2_bac) <- c("t",  "Bfr", "Blg", "Bbv", "Bad", "Ehal", "Fpr", "Rint")
lumen_T2_mets <- lumen_T2_s[, c(1, 9:18)]
colnames(lumen_T2_mets) <- c("t",  "macs", "hexose",  "succinate", "acetate", "propionate", "lactate", "formate", "ethanol", "butyrate", "h2")

speciesPlot(lumen_T2_bac, "./fig/lumen_T2_species", "Transverse Lumen")
metsPlot(lumen_T2_mets, "./fig/lumen_T2_mets", "Transverse Lumen")

##########
# lumen Tank 3
lumen_T3_s <- lumen_T3[sample_index, 1:18]
lumen_T3_bac <- lumen_T3_s[,1:8]
colnames(lumen_T3_bac) <- c("t",  "Bfr", "Blg", "Bbv", "Bad", "Ehal", "Fpr", "Rint")
lumen_T3_mets <- lumen_T3_s[, c(1, 9:18)]
colnames(lumen_T3_mets) <- c("t",  "macs", "hexose",  "succinate", "acetate", "propionate", "lactate", "formate", "ethanol", "butyrate", "h2")

speciesPlot(lumen_T3_bac, "./fig/lumen_T3_species", "Descending Lumen")
metsPlot(lumen_T3_mets, "./fig/lumen_T3_mets", "Descending Lumen")

##########
# lumen Tank 4
lumen_T4_s <- lumen_T4[sample_index, 1:18]
lumen_T4_bac <- lumen_T4_s[,1:8]
colnames(lumen_T4_bac) <- c("t",  "Bfr", "Blg", "Bbv", "Bad", "Ehal", "Fpr", "Rint")
lumen_T4_mets <- lumen_T4_s[, c(1, 9:18)]
colnames(lumen_T4_mets) <- c("t",  "macs", "hexose",  "succinate", "acetate", "propionate", "lactate", "formate", "ethanol", "butyrate", "h2")

speciesPlot(lumen_T4_bac, "./fig/lumen_T4_species", "Sigmoid Lumen")
metsPlot(lumen_T4_mets, "./fig/lumen_T4_mets", "Sigmoid Lumen")


##############################
# mucosa
#
##########
# mucosa Tank 1 
mucosa_T1_s <- mucosa_T1[sample_index, 1:18]
mucosa_T1_bac <- mucosa_T1_s[,1:8]
colnames(mucosa_T1_bac) <- c("t",  "Bfr", "Blg", "Bbv", "Bad", "Ehal", "Fpr", "Rint")
mucosa_T1_mets <- mucosa_T1_s[, c(1, 9:18)]
colnames(mucosa_T1_mets) <- c("t",  "macs", "hexose",  "succinate", "acetate", "propionate", "lactate", "formate", "ethanol", "butyrate", "h2")

speciesPlot(mucosa_T1_bac, "./fig/mucosa_T1_species", "Ascending Mucus")
metsPlot(mucosa_T1_mets, "./fig/mucosa_T1_mets", "Ascending Mucus")

##########
# mucosa Tank 2
mucosa_T2_s <- mucosa_T2[sample_index, 1:18]
mucosa_T2_bac <- mucosa_T2_s[,1:8]
colnames(mucosa_T2_bac) <- c("t",  "Bfr", "Blg", "Bbv", "Bad", "Ehal", "Fpr", "Rint")
mucosa_T2_mets <- mucosa_T2_s[, c(1, 9:18)]
colnames(mucosa_T2_mets) <- c("t",  "macs", "hexose",  "succinate", "acetate", "propionate", "lactate", "formate", "ethanol", "butyrate", "h2")

speciesPlot(mucosa_T2_bac, "./fig/mucosa_T2_species", "Transverse Mucus")
metsPlot(mucosa_T2_mets, "./fig/mucosa_T2_mets", "Transverse Mucus")

##########
# mucosa Tank 3
mucosa_T3_s <- mucosa_T3[sample_index, 1:18]
mucosa_T3_bac <- mucosa_T3_s[,1:8]
colnames(mucosa_T3_bac) <- c("t",  "Bfr", "Blg", "Bbv", "Bad", "Ehal", "Fpr", "Rint")
mucosa_T3_mets <- mucosa_T3_s[, c(1, 9:18)]
colnames(mucosa_T3_mets) <- c("t",  "macs", "hexose",  "succinate", "acetate", "propionate", "lactate", "formate", "ethanol", "butyrate", "h2")

speciesPlot(mucosa_T3_bac, "./fig/mucosa_T3_species", "Descending Mucus")
metsPlot(mucosa_T3_mets, "./fig/mucosa_T3_mets", "Descending Mucus")

##########
# mucosa Tank 4
mucosa_T4_s <- mucosa_T4[sample_index, 1:18]
mucosa_T4_bac <- mucosa_T4_s[,1:8]
colnames(mucosa_T4_bac) <- c("t",  "Bfr", "Blg", "Bbv", "Bad", "Ehal", "Fpr", "Rint")
mucosa_T4_mets <- mucosa_T4_s[, c(1, 9:18)]
colnames(mucosa_T4_mets) <- c("t",  "macs", "hexose",  "succinate", "acetate", "propionate", "lactate", "formate", "ethanol", "butyrate", "h2")

speciesPlot(mucosa_T4_bac, "./fig/mucosa_T4_species", "Sigmoid Mucus")
metsPlot(mucosa_T4_mets, "./fig/mucosa_T4_mets", "Sigmoid Mucus")

##############################
# blood
#
blood_s <- blood[sample_index, 1:11]
blood_mets <- blood_s
colnames(blood_mets) <- c("t",  "macs", "hexose",  "succinate", "acetate", "propionate", "lactate", "formate", "ethanol", "butyrate", "h2")

metsPlot(blood_mets, "./fig/blood_mets", "Blood")



##############################
# feces
#
feces_s <- feces[sample_index, 1:18]
feces_bac <- feces_s[,1:8]
colnames(feces_bac) <- c("t",  "Bfr", "Blg", "Bbv", "Bad", "Ehal", "Fpr", "Rint")
feces_mets <- feces_s[, c(1, 9:18)]
colnames(feces_mets) <- c("t",  "macs", "hexose",  "succinate", "acetate", "propionate", "lactate", "formate", "ethanol", "butyrate", "h2")

speciesPlot(feces_bac, "./fig/feces_species", "Feces")
metsPlot(feces_mets, "./fig/feces_mets", "Feces")

