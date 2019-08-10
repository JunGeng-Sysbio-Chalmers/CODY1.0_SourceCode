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
strain <- original_data$strain

# to proportion
data_matrix <- original_data %>% select(-strain)
data_matrix_prop <- as.data.frame(prop.table(as.matrix(data_matrix), 2))
data_matrix_new <- cbind(strain, data_matrix_prop)
head(data_matrix_new)

write_tsv(data_matrix_new, "all_ra.txt")
#strain_names <- original_data$strain
# 1747 strains


# select strain match the name
# list <- c("Bacteroides thetaiotaomicron", "Bacteroides fragilis", "Bifidobacterium longum", "Bifidobacterium breve", "Bifidobacterium adolescentis", "Eubacterium hallii", "Faecalibacterium prausnitzii", "Roseburia intestinalis" )
# 
# # 0
# Btheta_data <-  original_data %>% filter(grepl("thetaiotaomicron", strain))
# Bfra_data <-  original_data %>% filter(grepl("fragilis", strain))
# Blon_data <-  original_data %>% filter(grepl("Bifidobacterium longum", strain))
# Bbre_data <- original_data %>% filter(grepl("breve", strain))
# Bado_data <- original_data %>% filter(grepl("adolescentis", strain))
# Ehal_data <- original_data %>% filter(grepl("hallii", strain))
# Fpra_data <- original_data %>% filter(grepl("prausnitzii", strain))
# Rint_data <- original_data %>% filter(grepl("Roseburia intestinalis", strain))

species_data <- data_matrix_new %>% filter(grepl("thetaiotaomicron", strain) | 
                                             grepl("fragilis", strain) |
                                             grepl("Bifidobacterium longum", strain) | 
                                             grepl("breve", strain) | 
                                             grepl("adolescentis", strain) | 
                                             grepl("hallii", strain) |
                                             grepl("prausnitzii", strain) |
                                             grepl("Roseburia intestinalis", strain))

write_tsv(species_data, "Bac7_ra.txt")

Fpr_data <- species_data %>% filter(grepl("prausnitzii", strain))
Fpr_sum_data <- colSums(Fpr_data[, 2:ncol(Fpr_data)])
non_Fpr_data <- species_data %>% filter(!grepl("prausnitzii", strain))


new_data_matrix <- rbind(non_Fpr_data[, 2:ncol(non_Fpr_data)], Fpr_sum_data)
new_data <- new_data_matrix
new_data$strain <- c(as.character(non_Fpr_data$strain), "Faecalibacterium prausnitzii")
new_data$strain
# [1] "Bifidobacterium breve UCC2003"                                "Bifidobacterium longum subsp. infantis ATCC 15697 = JCM 1222"
# [3] "Bifidobacterium adolescentis L2-32"                           "Roseburia intestinalis XB6B4"                                
# [5] "Bacteroides fragilis 3_1_12"                                  "Eubacterium hallii DSM 3353"                                 
# [7] "Faecalibacterium prausnitzii"  

new_data$strain <- c("Bbv", "Blg", "Bad", "Rint", "Bfr", "Ehal", "Fpr")
write_tsv(new_data, "Bac7_nr_ra.txt")


data_list <- new_data %>% gather('Sample', "RA", -strain)
data_list$Sample <- as.character(data_list$Sample)

sample_file <- "sample_ID.txt"
sample_data <- read_tsv(sample_file)
sample_data$Sample <- as.character(sample_data$Sample)

sample_data_list <- full_join(sample_data, data_list, by="Sample")
write_tsv(sample_data_list, "Bac7_sample_ra.txt")

# total_count <- original_data %>% select(-strain) %>% summarise_all(sum)
# write_tsv(total_count, "total_count.txt")
# 
# data_matrix <- original_data %>% select(-strain)
# #t(t(data_matrix)/t(colSums(data_matrix)))
# data_matrix_prop <- prop.table(as.matrix(data_matrix), 2)
# dim(data_matrix_prop)
