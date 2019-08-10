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

all_mean_file <- "all_f_formula_mixed_phylum_abundance_mean.txt"
others_file <- "others_phylum_abundance_mean_formula_mixed.txt"
species_8_file <- "8_species_phylum_abundance_mean__formula_mixed.txt"

all_data <- read.table(file = all_mean_file, sep = "\t", header = T, stringsAsFactors = F)
colnames(all_data) <- c("time", "phylum", "mean")
all_data$time <- factor(all_data$time, levels = c("B", "4M", "12M"))

others_data <- read.table(file = others_file, sep = "\t", header = T, stringsAsFactors = F)
colnames(others_data) <- c("time", "phylum", "mean")
others_data$time <- factor(others_data$time, levels = c("B", "4M", "12M"))

species_data <- read.table(file = species_8_file, sep = "\t", header = T, stringsAsFactors = F)
colnames(species_data) <- c("time", "phylum", "mean")
species_data$time <- factor(species_data$time, levels = c("B", "4M", "12M"))

all_mean_main_3_data <- all_data %>% filter(phylum %in% c("Firmicutes", "Bacteroidetes", "Actinobacteria"))
phylum_3 <- rev(levels(factor(all_mean_main_3_data$phylum)))
all_mean_main_3_data$phylum <- factor(all_mean_main_3_data$phylum, levels = phylum_3)

others_mean_main_3_data <- others_data %>% filter(phylum %in% c("Firmicutes", "Bacteroidetes", "Actinobacteria"))
others_mean_main_3_data$phylum <- factor(others_mean_main_3_data$phylum, levels = phylum_3)

# reverse the order of phylum
phyla <- rev(levels(factor(all_data$phylum)))
all_data$phylum <- factor(all_data$phylum, levels = phyla)
others_data$phylum <- factor(others_data$phylum, levels = phyla)

col_values <- c(pal_futurama("planetexpress", alpha=0.7)(12)[4:10], pal_futurama("planetexpress", alpha=0.7)(12)[c(2,3,1)])



all_mean_main_3_plot <- ggplot(all_mean_main_3_data, aes(x = phylum, y = mean, fill = phylum)) +
  geom_bar(stat = "identity", color = "black", size = 0.3, width=0.8) +
  facet_grid(time~.) +
  # scale_color_jco() +
  scale_fill_manual(values = pal_futurama("planetexpress", alpha=0.7)(12)[c(2,3,1)]) +
  scale_y_continuous(limits = c(0, 0.4), expand = c(0.005, 0.01)) +
  coord_flip() +
  xlab("") +
  ylab("Mean Relative abundance") +
  geom_text(aes(label = ifelse(mean > 1e-3, round(mean, 3), "")), hjust = -0.2, color = "black", size = 2.5) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "#FCFCFC"),
    text = element_text(size = 10, family = "Arial"),
    axis.text = element_text(size = 10),
    axis.text.x = element_text(size = 10, angle = 0),
    axis.line.y = element_line(size = 0.5),
    axis.line.x = element_line(size = 0.4),
    legend.position = "none",
    legend.box = "horizontal",
    legend.background = element_blank(),
    legend.key = element_rect(fill = "transparent", colour = "transparent"),
    strip.text.x = element_text(size = 10, face = "italic"),
    strip.background = element_rect(),
    axis.title = element_text(size = 10, face = "bold"),
    panel.border = element_rect(colour = "black", fill = NA, size = 0.5),
    plot.margin = unit(c(2, 2, 2, 2), "pt")
  )
all_mean_main_3_plot

all_mean_plot <- ggplot(all_data, aes(x = phylum, y = mean, fill = phylum)) +
  geom_bar(stat = "identity", color = "black", size = 0.3, width=0.8) +
  facet_grid(time~.) +
  # scale_color_jco() +
  scale_fill_manual(values = col_values) +
  scale_y_continuous(limits = c(0, 0.4), expand = c(0.005, 0.01)) +
  coord_flip() +
  xlab("") +
  ylab("Mean Relative abundance") +
  geom_text(aes(label = ifelse(mean > 1e-3, round(mean, 3), "")), hjust = -0.2, color = "black", size = 2.5) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "#FCFCFC"),
    text = element_text(size = 10, family = "Arial"),
    axis.text = element_text(size = 10),
    axis.text.x = element_text(size = 10, angle = 0),
    axis.line.y = element_line(size = 0.5),
    axis.line.x = element_line(size = 0.4),
    legend.position = "none",
    legend.box = "horizontal",
    legend.background = element_blank(),
    legend.key = element_rect(fill = "transparent", colour = "transparent"),
    strip.text.x = element_text(size = 10, face = "italic"),
    strip.background = element_rect(),
    axis.title = element_text(size = 10, face = "bold"),
    panel.border = element_rect(colour = "black", fill = NA, size = 0.5),
    plot.margin = unit(c(2, 2, 2, 2), "pt")
  )
