# download and unzip the data
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile <- "dataset.zip"
download.file(dataUrl, destfile=zipfile)
unzip(zipfile)


# used unix wc command to get nrows

### Load all of X_train.txt, X_test.txt  into tables 
### train: 7352 obs 561 vars; test: 2947 x 561
 xtrain <- read.table("UCI HAR Dataset//train//X_train.txt", colClasses="numeric", nrows=7352)
 xtest <- read.table("UCI HAR Dataset//test//X_test.txt", colClasses="numeric", nrows=2947)

### load all subject_train.txt, subject_test.txt
### 7352 x 1; 2947 x 1: subject number for observation
 subjectTrain <- read.table("UCI HAR Dataset//train//subject_train.txt")
 subjectTest <- read.table("UCI HAR Dataset//test//subject_test.txt")

### make a logical vector of the required columns
### 561 x 2. col 1 is the column number, column 2 has text
 allFeatureLabels <- read.table("UCI HAR Dataset//features.txt")
 requiredFeatureLabels <- grep("mean|std", allFeatureLabels[[2]])

### label the columns for training and test sets
 names(xtrain) <- allFeatureLabels[[2]]
 names(xtest) <- allFeatureLabels[[2]]

### extract the required columns from training set
 xtestRequired <- xtest[,requiredFeatureLabels]
 xtrainRequired <- xtrain[,requiredFeatureLabels]
 
### associate numbers with activity names in ytest, train
 ### ytest and ytrain
 activityLabels  <- read.table("UCI HAR Dataset//activity_labels.txt")
 ytest <- read.table("UCI HAR Dataset//test//y_test.txt")
 ytrain <- read.table("UCI HAR Dataset//train//y_train.txt")
 activitiesTest <- activityLabels[ytest[[1]],]
 activitiesTrain <- activityLabels[ytrain[[1]],]
 names(activitiesTest) <- c("index","activity")
 names(activitiesTrain) <- c("index","activity")
 
 ### connect rows to their activities
 xtestRequired <- cbind(activitiesTest$activity, xtestRequired)
 xtrainRequired <- cbind(activitiesTrain$activity, xtrainRequired)
 
### connect rows to their corresponding subject id
 xtestRequired <- cbind(subjectTest, xtestRequired)
 xtrainRequired <- cbind(subjectTrain, xtrainRequired)
 
### set the names for the two new columns
 names(xtestRequired)[1:2] <- c("subject","activity")
 names(xtrainRequired)[1:2] <- c("subject","activity")
 
### merge the test and training sets
 xmerged <- rbind(xtestRequired, xtrainRequired)
 
### apply naming rules to column names
 labels <- names(xmerged)
 labels <- sub('-m','M',labels)    # change -mean to Mean
 labels <- sub('-s','S',labels)    # change -std to Std
 labels <- sub("\\(\\)","",labels) # remove ()
 labels <- sub('-','',labels)    # remove -
 names(xmerged) <- labels
 
 write.csv(xmerged, file="merged_averages.csv")
 
 ### remove unrequired data structures
 rm("subjectTest", "subjectTrain", "xtest", "xtestRequired", "xtrain", "xtrainRequired", "ytest", "ytrain")
  
 
