setwd("~/coursera/DataScience/GetCleanData/project")

# download and unzip files

###########
#READ FILES
###########

#test datasets
testdata <- read.table("~/coursera/DataScience/GetCleanData/project/UCI HAR Dataset/test/X_test.txt")
testsubjectdata <- read.table("~/coursera/DataScience/GetCleanData/project/UCI HAR Dataset/test/subject_test.txt")
testlabeldata <- read.table("~/coursera/DataScience/GetCleanData/project/UCI HAR Dataset/test/y_test.txt")


#train datasets
traindata <- read.table("~/coursera/DataScience/GetCleanData/project/UCI HAR Dataset/train/X_train.txt")
trainsubjectdata <- read.table("~/coursera/DataScience/GetCleanData/project/UCI HAR Dataset/train/subject_train.txt")
trainlabeldata <- read.table("~/coursera/DataScience/GetCleanData/project/UCI HAR Dataset/train/y_train.txt")




###############################
# USE DESCRIPTIVE COLUMN NAMES (4th project requirement)
###############################

#extract feature names (to be used for testdata and traindata column names)
features <- read.table("~/coursera/DataScience/GetCleanData/project/UCI HAR Dataset/features.txt")
fnames <- features[,2] #factor
fnames2 <- as.character(fnames) # character vector [1:561]

# assign column names to test dataset
colnames(testdata) <- fnames2
colnames(testsubjectdata) <- c("subjectId")
colnames(testlabeldata) <- c("activity")

# assign column names to training dataset
colnames(traindata) <- fnames2
colnames(trainsubjectdata) <- c("subjectId")
colnames(trainlabeldata) <- c("activity")



#############
# MERGE DATA (1st project requirement)
#############

# merge test datasets
testdata2 <- cbind(testsubjectdata, testlabeldata)
mergedtestdata <- cbind(testdata2, testdata)

# merge training datasetrs
traindata2 <- cbind(trainsubjectdata, trainlabeldata)
mergedtraindata <- cbind(traindata2, traindata)

# merge all datasets
alldata <- rbind(mergedtraindata, mergedtestdata)

numOfVars <- ncol(alldata)
numOfObs <- nrow(alldata)



##################################
# USE DESCRIPTIVE ACTIVITY LABELS (3rd project requirement)
##################################
activities <- read.table("~/coursera/DataScience/GetCleanData/project/UCI HAR Dataset/activity_labels.txt")
activities2 <- activities

#get character vector pf activity labels
activities2$V3 <- as.character(activities2$V2)

#replace activity number with label
for(i in 1:numOfObs) {
  alldata$activity[i] <- activities2[activities2$V1 == alldata$activity[i],]$V3
}



####################################
# EXTRACT mean AND std MEASUREMENTS (2nd project requirement)
####################################

## It is not clear to me what is meant by "extracting" in the project. In particular, 
## whether the resulting dataset should contain only the mean and std measurements
## or whether the R code is meant to specify a new object for the mean and std 
## measurements. I've opted for the second option, which includes all measurements, 
## including the mean and std ones.


# extract mean data
# the extracted object is called "meanData"

#get column names that contain "mean"
meanNames <- grep("mean", names(alldata), value=TRUE) 

#extract mean dataset
meanData <- NULL
for(j in 1:length(meanNames)){
  meanData <- cbind(meanData, alldata[,meanNames[j]])
}

#assign column names
colnames(meanData) <- meanNames




# extract std data
# the extracted object is called "stdData"

# get column names that contain "std"
stdNames <- grep("std", names(alldata), value=TRUE) 

#extract std dataset
stdData <- NULL
for(k in 1:length(stdNames)){
  stdData <- cbind(stdData, alldata[,stdNames[k]])
}

#assign column names
colnames(stdData) <- stdNames




#######################################################
# CREATE DATASET WITH AVERAGES PER ACTIVITY AND SUBJECT (5th project requirement)
#######################################################
s1 <- split(alldata, list(alldata$subjectId, alldata$activity))
averagedataset <- lapply(s1, function(x) colMeans(x[, names(alldata)[3:561]]))

write.table(averagedataset, "~/coursera/DataScience/GetCleanData/project/tidyDataset.txt", row.name=FALSE)
