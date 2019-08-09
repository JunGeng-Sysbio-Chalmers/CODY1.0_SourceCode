library(ggplot2)
library(gridExtra)
library(grid)
library(ggthemes)
library(dplyr)
library(tidyr)
library(tidyverse)
library(reshape2)
library(extrafont)
fonts()

library(scales)
library(ggpubr)
library(ggsci)

library(hash)
library(RColorBrewer)
source("plotLowerTriCol.R")
source("plotUpperTri.R")
source("plotDiagCurve.R")

source("resamplingTimePoints.R")

source("colBarList.R")

#######################################
### read the biomass data

biomass_file <- "./data/Biomass_format.txt"
biomass_data <- read.table(biomass_file, sep = "\t", header = F)

time_file<-"./data/Time.csv"

time_data<-read.table(time_file, sep = "\t", header = F)
# sampling
points <- 50
biomass_data <- resamplingTimePoints(biomass_data, points)
# time_data<-resamplingTimePoints(time_data, points)
time_index <- c(seq(2, nrow(time_data), by=points))
time_data_seq <- as.data.frame(time_data[time_index,]) 
time_data_seq$`time_data[time_index, ]`=as.numeric(levels(time_data_seq$`time_data[time_index, ]`))[time_data_seq$`time_data[time_index, ]`]

# remove diag ones ( species 1 == species 2 )
biomass_table_wo_diag <- biomass_data %>% filter(V1 != V2)
# data table to list
biomass_list_wo_diag <- split(biomass_table_wo_diag, seq(nrow(biomass_table_wo_diag)))

#######################################
### read the mu data
mu_file <- "./data/MaxMiu_tab.txt"

mu_data <- read.table(mu_file, sep = "\t", header = F)

mu_data_wo_diag <- mu_data %>% filter(V1 != V2)
mu_wo_diag_list <- split(mu_data_wo_diag, seq(nrow(mu_data_wo_diag)))

# read sing growth
mono_file <- "./data/Pure_Culture.csv"

mono_data <- read.csv(mono_file)
colnames(mono_data) <- c("t", "Bth", "Bfr", "Blg", "Bbv", "Bad", "Ehal", "Fpr", "Rint")


#######################################
### get the name info
#
# names <- c("Ba.\nthetaiotaomicron",
#            "Ba. fragilis",
#            "Bi. longum",
#            "Bi. breve",
#            "Bi.\n adolescentis",
#            "E. hallii",
#            "F.\n prausnitzii",
#            "R.\n intestinalis"
# )
names <- c(
  "Bth",
  "Bfr",
  "Blg",
  "Bbv",
  "Bad",
  "Ehal",
  "Fpr",
  "Rint"
)
names_list <- as.list(names)



lower_col_list <- c(pal_jco("default", alpha = 0.7)(10)[1], pal_jco("default", alpha = 1)(10)[2])


green_yellow_col <- c(pal_locuszoom("default")(7)[3], "#E7298A")
show_col(pal_locuszoom("default")(7))
upper_col_list <- colorRampPalette(c("#29bece", "white", green_yellow_col[2]), space = "rgb")(37)

upper_col_list <- colorRampPalette(c("#29bece","#55d6d1","#adf4f2","#fffef9","#e5b49c","#e8976f","#ff875b"), space = "rgb")(37)


upper_col_range <- c(
  -3.5, -2.75, -2, -1.25, -0.99, -0.75, -0.7, -0.45, -0.4, -0.35, -0.32, -0.29, -0.2, -0.1, -0.05, -0.02, -0.015, -0.005, -0.0025,
  0.0025, 0.005, 0.015, 0.02, 0.05, 0.1, 0.2, 0.29, 0.32, 0.35, 0.4, 0.45, 0.5, 0.65, 0.79, 1, 1.2, 1.5, 2
)

#######################################
### plot lower triangle (biomass)
#
plotLowerTri(biomass_list_wo_diag[[1]], col = lower_col_list)
# test function
original_data <- biomass_list_wo_diag[[1]]


biomass_wo_diag_plot <- lapply(biomass_list_wo_diag, plotLowerTri, col = lower_col_list)

#######################################
### plot lower triangle (mu)
#
plotUpperTri(mu_wo_diag_list[[16]], col = upper_col_list, ranges = upper_col_range)
mu_col_plot <- lapply(mu_wo_diag_list, plotUpperTri, col = upper_col_list, ranges = upper_col_range)

#######################################
### plot the diagnoal (names)
#plotDiag(names_list[[1]])
plotDiagCurve(names_list[[1]])
data <- names_list[[1]]

names_plot <- lapply(names_list, plotDiagCurve)

#######################################
# merge plot together
all_plot <- list()
all_plot[1:28] <- biomass_wo_diag_plot
all_plot[29:56] <- mu_col_plot
all_plot[57:64] <- names_plot


#######################################
# set the layout
all_layout <- matrix(NA, 8, 8)

# set the lower triangle
biomass_wo_diag_layout_matrix <- matrix(NA, 8, 8)
biomass_wo_diag_layout_matrix
biomass_wo_diag_layout_matrix[lower.tri(biomass_wo_diag_layout_matrix, diag = F)] <- 1:nrow(biomass_table_wo_diag)
biomass_wo_diag_layout_matrix
all_layout[lower.tri(all_layout, diag = F)] <- biomass_wo_diag_layout_matrix[lower.tri(biomass_wo_diag_layout_matrix, diag = F)]

all_layout

# set the upper triangle
mu_layout_matrix <- matrix(NA, 8, 8)
mu_layout_matrix[lower.tri(mu_layout_matrix, diag = F)] <- 29:(nrow(mu_data_wo_diag) + 28)
mu_layout_matrix <- t(mu_layout_matrix)
all_layout[upper.tri(all_layout, diag = F)] <- mu_layout_matrix[upper.tri(mu_layout_matrix, diag = F)]

# set the diagnoal
diag(all_layout) <- 57:64
#######################################
# PLOTTING ALL
#######################################
ALL_PLOT_LAYOUT <- grid.arrange(grobs = all_plot, layout_matrix = all_layout)
ALL_PLOT_LAYOUT

ggsave("biomass_mu_tri.pdf", ALL_PLOT_LAYOUT,
       height = 10, width = 10)


#######################################
### plot col bar
plot(upper_col_range[1:38], rep(1, 38), col = upper_col_list, pch = 19, cex = 16)
# plot(rep(1,6),col=alpha(color_list(6), 0.35),pch=19,cex=16)

bar_color <- upper_col_list[1:37]
bar_col_plot <- colBarList(bar_color, upper_col_range)

ggsave("col_bar.pdf", bar_col_plot, height = 1, width = 3)

#########
