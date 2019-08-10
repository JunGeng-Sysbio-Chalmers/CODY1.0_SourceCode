library(ggplot2)

library(grid)
library(gridExtra)
library(ggrepel)
library(ggsci)
library(cowplot)
library(ggthemes)

library(dplyr)
library(tidyr)
library(MASS)
library(reshape2)
library(extrafont)

library(ggpmisc)

####################
# loading functions for plotting
####################
source("speciesPlot_12M.R")
source("metsPlot_12M.R")

####################
# loading data
####################

load("./Rdata_12M/12M_lumen_T1.Rdata")
load("./Rdata_12M/12M_lumen_T2.Rdata")
load("./Rdata_12M/12M_lumen_T3.Rdata")
load("./Rdata_12M/12M_lumen_T4.Rdata")

load("./Rdata_12M/12M_mucosa_T1.Rdata")
load("./Rdata_12M/12M_mucosa_T2.Rdata")
load("./Rdata_12M/12M_mucosa_T3.Rdata")
load("./Rdata_12M/12M_mucosa_T4.Rdata")

load("./Rdata_12M/12M_blood.Rdata")
load("./Rdata_12M/12M_feces.Rdata")
load("./Rdata_12M/12M_rectum.Rdata")

#############
# preprocessing data
#############

# only select 10% of samples from the dataset, and only keep 17 columns
sample_index <- seq(1, nrow(lumen_T1), by=10)

##############################
# lumen
#
##########
# lumen Tank 1 ## 6041 is the begin index of 12m results
index_12m<-6041
lumen_T1_s <- lumen_T1[sample_index, 1:19]
lumen_T1_bac <- lumen_T1_s[,1:9]
colnames(lumen_T1_bac) <- c("t", "Btheta", "Bfragilis", "Blongum", "Bbreve", "Bado", "Ehalli", "Fpransnitzii", "Rintestinalls")
lumen_T1_mets <- lumen_T1_s[, c(1, 10:19)]
colnames(lumen_T1_mets) <- c("t", "macs", "hexose", "succinate", "acetate", "propionate", "lactate", "formate", "ethanol", "butyrate", "h2")


##########
# lumen Tank 2
lumen_T2_s <- lumen_T2[sample_index, 1:19]
lumen_T2_bac <- lumen_T2_s[,1:9]
colnames(lumen_T2_bac) <- c("t", "Btheta", "Bfragilis", "Blongum", "Bbreve", "Bado", "Ehalli", "Fpransnitzii", "Rintestinalls")
lumen_T2_mets <- lumen_T2_s[, c(1, 10:19)]
colnames(lumen_T2_mets) <- c("t", "fiber", "hexose", "succinate", "acetate", "propionate", "lactate", "formate", "ethanol", "butyrate", "h2")


## Jun's Plot, HMO tank1(left top)+ Bfr & Blg (tank1, left botomm) + Acetate tank1(right top) + Butyrate tank1 (right bottom)
# bac_plot1<-lumen_T1_bac[,c(1,2,3,4,5,8)]
bac_plot1<-lumen_T1_bac[,c(1,3,4,8)]
met_plot1<-lumen_T1_mets[,c(1,2,5,6,10)]  ## t, macs, acetate, propionate, butyrate


met_plot2<-lumen_T2_mets[,c(1,5,6,10)]
colnames(met_plot2)[2:4]<-paste(colnames(met_plot2)[2:4], "_2",sep="")
data_plot<-full_join(bac_plot1,met_plot1)

bac_plot1.df<-gather(bac_plot1, -t, key="metabolites", value="concentration")
met_plot1.df<-gather(met_plot1, -t, key="metabolites", value="concentration")
## regrouping data_plot into 4 groups, and then generate facet plot!!

met_plot1.df$group_m<-ifelse( met_plot1.df$metabolites == "macs", "MACs", "SCFA_ASC")
bac_plot1.df$group_m<-ifelse( bac_plot1.df$metabolites == "Bfragilis" | bac_plot1.df$metabolites == "Blongum", "Species", "SCFA_TRS")
data_plot_t<-rbind(bac_plot1.df,met_plot1.df)

