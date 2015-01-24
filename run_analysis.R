

#read data from files

#read activity data
dataActivityTest  <- read.table(file.path(getwd(), "UCI HAR Dataset/test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(getwd(), "UCI HAR Dataset/train", "Y_train.txt"),header = FALSE)
#read subject data
dataSubjectTest  <- read.table(file.path(getwd(), "UCI HAR Dataset/test" , "subject_test.txt" ),header = FALSE)
dataSubjectTrain <- read.table(file.path(getwd(), "UCI HAR Dataset/train", "subject_train.txt"),header = FALSE)
#read features data
dataFeatureTest  <- read.table(file.path(getwd(), "UCI HAR Dataset/test" , "X_test.txt" ),header = FALSE)
dataFeatureTrain <- read.table(file.path(getwd(), "UCI HAR Dataset/train", "X_train.txt"),header = FALSE)

# merge the dataset 
dataActivity<-rbind(dataActivityTest,dataActivityTrain)
dataSubject<-rbind(dataSubjectTest,dataSubjectTrain)
dataFeatures<-rbind(dataFeatureTest,dataFeatureTrain)

#set the names to variable
names(dataSubject)<-c("subject")
names(dataActivity)<-c("activity")
names(dataFeatures)<-c("features")

dataFeaturesNames <- read.table(file.path(getwd(), "UCI HAR Dataset/features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2


#Merge columns to get the data frame for all data
dataCombine<-cbind(dataSubject,dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#Extracts only the measurments on the mean and standard deviation for each measurment
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

#subset the data frame by selected names of features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#uses descriptive activity names to namethe activities in the data set
activityLabels <- read.table(file.path(getwd(), "UCI HAR Dataset/activity_labels.txt"),header = FALSE)

#Appropriate labels the data set with desciptive variable names

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))


#creating second independent dataset

library(plyr)
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

#creating CodeBook.md
write.table(paste("* ", names(Data2), sep=""), file="CodeBook.md", quote=FALSE,row.names=FALSE, col.names=FALSE, sep="\t")
