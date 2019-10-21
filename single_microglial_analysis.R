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

data<-read.csv("~/Google Drive (mdolan@broadinstitute.org)/Phagocytosis_20191018/single_microglial_analysis.csv")

#Extract the well id and experimental condition 
data$well.id<-sapply(strsplit(x = as.character(data$Label), "_"), "[", 2) 

data$Condition<-as.character(data$well.id)
data$Condition<-sub(data$Condition, pattern = "^A", replacement = "pbs-")
data$Condition<-sub(data$Condition, pattern = "^B", replacement = "ccl3-")
data$Condition<-sub(data$Condition, pattern = "^C", replacement = "ccl4-")
data$Condition<-sub(data$Condition, pattern = "^D", replacement = "ccl3ccl4-")
data$Condition<-sapply(strsplit(x = as.character(data$Condition), "-"), "[", 1) 
#Do reality check to make sure the data is all there?  

##PLOT DATA BY CELL 
#Plot mean intensity per cell, can also plot %area which seems to be more of an effect 
g<-ggplot(data, aes(x=reorder(Condition, Mean), y=Mean))
g<-g+geom_boxplot(outlier.shape = NA, alpha=0.5, notch = T, fill="magenta", col="magenta")
g<-g+geom_jitter(width = 0.3, alpha=0.3, size=0.3)
g<-g+coord_cartesian(ylim=c(600,1000))
g

#Run a statistical test
data$Condition<-as.factor(data$Condition)
kruskal.test(Mean ~Condition, data)
dunnTest(Mean ~ Condition, data, method="bonferroni")

##PLOT DATA BY WELL 
#Plot the data by well to aggregate analysis 
ag.data<-aggregate(data$Mean, by = list(data$well.id), FUN = mean)
colnames(ag.data)<-c("well.id", "Mean")
ag.data$Condition<-as.character(ag.data$well.id)

#Port the names to this aggregated dataset 
ag.data$Condition<-sub(ag.data$Condition, pattern = "^A", replacement = "pbs-")
ag.data$Condition<-sub(ag.data$Condition, pattern = "^B", replacement = "ccl3-")
ag.data$Condition<-sub(ag.data$Condition, pattern = "^C", replacement = "ccl4-")
ag.data$Condition<-sub(ag.data$Condition, pattern = "^D", replacement = "ccl3ccl4-")
ag.data$Condition<-sapply(strsplit(x = as.character(ag.data$Condition), "-"), "[", 1) 

g<-ggplot(ag.data, aes(x=reorder(Condition, Mean), y=Mean))
g<-g+geom_boxplot(outlier.shape = NA, alpha=0.5, notch = T, fill="magenta", col="magenta")
g<-g+geom_jitter(width = 0.3, alpha=0.3, size=0.3)
#g<-g+coord_cartesian(ylim=c(600,1000))
g

#Run a statistical test
ag.data$Condition<-as.factor(ag.data$Condition)
kruskal.test(Mean ~Condition, ag.data)
dunnTest(Mean ~ Condition, ag.data, method="bonferroni")





