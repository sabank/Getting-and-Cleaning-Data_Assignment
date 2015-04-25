READ ME
==============================================================================
author: "Sabank"
date: "25 April 2015"

## 1. INTRODUCTION

This assignment is conducted within the scope of Coursera Getting and Cleaning
Data course. The purpose of this project is to demonstrate the ability to collect,
work with, and clean a data set. For this, we need to prepare tidy data that can
be used for later analysis.

The rep "Getting-and-Cleaning-Data_Assignment" contains:

* 1) a tidy data set called "tidy_dataset" with the required information

* 2) the script "run_analysis.R"

* 3) a code book "codebook.md" that describes the variables, the data, and performed
transformations to clean up the data.

## 2. DATA LOADING
### 2.1 Link, documentation and acknowledgment

A full description is available at the site where the data was obtained:
"http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"

Data for this project com from here:
"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

### 2.2 Useful libraries in R for this work
* library(plyr)

* library(dplyr)

* library(reshape2)

* library(Hmisc)

## 3. DATA PROCESSING
The proposed script allow the following actions:

### 3.1 Reading the file

* download url zip file

* unzip file in working directory

* keep track of date of the download

* load libraries

### 3.2 Reshaping data and verification

* Merges the training and the test sets to create one data set.

* Extracts only the measurements on the mean and standard deviation for each measurement.

* Uses descriptive activity names to name the activities in the data set.

* Appropriately labels the data set with descriptive variable names.

### 3.3 Exporting tidy dataset

* Uploads the tidy data set as a txt file created with write.table() using row.name=FALSE.

* The separator is set as ";".
