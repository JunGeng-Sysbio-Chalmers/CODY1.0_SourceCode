plotUpperTri <- function (original_data, color, ranges) {
  
  data <- original_data
  
  s1 <- as.character(data[1,1])
  # s1 => species 1 name 
  s2 <- as.character(data[1,2])
  # s2 => species 2 name
  
  mu1 <- as.numeric(data[1,3])
  if (abs(mu1) <= 0.0001) {
    mu1 <- 0
  }
  # mu1 => rate 1
  mu2 <- data[1,4]
  if (abs(mu2) <= 0.0001) {
    mu2 <- 0
  }
  # mu2 => rate 2
  
  location_info <- data.frame(dwX=c(1,2,2), dwY=c(1,1,2), upX=c(1,2,1), upY=c(1,2,2)) 
  # set the coordinate for figure
  
  #color_list <- colorRampPalette(c("blue", "white", "red"), space="Lab")
  
  col1 <- getColFromRange(mu1, color, ranges)
  # col1 => get col by mapping to range
  col2 <- getColFromRange(mu2, color, ranges)
  # col2
  
  ggplot(location_info) +
    geom_polygon(mapping=aes(x=dwX, y=dwY), fill=col1,  alpha=1, lwd=1,size=1) +
    geom_polygon(mapping=aes(x=upX, y=upY), fill=col2,  alpha=1, lwd=1,size=1) +
    geom_abline(intercept = 0, slope = 1, color="#e3f8f9",  size=1.2) +
    annotate("text", x=1.75, y=1.25, label=ifelse(mu1 < 0, "-", ifelse(mu1==0, "0", "+") ), size=8) +
    annotate("text", x=1.25, y=1.75, label=ifelse(mu2 < 0, "-", ifelse(mu2==0, "0", "+")), size=8) +
    scale_y_continuous(expand = c(0,0)) +
    scale_x_continuous(expand = c(0,0)) +
    xlab("") +
    ylab("") +
    theme_bw() +
    theme(axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.title.y=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank(),
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(),
          panel.border = element_rect(colour="#e3f8f9", fill=NA, size=0.9),
          # panel.border = element_blank(),
          # plot.margin = unit(c(0.1, 0.1, 0.1, 0.6), "cm"),
          plot.margin = unit(c(0.45, -0.1, 0.45, 0.45), "cm"),
          text=element_text(family="Helvetica"),
          plot.title = element_blank(),
          aspect.ratio=1)
  
}

getColFromRange <- function(value, color, numRange) {
  
  num_col <- length(color)
  num_range_value <- length(numRange)
  if (num_col != num_range_value - 1) {
    
  }
  
  for (i in 1:(num_range_value-1)) {
    for (j in 2:num_range_value) {
      if (value < numRange[1]) {
        value_col <- color[1]
      } else if (value >= numRange[num_range_value]) {
        value_col <- color[num_range_value]
      } else if (value >= numRange[i] & value < numRange[j]) {
        value_col <- color[i]
      }
    }
  }
  
   return(value_col)
}

######################################
# test getColFraomRange function
# 
# value <- 0.1
# col <- colorRampPalette(c("blue", "white", "red"), space="Lab")(6)
# # [1] "#0000FF" "#9F74FF" "#E3D0FF" "#FFD8CB" "#FF8969" "#FF0000"
# range <- c(-3, -2, -1, 0, 1, 2, 3)
# # [1] -3 -2 -1  0  1  2  3
# getColFromRange(value, col, range)
# # [1] "#FFD8CB"