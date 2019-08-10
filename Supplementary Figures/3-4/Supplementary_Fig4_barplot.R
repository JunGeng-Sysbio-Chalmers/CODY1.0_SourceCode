library(tidyverse)
library(stringr)
library(tidyr)
# plotting
library(ggsci)
library(scales)
show_col(pal_npg("nrc", alpha = 0.6)(10))
library(ggplot2)
library(Rmisc) 
library(plyr)
library(ggpubr)

# fonts
library(extrafont)
fonts()

library(RColorBrewer)
library(ggthemes)

current_working_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_working_dir)
# setwd('./data')
all_sensitivity_files<-list.files(path=".",pattern = "*_RMSE_sensitivity_analysis.txt", full.names = TRUE, ignore.case = TRUE)
# all_sensitivity_files<-list.files(path=".")>%> grep("RMSE_sensitivity_analysis.txt", files, value = TRUE)


# Bacteroides_thetaRMSE_sensitivity_analysis <- read.csv("~/Desktop/Projects/Dynamic_Infant_Microbiome/Data_Visulization/Parameter sensitivity analysis/PureCulture/Bacteroides_thetaRMSE_sensitivity_analysis.txt", header=FALSE)
# sensitivity_data<-read.csv('Bacteroides_thetaRMSE_sensitivity_analysis.txt',header=TRUE)

data_Sensi<-data.frame()
for (i in 1:length(all_sensitivity_files)){
  sensitivity_file<-all_sensitivity_files[i]
  sensitivity_data<-read.csv(sensitivity_file,header=TRUE)
  rownames(sensitivity_data)<-c("95%","100%","105%")
  sensitivity_data<-cbind(c("95%","100%","105%"),sensitivity_data)
  colnames(sensitivity_data)[1]<-"CI"
  sensitivity<-gather(sensitivity_data,kmax, value, kmax1:colnames(sensitivity_data)[ncol(sensitivity_data)],factor_key=TRUE)
  a<-strsplit(sensitivity_file,"/")[[1]][2]
  sensitivity$Species<-strsplit(a,"_RMSE")[[1]][1]
  data_Sensi<-rbind(data_Sensi,sensitivity)
  # return(data_Sensi)
}

data_Sensi$Species <- factor(data_Sensi$Species, levels = c("Bacteroides_theta", "Bacteroides_fragilis", "Bifido_longum", "Bifido_adolescentis", "Eubacterium_hallii"))
data_Sensi$Species

species_name <- c("Bacteroides_theta", "Bacteroides_fragilis", "Bifido_longum", "Bifido_adolescentis", "Eubacterium_hallii")

data_Sensi$CI <- factor(data_Sensi$CI, levels = c("95%", "100%", "105%"))
data_Sensi$CI
# all_summary <- aggregate(value~ kmax+Species, mean, data=data_Sensi)
# all_summary_sd <- aggregate(value~ kmax+Species, sd, data=data_Sensi)
# data_Sensi<-spread(data_Sensi,CI,value)
# colnames(data_Sensi)[3:5]<-c("Mean","Mean_sdm","Mean_sdp")
# data_Sensi$`0`
my_col<-c(brewer.pal(n=9,name="Set1"),brewer.pal(n=8,name="Set2"),brewer.pal(n=9,name="Set3"))

