
# read training data

trainingSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
training_X <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
training_y <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)

testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
test_X <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)

feature_names <- read.table("./UCI HAR Dataset/features.txt", as.is=TRUE, header = FALSE)

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
colnames(activity_labels) <- c("activityId", "activityLabel")



#Merge the training and the test sets to create one data set.

subjects <- rbind(trainingSubjects, testSubjects)
activity <- rbind(training_y, test_y)
features <- rbind(training_X, test_X)

names(subjects) <- c("subject")
names(activity) <- c("activity")
names(features) <- feature_names[,2]

dataCombine <- cbind(subjects, activity)
data <- cbind(features, dataCombine)



#Extracts only the measurements on the mean and standard deviation for each measurement.

columnsToKeep <- grepl("subject|activity|mean|std", colnames(data))

# ... and keep data in these columns only
data <- data[, columnsToKeep]

data$activity <- factor(data$activity, levels = activity_labels[,1], labels = activity_labels[,2])

#prefix t is replaced by time
#Acc is replaced by Accelerometer
#Gyro is replaced by Gyroscope
#prefix f is replaced by frequency
#Mag is replaced by Magnitude
#BodyBody is replaced by Body

names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

library(plyr);
data2<-aggregate(. ~subject + activity, data, mean)
data2<-data2[order(data2$subject,data2$activity),]
write.table(data2, file = "tidydata.txt",row.name=FALSE)

