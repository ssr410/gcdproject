#setwd("./data/proj")

library(plyr)

# STEP 1: Merges the training and the test sets to create one data set.
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# create data set 'x'
x_data <- rbind(x_train, x_test)

# create data set 'y'
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)


# STEP 2: Extracts only the measurements on the mean and standard deviation
# for each measurement.

features <- read.table("features.txt")

# get only columns with mean() or std() in their names
mean_std <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_std]

# correct the column names
names(x_data) <- features[mean_std, 2]


# STEP 3: Uses descriptive activity names to name the activities in the data set.

activities <- read.table("activity_labels.txt")

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"


# STEP 4: Appropriately labels the data set with descriptive variable names.

# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)


# STEP 5: From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

# 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)
