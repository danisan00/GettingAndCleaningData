# Loads the training data set.
loadTrainingSet <- function() {
  
  train <- read.table(file = "UCI HAR Dataset/train/X_train.txt", header = F, sep = "",
                      colClasses = rep("numeric", times = 561), nrows = 7352, skip = 0,
                      stringsAsFactors = F)
  
  trainActivityIds <- read.table(file = "UCI HAR Dataset/train/y_train.txt", header = F,
                                 sep = "", colClasses = c("numeric"), nrows = 7352,
                                 skip = 0, stringsAsFactors = F)

  trainSubjectIds <- read.table(file = "UCI HAR Dataset/train/subject_train.txt",
                                header = F, sep = "", colClasses = c("numeric"),
                                nrows = 7352, skip = 0, stringsAsFactors = F)
  
  featureColNames <- read.table("UCI HAR Dataset/features.txt", header = F, sep = "",
                                colClasses = c("numeric", "character"), nrows = 561,
                                skip = 0)
  
  colnames(train) <- as.vector(featureColNames[, 2])
  
  train$activityId <- trainActivityIds[, 1]
  
  train$subjectId <- trainSubjectIds[, 1]
  
  return(train);
}

# Loads the test data set.
loadTestSet <- function() {
  
  test <- read.table(file = "UCI HAR Dataset/test/X_test.txt", header = F, sep = "",
                      colClasses = rep("numeric", times = 561), nrows = 2947, skip = 0,
                      stringsAsFactors = F)
  
  testActivityIds <- read.table(file = "UCI HAR Dataset/test/y_test.txt", header = F,
                                 sep = "", colClasses = c("numeric"), nrows = 2947, skip = 0,
                                 stringsAsFactors = F)
  
  testSubjectIds <- read.table(file = "UCI HAR Dataset/test/subject_test.txt", header = F,
                                sep = "", colClasses = c("numeric"), nrows = 2947, skip = 0,
                                stringsAsFactors = F)
  
  featureColNames <- read.table("UCI HAR Dataset/features.txt", header = F, sep = "",
                                colClasses = c("numeric", "character"), nrows = 561,
                                skip = 0)
  
  colnames(test) <- as.vector(featureColNames[, 2])
  
  test$activityId <- testActivityIds[, 1]
  
  test$subjectId <- testSubjectIds[, 1]
  
  return(test);
}

# Loads the training and test data sets and merges them into a single data set.
loadTotalDataSet <- function() {
  train <- loadTrainingSet()
  test <- loadTestSet()
  
  total <- rbind(train, test)
  
  return(total)
}

# Creates a new data set which is equal to the input one but dropping all columns except
#"subjectId", "activity/activityId" and all other columns containing "mean()" or "std()"
# in their names.
removeColumnsFromDataSet <- function(dataSet) {
  
  columnNames <- colnames(dataSet)
  columnsToKeep = vector("logical", length(columnNames))
  
  for(i in 1:length(columnNames)) {
    if(length(grep("mean\\(\\)", columnNames[i])) > 0) {
      columnsToKeep[i] <- TRUE;
    } else if(length(grep("std\\(\\)", columnNames[i])) > 0) {
      columnsToKeep[i] <- TRUE;
    } else if(columnNames[i] == "activity" | columnNames[i] == "activityId") {
      columnsToKeep[i] <- TRUE;
    } else if(columnNames[i] == "subjectId") {
      columnsToKeep[i] <- TRUE;
    } else {
      columnsToKeep[i] <- FALSE;
    }
  }

  return(dataSet[, columnsToKeep])
}

# Creates a new data set which is equal to the input one but replacing the column
# "activityId" (numeric) by "activity" (character).
addActivityLabels <- function(dataSet) {
  
  activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = F, sep = "",
                               colClasses = c("numeric", "character"), nrows = 6, skip = 0)
  
  dataSet <- merge(dataSet, activityLabels, by.x = "activityId", by.y = "V1")
  
  colnames(dataSet)[which(names(dataSet) == "V2")] <- "activity"
  
  return(dataSet[, !(colnames(dataSet) == "activityId")])
}

# Creates a second tidy data set with the average of each variable for each activity and
# each subject.
createSecondDataSet <- function(dataSet) {
  
  library(reshape2)
  
  dataSetMelt <- melt(dataSet, id = c("activity", "subjectId"))
  
  return(dcast(dataSetMelt, activity + subjectId ~ variable, mean))
}

dataSet <- loadTotalDataSet()
dataSet <- removeColumnsFromDataSet(dataSet)
dataSet <- addActivityLabels(dataSet)

secondDataSet <- createSecondDataSet(dataSet)