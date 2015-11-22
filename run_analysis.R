# run_analysis.R / aleksimustonen
# This file
# 0.1. Downloads a dirty data set as a ZIP.
# 0.2. Extracts the ZIP. The zip should contain training and test data.
# 0.3. Reads in the data.
# 1. Merges training and test data together.
# 2. Extracts fields elated to mean and standard deviation
# 3. Uses descriptive activity names.
# 4. Relabels the data.
# 5. Creates a secondary data set with averaged values.

# Actions listed above follow the numbering given in assignment instructions.
# However, it makes more sense to execute them in a different order so that's what I did.

###########################

# 0.0 Load libraries
install.packages("data.table")
library("data.table")

###########################

# 0.1 & 0.2: Download the data and extract it
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "dirty.zip")
unzip("dirty.zip", exdir="dirty")

###########################

# 0.3. Data reading
# Dirty data is organized in a hierarchical directory structure with multiple files. 
# Traversing the directory structure programmatically is not within the scope of this assignment.

# 0.3.1 List the files, just to take a look
trainingDir <- "./dirty/UCI\ HAR\ Dataset/train"
testDir <- "./dirty/UCI\ HAR\ Dataset/test"
trainingFiles <- list.files(path = trainingDir)
testFiles <- list.files(path = testDir)

# 0.3.2 Read in the training data. This resides in two files: X_train.txt and Y_train.txt
xTrain <- read.table(paste(trainingDir, "/X_train.txt", sep = ""))
yTrain <- read.table(paste(trainingDir, "/Y_train.txt", sep = ""))

# 0.3.3 Read in the test data. This resides in two files: X_test.txt and Y_test.txt
xTest <- read.table(paste(testDir, "/X_test.txt", sep=""))
yTest <- read.table(paste(testDir, "/Y_test.txt", sep=""))

###########################

# 4. Relabel the data. It's better to do it now than later.
# 4.1 Read in the label names. These are found in file called features.txt
dirtyRootDir <- "./dirty/UCI\ HAR\ Dataset"
labelNames <- read.table(paste(dirtyRootDir, "/features.txt", sep=""))
# 4.1.1 The names are in the second column so we only take interest in that
labelNames <- labelNames[,2]
# 4.2 Execute relabeling
names(xTrain) <- labelNames
names(xTest) <- labelNames

###########################

# 3. Use descriptive activity names
# 3.1 Read in activity names. They're found in activity_labels.txt
activityNames <- read.table(paste(dirtyRootDir, "/activity_labels.txt", sep=""))
# 3.1.1 Again, as with the other labels, names are in the second column so we only take interest in that
activityNames <- activityNames[,2]
# 3.2 Set the names to y-data as a new column
key <- yTrain[, 1]
yTrain[, 2] <- activityNames[key]
key <- yTest[, 1]
yTest[, 2] <- activityNames[key]
# 3.3 Y-data is still missing column labels so let's set those by hand
names(yTrain) <- c("ActivityID", "ActivityName")
names(yTest) <- c("ActivityID", "ActivityName")

###########################

# 2. Extract mean and std deviation from data
# 2.1 For this, we don't need all data so let's simplify. Mark labels containing mean or std.
labelsSimple <- grepl("mean|std", labelNames)
# 2.2 Get only marked data.
xTestSimple <- xTest[, labelsSimple]
xTrainSimple <- xTrain[, labelsSimple]

###########################

# 1. Data merging
# Now that we have labeled and simplified (filtered) our data, it is time to get it merged.
# 1.1 Activities were performed by subjects (individuals). Read in the subject IDs.
trainingSubjects <- read.table(paste(trainingDir, "/subject_train.txt", sep = ""))
testSubjects <- read.table(paste(testDir, "/subject_test.txt", sep = ""))
# 1.2 Column-bind subjects and simplified training data together
trainingSubjects <- as.data.table(trainingSubjects)
trainingData <- cbind(trainingSubjects, yTrain, xTrainSimple)
# 1.2 Column-bind subjects and simplified test data together
testSubjects <- as.data.table(testSubjects)
testData <- cbind(testSubjects, yTest, xTestSimple)
# 1.3 Finally row-bind training data and test data together to create one big dataset
simplifiedData <- rbind(testData, trainingData)
# 1.4 Subjects column is still unlabeled. Give it a meaningful name.
setnames(simplifiedData, "V1", "Subject")
columnNames <- colnames(simplifiedData)
# 1.5 Define conditions on which to simplify the dataset and melt it together
meltBy <- c("Subject", "ActivityID", "ActivityName")
meltThese <- setdiff(columnNames, meltBy)
# 1.6 Now melt the data together based on subjects and activities to create a simplified version of the data
simplifiedDataMelted <- melt(simplifiedData, id=meltBy, measure.vars=meltThese)

###########################

# 5. Create a dataset with averaged values.
# 5.1 Calculate the mean
averagedData = dcast(simplifiedDataMelted, Subject + ActivityName ~ variable, mean)
# 5.2 Store the result to a file
if(!file.exists("./tidy")) {
  dir.create("./tidy")
}
write.table(averagedData, file="./tidy/tidyData.txt" )


