
library(reshape2)
library(dplyr)

file <- "getdata_dataset.zip"

if (!file.exists(file)){
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(url, file, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file) 
}

activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity.labels[,2] <- as.character(activityLabels[,2])

features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

train <- read.table("UCI HAR Dataset/train/X_train.txt")
names(train) <- features$V2
train <- train[ , grepl( "mean" , names( train ) ) | grepl( "std" , names( train ) ) ]

train.activities <- read.table("UCI HAR Dataset/train/Y_train.txt")
train.subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(train.subjects, train.activities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")
names(test) <- features$V2
test <- test[ , grepl( "mean" , names( test) ) | grepl( "std" , names( test ) ) ]
test.activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test.subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test.subjects, test.activities, test)

allData <- rbind(train, test)

names(allData)[1] <- "subject"

names(allData)[2] <- "activity"

allData$activity <- factor(allData$activity, levels = activity.labels[,1], labels = activity.labels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
