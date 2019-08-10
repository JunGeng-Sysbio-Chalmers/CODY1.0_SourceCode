# library(dplyr)
# library(corrplot)

# library(ggcorrplot)
library(RColorBrewer)
library(ggplot2)
library(reshape2)
library(stringr)
library(readxl)
library(tidyverse)
# library(ggsci)
# library(ggpubr)

# library(ComplexHeatmap)
# library(extrafont)
# fonts()
rsqred<-function (x,y) {
  y_hat <- y
  y <- x
  y_bar = mean(y)
  RSS = sum((y-y_hat)^2)
  TSS = sum((y-y_bar)^2)
  R2 = 1 - RSS/TSS
  return(R2)
}
################################
# step 2: load related data
################################
## 12month

metabolite<-read.delim(file = "Fece_metabolites", sep = "\t", header = T, stringsAsFactors = F)
metabolite$Time<-str_replace(metabolite$Time,"m4","(4m)")
metabolite$Time<-str_replace(metabolite$Time,"m12","(12m)")
metabolite$Metabolites<-paste0(metabolite$Metabolites,sep=" ",metabolite$Time)
# metabolite$Time<-factor(metabolite$Time)
rsqred(metabolite$Experiment,metabolite$Prediction)   ## 

metabolite<-gather(metabolite,data,value,Prediction:Experiment,factor_key=TRUE)
metabolite$Metabolites<-factor(metabolite$Metabolites)
# metabolite$Metabolites<-factor(metabolite$Metabolites,levels = c("Acetate (4m)","Propionate (4m)","Acetate (12m)",
#                                "Butyrate (12m)","Propionate (12m)"))
metabolite$Metabolites<-factor(metabolite$Metabolites,levels = c("Act (4m)","Prop (4m)","Act (12m)",
                                                                 "Buty (12m)","Prop (12m)"))



p <-ggplot(metabolite, aes(x=Metabolites,y=value,fill=data,width=.5))
p<-p + theme_minimal()
p<-p +geom_bar(stat = "identity", position=position_dodge())
p<-p + scale_y_continuous(expand = c(0, 0), limits = c(0, 90))
p<-p+theme(plot.background = NULL)
p <- p +
   labs(x="",y="SCFA (mmol/kg feces)",size = 28, color = "black",family = "Helvetica")
p
p<-p + theme(
#           plot.title = element_text(size = 11, color = "black", 
#                                        hjust = 0.5, face = "bold", 
#                                        angle = 0),
             text = element_text(size = 24, colour="black",family = "Helvetica"),
             axis.text = element_text(size = 24, colour="black", family = "Helvetica"),
             # panel.border = element_blank(),
             panel.border = element_rect(colour = "black",size=1.25,fill = "transparent"),
             axis.line=element_line(size=0.5,colour="black"),
             panel.grid=element_blank(),
             axis.text.x = element_text(size = 24, colour="black", family = "Helvetica",vjust=-1.5),
             axis.title.y = element_text(vjust=5),
             
             axis.ticks.length=unit(0.42, "line"),
             axis.ticks = element_line(colour = "black", size = 0.7)
             # axis.title.x = element_text(vjust=-10)
             )
# p<-p+theme(panel.grid=element_blank(),panel.border=element_blank())

# p<-p+scale_fill_brewer(palette="Dark2")
# p<-p+scale_fill_brewer(palette="Accent")
p<-p+scale_fill_manual(values = c("lightsalmon2", "#5d8e92","lightpink4"))
p<- p + theme(legend.position="top",legend.text=element_text(size=26)) 
p


# ggsave("SCFA_profile_feces.pdf",device="pdf",width=11,height=5.1)











