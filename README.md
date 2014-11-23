### Introduction

This repository contains my solution to the Course Project for Getting and
Cleaning Data course in Coursera.
See https://www.coursera.org/course/getdata

The repository contains an R script run_analysis.R which implements the
required functionality:

1.  Merges the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation for each
    measurement. 
3.  Uses descriptive activity names to name the activities in the data set
4.  Appropriately labels the data set with descriptive variable names. 
5.  From the data set in step 4, creates a second, independent tidy data set
    with the average of each variable for each activity and each subject.

For the script to work, the following input files are needed (all paths are
relative to R working folder):
* UCI HAR Dataset/features.txt
* UCI HAR Dataset/activity_labels.txt
* UCI HAR Dataset/train/X_train.txt
* UCI HAR Dataset/train/y_train.txt
* UCI HAR Dataset/train/subject_train.txt
* UCI HAR Dataset/test/X_test.txt
* UCI HAR Dataset/test/y_test.txt
* UCI HAR Dataset/test/subject_test.txt
           
The output of running the script consists of two tidy data sets:
* dataSet (steps 1-4)
* secondDataSet (step 5)
