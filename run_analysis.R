#loading libraries
library(tidyverse)

###################
###FETCHING DATA###
###################

#downloads compressed data if it doesn't already exist
if (!file.exists('raw_data.zip')) { 
  url = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  download.file(url, destfile = 'raw_data.zip')
}

#unzips data if unzipped folder doesn't already exist
if (!file.exists('UCI HAR Dataset')) { 
  unzip('raw_data.zip', )
}



#######################################
###READING IN LABEL IDENTIFIER FILES###
#######################################

act <- fread(file = 'UCI HAR Dataset/activity_labels.txt') #key for activities i.e. numbers in activity column
feat <- fread(file = 'UCI HAR Dataset/features.txt') #key for features i.e. the third to very last columns



##########################################
###READING IN TRAINING AND TESTING DATA###
##########################################

#reading training data and attached subject/activity labels
tr <- fread(file = 'UCI HAR Dataset/train/X_train.txt') #training data
trlab <- fread(file = 'UCI HAR Dataset/train/y_train.txt') #activity labels
trsub <- fread(file = 'UCI HAR Dataset/train/subject_train.txt') #subject labels
train <- bind_cols(trsub, trlab, tr) #binding these data together

#reading training data and attached subject/activity labels
te <- fread(file = 'UCI HAR Dataset/test/X_test.txt')  #test data
telab <- fread(file = 'UCI HAR Dataset/test/y_test.txt') #activity labels
tesub <- fread(file = 'UCI HAR Dataset/test/subject_test.txt') #subject labels
test <- bind_cols(tesub, telab, te) #binding these data together

#appending training and test data together by row into a single data frame
train.test <- bind_rows(train, test)



########################################################
###ADDING IN APPROPRIATE FEATURE/ACTIVITY IDENTIFIERS###
########################################################

#changing column names to subject, activity, and measured features
colnames(train.test) <- unlist(c('subject', 'activity', feat[, 2]))

#changing activity names in column 2 to match those found in the key
train.test$activity <- act[match(train.test$activity, act$V1), 2]
train.test$activity <- as.factor(train.test$activity) #activities should be factors



########################################
###SUBSETTING TO DESIRED MEASUREMENTS###
########################################

#retain only features containing mean and standard deviations for measurements, plus subject and activity columns
colkeep <- c(1, 2, grep(colnames(train.test), pattern = 'mean|std')) #generating index of columns to keep
train.test <- train.test[, ..colkeep] #remove columns containing data we don't want



##########################################
###CONVERTING ABBREVIATED FEATURE NAMES###
##########################################

#iteratively changing abbreviations in feature column names to their full names
colnames(train.test) <- gsub(colnames(train.test), pattern = '^t{1}', replacement = 'Time')
colnames(train.test) <- gsub(colnames(train.test), pattern = '^f{1}', replacement = 'Frequency')
colnames(train.test) <- gsub(colnames(train.test), pattern = 'Acc', replacement = 'Accelerometer')
colnames(train.test) <- gsub(colnames(train.test), pattern = 'Gyro', replacement = 'Gyroscope')
colnames(train.test) <- gsub(colnames(train.test), pattern = 'Jerk', replacement = 'JerkSignal')
colnames(train.test) <- gsub(colnames(train.test), pattern = 'Mag', replacement = 'Magnitude')
colnames(train.test) <- gsub(colnames(train.test), pattern = 'mean', replacement = 'Mean')
colnames(train.test) <- gsub(colnames(train.test), pattern = 'std', replacement = 'StandardDeviation')

#get rid of parentheses and hyphens
colnames(train.test) <- gsub(colnames(train.test), pattern = '[\\(\\)\\-]', replacement = '')



###############################
###GENERATING SUMMARY TABLES###
###############################

#generating new table containing averages for train.test variables, stratified by subject and activity
train.test.avg <- train.test %>% group_by(subject, activity) %>%
  summarise(across(everything(), mean))



###########################
###EXPORTING TIDIED DATA###
###########################

#writing tidied dataset
train.test.avg %>% write.csv(file = 'tidied_dataset.csv', row.names = FALSE)
