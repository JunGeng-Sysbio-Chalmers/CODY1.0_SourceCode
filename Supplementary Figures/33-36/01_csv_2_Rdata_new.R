#############
# file IO
#############
library(stringr)
pre_out_filename="./data/community_10tank_adult_concate_profiles_"

lumen_file_1 =  paste0(pre_out_filename,"Lumen_1.csv")
lumen_file_2 = paste0(pre_out_filename,"Lumen_2.csv")
lumen_file_3 = paste0(pre_out_filename,"Lumen_3.csv")
lumen_file_4 = paste0(pre_out_filename,"Lumen_4.csv")

mucosa_file_1 = paste0(pre_out_filename,"Mucosa_1.csv")
mucosa_file_2 = paste0(pre_out_filename,"Mucosa_2.csv")
mucosa_file_3 = paste0(pre_out_filename,"Mucosa_3.csv")
mucosa_file_4 = paste0(pre_out_filename,"Mucosa_4.csv")

blood_file = paste0(pre_out_filename,"Blood.csv")
feces_file = paste0(pre_out_filename,"Feces.csv")

lumen_T1 <- read.csv(lumen_file_1)
save(lumen_T1, file="./Rdata/lumen_T1.Rdata")
lumen_T2 <- read.csv(lumen_file_2)
save(lumen_T2, file="./Rdata/lumen_T2.Rdata")
lumen_T3 <- read.csv(lumen_file_3)
save(lumen_T3, file="./Rdata/lumen_T3.Rdata")
lumen_T4 <- read.csv(lumen_file_4)
save(lumen_T4, file="./Rdata/lumen_T4.Rdata")

mucosa_T1 <- read.csv(mucosa_file_1)
save(mucosa_T1, file="./Rdata/mucosa_T1.Rdata")
mucosa_T2 <- read.csv(mucosa_file_2)
save(mucosa_T2, file="./Rdata/mucosa_T2.Rdata")
mucosa_T3 <- read.csv(mucosa_file_3)
save(mucosa_T3, file="./Rdata/mucosa_T3.Rdata")
mucosa_T4 <- read.csv(mucosa_file_4)
save(mucosa_T4, file="./Rdata/mucosa_T4.Rdata")

blood <- read.csv(blood_file)
save(blood, file="./Rdata/blood.Rdata")

feces <- read.csv(feces_file)
save(feces, file="./Rdata/feces.Rdata")
