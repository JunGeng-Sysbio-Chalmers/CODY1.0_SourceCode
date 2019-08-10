require(graphics)
library(stringr)
library(ggplot2)
library(reshape2)



## flow function , y=0.1L/h ##



## nutrients input, 0˜4month ##



## nutrients input, 4˜12month ##



## define a step function using R ##
hours<-c(0,24)
nutrients<-stepfun(hours,c(0.1,0.1,0.1))
tt <- seq(0, 24, by = 6)
plot(nutrients,tt,
     do.points=FALSE,
     fg = gray(0.3),
     # bty = "7" , 
     xoff = 0, xaxs= "i",
     # col="#0570B0",
     col="#7a0177",
     xlim = c(0,24), ylim = c(0, 0.2),
     xpd=FALSE,
     yaxp=c(0,0.2,2),
     verticals = FALSE, 
     lty = "solid", lwd = 2.5,
     tcl=0.4,tck=0.02,
     # yaxs=
     xlab = "Time [h]",
     ylab = "Flow rate [L/h]",
     main = "")



##
hours<-c(0,7,8,12,13,17,18,24)
nutrients<-stepfun(hours,c(0,50,50,50,50,50,50,0))
pdf("flowrate.pdf",width=5,height=3)
plot(seq(0,24,by=6), rep(0.1, 5),type='l',
     cex.lab = 1.15, 
     cex.axis=0.9,
     col.lab="black", 
     font.lab=2, font.axis=2, 
     fg = gray(0.3),
     # bty = "7" , 
     xoff = 0, xaxs= "i",
     # col="#0570B0",
     col="#7a0177",
     xlim = c(0,24), ylim = c(0, 0.2),
     xpd=FALSE,
     yaxp=c(0,0.2,2),
     verticals = FALSE, 
     lty = "solid", lwd = 2.5,
     tcl=0.4,tck=0.02,
     # yaxs=
     xlab = "Time [h]",
     ylab = "Flow rate [L/h]",
     main = "",axes = FALSE)
     axis(side=1, at=seq(0,24,by=6), tcl=0.4, tck=0.03,
          cex.lab = 1.15, 
          cex.axis=0.9,
          col.lab="black", 
          font.lab=2, font.axis=2)
     axis(side = 2,at=seq(0,0.2,by=0.1), tcl=0.4, tck=0.03,
          cex.lab = 1.15, 
          cex.axis=0.9,
          col.lab="black", 
          font.lab=2, font.axis=2)
     box()
dev.off()

# ## nutrients input ##
# hours<-c(0,7,8,12,13,17,18,24)
# nutrients<-stepfun(hours,c(0,0,50,0,50,0,50,0,0),right=FALSE)
# pdf("nutrients_0-4month.pdf",width=5,height=3)
# plot(nutrients,do.points=FALSE,
#      # tcl=0.4, tck=0.03,
#      xlim = c(0,24), ylim = c(0, 60),
#      axes=FALSE,
#      col="#41ae76",lwd = 2.5,
#      cex.lab = 1.15, 
#      cex.axis=0.9,
#      col.lab="black",  
#      # fg = gray(0.3),
#      fg="#efedf5",
#      font.lab=2, font.axis=2,
#      xlab = "Each day [h]",
#      ylab = "Nutrients [mM/L]",
#      main = "0 month To 4 month")
# axis(side=1, at=seq(0,24,by=6), tcl=-0.4, tck=-0.03,
#      cex.lab = 1.15, 
#      cex.axis=0.9,
#      col.lab="black", 
#      font.lab=2, font.axis=2)
# axis(side = 2,at=seq(0,60,by=30), tcl=-0.3, tck=0.03,
#      cex.lab = 1.15, 
#      cex.axis=0.9,
#      col.lab="black", 
#      font.lab=2, font.axis=2)
# box()
# dev.off()
#      

## nutrients input ##

hours<-c(0,3,3.5,6.5,7,10,10.5,13.5,14,17,17.5,20.5,21,24)
nutrients_4month_6diets<-stepfun(hours,c(0,0,50,0,50,0,50,0,50,0,50,0,50,0,0),right=FALSE)
pdf("nutrients_0-4month_6diets.pdf",width=7.5,height=4.1)
plot(nutrients_4month_6diets,do.points=FALSE,
     # tcl=0.4, tck=0.03,
     xlim = c(0,24), ylim = c(0, 60),
     axes=FALSE,
     # col="#41ae76",918805
     col="#918805",
     lwd = 2.5,
     cex.lab = 1.15, 
     cex.axis=0.9,
     col.lab="black",  
     # fg = gray(0.3),
     fg="#efedf5",
     font.lab=2, font.axis=2,
     xlab = "Each day [h]",
     ylab = "Nutrients [mM/L]",
     main = "0 month To 4 month")
