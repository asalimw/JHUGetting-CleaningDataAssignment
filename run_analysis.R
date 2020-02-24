## Install and loading dplyr packages ##
install.packages("dplyr")
library("dplyr")

## Download the data from UCI ##
fileName <- "Coursera_DS3_Final.zip"
if (!file.exists(fileName)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename, method="curl")
}  

## Check if file exist ##
if (!file.exists("UCI HAR Dataset")) { 
    unzip(fileName) 
}

## Reading and Assigning Data ##
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt") 

## 1. Merge the training and the test sets to create one data set ##
xComData <- rbind(x_train, x_test)



## 2. Extract only the measurements on the mean and standard deviation for each measurement
mean_std <- grepl("mean\\(\\)|std\\(\\)", features[, 2])
meanStdData <- mergeData[, mean_std]


## 4. Appropriately labels the data set with descriptive variable names.cleanNames <- sapply(features[, 2], function(x) {gsub("[()]", "",x)})
cleanNames <- sapply(features[, 2], function(x) {gsub("[()]", "",x)})
names(meanStdData) <- cleanNames[mean_std]

## Combine All Data ##
yComData <- rbind(y_train, y_test)
names(yComData) <- "activity"
subjectComData <- rbind(subject_train, subject_test)
names(subjectComData) <- "subject"
mergeData <- cbind(subjectComData, yComData, xComData)

## 3. Uses descriptive activity names to name the activities in the data set ##
mergeData$activity <- activity_labels$V2[match(mergeData$activity,activity_labels$V1)]


## 5.  creates a second, independent tidy data set with the average of each variable for each activity and each subject. ##
install.packages("reshape2")
library("reshape2")
firstData <- melt(mergeData,(id.vars=c("subject","activity")))
secondDataSet <- dcast(firstData, subject + activity ~ variable, mean)
names(secondDataSet)[-c(1:2)] <- paste("[mean of]" , names(secondDataSet)[-c(1:2)] )
write.table(secondDataSet, "tidy_data.txt", sep = ",", row.name=FALSE)
