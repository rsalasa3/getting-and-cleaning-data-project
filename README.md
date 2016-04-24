# Getting and Cleaning Data Course Project

This is the course project for the Getting and Cleaning Data Coursera course.
The R script, `run_analysis.R`, does the following:

1. Clean up workspace
2. Set working directory 
3. Download and unzip the dataset (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
4. Read in the data from files
5. Merges the training and the test sets to create one data set
6. Extracts only the measurements on the mean and standard deviation for each measurement
7. Uses descriptive activity names to name the activities in the data set
8. Appropriately labels the data set with descriptive variable names
9. Creates a second, independent tidy data set with the average of each variable for each activity and each subject


The end result is shown in the file `tidydata.txt`.
