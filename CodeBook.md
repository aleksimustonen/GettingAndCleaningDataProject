# Code Book

This is a codebook for "Getting and Cleanng Data, Course Project".

## Data source

- Description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
- Data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Variables

- Subject: The ID of the subject who carried out an activity.
- ActivityName: The name of the activity that was carried out. Individual values can be found in the original data description.
- Measurements: Variable names in the dataset follow the original variable names detailed in the original data description, referenced above.

## Data

This dataset contains
* The codebook: CodeBook.md (this file)
* General instructions: Readme.md
* Tidied data: tidy/tidyData.txt
* Script that reads oiginal data and calculates tidied data: run_analysis.R

## Transformations

In order to carry out the cleanup and calculation to get to a tidy result data (available at https://github.com/aleksimustonen/GettingAndCleaningDataProject/blob/master/tidy/tidyData.txt)
the following transformations were carried out:
1. Relevant parts of the dirty dataset were read in
2. Data was relabeled, based on features.txt and activity_labels.txt in the original dataset
3. Data was filtered in the following fashion: If column label did not contain strings "std" or "mean", they were filtered out.
4. Original data had separate training and test data. These were merged together by subject and activity.
5. Average of each variable of each activity per each subject was calculated using dcast and mean

## Running instructions

Run run_analysis.R

## Implementation details

Source file run_nalysis.R contains implementation details as code comments.