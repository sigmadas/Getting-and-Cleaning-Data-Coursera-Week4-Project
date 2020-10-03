library(dplyr) 

# set dataset directory
setwd("C:\\Users\\A2150\\OneDrive - Axtria\\Work\\R self-learning\\data\\getdata_projectfiles_UCI HAR Dataset\\UCI HAR Dataset")

# read training data 
x_train   <- read.table("./train/X_train.txt")
y_train   <- read.table("./train/Y_train.txt") 
subject_train <- read.table("./train/subject_train.txt")

# read testing data 
x_test   <- read.table("./test/X_test.txt")
y_test   <- read.table("./test/Y_test.txt") 
subject_test <- read.table("./test/subject_test.txt")

# read other files
features <- read.table("./features.txt") 
activity_labels <- read.table("./activity_labels.txt") 

names(x_train)

#Creating correct column name
colnames(x_train) = features[,2]
colnames(y_train) = "activity"
colnames(subject_train) = "subject"

colnames(x_test) = features[,2]
colnames(y_test) = "activity"
colnames(subject_test) = "subject"

#Create sanity check for the activity labels value
colnames(activity_labels) <- c('activity','activityType')

train_data = cbind(y_train, subject_train, x_train)
test_data = cbind(y_test, subject_test, x_test)

#merging tables
mrg_all = rbind(train_data, test_data)



# keep only measurements for mean and standard deviation
colNames = colnames(mrg_all)
mean_std = (grepl("activity" , colNames) | grepl("subject" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))


mean_and_std <- mrg_all[ , mean_std == TRUE]

Final_data = merge(mean_and_std, activity_labels, by='activity', all.x=TRUE)

# create a summary independent tidy dataset from final dataset 
# with the average of each variable for each activity and each subject. 
mean_val <- Final_data  %>% group_by(activity, subject) %>% summarize_all(funs(mean)) 

# export summary dataset
write.table(mean_val, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE) 
