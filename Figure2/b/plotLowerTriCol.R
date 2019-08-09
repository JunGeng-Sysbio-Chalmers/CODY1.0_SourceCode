scaleFUN <- function(x) sprintf("%.2f", x)
color_8spc<-c(brewer.pal(n=8,"Dark2")[1:5],"#BC80BD", "#E6AB02", "#80B1D3")

plotLowerTri <- function(original_data, col) {

  

  
    # get species names
  # t<-time_co$`time_data[time_index, ]`
  s1 <-as.character(original_data[[1]])
  s2 <- as.character(original_data[[2]])

  # set the color
  # color_list <- list(
  #   "Bacteroides theta" = "#b73276",
  #   "Bacteroides fragilis" = "#228fa0",
  #   "Bifido longum" = "#325780",
  #   "Bifido breve" = "#3a8f62",
  #   "Bifido adolescentis" = "#b48939",
  #   "Eubacterium hallii" = "#8f5360",
  #   "Faecalibacterium prausnitzii" = "#754577",
  #   "Roseburia intestinalis" = "#a7624f"
  # )
  color_list <- list(
    "Bacteroides theta" = color_8spc[1],
    "Bacteroides fragilis" = color_8spc[2],
    "Bifido longum" = color_8spc[3],
    "Bifido breve" = color_8spc[4],
    "Bifido adolescentis" = color_8spc[5],
    "Eubacterium hallii" = color_8spc[6],
    "Faecalibacterium prausnitzii" = color_8spc[7],
    "Roseburia intestinalis" = color_8spc[8]
  )

  col1 <- color_list[[s1]]
  col2 <- color_list[[s2]]

  data <- unlist(original_data)

  growth1 <- as.vector(unlist(data[3:(((length(data) - 2) / 2) + 2)]))
  growth2 <- as.vector(unlist(data[(((length(data) - 2) / 2) + 3):length(data)]))

  new_data <- data.frame(
    # t = 1:length(growth1),
    t=0:24,
    # t = as.vector(t),
    g1 = growth1,
    g2 = growth2
   )
  # new_data<-gather(new_data1,species,growth,g1:g2,factor_key = TRUE) 

  
  
  
  
  

  if (identical(s1, s2)) {
    ggplot(new_data, aes(t)) +
      geom_line(aes(x=t, y = g1), colour = col1, lwd = 1) +
      # geom_point(aes(y = g1), colour = col1, pch = 2) +
      ylim(0, 5) +
      # scale_y_continuous(labels=scaleFUN) +
      scale_x_continuous(limits = c(0,24), breaks = c(0,10,20)) +
      xlab("") +
      ylab("") +
      theme_linedraw() +
      theme(
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        # panel.border = element_rect(colour = "#A9A9A9", fill = NA, size = 0.6),
        panel.border = element_rect(colour = "#e3f8f9", fill = NA, size = 0.6),

        # panel.border = element_rect(colour="#808080", fill=NA, size=0.6),
        plot.margin = unit(c(0.1, 0.1, 0.1, 0.1), "cm"),
        #plot.margin = unit(c(0., 0., 0., 0.), "cm"),
        plot.title = element_blank(),
        axis.title.y = element_blank(),
        aspect.ratio = 1
      )
    # theme1()
  }
  else {
    ggplot(new_data, aes(t)) +
    # ggplot(new_data, aes(x=t,y=growth,colour=species)) +
      
          #annotate("text", x=5, y=3, label=s1, col=col1, fontface="italic", size=8, family="Arial") +
      #annotate("text", x=5, y=2, label=s2, col = col2, fontface="italic", size=8, family="Arial") +
      geom_line(aes(x=t,y = g1), colour = col1, lwd = 1.2) +
      geom_line(aes(x=t,y = g2), colour = col2, lwd = 1.2) +
      # geom_line(aes(colour=species),lwd=1.2)+
      # scale_color_manual(values=c(col1,col2))+
      ylim(0, 5)+
    
     
      # scale_y_continuous(labels=scaleFUN) +
      scale_x_continuous(limits = c(0,24), breaks = c(0,10,20)) +
      # xlab("") +
      ylab("") +
      theme_linedraw() +
      theme(
        axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        # axis.ticks.x = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        # panel.border = element_rect(colour = "black", fill = NA, size = 0.6),
        panel.border = element_rect(colour = "#4b8ea3", fill = NA, size = 0.5),
        # plot.margin = unit(c(0.1, 0.1, 0.1, 0.1), "cm"),
        plot.margin = unit(c(0.45, -0.1, 0.45, 0.45), "cm"),
        text = element_text(family = "Helvetica"),
        plot.title = element_blank(),
        axis.title.y = element_blank(),
        legend.position="none",
        aspect.ratio = 1
      )
     # theme1()
  }
}
