run_analysis <- function(){
    ################################### 1. LOAD DATA ###################################
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
    library(reshape2); library(Hmisc); library(stringr)
    
    ################################### 2. READ FILE ###################################
    ## read txt file
    path <- "./UCI HAR Dataset/"
    pathtest <- paste0(path,"test/")
    pathtrain <- paste0(path,"train/")
    
    files <- c("activity_labels", "features",
               "subject_test", "X_test", "Y_test",
               "subject_train", "X_train", "Y_train")
    
    actlab <- read.table(paste0(path, files[1], ".txt"), stringsAsFactors = FALSE)
    features <- read.table(paste0(path, files[2], ".txt"), stringsAsFactors = FALSE)
    
    subj_test <- read.table(paste0(pathtest, files[3], ".txt"), stringsAsFactors = FALSE)
    x_test <- read.table(paste0(pathtest, files[4], ".txt"), stringsAsFactors = FALSE)
    y_test <- read.table(paste0(pathtest, files[5], ".txt"), stringsAsFactors = FALSE)
    
    subj_train <- read.table(paste0(pathtrain, files[6], ".txt"), stringsAsFactors = FALSE)
    x_train <- read.table(paste0(pathtrain, files[7], ".txt"), stringsAsFactors = FALSE)
    y_train <- read.table(paste0(pathtrain, files[8], ".txt"), stringsAsFactors = FALSE)
    
    ################################### 3. MANIPULATING DATA ###################################
    colnames(actlab) <- c("activity"," actlab")
    namecol <- as.character(features$V2)
    
    ################################### reshape 'test' data
    # update column names
    colnames(subj_test) <- "subject"
    colnames(y_test) <- "activity"
    colnames(x_test) <- namecol
    # create new variable and merge data
    subj_test <- mutate(subj_test, category = "test")
    y_test <- merge(y_test, actlab, by = "activity", sort=FALSE)
    test_mg <- cbind(subj_test, y_test, x_test)
    # remove duplicated column
    dupcol <- duplicated(colnames(test_mg))
    newtest_mg <- test_mg[,!dupcol]
    # select required column
    test_f <- select(newtest_mg, 1:4, contains("-mean"), contains("-std"))
    
    ################################### reshape 'train' data
    # update column names
    colnames(subj_train) <- "subject"
    colnames(y_train) <- "activity"
    colnames(x_train) <- namecol
    # create new variable and merge data
    subj_train <- mutate(subj_train, category = "train")
    y_train <- merge(y_train, actlab, by = "activity", sort=FALSE)
    train_mg <- cbind(subj_train, y_train, x_train)
    # remove duplicated column
    dupcol <- duplicated(colnames(train_mg))
    newtrain_mg <- train_mg[,!dupcol]
    # select required column
    train_f <- select(newtrain_mg, 1:4, contains("-mean"), contains("-std"))
    
    ## this compares train_f and test_f
    # same column names
    #identical(colnames(test_f), colnames(train_f))
    # dimensions
    #dim(test_f); dim(train_f)
    
    ################################### creating tidy dataset
    # new dataset
    cleandata <- rbind(test_f, train_f)
    # confirm total dimension in observation
    #identical(dim(cleandata)[1], dim(test_f)[1] + dim(train_f)[1])
    
    ################################### creating dataset with average values by subject and activity
    cleandata_ml <- melt(cleandata, id = 1:4, measure.vars = 5:83)
    newdataset <- dcast(cleandata_ml, subject + category + activity ~ variable, mean)
    # ordering ascending by category, subject and activity
    newdataset <- arrange(newdataset, category, subject, activity)
    # this confirm subject are not missing
    #summary(unique(subj_test)); summary(unique(subj_train))
    
    ## create txt file in working directory
    write.table(newdataset, "./tidy_dataset.txt", sep = ";", row.names = FALSE)
}