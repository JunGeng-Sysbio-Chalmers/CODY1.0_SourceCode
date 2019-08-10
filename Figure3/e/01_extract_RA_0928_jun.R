

#-----------------------------
# load related library
#-----------------------------

# data import, tidy
library(tidyverse)
library(stringr)
library(reshape2)

# plotting
library(ggsci)
library(ggpubr)

# fonts
library(extrafont)
fonts()

#-----------------------------
# load data
#-----------------------------
# source('extract_strain.R')
data_file <- "genome_95_count.strain"
original_data <- read_tsv(data_file)
colnames(original_data)[1] <- "strain"
## remove two columns
# rmv<-c('170','171')
# original_data<-subset(original_data, select=-"170")
original_data<-original_data[, -which(colnames(original_data) %in% c("170","171"))]

strain_names <- original_data$strain
# 1747 strains

## calculate RA of each sample
Abundance<-original_data[,2:49]
AA<-colSums(Abundance)
RA<-apply(Abundance, 2, FUN = function(x){x / sum(x)})
RA_data<-data.frame(cbind(strain_names, RA))
colnames(RA_data)<-colnames(original_data)
# N_AA<-colSums(RA[,2:51])
# select strain match the name
mylist <- c("Bacteroides thetaiotaomicron", "Bacteroides fragilis", "Bifidobacterium longum", "Bifidobacterium breve", "Bifidobacterium adolescentis", "Eubacterium hallii", "Faecalibacterium prausnitzii", "Roseburia intestinalis" )

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
species_RA_data <- RA_data %>% filter(grepl("thetaiotaomicron", strain) | grepl("fragilis", strain) | grepl("Bifidobacterium longum", strain) | grepl("breve", strain) | grepl("adolescentis", strain) | grepl("hallii", strain) | grepl("prausnitzii", strain) | grepl("Roseburia intestinalis", strain))

# RA_8spc<-extract_strain(mylist,RA_data)

# extract_strain<-function(strain_list,strain_data){
#   ar=0;  ## current pointer
#   arp=0; ## previous pointer
#   # str_data<-matrix(nrow=20,ncol=51)
#   for (i in 1:length(strain_list)){
#     if (length(str)>0){
#       strdata <-  strain_data %>% filter(grepl(str[2], strain_data$strain))
#       ar<-arp+nrow(strdata)
#       str_data[arp+1:ar,]<-strdata
#       arp<-ar}
#     else{
#     }
#   }
#   return(str_data)
# }


write_tsv(species_data, "species.txt")
write_tsv(species_RA_data, "species_RA.txt")




## read sample files
sample_file <- "sample_ID.txt"
sample_data <- read_tsv(sample_file)
# species_data<-reshape(species_RA_data)
a<-data.frame(t(species_RA_data))
colnames(a)<-species_RA_data[,1]
a<-a[-1,]
a$Sample<-as.numeric(rownames(a)) 
# alldata<-cbind(sample_data,a)
# species_RA_data$subject <- factor(olddata_long$subject)

full_data<-inner_join(sample_data,a, by="Sample")
full_data$Time <- factor(full_data$Time, levels=c(0, 1, 3, 7, 14))

full_data_long <- gather(full_data, Sample, measurement, control:cond2, factor_key=TRUE)
full_data_long <- melt(full_data, id.vars=c("ID", "Sample", "Time"))
full_data_long$Time <- factor(full_data_long$Time, levels=c("0", "1", "3", "7", "14"))
full_data_long$value<-as.numeric(full_data_long$value)
full_data_mean <- aggregate(value~ Time + variable ,  data=full_data_long, FUN="mean")

full_data_output <- dcast(full_data_mean, variable ~ Time, value.var="value")

write_tsv(full_data_output, "Mean_RA_species.txt")


## read sample files and calculate the AA values:
sample_file <- "sample_ID.txt"
sample_data <- read_tsv(sample_file)
# species_data<-reshape(species_RA_data)
a<-data.frame(t(species_data))
colnames(a)<-species_RA_data[,1]
a<-a[-1,]
a$Sample<-as.numeric(rownames(a)) 
# alldata<-cbind(sample_data,a)
# species_RA_data$subject <- factor(olddata_long$subject)

full_data<-inner_join(sample_data,a, by="Sample")
full_data$Time <- factor(full_data$Time, levels=c(0, 1, 3, 7, 14))

full_data_long <- gather(full_data, Sample, measurement, control:cond2, factor_key=TRUE)
full_data_long <- melt(full_data, id.vars=c("ID", "Sample", "Time"))
full_data_long$Time <- factor(full_data_long$Time, levels=c("0", "1", "3", "7", "14"))
full_data_long$value<-as.numeric(full_data_long$value)
full_data_mean <- aggregate(value~ Time + variable ,  data=full_data_long, FUN="mean")

full_data_output <- dcast(full_data_mean, variable ~ Time, value.var="value")

write_tsv(full_data_output, "Mean_AA_species.txt")

## calculate the mean AA of all samples, at each time point
AA_total<-data.frame(t(AA))
# species_data<-reshape(species_RA_data)
a<-data.frame(AA)
# colnames(a)<-species_RA_data[,1]
# a<-a[-1,]
a$Sample<-as.numeric(rownames(a)) 
# alldata<-cbind(sample_data,a)
# species_RA_data$subject <- factor(olddata_long$subject)

full_data<-inner_join(sample_data,a, by="Sample")
full_data$Time <- factor(full_data$Time, levels=c(0, 1, 3, 7, 14))

full_data_long <- gather(full_data, Sample, measurement, control:cond2, factor_key=TRUE)
full_data_long <- melt(full_data, id.vars=c("ID", "Sample", "Time"))
full_data_long$Time <- factor(full_data_long$Time, levels=c("0", "1", "3", "7", "14"))
full_data_long$value<-as.numeric(full_data_long$value)
full_data_mean <- aggregate(value~ Time + variable ,  data=full_data_long, FUN="mean")

full_data_output <- dcast(full_data_mean, variable ~ Time, value.var="value")
# write_tsv(full_data_output, "species_mean_AA.txt")
