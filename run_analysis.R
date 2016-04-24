##############################################################
# Getting and Cleaning Data Course Project
# 2016-04-24
# 

# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names.
# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
##############################################################

# Clean up workspace
rm(list=ls())
#set working directory 
setwd('/home/lambao/projetos/projetos_R/cleaning_data_course/project/');

## Download and unzip the dataset:
filename <- "uci_har_dataset.zip"
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

#set working directory to the location where the UCI HAR Dataset was unzipped
setwd('/home/lambao/projetos/projetos_R/cleaning_data_course/project/UCI HAR Dataset/');

# Read in the data from files
activityLabels = read.table('./activity_labels.txt',header=FALSE);
features     = read.table('./features.txt',header=FALSE);
subjectTrain = read.table('./train/subject_train.txt',header=FALSE);
xTrain       = read.table('./train/X_train.txt',header=FALSE);
yTrain       = read.table('./train/y_train.txt',header=FALSE);

subjectTest = read.table('./test/subject_test.txt',header=FALSE);
xTest       = read.table('./test/X_test.txt',header=FALSE);
yTest       = read.table('./test/y_test.txt',header=FALSE);

# 1.Merges the training and the test sets to create one data set.
dataSubject <- rbind(subjectTrain, subjectTest)
dataActivity <- rbind(yTrain, yTest)
dataFeatures <- rbind(xTrain, xTest)

activityLabels[,2] <- as.character(activityLabels[,2])
features[,2] <- as.character(features[,2])
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
names(dataFeatures) <- features$V2
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
subdataFeaturesNames<-features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

# 3.Uses descriptive activity names to name the activities in the data set
Data$activity<-factor(Data$activity)
Data$activity<- factor(Data$activity,labels=as.character(activityLabels$V2))


# 4.Appropriately labels the data set with descriptive variable names.
colNames  = colnames(Data)

for (i in 1:length(colNames)) 
{
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("-std$","StdDev",colNames[i])
  colNames[i] = gsub("-mean","Mean",colNames[i])
  colNames[i] = gsub("^(t)","time",colNames[i])
  colNames[i] = gsub("^(f)","freq",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
}

colnames(Data) = colNames

# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(plyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)