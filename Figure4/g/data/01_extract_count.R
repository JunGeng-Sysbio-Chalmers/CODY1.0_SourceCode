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
library(ggpubr)

# fonts
library(extrafont)
fonts()

#-----------------------------
# load data
#-----------------------------

data_file <- "genome_95_count.strain"
original_data <- read_tsv(data_file)
colnames(original_data)[1] <- "strain"
samples <- colnames(original_data)[-1]

# to proportion
data_matrix <- original_data %>% select(-strain)
data_matrix_prop <- (prop.table(as.matrix(data_matrix), 2))


strain_names <- original_data$strain
# 1747 strains


# select strain match the name
list <- c("Bacteroides thetaiotaomicron", "Bacteroides fragilis", "Bifidobacterium longum", "Bifidobacterium breve", "Bifidobacterium adolescentis", "Eubacterium hallii", "Faecalibacterium prausnitzii", "Roseburia intestinalis" )

# 0
Btheta_data <-  original_data %>% filter(grepl("thetaiotaomicron", strain))
Bfra_data <-  original_data %>% filter(grepl("fragilis", strain))
Blon_data <-  original_data %>% filter(grepl("Bifidobacterium longum", strain))
Bbre_data <- original_data %>% filter(grepl("breve", strain))
Bado_data <- original_data %>% filter(grepl("adolescentis", strain))
Ehal_data <- original_data %>% filter(grepl("hallii", strain))
Fpra_data <- original_data %>% filter(grepl("prausnitzii", strain))
Rint_data <- original_data %>% filter(grepl("Roseburia intestinalis", strain))

species_data <- original_data %>% filter(grepl("thetaiotaomicron", strain) | grepl("fragilis", strain) | grepl("Bifidobacterium longum", strain) | grepl("breve", strain) | grepl("adolescentis", strain) | grepl("hallii", strain) | grepl("prausnitzii", strain) | grepl("Roseburia intestinalis", strain))

write_tsv(species_data, "species.txt")

total_count <- original_data %>% select(-strain) %>% summarise_all(sum)
write_tsv(total_count, "total_count.txt")

data_matrix <- original_data %>% select(-strain)
#t(t(data_matrix)/t(colSums(data_matrix)))
data_matrix_prop <- prop.table(as.matrix(data_matrix), 2)
dim(data_matrix_prop)
