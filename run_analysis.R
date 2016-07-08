## checking to see if the directory already exists:

if(!file.exists("./projectData")){
  dir.create("./projectData")
  }
Url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

## checking to see if the zip already downloaded:

if(!file.exists("./projectData/project_Dataset.zip")){
  download.file(Url,destfile="./projectData/project_Dataset.zip",mode = "wb")
  }
  
  ##is zip already unzipped:
  
  if(!file.exists("./projectData/UCI HAR Dataset")){
  unzip(zipfile="./projectData/project_Dataset.zip",exdir="./projectData")
}

## Listing the files of the UCI HAR Dataset folder:

path <- file.path("./projectData" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)

## all of the files that will be read:

## activity files!
ActivityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)

## subject files!
SubjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)

## feature files!
FeaturesTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

## (1) Merging the training and the test sets to create one data set:

## data tables!
dataSubject <- rbind(SubjectTrain, SubjectTest)
dataActivity<- rbind(ActivityTrain, ActivityTest)
dataFeatures<- rbind(FeaturesTrain, FeaturesTest)

## naming veriables!
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

## combining data!
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

## (2) Extracts only the measurements on the mean and standard deviation for each measurement:

## features, mean() and std()!
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

## (3) Uses descriptive activity names to name the activities in the data set:

## activity_labels/ names!
activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)

Data$activity<-factor(Data$activity,labels=activityLabels[,2])

head(Data$activity,30)

## (4) Appropriately labels the data set with descriptive variable names:

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

 ## (5) creates a second, independent tidy data set with the average of each variable for each activity and each subject:
 
newData<-aggregate(. ~subject + activity, Data, mean)
newData<-newData[order(newData$subject,newData$activity),]
write.table(newData, file = "tidydata.txt",row.name=FALSE,quote = FALSE, sep = '\t')

## files being used to test data:
# test/subject_test.txt
# test/X_test.txt
# test/y_test.txt
# train/subject_train.txt
# train/X_train.txt
# train/y_train.txt

## all tests and where to test it:

## files being read!
# str(ActivityTest)
# str(ActivityTrain)
# str(SubjectTrain)
# str(SubjectTest)
# str(FeaturesTest)
# str(FeaturesTrain)

## Extracts only the measurements on the mean and standard deviation for each measurement:
#str(Data)

## Appropriately labels the data set with descriptive variable names:
# names(Data)