all_mean_plot
# ggexport(all_mean_main_3_plot, filename = "all_phylum_mean_main_3_plot_formula_mixed.jpg", width = 800, height = 300, res = 150, pointsize = 10)
ggsave(plot = all_mean_main_3_plot, filename = "all_phylum_main_3_mean_plot_formula_mixed.pdf", width = 9, height = 6, units = "cm")
# ggsave(plot = all_mean_main_3_plot, filename = "all_phylum_main_3_mean_plot_formula_mixed.tif", width = 9, height = 6, units = "cm", device="tiff", dpi=300)

# ggexport(all_mean_plot, filename = "all_phylum_mean_plot.jpg", width = 800, height = 900, res = 150, pointsize = 10)
# ggsave(plot = all_mean_plot, filename = "all_phylum_mean_plot.pdf", width = 9.5, height = 14, units = "cm")
# ggsave(plot = all_mean_plot, filename = "all_phylum_mean_plot.tif", width = 9.5, height = 14, units = "cm", device="tiff", dpi=300)

others_mean_plot <- ggplot(others_data, aes(x = phylum, y = mean, fill = phylum)) +
  geom_bar(stat = "identity", color = "black", size = 0.3, width=0.8) +
  facet_grid(time~.) +
  # scale_color_jco() +
  scale_fill_manual(values = col_values) +
  scale_y_continuous(limits = c(0, 0.3), expand = c(0.005, 0.01)) +
  coord_flip() +
  xlab("") +
  ylab("Mean Relative abundance") +
  geom_text(aes(label = ifelse(mean > 1e-3, round(mean, 3), "")), hjust = -0.2, color = "black", size = 2.5) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "#FCFCFC"),
    text = element_text(size = 10, family = "Arial"),
    axis.text = element_text(size = 10),
    axis.text.x = element_text(size = 10, angle = 90),
    axis.line.y = element_line(size = 0.5),
    axis.line.x = element_line(size = 0.4),
    legend.position = "none",
    legend.box = "horizontal",
    legend.background = element_blank(),
    legend.key = element_rect(fill = "transparent", colour = "transparent"),
    strip.text.x = element_text(size = 10, face = "italic"),
    strip.background = element_rect(),
    axis.title = element_text(size = 10, face = "bold"),
    panel.border = element_rect(colour = "black", fill = NA, size = 0.5),
    plot.margin = unit(c(2, 2, 2, 2), "pt")
  )

# ggexport(others_mean_plot, filename = "others_phylum_mean_plot.jpg", width = 800, height = 900, res = 150, pointsize = 10)
# ggsave(plot = others_mean_plot, filename = "others_phylum_mean_plot.pdf", width = 9.5, height = 14, units = "cm")
# ggsave(plot = others_mean_plot, filename = "others_phylum_mean_plot.tif", width = 9.5, height = 14, units = "cm", device="tiff", dpi=300)

others_mean_main_3_plot <- ggplot(others_mean_main_3_data, aes(x = phylum, y = mean, fill = phylum)) +
  geom_bar(stat = "identity", color = "black", size = 0.3, width=0.8) +
  facet_grid(time~.) +
  # scale_color_jco() +
  scale_fill_manual(values = pal_futurama("planetexpress", alpha=0.7)(12)[c(2,3,1)]) +
  scale_y_continuous(limits = c(0, 0.4), expand = c(0.005, 0.01)) +
  coord_flip() +
  xlab("") +
  ylab("Mean Relative abundance") +
  geom_text(aes(label = ifelse(mean > 1e-3, round(mean, 3), "")), hjust = -0.2, color = "black", size = 2.5) +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "#FCFCFC"),
    text = element_text(size = 10, family = "Arial"),
    axis.text = element_text(size = 10),
    axis.text.x = element_text(size = 10, angle = 0),
    axis.line.y = element_line(size = 0.5),
    axis.line.x = element_line(size = 0.4),
    legend.position = "none",
    legend.box = "horizontal",
    legend.background = element_blank(),
    legend.key = element_rect(fill = "transparent", colour = "transparent"),
    strip.text.x = element_text(size = 10, face = "italic"),
    strip.background = element_rect(),
    axis.title = element_text(size = 10, face = "bold"),
    panel.border = element_rect(colour = "black", fill = NA, size = 0.5),
    plot.margin = unit(c(2, 2, 2, 2), "pt")
  )

# ggexport(others_mean_main_3_plot, filename = "others_phylum_mean_main_3_plot.jpg", width = 800, height = 300, res = 150, pointsize = 10)
# ggsave(plot = others_mean_main_3_plot, filename = "others_phylum_main_3_mean_plot.pdf", width = 9, height = 6, units = "cm")
# ggsave(plot = others_mean_main_3_plot, filename = "others_phylum_main_3_mean_plot.tif", width = 9, height = 6, units = "cm", device="tiff", dpi=300)
