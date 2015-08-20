library(dplyr)
setwd("~/SK Files/Coursera/Getting and Cleaning Data/UCI HAR Dataset")

##Read the data into R and check the dimensions (##and first few records##) of each file.
testdat <- read.table("./test/X_test.txt",colClasses="numeric",header=FALSE)
#dim(testdat)
#head(testdat)
testlbl <- read.table("./test/y_test.txt",colClasses="numeric",header=FALSE)
#dim(testlbl)
#head(testlbl)
testsub <- read.table("./test/subject_test.txt",colClasses="numeric",header=FALSE)
#dim(testsub)
#head(testsub)
traindat <- read.table("./train/X_train.txt",colClasses="numeric",header=FALSE)
#dim(traindat)
#head(traindat)
trainlbl <- read.table("./train/y_train.txt",colClasses="numeric",header=FALSE)
#dim(trainlbl)
#head(trainlbl)
trainsub <- read.table("./train/subject_train.txt",colClasses="numeric",header=FALSE)
#dim(trainsub)
#head(trainsub)

##Combine all data for test group and all data for training group.
##Establish a variable that identifies the group.
alltestdat<-cbind(testsub,testlbl,testdat)
alltestdat$group<-"test"
alltraindat<-cbind(trainsub,trainlbl,traindat)
alltraindat$group<-"train"

##Combine test group data and training group data.
alldat<-rbind(alltestdat,alltraindat)
names(alldat)[1]<-"subject"
names(alldat)[2]<-"label"

##Read the activity descriptions associated with the labels.
lbldat <- read.table("activity_labels.txt",colClasses="character",header=FALSE)
#dim(lbldat)
names(lbldat)[1]<-"label"
names(lbldat)[2]<-"activity"
lbldat$label<-as.numeric(lbldat$label)

##Adds the activity descriptions onto the records.
alldat <- merge(alldat, lbldat, by.x="label", by.y="label", sort=FALSE)

##Reads in column names for original data and renames columns.
featdat<-as.character(read.table("features.txt")$V2)
#dim(featdat)
colnames(alldat)[3:(length(featdat)+2)]<-featdat

##Builds a list of variables representing means and standard deviations.
meanstdvars<-grep("mean[:():]|std[:():]",names(alldat)) 

##Chooses only the data corresponding to means and standard deviations.
##This is step 4 of the project!
meanstddat<-alldat[,c(length(featdat)+3, 2, length(featdat)+4, meanstdvars)]

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
meanstdsummary<-aggregate(.~group + subject + activity, data=meanstddat, mean)

##Output the tidy dataset.
write.table(meanstdsummary, file="projecttidydataset.txt", row.names=F, col.names=T)