axis(side=1, at=seq(0,24,by=6), tcl=-0.4, tck=-0.03,
     cex.lab = 1.15, 
     cex.axis=0.9,
     col.lab="black", 
     font.lab=2, font.axis=2)
axis(side = 2,at=seq(0,60,by=30), tcl=-0.3, tck=0.03,
     cex.lab = 1.15, 
     cex.axis=0.9,
     col.lab="black", 
     font.lab=2, font.axis=2)
box()
dev.off()


hours<-c(0,7,8,12,13,17,18,24)+399
nutrients_12m<-fortify(stepfun(hours,c(0,0,80,0,80,0,80,0,0),right=FALSE))
pdf("nutrients_4-12month.pdf",width=7.1,height=4)
# summary(nutrients_12m)
# unclass(nutrients_12m)
# ls(envir = environment(nutrients_12m))

# diet_12m<-data.frame("time"=hours,"nutrient"=the.nutrients_12m)
# ggplot(nutrients_12m,aes=(hours))
diet_12m<-plot(nutrients_12m,do.points=FALSE,
     # tcl=0.4, tck=0.03,
     xlim = c(0,24)+399, ylim = c(-0.2, 120),
     yaxs="i",xaxs="i",  ## give the exact limit of axis
     axes=FALSE,
     # col="#cc4c02",
     col=alpha("#6d0435",0.67),
     lwd = 3,
     cex.lab = 1.15, 
     cex.axis=0.9,
     col.lab="black",  
     # fg = gray(0.3),
     fg="#efedf5",
     font.lab=2, font.axis=2,
     xlab = "Each day [h]",
     # ylab = "Nutrients [mM/L]",
     ylab="",
     main = "4 month To 12 month")
axis(side=1, at=seq(399,423,by=6), tcl=-0.2, tck=-0.02,
     cex.lab = 1.15, 
     cex.axis=0.9,
     col.lab="black", 
     font.lab=2, font.axis=2)
axis(side = 2,at=seq(0,120,by=60), tcl=-0.2, tck=0.02,
     cex.lab = 1.15, 
     cex.axis=0.9,
     col.lab="black", 
     font.lab=2, font.axis=2)
box()
dev.off()

## 4m data plot
data_4m<-read.table('4m_24h_data_comparison.txt',header=T, row.names=1, sep="\t", stringsAsFactors=T)
data_4m<-data_4m[,-3]
time<-rownames(data_4m)
time<-str_replace(time,',','.')
time<-as.numeric(time)
index_Str<- which(time==69)
index_end<- which(time==93)
# index_Str<- which(time==72)
# index_end<- which(time==96)
data_4m_24h<-data_4m[index_Str:index_end,]
data_4m_24h$time<-time[index_Str:index_end]
data_4m_24h_tt <- melt(data_4m_24h, id="time")  # convert to long format

plot_4m <- ggplot(data_4m_24h_tt,aes(time, value, colour=variable)) +
  geom_line(linetype = "solid", size=1) +

  # scale_x_continuous(limits = c(72, 96), expand = c(0, 0)) +
  scale_x_continuous(limits = c(69, 93), expand = c(0, 0)) +
  
  scale_y_continuous(limits = c(-0.2, 73), expand = c(0, 0)) +
  # scale_fill_manual(values=c("#238b45", "#4eb3d3", "#e31a1c", "#fdbf6f")) +  ## previous color
  # scale_color_manual(values=c("#f6e8c3","#dfc27d", "#bf812d","#8c510a","#c7eae5","#80cdc1","#35978f","#01665e","#e0a494","#90933d")) +    ## add circle line
  # scale_color_brewer(3,type = "qual")+
  scale_color_manual(values=c("#8e7107","#5a6d32","#d87538"))+
   # 
    # scale_fill_manual(values=c("#f1e53b", "#c36031", "#1b764a", "#1384a7","#eff1f2","#f4f4ef")) +
  xlab("Diet Frequency [h]") +
  ylab("Metabolic Profiles") +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # panel.border = element_rect(
    #   colour = "#5e5e5e",
    #   fill = NA,
    #   size = 0.21
    # ),
    panel.border = element_blank(),
    # axis.ticks.length=unit(-0.2, "cm"),
    axis.ticks.margin=unit(-0.1, "cm"),    ## ticker inside
    # panel.border = element_blank(), 
    axis.line = element_line(colour = "#5e5e5e", size=0.07),
    panel.background = element_rect(fill = "transparent", colour = NA),
    text = element_text(size = 9, family = "Helvetica"),
    legend.position = "none",
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.box.background = element_rect(),
    legend.key = element_rect(fill = "transparent", colour = "transparent"),
    legend.key.height = unit(0.6, "line"),
    legend.title = element_blank(),
    legend.text = element_text(size = 8),
    legend.margin = margin(0, 2, 0, -1),
    plot.background = element_rect(fill = "transparent", colour = NA)
  )

