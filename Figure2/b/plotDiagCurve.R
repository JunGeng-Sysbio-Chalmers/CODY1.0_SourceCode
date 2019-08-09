scaleFUN <- function(x) sprintf("%.2f", x)

plotDiagCurve <- function(data) {
  time_data_mono<-mono_data$t
  mono_data_list <- mono_data %>% gather("species", "growth", -t)
  
  data_list <- mono_data_list %>% filter(species == data)
  color_8spc<-c(brewer.pal(n=8,"Dark2")[1:5],"#BC80BD", "#E6AB02", "#80B1D3")
  
  # set # set the color
  # color_list <- list(
  #   "Bth" = "#b73276",
  #   "Bfr" = "#228fa0",
  #   "Blg" = "#325780",
  #   "Bbv" = "#3a8f62",
  #   "Bad" = "#b48939",
  #   "Ehal" = "#8f5360",
  #   "Fpr" = "#754577",
  #   "Rint" = "#a7624f"
  # )
  color_list <- list(
    "Bth" = color_8spc[1],
    "Bfr" = color_8spc[2],
    "Blg" = color_8spc[3],
    "Bbv" = color_8spc[4],
    "Bad" = color_8spc[5],
    "Ehal" = color_8spc[6],
    "Fpr" = color_8spc[7],
    "Rint" = color_8spc[8]
  )
  
  
  
  curve_col <- color_list[[data]]
  max_value <- max(data_list$growth)
  min_value <- min(data_list$growth)
  pos_value <- min_value + 0.5 * (max_value - min_value)
  
  ggplot(data_list) +
    #annotate("text", x=5, y=3, label=data, col=curve_col, fontface="italic", size=8, family="Arial") +
    geom_line(aes(x=time_data_mono, y = growth), colour = curve_col, lwd = 1.5, linetype="dashed") +
    annotate("text", x=18, y=pos_value, colour = curve_col, label=data, fontface="plain", size=6, family="Helvetica") +
    # geom_point(aes(y=g1), colour=col1, pch=19, size=0.50) +
    # geom_point(aes(y=g2), colour=col2, pch=18, size=0.50) +
    ylim(0, 5) +
    # scale_y_continuous(labels=scaleFUN) +
    scale_x_continuous(limits = c(0,24), breaks = c(0,10,20)) +
    xlab("") +
    ylab("") +
    theme_linedraw() +
    theme(
      axis.title.x = element_blank(),
      axis.text.x = element_blank(),
      # axis.ticks.x = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      # panel.border = element_rect(colour = "black", fill = NA, size = 0.5),
      panel.border = element_rect(colour = "#4b8ea3", fill = NA, size = 0.5),
      # plot.margin = unit(c(0.1, 0.1, 0.1, 0.1), "cm"),
      plot.margin = unit(c(0.45, -0.12, 0.45, 0.45), "cm"),
      text = element_text(family = "Helvetica"),
      plot.title = element_blank(),
      axis.title.y = element_blank(),
      aspect.ratio = 1
    )
  
}