## define the sequence of plot
data_plot_t$metabolites <- as.factor(data_plot_t$metabolites)

# data_plot_t$metabolites<-factor(data_plot_t$metabolites, labels=c("Btheta","Bfragilis","Blongum","Bbreve","Fpransnitzii","macs","acetate","propionate","butyrate" ))
data_plot_t$metabolites<-factor(data_plot_t$metabolites, levels=c("macs", "acetate", "Btheta","Bfragilis", "Blongum","Bbreve","propionate" ,"butyrate", "Fpransnitzii"))
data_plot_t$metabolites<-factor(data_plot_t$metabolites, levels=c("macs", "acetate", "Bfragilis", "Blongum","propionate" ,"butyrate", "Fpransnitzii"))


metabolites <- as.character(unique(data_plot_t[, c("metabolites")]))
metabolites_col_set <- data.frame(metabolites=metabolites)
metabolites_col_set$t <- metabolites_col_set$concentration <- 1

# set individual ylim in the figure
# blank_data <- data.frame(metabolites = c("macs", "acetate", "Btheta","Bfragilis", "Blongum","Bbreve","propionate" ,"butyrate", "Fpransnitzii"), 
blank_data <- data.frame(metabolites = c("macs", "acetate", "Bfragilis", "Blongum","propionate" ,"butyrate", "Fpransnitzii"), 
                         x = c(0,1033), y = c(0.01,143,    ## acetate
                                              0.01,5.3,    ## Blongum
                                              # 0.01,4.1,    ## Bbreve
                                              0.01,33,    ## butyrate
                                              0.01,43,    ## macs
                                              # 0.01,4.1,    ## Btheta
                                              0.01,7.3,    ## Bfragilis
                                              0.01,32,    ## propionate
                                              0.01,4.1     ## Fpr
                                              ))
  ## acetate, Bfragilis, acetate_2, macs, Blongum, butyrate, 
# rect_fill_data<-data.frame(x=c(0,1033), y=)

# metabolite_col<-c("")
# plot one line each graph
Macs1_plot <- ggplot(data_plot_t, aes(x=t, y=concentration)) +
  geom_line(lwd=0.32) +
  facet_wrap(~metabolites, ncol=2, scale="free_y") +
  # scale_color_discrete(breaks=metabolites, guide = F)+
  # geom_blank(data=dummy) +
  geom_blank(data = blank_data, aes(x = x, y = y)) +
  geom_rect(data = metabolites_col_set, aes(fill = metabolites),xmin = -Inf,xmax = Inf,
            ymin = -Inf,ymax = Inf,alpha = 0.11) +

  # xlab("Time (h)") +
  # ylab("Concentration") +
  xlab("") +
  ylab("") +
  scale_x_continuous(expand=c(0,0), limits=c(0, 1033.52), breaks=c(0, 302,  604, 906 ), labels=c(0, 10, 20, 30)) +
  # scale_x_continuous(expand=c(0,0), limits=c(0, 1033.52), breaks=302) +
  
  scale_y_continuous(expand=c(0.005,0.01)) +
  # ggtitle("MACs") +
  theme_pander(base_family = "Helvetica", base_size=6) +
  theme(legend.position = "none",
        plot.margin = unit( c(0,0,0,0) , units = "lines" ),
        # panel.grid.major = element_line(size = 0.01, color = "#efefef"),
        panel.grid.minor = element_blank(),
                # panel.background = element_rect(fill="#f9f7ff"),
        panel.spacing = unit(0.25, "lines"),
        panel.border = element_rect(colour = "black", size=1),
        axis.line = element_line(size = 0.5),
        strip.background = element_rect(fill="#F2F3F4"),
        strip.text.x = element_text(margin = margin(0.05,0,0.05,0, "cm"))
  )

Macs1_plot



ggsave(plot = Macs1_plot, filename = "./fig/data_0-12m.pdf", width = 8, height = 5)



