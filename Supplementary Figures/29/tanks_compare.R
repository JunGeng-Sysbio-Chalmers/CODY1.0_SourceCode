# library(dplyr)
# library(corrplot)

# library(ggcorrplot)
library(RColorBrewer)
library(ggplot2)
library(reshape2)
library(stringr)
library(readxl)

bacteria_4m_1102 <- read_excel("bacteria_4m.xlsx")
bacteria<-bacteria_4m_1102[1:4,]

# bacteria_12m_1102 <- read_excel("bacteria_12m.xlsx")
# bacteria<-bacteria_12m_1102[1:4,]
colnames(bacteria)[1]<-"Position"
mets_4m<-read_excel("mets_4m.xlsx")

# mets_12m<-read_excel("mets_12m.xlsx")
mets<-mets_4m[1:4,c(1,6,4,5)]   ## prop, but, ac

# mets<-mets_12m[1:4,c(1,6,10,5)]   ## prop, but, ac
colnames(mets)[1]<-"Position"


bacteria$Position <- factor(bacteria$Position, levels=unique(bacteria$Position))
colnames(bacteria)[2:ncol(bacteria)]<-str_replace(colnames(bacteria)[2:ncol(bacteria)],'_','.')
bacteria<-bacteria[c(1,6,2,5,3,4)]
colnames(bacteria)<-c("Position","Bad" ,"Bth", "Bbr", "Bfr", "Blg"  )
# bacteria<-bacteria[c(1,7,5,6,4,2,9,8,3)]
# colnames(bacteria)<-c("Position","Ehallii" ,"Bbr", "Bad", "Blg", "Bth","Rint", "Fpr","Bfr"   )

mets$Position <- factor(mets$Position, levels=unique(mets$Position))
mets<-melt(mets)
bacteria<-melt(bacteria)


col_8 <- brewer.pal(8, "Set3")
col_8 <- brewer.pal(8, "Set1")
col_8 <- brewer.pal(8, "YlOrRd")
col_8 <- brewer.pal(8, "BuGn")
col_8 <- brewer.pal(8, "Greys")

col_8<-c(brewer.pal(n=8,name="Set3")[1:5],rev(brewer.pal(n=8,name="Set3")[6:8]))
col_8<-c("#80B1D3","#FDB462","#B3DE69","#FCCDE5","#8DD3C7","#FFFFB3","#BEBADA","#d87b7d")
col_8<-c("#80B1D3","#FDB462","#B3DE69","#FCCDE5","#8DD3C7","#FFFFB3","#BC80BD","#FB8072")
col_8<-c("#BC80BD","#FDB462","#B3DE69","#FCCDE5","#8DD3C7","#FFFFB3","#80B1D3","#FB8072")
col_8<-c("#BC80BD","#FDB462","#B3DE69","#FB8072","#8DD3C7","#FFFFB3","#80B1D3","#e886ba")
col_8<-c("#BC80BD","#FDB462","#B3DE69","#FB8072","#8DD3C7","#FFFFB3","#80B1D3","#f291c4")
col_8<-c("#BC80BD","#FDB462","#B3DE69","#FB8072","#8DD3C7","#FFFFB3","#80B1D3","#f7aad2")
col_8<-c("#BC80BD","#FDB462","#B3DE69","#FB8072","#8DD3C7","#FFFFB3","#80B1D3","#bdb9d8")    ## chosen color
# col_8<-c("#BC80BD","#FDB462","#B3DE69","#FB8072","#8DD3C7","#FFFFB3","#80B1D3","#fecde4")
species_main5_sondii<-c("#b73276", "#228fa0", "#325780", "#3a8f62", "#b48939")
species_other3_sondii<-c("#8f5360", "#754577", "#a7624f")

col_8<-c(species_main5_sondii,species_other3_sondii)
# col_8<-col_8[c(6,4,5,3,1,8,7,2)]
col_8<-col_8[c(5,1,4,2,3)]

# dat <- data.frame(
#   position_colon = factor(c("Acending","Transverse","Descending","Sigmoid"), 
#                           levels=c("Acending","Transverse","Descending","Sigmoid")),
#   total_bill = c(14.89, 17.23)
# )
# levels(position_colon)=c('ascending','transverse','descending',"sigmoid")

# qplot(name,score,data = a, geom = 'bar')
colnames(bacteria)[2]<-"Species"
p <-ggplot(bacteria, aes(x=Position,y=value,fill=Species))
# p<-p + theme_minimal()
p<-p+theme(panel.grid=element_blank(),panel.border=element_blank(),axis.line=element_line(size=0.1,colour="#5e5e5e"),
           # axis.text.x = element_text(angle = 13, hjust = 1))
           axis.text.x = element_text(angle = 0, hjust = 0.2))

           p<-p+theme(
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  # panel.border = element_rect(
  #   colour = "#5e5e5e",
  #   fill = NA,
  #   size = 0.3)
  text = element_text(size = 24, family = "Helvetica"),
  axis.text = element_text(size = 20, family = "Helvetica"),
  panel.border = element_blank(),
  axis.line = element_line(colour = "#272727", size=1)
)

p<-p +geom_bar(stat = "identity", position=position_dodge())
p<-p + scale_y_continuous(expand = c(0, 0), limits = c(-0.2, 18.8), breaks = c(0, 4,8,12 ))

p <- p + labs(
              # title = "Microbial profiles downstream the colon",
              x="Colon Site",y="Microbial level",
              size = 19, color = "black",family = "Helvetica")
# p<-p + theme(plot.title = element_text(size = 11, color = "black", 
#                                     hjust = 0.5, face = "bold", 
#                                     angle = 30))

# p<-p+scale_fill_brewer(palette="Dark2")
# p<-p+scale_fill_brewer(palette="Accent")
# p<-p+scale_fill_brewer(palette="Set3")
p<-p+scale_fill_manual(values = col_8)

p<- p + theme(legend.position="none") 
p

ggsave("Supplementary_Fig_29a.pdf",device="pdf",width=7.2,height=3.5)


p <-ggplot(mets, aes(x=Position,y=value,fill=variable))
p<-p + theme_minimal()
p<-p+theme(panel.grid=element_blank(),panel.border=element_blank(),axis.line=element_line(size=1,colour="black"))
p<-p +geom_bar(stat = "identity", position=position_dodge())
p<-p + scale_y_continuous(expand = c(0, 0), limits = c(0, 120))

# p<-p + scale_y_continuous(expand = c(0, 0), limits = c(0, 63))
p<-p+theme(plot.background = NULL)
p <- p + labs(title = "Metabolite profiles downstream the colon",x="Colon Position",y="SCFA level",
              size = 13, color = "black")
p<-p + theme(plot.title = element_text(size = 11, color = "black", 
                                       hjust = 0.5, face = "bold", 
                                       angle = 0),
             text = element_text(size = 18, family = "Helvetica"),
             axis.text = element_text(size = 16, family = "Helvetica"),
             panel.border = element_blank())

# p<-p+scale_fill_brewer(palette="Dark2")
# p<-p+scale_fill_brewer(palette="Accent")
p<-p+scale_fill_manual(values = c("lightsalmon2", "darkcyan","lightpink4"))
p<- p + theme(legend.position="top") 
p
ggsave("Supplementary_Fig29b.pdf",device="pdf",width=8,height=5)