line_plot <- ggplot(data_Sensi, aes(x=CI,y=value,group=kmax, fill= kmax, colour=kmax )) +
  geom_point(aes(colour=kmax),size=0.75)+
  geom_line()+
  # geom_bar(stat="identity", colour="black") + 
  facet_grid(Species ~. ) + theme_bw()+
  # geom_errorbar(aes(x=CI, ymin=Mean_sdm,ymax=Mean_sdp),size=0.65,
  #            width=0.35, position=position_dodge(.9))+
  scale_fill_manual(values=my_col)+
  # geom_point(aes(color=strain)) +
  # scale_color_manual(values=as.character(col_8[1:7])) +
  # #geom_point(aes(color=strain)) +
  # geom_line(linetype = "dashed", color="black", lwd=0.6) +
  # # facet_grid(strain ~.) +
  # facet_grid(strain ~., scales="free_y") +
  # geom_rect(data = species_col_set, inherit.aes=FALSE,
  #           aes(fill = species,xmin = xl,xmax = xm,ymin = yl,ymax = ym),
  #           alpha = 0.2) +
  xlab("Parameters Vairations (%)") +
  ylab("RMSE of Model Simulations") +
  # scale_fill_manual(values=as.character(col_8[1:7]))+
  #geom_smooth(method='lm') +
  theme_pander(base_family = "helvetica", base_size = 10) +
  #   theme(
  #   legend.title = element_blank(), legend.position = "none",
  #   panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  #   #panel.background = element_blank(),
  #   panel.border = element_rect(colour = "black", fill = NA, size = 1),
  #   text = element_text(size = 10, family = "Arial"),
  #   plot.title = element_text(hjust = 0.5),
  #   axis.line = element_line(color = "black", size = 0),
  #   axis.text = element_text(size = 10, family = "Arial"),
  #   axis.title = element_text(size = 10, face = "bold", family = "Arial"),
  #   axis.text.x = element_text(size = 10, family = "Arial")
# )
theme(legend.position = "none",
      plot.margin = unit( c(0.5,0.5,0.5,0.5) , units = "lines" ),
      text = element_text(size = 10, family = "Helvetica"),
      axis.text = element_text(size = 7, family = "Helvetica",colour = "black"),
      
      panel.spacing = unit(0.5, "lines"),
      panel.border = element_rect(colour = "black", size=0.7),
      panel.grid = element_line(size = 0.0001, linetype = 2, color="#fefefe"),
      axis.line = element_line(size = 0.15),
      strip.background = element_rect(fill="#F2F3F4"),
      strip.text.x = element_text(margin = margin(0.05,0,0.05,0, "cm"))
)

line_plot

ggsave("line_v3-0503.pdf", line_plot, height = 16, width = 9, units = "cm")
ggsave("line_v3-0503.jpg", line_plot, height = 16, width = 9, units = "cm", dpi = 300)




# df<-aggregate(. ~ kmax+Species, data_Sensi, function(x) c(mean=mean(x), sd=sd(x)))
df<-ddply(data_Sensi,~kmax+Species,summarise,mean=mean(value),sd=sd(value))

data_Sensi<-spread(data_Sensi,Species,value)
df1<-na.omit(data_Sensi[,1:3])
colnames(df1)[3]<-"value"
df1<-ddply(df1,~kmax,summarise,mean=mean(value),sd=sd(value))
# df1<-spread(df1,CI,value)
# colnames(df1)[2:4]<-c("low","mean","upper")


df2<-na.omit(data_Sensi[,c(1:2,4)])
colnames(df2)[3]<-"value"
df2<-ddply(df2,~kmax,summarise,mean=mean(value),sd=sd(value))


df3<-na.omit(data_Sensi[,c(1:2,5)])
colnames(df3)[3]<-"value"
df3<-ddply(df3,~kmax,summarise,mean=mean(value),sd=sd(value))


df4<-na.omit(data_Sensi[,c(1:2,6)])
colnames(df4)[3]<-"value"
df4<-ddply(df4,~kmax,summarise,mean=mean(value),sd=sd(value))


df5<-na.omit(data_Sensi[,c(1:2,7)])
colnames(df5)[3]<-"value"
df5<-ddply(df5,~kmax,summarise,mean=mean(value),sd=sd(value))

# df <- data_Sensi %>%
#   group_by(kmax, Species) %>%
#   summarise(mean_CI = mean(CI), se_CI = se(CI))
my_col<-c(brewer.pal(n=9,name="Set1"),brewer.pal(n=8,name="Set2"),brewer.pal(n=9,name="Set3"))