plot_4m
ggsave(plot = plot_4m, filename = "./fig/data_4m_24h.pdf", width = 7, height = 3)


## 12m data plot
# nutrients_12m
data_file_12m<-'/Users/gejun/Desktop/Projects/Dynamic_Infant_Microbiome/Data_Visulization/20181027/Figure4/c/Rdata_12M/12M_lumen_T1.Rdata'
# data_12m<-read.table('12m_24h_data_comparison_20180911.txt',header=T, row.names=1, sep="\t", stringsAsFactors=T)
load(data_file_12m)
data_12m<-lumen_T1


# data_4m<-data_4m[,-3]
time<-lumen_T1$Time
# time<-str_replace(time,',','.')
time<-as.numeric(time)
# index_Str<- which(time==137)
# index_end<- which(time==161)
time_str<-438.5
time_end<-462.5  
index_Str<- which(abs(time-time_str)<0.05)
index_end<- which(abs(time-time_end)<0.05)
# data_12m_24h<-data_12m[index_Str:index_end,c("Time","HMO", "HEXOSE", "SUCCINATE", "PROPIONATE","BIOMASS_Bifido.longum")]
data_12m_24h<-data_12m[index_Str:index_end,c("Time","HMO", "HEXOSE", "SUCCINATE")]

# data_12m_24h$time<-time[index_Str:index_end]
data_12m_24h_tt <- melt(data_12m_24h, id="Time")  # convert to long format

plot_12m <- ggplot(data_12m_24h_tt,aes(Time, value, colour=variable)) +
  geom_line(linetype = "solid", size=1) +
  
  # scale_x_continuous(limits = c(125, 153), expand = c(0, 0)) +
  # scale_x_continuous(limits = c(137, 161), expand = c(0, 0)) +
  # scale_x_continuous(limits = c(140, 164), expand = c(0, 0)) +
  scale_x_continuous(limits = c(time_str, time_end), breaks =c(time_str+6, time_str+12, time_str+18), labels =c(6,12,18), expand = c(0, 0)) +
  
    scale_y_continuous(limits = c(-0.2, 157), breaks =c(0, 50, 100),expand = c(0, 0)) +
  # scale_fill_manual(values=c("#238b45", "#4eb3d3", "#e31a1c", "#fdbf6f")) +  ## previous color
  # scale_color_manual(values=c("#f6e8c3","#dfc27d", "#bf812d","#8c510a","#c7eae5","#80cdc1","#35978f","#01665e","#e0a494","#90933d")) +    ## add circle line
  # scale_color_brewer(3,type = "qual")+
  # scale_color_manual(values=c("#af6d95","#5a6d32","#d87538"))+
  scale_color_manual(values=c("#7a0177","#5a6d32","#d87538"))+
  
    # scale_fill_manual(values=c("#f1e53b", "#c36031", "#1b764a", "#1384a7","#eff1f2","#f4f4ef")) +
  xlab("Daily Frequency [h]") +
  ylab("Metabolic Level") +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    # panel.border = element_rect(
    #   colour = "#5e5e5e",
    #   fill = NA,
    #   size = 0.21
    # ),
    panel.border = element_blank(),
    # axis.ticks.length=unit(-0.2, "cm"),
    axis.ticks.margin=unit(-0.1, "cm"),    ## ticker inside
    # panel.border = element_blank(), 
    axis.line = element_line(colour = "#272727", size=0.5),
    panel.background = element_rect(fill = "transparent", colour = NA),
    text = element_text(size = 20, family = "Helvetica"),
    axis.text = element_text(size = 16, family = "Helvetica"),
    legend.position = "none",
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.box.background = element_rect(),
    legend.key = element_rect(fill = "transparent", colour = "transparent"),
    legend.key.height = unit(0.6, "line"),
    legend.title = element_blank(),
    legend.text = element_text(size = 12),
    legend.margin = margin(0, 2, 0, -1),
    plot.background = element_rect(fill = "transparent", colour = NA)
  )
plot_12m

ggsave(plot = plot_12m, filename = "./fig/data_12m_24h.pdf", width =7.2, height = 3.5)

