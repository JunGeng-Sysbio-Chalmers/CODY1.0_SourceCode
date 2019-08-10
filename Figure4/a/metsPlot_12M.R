metsPlot_12M <- function(data, outLabel, figLabel) {
  
  # set output file
  outpdf <- paste(outLabel, ".pdf", sep="")
  outjpg <- paste(outLabel, ".jpg", sep="")
  outtif <- paste(outLabel, ".tif", sep="")
  outpng <- paste(outLabel, ".png", sep="")
  
  mets_data <- gather(data, -t, key="metabolites", value="concentration")
  # colnames(mets_data) <- c("t", "metabolites", "concentration")
  
  max_value <- ifelse(ceiling(max(mets_data$concentration)) %% 2 == 0, ceiling(max(mets_data$concentration)), ceiling(max(mets_data$concentration))+1)
  
  mets_data$metabolites <- as.factor(mets_data$metabolites)
  # levels(mets_data$metabolites)
  # "acetate"    "butyrate"   "ethanol"    "fiber"      "formate"    "h2"         "hexose"     "lactate"    "propionate" "succinate"
  levels(mets_data$metabolites) <- c("Acetate", "Butyrate", "Ethanol", "Formate", "H2", "Hexose", "Lactate", "MACs", "Propionate", "Succinate")
  
  
  metabolites <- as.character(unique(mets_data[, c("metabolites")]))
  metabolites_col_set <- data.frame(metabolites=metabolites)
  metabolites_col_set$t <- metabolites_col_set$concentration <- 1
  
  
  mets_plot <-  ggplot(mets_data, aes(x=t, y=concentration)) +
    geom_line(lwd=0.3) +
    facet_wrap(~metabolites, ncol=2, scale="free_y") +
    geom_rect(data = metabolites_col_set, aes(fill = metabolites),xmin = -Inf,xmax = Inf,
              ymin = -Inf,ymax = Inf,alpha = 0.2) +
    xlab("Time (h)") +
    ylab("Concentration") +
    scale_x_continuous(expand=c(0,0), limits=c(0, 1033.52), breaks=c(0, 200, 400, 600, 800, 1000), labels=c(0, 200, 400, 600, 800, 1000)) +
    scale_y_continuous(expand=c(0.05,0.1)) +
    ggtitle(figLabel) +
    theme_pander(base_family = "Arial", base_size=8) +
    theme(legend.position = "none",
          plot.margin = unit( c(0.5,1,0.5,0.5) , units = "lines" ),
          panel.spacing = unit(1, "lines"),
          panel.border = element_rect(colour = "black", size=1),
          axis.line = element_line(size = 0.5),
          strip.background = element_rect(fill="#F2F3F4"),
          strip.text.x = element_text(margin = margin(0.05,0,0.05,0, "cm"))
    ) 
  mets_plot
  # ggsave(outpdf, mets_plot, height=14, width=16, units = "cm")
  # ggsave(outjpg, mets_plot, height=14, width=16, units = "cm", dpi=300)
  # ggsave(outtif, mets_plot, height=14, width=16, units = "cm", dpi=300, device="tiff")
  # ggsave(outpng, mets_plot, height=14, width=16, units = "cm", dpi=300, device="png")
}