line_plot1 <-ggplot(df1, aes(x = kmax, y = mean, fill=kmax)) +
  geom_bar(stat = "identity",width =0.75) +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd),width=0.3, size=0.75) +
  # geom_errorbar(data=df1,aes(ymin = low, ymax = upper),width=0.3, size=0.75) +
 #  ylab("RMSE Range")+
 #  scale_fill_manual(values=my_col)+
 #  # facet_wrap(Species ~. )
 # theme_bw()
  geom_bar(stat = "identity",width =0.75) +
  geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd),width=0.3, size=0.75) +
  ylab("RMSE Range")+
  scale_y_continuous(limits = c(-0.2, 10.3), expand = c(0, 0)) +

  # facet_wrap(Species ~. )
  scale_fill_manual(values=my_col)+
  theme(
    legend.title = element_blank(), legend.position = "none",
    panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    #panel.background = element_blank(),
    panel.border = element_rect(colour = "black", fill = NA, size = 0.75),
    text = element_text(size = 9, family = "Helvetica"),
    plot.title = element_text(hjust = 0.5),
    axis.line = element_line(color = "black", size = 0),
    axis.text = element_text(size = 9, family = "Helvetica"),
    # axis.title = element_text(size = 10, face = "bold", family = "Helvetica"),
    axis.text.x = element_text(size = 9, family = "Helvetica",angle = 30, hjust = 1)
  )+
  ggtitle(species_name[1])
