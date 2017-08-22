install.packages("plyr")
install.packages("dplyr")

library(plyr)
library(dplyr)

#Step 1: Merges the training and the test sets to create one data set.

fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destination <- "./assignmentData.zip"

if(!file.exists(destination)){  download.file(fileurl,destination)}

dataDirName<-"UCI HAR Dataset"

if(!file.exists(dataDirName)){unzip(destination)}

xtestdatapath<-paste(".",dataDirName,"test","X_test.txt",sep="/")
xtestsubjectdatapath<-paste(".",dataDirName,"test","subject_test.txt",sep="/")
ytestdatapath<-paste(".",dataDirName,"test","Y_test.txt",sep="/")

xtestdata<-read.table(xtestdatapath)
xtestsubjectdata<-read.table(xtestsubjectdatapath)
ytestdata<-read.table(ytestdatapath)

xtraindatapath<-paste(".",dataDirName,"train","X_train.txt",sep="/")
xtrainsubjectdatapath<-paste(".",dataDirName,"train","subject_train.txt",sep="/")
ytraindatapath<-paste(".",dataDirName,"train","Y_train.txt",sep="/")

xtraindata<-read.table(xtraindatapath)
xtrainsubjectdata<-read.table(xtrainsubjectdatapath)
ytraindata<-read.table(ytraindatapath)

xtestdata<-cbind(xtestsubjectdata,ytestdata,xtestdata)
xtraindata<-cbind(xtrainsubjectdata,ytraindata,xtraindata)
mergedData<-rbind(xtestdata,xtraindata)

#Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.
featuresdatapath<-paste(".",dataDirName,"features.txt",sep="/")

featuresdata<-read.table(featuresdatapath)

colnames(mergedData)[1:2]<-c("Subject","Activity")
colnames(mergedData)[3:563]<-as.character(featuresdata$V2)

mergeddatasubsetcolumns<-grepl("mean\\(\\)|std\\(\\)",names(mergedData))

validcolumnnames <- make.names(names=names(mergedData), unique=TRUE, allow_ = TRUE)
names(mergedData)<-validcolumnnames

mergeddatasubset<-select(mergedData,Subject,Activity,which(mergeddatasubsetcolumns))

#Step 3: Uses descriptive activity names to name the activities in the data set

activityname<-c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING")
mergeddatasubset<-mutate(mergeddatasubset,Activity=activityname[Activity])

#Step 4: Appropriately labels the data set with descriptive variable names. 

colnames(mergeddatasubset)<-gsub("^t","Time",colnames(mergeddatasubset))
colnames(mergeddatasubset)<-gsub("^f","Frequency",colnames(mergeddatasubset))
colnames(mergeddatasubset)<-gsub("BodyBody","Body",colnames(mergeddatasubset))
colnames(mergeddatasubset)<-gsub("\\.\\.\\.","\\.",colnames(mergeddatasubset))
colnames(mergeddatasubset)<-gsub("\\.\\.","\\.",colnames(mergeddatasubset))
colnames(mergeddatasubset)<-gsub("\\.$","",colnames(mergeddatasubset))
colnames(mergeddatasubset)<-gsub("mean","Mean",colnames(mergeddatasubset))
colnames(mergeddatasubset)<-gsub("std","StdDev",colnames(mergeddatasubset))

#Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidyColMeans <- function(data) { colMeans(data[,-c(1,2)]) }
tidyDataSet <- ddply(mergeddatasubset, c("Subject", "Activity"), tidyColMeans)

write.table(tidyDataSet, "tidyDataSet.txt")