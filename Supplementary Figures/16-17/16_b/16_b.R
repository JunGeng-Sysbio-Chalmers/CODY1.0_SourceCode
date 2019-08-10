# load packages
library(dplyr)
library(tidyr)
library(ggplot2)
library(stringr)
library(ggpubr)
library(ggsci)

library(extrafont)
fonts()

# load data
data_file <- "all_f_formula_mixed_phylum.txt"
phylum_data <- read.table(data_file, sep="\t", header=T, stringsAsFactors = F)
phylum_data$sample <- rownames(phylum_data)

phylum_abundance_data <- gather(phylum_data, -sample, key="id", value="abundance")
colnames(phylum_abundance_data) <- c("phylum", 'id', "abundance")

id_info <- str_split_fixed(phylum_abundance_data$id, "_", 2)
phylum_abundance_data$id <- id_info[,1]
phylum_abundance_data$time <- id_info[,2]

# remove mother data
phylum_abundance_data <- phylum_abundance_data %>% filter(time != "M")
phylums <- rev(levels(factor(phylum_abundance_data$phylum)))
phylum_abundance_data$phylum <- factor(phylum_abundance_data$phylum, levels=phylums)

# order the data by B 4M 12M
phylum_abundance_data$time <- factor(phylum_abundance_data$time, levels = c("B","4M", "12M"))
write.table(phylum_abundance_data, "allf_formula_mixed_phylum_abudance.txt", sep="\t", quote=F, row.names = F)

cols_phylum <- rev(pal_futurama("planetexpress", alpha=0.7)(12)[c(1,3,2,4:10)])

phylum_plot <- ggplot(phylum_abundance_data, aes(x=phylum, y=abundance, fill=phylum)) +
  geom_boxplot(outlier.size=0.1, width=0.8, lwd=0.2) +
  facet_grid(time~.) +
  scale_color_jco() +
  scale_fill_manual(values=cols_phylum) +
  coord_flip() +
  xlab("") +
  ylab("Relative abundance") +
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
  ) 
phylum_plot
ggexport(phylum_plot, filename="all_f_formula_mixed_phylum_plot.jpg", width=900, height=700, res=150, pointsize = 10)
ggsave(plot=phylum_plot, filename="all_f_formula_mixed_phylum_plot.pdf", width=9.5, height=14, units="cm")
ggsave(plot=phylum_plot, filename="all_f_formula_mixed_phylum_plot.tif", width=9.5, height=14, units="cm", device="tiff", dpi=300)

phylum_main_3_data <- phylum_abundance_data %>% filter(phylum %in% c("Firmicutes", "Bacteroidetes", "Actinobacteria"))

phylum_main_3_plot <- ggplot(phylum_main_3_data, aes(x=phylum, y=abundance, fill=phylum)) +
  geom_boxplot(outlier.size=0.1, width=-.8, lwd=0.2) +
  facet_grid(time~.) +
  scale_color_jco() +
  scale_fill_manual(values=rev(pal_futurama("planetexpress", alpha=0.7)(12)[c(1,3,2)])) +
  coord_flip() +
  xlab("") +
  ylab("Relative abundance") +
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
  ) 
phylum_main_3_plot
# ggexport(phylum_main_3_plot, filename = "all_phylum_f_formula_mixed__main_3_boxplot.jpg", width = 800, height = 300, res = 150, pointsize = 10)
# ggsave(plot = phylum_main_3_plot, filename = "all_phylum_f_formula_mixed__main_3_boxplot.pdf", width = 9, height = 6, units = "cm")
# ggsave(plot = phylum_main_3_plot, filename = "all_phylum_f_formula_mixed__main_3_boxplot.tif", width = 9, height = 6, units = "cm", device="tiff", dpi=300)


