# CODY1.0 SourceCode
========================================
 CODY - A MATLAB(R) Package for 
 Dynamic Modeling of Gut Microbiota
======================================

Version:    1.0

Home Page:  To be added later

Authors:    Jun Geng <gejun@chalmers.se>

            Friday, Feb. 23, 2019

%   by Jun Geng, Chalmers University of Technology, Gothenburg, SE
%   Copyright (c) 2015-2019 by System biology, Chalmers University

The folder Figure1 ----> provides the data and code to produce the
                         figures in Fig.1 
The folder Figure2 ----> provides the data and code to produce the 
                         figures in Fig.2, and coculture, Supplementary Fig.6
The folder Figure3 ----> provides the data and code to produce the 
                         figures in Fig.3 and spatiotemporal 
                         profiles from newborn to 12 month
The folder Figure4 ----> provides the data and code to produce the 
                         Figure4.

------------------------------------------------------------------------
About simulation code : CODY1.0 
------------------------------------------------------------------------
### Main Figure 
Figure1 ----> Pipeline of CODY platform, including three multiscale frameworks

Figure2 ----> Fig2a ---> a+Supp_Fig_6---->
                          Figure2a.m------>Fig2a
                          Supplementary_Fig6a.m--->Supp Fig 6a
                          Supplementary_Fig6b.m--->Supp Fig 6b
Figure2 ----> Fig2b ---> main_pairwise.m-->
                            ./data/pairwise_growth.xlsx-->
                            format_table.pl--> PureCulture.csv
                            Biomass_tab.txt MaxMu_tab.txt --->
                            Figure2b.R --->Figure2b.pdf
                            
Figure3 ----> Fig3a ---> draw_multi_donut_Fig3a.R---->Evaluation of 
Infant cohort in vitro variability---->Figure3a.pdf
                            
Figure3 ----> Fig3b ---> Box_formula_mixed_Fig3b.R--->
                         dynamic changes of Infant fecal microbiome
                         ---->Figure3b.pdf
                         
Figure3 ----> Fig3c ---> metabolite_barplot_Fig3c.R--->
                         dynamic changes of Infant fecal SCFA
                         ---->Figure3c.pdf
                         
Figure3 ----> Fig3d ---> Fig3d.R--->
                         Evaluation of Adult in vitro microbial variability
                         ---->Figure3d.pdf
                         
Figure3 ----> Fig3e ---> Jitter_Fig3e.R--->
                         dynamic changes of Adult fecal microbiota
                         ---->Figure3e.pdf
                         
Figure3 ----> microbiome and metabolite profiles from newborn to
                            12 month--->main_HMO_5spc_BFeeding.m 
                            --->20181024_4m_diet_302h.mat---->
                            ./Results/
                            Community_10tanks_output_Feces_4m_68sample_302h.xlsx
                            main_SF_8spc_SFeeding.m---->
                            20181029_12m_diet_732h.mat---->
                            ./Results/
                            Community_10tanks_output_Feces_12m_68sample_732h.xlsx
                            ----> ./lineplot ----> 
                            convert csv to R.data---->
                            02_line_plot_v1_12M_1103.R----->
                            fig_12M, supp figures of microbiome
                            and metabolite profiles
                            
Figure4 ----> Fig4a ---> 02_line_plot_4a.R---->./fig/
                         data_0-12m.pdf
                         
Figure4 ----> Fig4b ---> Bac_heatmap.R---->Fig4b.pdf
                         
Figure4 ----> Fig4c ---> Mets_heatmap_0to12m.R---->Fig4c.pdf

Figure4 ----> Fig4d ---> Fig4d.R---->
                         flowrate.pdf
                         nutrients_0-4month_6diets.pdf
                         nutrients_4-12month.pdf
                         ./fig/data_12m_24h.pdf
                         ./fig/data_12m_24h.pdf
                         
Figure4 ----> Fig4e ---> tanks_compare.R---->Fig4e.pdf

Figure4 ----> Fig4f ---> Fig4f.R---->PCA_no_legend.pdf

Figure4 ----> Fig4g ---> Fig4g.R---->line_prediction_exp.pdf--->
                         comparison between model predictions on 
                         in vitro microbial variability at time-scale with
                         that of clinical measurements
                         
### Supplementary 
Folder: Supplementary Figures

  Supp Fig 1----> Step by Step paradigm of CODY framework
  
  Supp Fig 2----> phylogenetic distance among microbial ecosystem members
  
  Supp Fig 3----> Pure culture simulation --->main_PureCulture.m ---> Supplementary Fig.3
  
  Supp Fig 4----> Sensitivity analysis --->Supplementary_Fig4.m
  
  Supp Fig 5----> metabolic capacity
  
  Supp Fig 7---->one region of each compartment illustration for colon model
  
  Supp Fig 8---->Supplementary_Fig8.m----> evaluation of colon model with condition 1
  
  Supp Fig 9---->Supplementary_Fig9.m----> evaluation of colon model with condition 2
  
  Supp Fig 10---->Supplementary_Fig9.m----> evaluation of colon model with condition 3

  Supp Fig 11---->Supplementary_Fig9.m----> evaluation of colon model with condition 4
  
  Supp Fig 12---->Supplementary_Fig9.m----> evaluation of colon model with condition 5
  
  Supp Fig 13---->evaluation of colon model with condition 6
  
  Supp Fig 14---->evaluation of colon model with condition 6 for SCFA production
  
  Supp Fig 15---->Supplementary_Fig28.R---->Diet regime for different periods
  
  Supp Fig 16---->Venn diagram of most abundant twenty species from three dominant phyla
  
  Supp Fig 17---->a/b/c/d Comparison between smaller-scale ecosystem to original microbiota
  
  Supp Fig 18-20---->Line plot of infant cohort dynamic microbial variability--->02_line_plot.R
  With calculation process in "Figure3/lineplot_infant"
  
  Supp Fig 21----->Supplementary_Fig21.R---->Coefficient of determination for evaluation of CODY predictions for the infant cohort
  
  Supp Fig 23-27----->Line plot of infant cohort dynamic metabolite variability--->02_line_plot.R
  With calculation process in "Figure3/lineplot_infant"
  
  Supp Fig 28---->Comparison of microbial variability changes and metabolite changes----> Supplementary_Fig_28.R
  
  Supp Fig 29---->Comparison of site-specific differences of both microbial variability and metabolite variability---->Supplementary_Fig_29.R
  
  Supp Fig 30-32---->PCA analysis of lumen-,mucus-,and feces- specific dynamic microbial growth
  
  Supp Fig 33-36---->Line plot of adult cohort dynamic microbial variability--->02_line_plot.R
  With calculation process in "Figure3/lineplot_adult"

####Supplementary Datasets

Folder: Supplementary Datasets
         
         
