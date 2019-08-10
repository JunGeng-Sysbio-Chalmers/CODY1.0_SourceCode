library(dplyr)
library(tidyr)

library(ggplot2)
library(ggpubr)
library(ggsci)
library(ggthemes)
library(ggthemr)

library(ggrepel)

library(extrafont)
fonts()

mean_file <- "data.txt"


mean_data <- read.table(file=mean_file, sep="\t", header=T, stringsAsFactors=F)
colnames(mean_data) <- c("time", "phylum", "mean")
mean_data$time <- factor(mean_data$time, levels=c("B", "4M", "12M"))

# sorting by phylum
mean_data$phylum <- factor(mean_data$phylum , levels=rev(c("Actinobacteria", "Bacteroidetes", "Firmicutes")))


mean_plot <- ggplot(mean_data, aes(x=phylum, y=mean, fill=phylum)) +
  geom_bar(stat="identity", color=c("black"), size=0.3, width=0.8) +
  facet_grid(time~.) +
  # scale_color_jco() +
  # scale_fill_futurama() +
  scale_fill_manual(values = pal_futurama("planetexpress", alpha=0.7)(12)[c(2,3,1)]) +
  # scale_fill_discrete()
  scale_y_continuous(limits = c(0, 0.45), expand=c(0.005, 0.01)) +
  xlab("") +
  ylab("Mean Relative abundance") +
  coord_flip() +
  geom_text(aes(label=ifelse(mean>1e-3, round(mean, 3), "")), hjust=-0.1, color="black", size=2.5) +
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
mean_plot
# ggexport(mean_plot, filename="species_8_phylum_mean_plot_formula_mixed.jpg", width=800, height=400, res=150, pointsize = 10)
# ggsave(plot=mean_plot, filename="species_8_phylum_mean_plot_formula_mixed.pdf", width=9, height=6, units="cm")
# ggsave(plot=mean_plot, filename="species_8_phylum_mean_plot_formula_mixed.tif", width=9, height=6, units="cm", device="tiff", dpi=300)
