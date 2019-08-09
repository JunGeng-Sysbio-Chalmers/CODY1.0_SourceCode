resamplingTimePoints <- function(tData, points) {
  # if(ncol(tData)>1) {
    tData_header <- tData[,1:2]
    tData_part <- tData[,c(-1, -2)]
  #   } else {
  #   tData_part<-tData
  # }
  
  tData_col_num <- ncol(tData_part)/2
  tData_part_1 <- tData_part[,1:tData_col_num]
  colnames(tData_part_1) <- paste(colnames(tData_part_1), "1", sep="_")
  tData_part_2 <- tData_part[,(tData_col_num+1):(tData_col_num*2)]
  colnames(tData_part_2) <- paste(colnames(tData_part_2), "2", sep="_")
  
  # sampling from 1 to last colum
  sample_points <- seq(1, tData_col_num, by=points)
  sample_1 <- tData_part_1[,sample_points]
  sample_2 <- tData_part_2[,sample_points]
  
  sample_data <- as.data.frame(cbind(tData_header, sample_1, sample_2))
}