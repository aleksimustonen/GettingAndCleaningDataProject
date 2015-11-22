# run_analysis.R / aleksimustonen
# This file
# 0.1. Downloads a dirty data set as a ZIP.
# 0.2. Extract the ZIP. The zip should contain training and test data.
# 1. Merges training and test data together.
# 2. Extracts mean and standard deviation
# 3. Uses descriptive activity names.
# 4. Relabels the data.
# 5. Stores the tidied data. Creates a secondary data set with averaged values.

# Actions listed above follow the numbering given in assignment instructions.
# However, it makes more sense to execute them in a different order so that's what I did.

###########################

# 0.0 Load libraries
install.packages("data.table")
library("data.table")

###########################

# Steps 0.1 & 0.2: Download the data and extract it
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "dirty.zip")
unzip("dirty.zip", exdir="dirty")

###########################

# Step 1. Data merging
# Dirty data is organized in a hierarchical directory structure with multiple files. 
# Traversing the directory structure programmatically is not within the scope of this assignment.

# 1.1 List the files, just to take a look
trainingDir <- "./dirty/UCI\ HAR\ Dataset/train"
testDir <- "./dirty/UCI\ HAR\ Dataset/test"
trainingFiles <- list.files(path = trainingDir)
testFiles <- list.files(path = testDir)

# 1.2 Read in the training data. This resides in two files: X_train.txt and Y_train.txt
xTrain <- read.table(paste(trainingDir, "/X_train.txt", sep = ""))
yTrain <- read.table(paste(trainingDir, "/Y_train.txt", sep = ""))

# 1.3 Read in the test data. This resides in two files: X_test.txt and Y_test.txt
xTest <- read.table(paste(testDir, "/X_test.txt", sep=""))
yTest <- read.table(paste(testDir, "/Y_test.txt", sep=""))

# 4. Relabel the data. It's better to do it now than later.
# 4.1 Read in the label names. These are found in file called features.txt
dirtyRootDir <- "./dirty/UCI\ HAR\ Dataset"
labelNames <- read.table(paste(dirtyRootDir, "/features.txt", sep=""))
# 4.1.1 The names are in the second column so we only take interest in that
labelNames <- labelNames[,2]
# 4.2 Execute relabeling
names(xTrain) <- labelNames
names(xTest) <- labelNames

