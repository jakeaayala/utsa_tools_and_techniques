

library(dplyr)



# read in train, test, and sub files
train.x <- read.table(file = "~/Desktop/Tools and Techniques/UCI HAR Dataset/train/X_train.txt")
test.x <- read.table(file = "~/Desktop/Tools and Techniques/UCI HAR Dataset/test/X_test.txt")

train.y <- read.table(file = "~/Desktop/Tools and Techniques/UCI HAR Dataset/train/Y_train.txt")
test.y <- read.table(file = "~/Desktop/Tools and Techniques/UCI HAR Dataset/test/Y_test.txt")

train.sub <- read.table(file = "~/Desktop/Tools and Techniques/UCI HAR Dataset/train/subject_train.txt")
test.sub <- read.table(file = "~/Desktop/Tools and Techniques/UCI HAR Dataset/test/subject_test.txt")




# merge train, test, and sub
x <- rbind(train.x, test.x)
y <- rbind(train.y, test.y)
subject <- rbind(train.sub, test.sub)

data1 <- cbind(y, x)
data <- cbind(subject, data1)

dim(data)


# read features file
features <- read.table("~/Desktop/Tools and Techniques/UCI HAR Dataset/features.txt")

# name columns in merged data
names(data) <- c("SubjectID", "ActivityName", as.character(features$V2))

str(features)


# extract only mean and std features
sub.sd.mean <- features$V2[grep("-mean\\(\\)|-std\\(\\)", features[, 2])]

selColumns <- c("SubjectID", "ActivityName", as.character(sub.sd.mean))

# subset data to include only selected colunms
data <- subset(data, select = selColumns)




# read activity labels file
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
activity$V2 <- as.character(activity$V2)
data$ActivityName = activity[data$ActivityName, 2]

# replace names with more descriptive names
names(data) <- gsub("^t", "Time", names(data))
names(data) <- gsub("^f", "Frequency", names(data))
names(data) <- gsub("Acc", "Accelerometer", names(data))
names(data) <- gsub("Gyro", "Gyroscope", names(data))
names(data) <- gsub("Mag", "Magnitude", names(data))

# write tidy data to txt
write.table(data, "tidy_data.txt")

str(data)




# group data
data_group <- group_by(data, SubjectID, ActivityName)

# find avg
data_avg <- summarise_each(data_group, funs(mean))



# write to txt
write.table(data_avg, "tidy_avg.txt", row.names = FALSE)





