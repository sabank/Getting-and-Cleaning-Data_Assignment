# CodeBook
Sabank  
April 25, 2015  

## 1. INTRODUCTION

Dataset: UCI HAR Dataset [282Mb]

Description: Measurements of human activity using Smartphones Dataset.

The initial dataset includes the following files:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The script "run_analysis" processes the following data:

- 'fileUrl': capture the link to URL file

- 'zipfilName': store zip file in working directory

- 'dateDownloaded': capture date of download

- 'path, pathtest, pathtrain': define path to parent and children folders

- 'files': store names of files of interest

- 'actlab, features, subj_test, x_test, y_test, subj_train, x_train, y_train': read content of respective files

_ 'namecol, dupcol': variables to manipulate column names and duplicated column in files

_ 'test_mg, train_mg, newtest_mg, newtrain_mg': variable to manipulate merging and reshaping

- 'test_f, train_f': final and cleaned version of dataset for each set

- 'cleandata': output from merged data test_f and train_f

- 'newdataset': output from melted/reshaped cleandata to be exported as tidy_dataset


## 2. DATA LOADING

```r
## download url zip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfileName <- "./getdata-fuci-har.zip"
download.file (fileUrl, zipfileName, "curl") 
## unzip file in working directory
unzip(zipfileName, exdir = "./")
## keep track of date of the download
dateDownloaded <- Sys.Date()
## load libraries
library(plyr); library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:plyr':
## 
##     arrange, count, desc, failwith, id, mutate, rename, summarise,
##     summarize
## 
## The following object is masked from 'package:stats':
## 
##     filter
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
library(reshape2); library(Hmisc)
```

```
## Loading required package: grid
## Loading required package: lattice
```

```
## Warning: package 'lattice' was built under R version 3.1.3
```

```
## Loading required package: survival
## Loading required package: splines
## Loading required package: Formula
```

```
## Warning: package 'Formula' was built under R version 3.1.3
```

```
## Loading required package: ggplot2
```

```
## Warning: package 'ggplot2' was built under R version 3.1.3
```

```
## 
## Attaching package: 'Hmisc'
## 
## The following objects are masked from 'package:dplyr':
## 
##     combine, src, summarize
## 
## The following objects are masked from 'package:plyr':
## 
##     is.discrete, summarize
## 
## The following objects are masked from 'package:base':
## 
##     format.pval, round.POSIXt, trunc.POSIXt, units
```
This file was last downloaded the 2015-04-25

## 3. DATA PROCESSING
### 3.1 Reading the file

```r
## as the folder contains subfolder for each set, read txt file is organized to
## capture the different files
# parent folder
path <- "./UCI HAR Dataset/"
# folder 'test'
pathtest <- paste0(path,"test/")
# folder 'train'
pathtrain <- paste0(path,"train/")
# names of files of interest
files <- c("activity_labels", "features",
           "subject_test", "X_test", "Y_test",
           "subject_train", "X_train", "Y_train")
# read files from parent    
actlab <- read.table(paste0(path, files[1], ".txt"), stringsAsFactors = FALSE)
features <- read.table(paste0(path, files[2], ".txt"), stringsAsFactors = FALSE)
# read files from test
subj_test <- read.table(paste0(pathtest, files[3], ".txt"), stringsAsFactors = FALSE)
x_test <- read.table(paste0(pathtest, files[4], ".txt"), stringsAsFactors = FALSE)
y_test <- read.table(paste0(pathtest, files[5], ".txt"), stringsAsFactors = FALSE)
# read files from train
subj_train <- read.table(paste0(pathtrain, files[6], ".txt"), stringsAsFactors = FALSE)
x_train <- read.table(paste0(pathtrain, files[7], ".txt"), stringsAsFactors = FALSE)
y_train <- read.table(paste0(pathtrain, files[8], ".txt"), stringsAsFactors = FALSE)
```

### 3.2 Reshaping data and verification

```r
# rename column names in 'actlab'
colnames(actlab) <- c("activity"," actlab")
# list names from 'features'
namecol <- as.character(features$V2)
    
## reshape 'test' data
# update column names in subj_test, x_test and y_test
colnames(subj_test) <- "subject"
colnames(y_test) <- "activity"
colnames(x_test) <- namecol
# create new variable 'category' and merge data in 'test_mg'
subj_test <- mutate(subj_test, category = "test")
y_test <- merge(y_test, actlab, by = "activity", sort=FALSE)
test_mg <- cbind(subj_test, y_test, x_test)
# remove duplicated column from 'test_mg'and store in 'newtest_mg'
dupcol <- duplicated(colnames(test_mg))
newtest_mg <- test_mg[,!dupcol]
# select required (i.e mean and std) column and store in 'test_f'
test_f <- select(newtest_mg, 1:4, contains("-mean"), contains("-std"))

## reshape 'train' data
# update column names in subj_train, x_train and y_train
colnames(subj_train) <- "subject"
colnames(y_train) <- "activity"
colnames(x_train) <- namecol
# create new variable 'category' and merge data in 'train_mg'
subj_train <- mutate(subj_train, category = "train")
y_train <- merge(y_train, actlab, by = "activity", sort=FALSE)
train_mg <- cbind(subj_train, y_train, x_train)
# remove duplicated column from 'train_mg'and store in 'newtrain_mg'
dupcol <- duplicated(colnames(train_mg))
newtrain_mg <- train_mg[,!dupcol]
# select required column (i.e mean and std) column and store in 'train_f'
train_f <- select(newtrain_mg, 1:4, contains("-mean"), contains("-std"))

## this compares train_f and test_f
# same column names
#identical(colnames(test_f), colnames(train_f))
# dimensions
#dim(test_f); dim(train_f)
```

### 3.3 Exporting tidy dataset

```r
## creating tidy dataset
# new dataset 'cleandata' with merged data from 'test_f' and 'train_f'
cleandata <- rbind(test_f, train_f)
# this confirm total dimension in observation
#identical(dim(cleandata)[1], dim(test_f)[1] + dim(train_f)[1])

## melting/dcasting dataset with average values by subject and activity
cleandata_ml <- melt(cleandata, id = 1:4, measure.vars = 5:83)
newdataset <- dcast(cleandata_ml, subject + category + activity ~ variable, mean)
# ordering ascending by category, subject and activity
newdataset <- arrange(newdataset, category, subject, activity)
# this confirm subject are not missing
#summary(unique(subj_test)); summary(unique(subj_train))

## create txt file in working directory
write.table(newdataset, "./tidy_dataset.txt", sep = ";", row.names = FALSE)
```