line_plot1
output1<-paste("./Sensitivity_analysis_figures/",species_name[1],".pdf")
# ggsave("./Sensitivity_analysis_figures/-0530.pdf", all_plot, height = 9, width = 27, units = "cm")
ggsave(output1, line_plot1, height = 7, width = 8, units = "cm")


  
  line_plot2 <-ggplot(df2, aes(x = kmax, y = mean, fill=kmax)) +
    # geom_bar(stat = "identity") +
    # geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd)) +
    # ylab("RMSE Range")+
    # # facet_wrap(Species ~. )
    # scale_fill_manual(values=my_col)+
    # theme_bw()
    geom_bar(stat = "identity",width =0.75) +
    geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd),width=0.3, size=0.75) +
    ylab("RMSE Range")+
    scale_y_continuous(limits = c(-0.2, 10.3), expand = c(0, 0)) +
    
    # facet_wrap(Species ~. )
    scale_fill_manual(values=my_col)+
    theme(
      legend.title = element_blank(), legend.position = "none",
      panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      #panel.background = element_blank(),
      panel.border = element_rect(colour = "black", fill = NA, size = 0.75),
      text = element_text(size = 9, family = "Helvetica"),
      plot.title = element_text(hjust = 0.5),
      axis.line = element_line(color = "black", size = 0),
      axis.text = element_text(size = 9, family = "Helvetica"),
      # axis.title = element_text(size = 10, face = "bold", family = "Helvetica"),
      axis.text.x = element_text(size = 9, family = "Helvetica",angle = 30, hjust = 1)
    )+
    ggtitle(species_name[2])
  line_plot2
  output2<-paste("./Sensitivity_analysis_figures/",species_name[2],".pdf")
  # ggsave("./Sensitivity_analysis_figures/-0530.pdf", all_plot, height = 9, width = 27, units = "cm")
  ggsave(output2, line_plot2, height = 7, width = 12, units = "cm")
  
  
  line_plot3 <-ggplot(df3, aes(x = kmax, y = mean, fill=kmax)) +
    # geom_bar(stat = "identity") +
    # geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd)) +
    # ylab("RMSE Range")+
    # # facet_wrap(Species ~. )
    # scale_fill_manual(values=my_col)+
    # theme_bw()
    geom_bar(stat = "identity",width =0.75) +
    geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd),width=0.3, size=0.75) +
    ylab("RMSE Range")+
    scale_y_continuous(limits = c(-0.4, 20.3), expand = c(0, 0)) +
    
    # facet_wrap(Species ~. )
    scale_fill_manual(values=my_col)+
    theme(
      legend.title = element_blank(), legend.position = "none",
      panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      #panel.background = element_blank(),
      panel.border = element_rect(colour = "black", fill = NA, size = 0.75),
      text = element_text(size = 9, family = "Helvetica"),
      plot.title = element_text(hjust = 0.5),
      axis.line = element_line(color = "black", size = 0),
      axis.text = element_text(size = 9, family = "Helvetica"),
      # axis.title = element_text(size = 10, face = "bold", family = "Helvetica"),
      axis.text.x = element_text(size = 9, family = "Helvetica",angle = 30, hjust = 1)
    )+
    ggtitle(species_name[3])
  line_plot3
  output3<-paste("./Sensitivity_analysis_figures/",species_name[3],".pdf")
  # ggsave("./Sensitivity_analysis_figures/-0530.pdf", all_plot, height = 9, width = 27, units = "cm")
  ggsave(output3, line_plot3, height = 7, width = 10, units = "cm")
  
  
  line_plot4 <-ggplot(df4, aes(x = kmax, y = mean, fill=kmax)) +
    # geom_bar(stat = "identity") +
    # geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd)) +
    geom_bar(stat = "identity",width =0.75) +
    geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd),width=0.3, size=0.75) +
    ylab("RMSE Range")+
    scale_y_continuous(limits = c(-0.2, 20.3), expand = c(0, 0)) +
    
    # facet_wrap(Species ~. )
    scale_fill_manual(values=my_col)+
    theme(
      legend.title = element_blank(), legend.position = "none",
              panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              #panel.background = element_blank(),
              panel.border = element_rect(colour = "black", fill = NA, size = 0.75),
              text = element_text(size = 9, family = "Helvetica"),
              plot.title = element_text(hjust = 0.5),
              axis.line = element_line(color = "black", size = 0),
              axis.text = element_text(size = 9, family = "Helvetica"),
              # axis.title = element_text(size = 10, face = "bold", family = "Helvetica"),
              axis.text.x = element_text(size = 9, family = "Helvetica",angle = 30, hjust = 1)
          )+
    ggtitle(species_name[4])
  line_plot4
  output4<-paste("./Sensitivity_analysis_figures/",species_name[4],".pdf")
  # ggsave("./Sensitivity_analysis_figures/-0530.pdf", all_plot, height = 9, width = 27, units = "cm")
  ggsave(output4, line_plot4, height = 7, width = 20, units = "cm")
  
  
  line_plot5 <-ggplot(df5, aes(x = kmax, y = mean, fill=kmax)) +
    # geom_bar(stat = "identity") +
    # geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd)) +
    # ylab("RMSE Range")+
    # # facet_wrap(Species ~. )
    # scale_fill_manual(values=my_col)+
    # theme_bw()
    geom_bar(stat = "identity",width =0.75) +
    geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd),width=0.3, size=0.75) +
    ylab("RMSE Range")+
    scale_y_continuous(limits = c(-0.2, 5.3), expand = c(0, 0)) +
    
    # facet_wrap(Species ~. )
    scale_fill_manual(values=my_col)+
    theme(
      legend.title = element_blank(), legend.position = "none",
      panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
      #panel.background = element_blank(),
      panel.border = element_rect(colour = "black", fill = NA, size = 0.75),
      text = element_text(size = 9, family = "Helvetica"),
      plot.title = element_text(hjust = 0.5),
      axis.line = element_line(color = "black", size = 0),
      axis.text = element_text(size = 9, family = "Helvetica"),
      # axis.title = element_text(size = 10, face = "bold", family = "Helvetica"),
      axis.text.x = element_text(size = 9, family = "Helvetica",angle = 30, hjust = 1)
    )+
    ggtitle(species_name[5])
  line_plot5
  output5<-paste("./Sensitivity_analysis_figures/",species_name[5],".pdf")
  ggsave(output5, line_plot5, height = 7, width = 8.3, units = "cm")
  
  gs = list(ggplotGrob(line_plot1), ggplotGrob(line_plot2), ggplotGrob(line_plot3), ggplotGrob(line_plot4), ggplotGrob(line_plot5))
  
  library(gridExtra)
  # grid.arrange(
  #   grobs = gs,
  #   widths = c(1, 1, 1,2,1),
  #   layout_matrix = rbind(c(1, 2, 3),
  #                         c(4, 5, NA))
  # )
  grid.arrange(
    grobs=gs,
    # ncol=3,
    widths = c(1,1,1,2,1),
    layout_matrix = rbind(c(1, 2, 3),
                          c(4, 5, NA))
  )
  all_plot <- ggarrange(line_plot1,line_plot2,line_plot3,line_plot4,line_plot5,  legend = FALSE)
  all_plot <-ggpubr::ggarrange(line_plot1,line_plot2, line_plot3,line_plot4,line_plot5, common.legend = TRUE, legend = "right",ncol=1,align = "v")

  all_plot
  # ggsave("./Sensitivity_analysis_figures/line_v3.pdf", all_plot, height = 9, width = 27, units = "cm")
  
