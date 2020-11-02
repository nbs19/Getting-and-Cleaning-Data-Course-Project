# Peer Graded Assignment: Getting and Cleaning Data Course Project

# Read feature list and activity names
features_list <- read.table("features.txt", col.names = c("no","features"))
activity <- read.table("activity_labels.txt", col.names = c("label", "activity"))


# Read test dataset and combine into one dataframe
sbj_test <- read.table("test/sbj_test.txt", col.names = "sbj")
x_test <- read.table("test/X_test.txt", col.names = features_list$features)
y_test <- read.table("test/Y_test.txt", col.names = "label")
y_test_label <- left_join(y_test, act, by = "label")

td_test <- cbind(sbj_test, y_test_label, x_test)
td_test <- select(td_test, -label)


# Read train dataset
sbj_train <- read.table("train/sbj_train.txt", col.names = "sbj")
x_train <- read.table("train/X_train.txt", col.names = features_list$features)
y_train <- read.table("train/Y_train.txt", col.names = "label")
y_train_label <- left_join(y_train, act, by = "label")

td_train <- cbind(sbj_train, y_train_label, x_train)
td_train <- select(td_train, -label)

# Merges the training and the test sets to create one data set.
td_set <- rbind(td_test, td_train)

# Extracts only the measurements on the mean and standard deviation for each measurement
td_mean_std <- select(td_set, contains("mean"), contains("std"))

# Averanging all variable by each subject each activity
td_mean_std$sbj <- as.factor(td_set$sbj)
td_mean_std$act<- as.factor(td_set$act)

td_avg <- td_mean_std %>%
  group_by(sbj, act) %>%
  summarise_each(funs(mean))

