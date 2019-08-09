colBarList <- function(color, list) {
  colbar_plot <- ggplot()

  num_list <- length(list)

  rect_data <- data.frame(xmin = list[(1:num_list - 1)], xmax = list[2:num_list], ymin = rep(-1, (num_list - 1)), ymax = rep(1, (num_list - 1)))
  barplots <- ggplot(rect_data) +
    geom_rect(aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), fill = color, alpha = 1) +
    scale_y_continuous(expand = c(0, 0)) +
    scale_x_continuous(expand = c(0, 0), limits = c(-3, 3), breaks = c(-3, -2, -1, 0, 1, 2, 3)) +
    theme_bw() +
    theme(
      axis.title.x = element_blank(),
      # axis.text.x=element_blank(),
      # axis.ticks.x=element_blank(),
      # axis.line.x = element_line(colour = "black", size = 0.2, linetype = "solid"),
      axis.title.y = element_blank(),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_rect(colour = "white", fill = NA, size = 0.5),
      plot.margin = unit(c(0.45, 0.45, 0.45, 0.45), "cm"),
      text = element_text(family = "Arial"),
      plot.title = element_blank(),
      aspect.ratio = 1 / 10
    )

  return(barplots)
}

# color = upper_col_list[1:37]
# list <- upper_col_range