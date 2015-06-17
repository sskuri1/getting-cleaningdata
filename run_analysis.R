path_rf <- file.path(".","UCI HAR Dataset", fsep="/")

library(plyr)

library(dplyr)

#reading data
trainingSet<-read.table(paste(path_rf,"/train/X_train.txt", sep=""), header = F)
testingSet<-read.table(paste(path_rf,"/test/X_test.txt", sep =""), header= F)

#reading the features
features<-read.table(paste(path_rf,"/features.txt",sep=""), header= FALSE)
colNames<- as.vector(features$V2)


#reading activity
trainingActivity<-read.table(paste(path_rf,"/train/y_train.txt", sep = ""), header = F)
testingActivity<-read.table(paste(path_rf,"/test/y_test.txt", sep=""), header = F)

#reading subject
trainingSubject<-read.table(paste(path_rf,"/train/subject_train.txt",sep=""), header = F)
testingSubject<-read.table(paste(path_rf,"/test/subject_test.txt",sep=""), header = F)

#merging datasets (3 steps).
#1. getting complete data 
setComplete<- bind_rows(trainingSet, testingSet)
activityComplete<-bind_rows(trainingActivity, testingActivity)
subjectComplete<-bind_rows(trainingSubject, testingSubject)

#2. naming columns
colnames(setComplete)<- colNames
colnames(activityComplete)<-"activityID"
colnames(subjectComplete)<-"subject"

#3. combine set, activity and subject - 
dataComplete<- cbind(setComplete,subjectComplete, activityComplete)  

#extracting the mean and std columns
dataMeanStd<-subset(dataComplete, select = c(colnames(dataComplete[grep("mean\\(\\)|std\\(\\)",colnames(dataComplete))]), "subject", "activityID"))

#Add activity labels
activityLabels<- read.table(paste(path_rf,"/activity_labels.txt", sep=""), header = F)

  #labels for mean and std data (did not replace id, instead added column)
  for (actId in 1:6) {
  
     dataMeanStd$activityName[dataMeanStd$activityID == actId] <- as.character(activityLabels[actId,2])
    }

  #labels for complete data (did not replace id, instead added column)
  # for (actId in 1:6) {
  #      dataComplete$activityName[dataComplete$activityID == actId] <- as.character(activityLabels[actId,2])
  #  }

#label dataset with descriptive names
  # label data set with descriptive variable names (for mean and std data)
  names(dataMeanStd)<-gsub("^t", "Time", names(dataMeanStd))
  names(dataMeanStd)<-gsub("^f", "Frequency", names(dataMeanStd))
  names(dataMeanStd)<-gsub("Acc", "Accelerometer", names(dataMeanStd))
  names(dataMeanStd)<-gsub("Gyro", "Gyroscope", names(dataMeanStd))
  names(dataMeanStd)<-gsub("Mag", "Magnitude", names(dataMeanStd))
  names(dataMeanStd)<-gsub("BodyBody", "Body", names(dataMeanStd))

  # label data set with descriptive variable names (for complete data)
  # names(dataComplete)<-gsub("^t", "Time", names(dataComplete))
  # names(dataComplete)<-gsub("^f", "Frequency", names(dataComplete))
  # names(dataComplete)<-gsub("Acc", "Accelerometer", names(dataComplete))
  # names(dataComplete)<-gsub("Gyro", "Gyroscope", names(dataComplete))
  # names(dataComplete)<-gsub("Mag", "Magnitude", names(dataComplete))
  # names(dataComplete)<-gsub("BodyBody", "Body", names(dataComplete))

#creates a second, independent tidy data set with the average of each variable for each activity and each subject
  Data2<-aggregate(. ~subject + activityName, dataMeanStd, mean)
  Data2<-Data2[order(Data2$subject,Data2$activityName),]
  write.table(Data2, file = "tidydata.txt",row.name=FALSE)
