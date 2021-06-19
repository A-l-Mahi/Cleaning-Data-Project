# Loading activity_labels file
activity <- read.table("datasets/activity_labels.txt")
activity[,2] <- as.character(activityLabels[,2])

#Loading features file
features <- read.table("datasets/features.txt")
features[,2] <- as.character(features[,2])

#get any features observation that contains mean or std
featuresIndex <- grep(".*mean.*|.*std.*", features[,2])
featuresNames <- features[featuresIndex,2]

#filter mean and std
featuresNames = gsub('-mean', 'Mean', featuresNames)
featuresNames = gsub('-std', 'Std', featuresNames)
featuresNames <- gsub('[-()]', '', featuresNames)

#Load train dataset
train <- read.table("datasets/train/X_train.txt")[featuresIndex]
trainActivities <- read.table("datasets/train/y_train.txt")
trainSubjects <- read.table("datasets/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

#load train datasets
test <- read.table("datasets/test/X_test.txt")[featuresIndex]
testActivities <- read.table("datasets/test/y_test.txt")
testSubjects <- read.table("datasets/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets
mergeData <- rbind(train, test)
colnames(mergeData) <- c("subject", "activity", featuresNames)

dataMelt <- melt(mergeData, id = c("subject","activity"))

#make the two  variables(i.e subject and activity in to factors)
mergeData$activity <- factor(mergeData$activity, levels = activity[,1], labels = activity[,2])
mergeData$subject <- as.factor(mergeData$subject)

#compute mean for each variable of subject and activity
dataMean <- dcast(dataMelt, subject + activity ~ variable, mean)

#write tidy data
write.table(dataMean, "tidy.txt", row.names = FALSE, quote = FALSE)

