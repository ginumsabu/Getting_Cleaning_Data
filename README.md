# README

This readme file describes how to recreate the tidy data set that was crated for "Human Activity Recognition Using Smartphones". The tidy dataset provides mean values for variables for each subject and activity.

Execute the accompanying run_analysis.R file to recreate the tidy data set. This script is written to execute on Windowe x64. The script will download the raw data, if it is already not downloaded, from the following URL:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The script will then convert this raw dataset to a tidyset through the following steps:
* 1. Merges the training and the test sets to create one data set.
* 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
* 3. Uses descriptive activity names to name the activities in the data set
* 4. Appropriately labels the data set with descriptive variable names. 
* 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
