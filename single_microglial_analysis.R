#Code to process the single microglial cell data 
#Read in the data and load required libraries  
library(ggplot2)
library(dplyr)
library(tiff)
library(rmngb)
library(reshape2)
library(PMCMR)
library(car)
library(FSA)

data<-read.csv("Desktop/Phagocytosis_analysis/single_microglial_analysis.csv")

#Extract the well id and experimental condition 
data$well.id<-sapply(strsplit(x = as.character(data$Label), "_"), "[", 2) 

data$Condition<-as.character(data$well.id)
data$Condition<-sub(data$Condition, pattern = "^A", replacement = "Veh-")
data$Condition<-sub(data$Condition, pattern = "^B", replacement = "ccl3-")
data$Condition<-sub(data$Condition, pattern = "^C", replacement = "NoSyn-")
data$Condition<-sapply(strsplit(x = as.character(data$Condition), "-"), "[", 1) 

aggregate(data$Mean, by=list(data$Condition), median)

#Plot mean intensity per cell, can also plot %area which seems to be more of an effect 
g<-ggplot(data, aes(x=Condition, y=Mean))
g<-g+geom_boxplot(outlier.shape = NA, alpha=0.5, notch = T, fill="magenta", col="magenta")
g<-g+geom_jitter(width = 0.3, alpha=0.3, size=0.3)
g

#Run a statistical test
data$Condition<-as.factor(data$Condition)
kruskal.test(Mean ~Condition, data)
dunnTest(Mean ~ Condition, data, method="bonferroni")

#Can repeat the above using the X.area 

