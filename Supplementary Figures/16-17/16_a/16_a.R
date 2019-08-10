library(dplyr)
library(tidyr)

library(ggplot2)
library(ggpubr)
library(ggsci)
library(ggthemes)
library(ggthemr)
library(extrafont)
fonts()

species_data_file <- "all_metaotu_f_formula_mixed.txt"
species_data <- read.table(file=species_data_file, sep="\t", header=T, stringsAsFactors = F, row.names = 1)
species_names <- rownames(species_data)
species_data$id <- species_names
head(species_data)

wanted_species_file <- "species_phylum_8.txt"
wanted_species <- read.table(file=wanted_species_file, sep="\t", header = T, stringsAsFactors = F)
wanted_species_name <- wanted_species[,1]
wanted_species_name_order <- wanted_species_name[order(wanted_species_name)]
wanted_species <- wanted_species[order(wanted_species[,1]),]
#  [1] "MS00045" "MS00052" "MS00054" "MS00056" "MS00059" "MS00061" "MS00159" "MS00167" "MS00168" "MS00169" "MS00300"

wanted_species_data <- species_data %>% filter(id %in% wanted_species_name) %>% arrange(id)
wanted_species_data$id
wanted_species_data$phylum <- wanted_species$Phylum
# wanted_species_data$phylum <- as.factor(wanted_species$Phylum)

wanted_phylum_data <- wanted_species_data %>% group_by(phylum) %>% summarise_if(is.numeric, sum)

phylum_abundance_data <- wanted_phylum_data %>% gather(sample, value, -phylum) %>% separate(sample, c("id", "time")) %>% filter(time != "M")
phylum_abundance_data$time <- factor(phylum_abundance_data$time, levels = c("B","4M", "12M"))
write.table(phylum_abundance_data, file="8_species_phylum_abundance_formula_mixed.txt", sep="\t", quote=F, row.names = F)

phylum_abundance_data$phylum <- factor(phylum_abundance_data$phylum, levels=c("Firmicutes", "Bacteroidetes", "Actinobacteria")) 



phylum_plot <- ggplot(phylum_abundance_data, aes(x=phylum, y=value, fill=phylum)) +
  geom_boxplot(outlier.size=0.1, width=0.8, lwd=0.2) +
  facet_grid(time~.) +
  scale_color_jco() +
  scale_fill_manual(values=rev(pal_futurama("planetexpress", alpha=0.7)(12)[c(1,3,2)])) +
  coord_flip()+
  xlab("") +
  ylab("Relative abundance") +
  # theme(panel.grid.major = element_blank(), 
  #       panel.grid.minor = element_blank(),
  #       panel.background = element_rect(fill="#FCFCFC"),
  #       text = element_text(size=10, family="Arial"), 
  #       axis.text=element_text(size=10),
  #       axis.text.x=element_text(size=10, angle=90),
  #       axis.line.y=element_line(size=0.5),
  #       axis.line.x=element_line(size=0.4),
  #       legend.position="none", 
  #       legend.box = "horizontal",
  #       legend.background = element_blank(),
  #       legend.key = element_rect(fill = "transparent", colour = "transparent"),
  #       strip.text.x = element_text(size=10, face="italic"),
  #       strip.background = element_rect(),
  #       axis.title=element_text(size=10,face="bold"),
  #       panel.border = element_rect(colour = "black", fill=NA, size=0.5),
  #       plot.margin = unit(c(2, 2, 2, 2), "pt")
  # ) 
theme(panel.grid.major = element_blank(), 
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill="#FCFCFC"),
      text = element_text(size=10, family="Arial"), 
      axis.text=element_text(size=10),
      axis.text.x=element_text(size=10, angle=0),
      axis.line.y=element_line(size=0.5),
      axis.line.x=element_line(size=0.4),
      legend.position="none", 
      legend.box = "horizontal",
      legend.background = element_blank(),
      legend.key = element_rect(fill = "transparent", colour = "transparent"),
      strip.text.x = element_text(size=10, face="italic"),
      strip.background = element_rect(),
      axis.title=element_text(size=10,face="bold"),
      panel.border = element_rect(colour = "black", fill=NA, size=0.5),
      plot.margin = unit(c(2, 2, 2, 2), "pt")
      #plot.background = element_rect(colour="red")
) 
phylum_plot

# ggsave(plot=phylum_plot, filename="8_species_phylum_plot_formula_mixed.tif", width=9, height=6, units="cm", device="tiff", dpi=300)

# get the information for each group
group_mean_abundance <- phylum_abundance_data %>% group_by(time, phylum) %>% summarise(mean(value))
write.table(group_mean_abundance, file="8_species_phylum_abundance_mean_formula_mixed.txt", sep="\t", quote=F, row.names = F)

group_median_abundance <- phylum_abundance_data %>% group_by(time, phylum) %>% summarise(median(value))
