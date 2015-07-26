# 1) Merging of the training and the test datasets to create one dataset
# is being handled by this function called merge_data(directory). It is assumed that 
# this file is in the same directory as the UCI HAR Dataset.
merge_data <- function(directory) {
    ## read the dataset in X_test and X_train sets by first setting its path and then read the table
    path <- paste("./", directory, "/test/X_test.txt", sep="")
    test_data <- read.table(path)
    path <- paste("./", directory, "/train/X_train.txt", sep="")
    train_data <- read.table(path)
    
    ## read the y_test and y_train datasets
    path <- paste("./", directory, "/train/y_train.txt", sep="")
    y_train <- read.table(path)
    path <- paste("./", directory, "/test/y_test.txt", sep="")
    y_test <- read.table(path)
    
    ## read the activity labels, starting with path setting
    path <- paste("./", directory, "/activity_labels.txt", sep="")
    activity_labels <- read.table(path)
    
    ## read the test and training subject labels
    path <- paste("./", directory, "/train/subject_train.txt", sep="")
    subject_train <- read.table(path)
    path <- paste("./", directory, "/test/subject_test.txt", sep="")
    subject_test <- read.table(path)
    
    
    ## merge y_test and y_train datasets with activity labels
    y_train_labels <- merge(y_train,activity_labels,by="V1")
    y_test_labels <- merge(y_test,activity_labels,by="V1")
    
    ## merge the test and training datasets with their respective subject labels using column bind to create new datasets 
    train_data <- cbind(subject_train,y_train_labels,train_data)
    test_data <- cbind(subject_test,y_test_labels,test_data)
    
    ## Finally, merge the test dataset  with the training dataset
    complete_data <- rbind(train_data,test_data)
    
    return (complete_data)
}

# 2) Extracts only the measurements on the mean and standard deviation for each measurement
# This is done using function approach. The function get_mean_std(dataset, directory) accepts the dataset (in this case the complete_data) and the location (directory)
get_mean_std <- function(data_set, directory) {
    path <- paste("./", directory, "/features.txt", sep="") # set the path
    features_data <- read.table(path)
    # usually the columns is a data.table where V1 is the column number
    # and V2 is the actual name
    # subset only those rows where the name contains the word mean and std
    mean_std_rows <- subset(features_data,  grepl("(mean\\(\\)|std\\(\\))", features_data$V2) )
    
    # rename the columns of combined data with subject, activityId, activity
    colnames(data_set) <- c("subject","activityId","activity",as.vector(features_data[,2]))
    
    # extract the mean and std from merged data where the column name is mean OR std
    mean_columns <- grep("mean()", colnames(data_set), fixed=TRUE)
    std_columns <- grep("std()", colnames(data_set), fixed=TRUE)
    
    # put both mean and std columns into single vector and sort 
    mean_std_column_vector <- c(mean_columns, std_columns) 
    mean_std_column_vector <- sort(mean_std_column_vector)
    
    # extract the columns with std and mean in their column headers
    extracted_dataset <- data_set[,c(1,2,3,mean_std_column_vector)]
    return (head(extracted_dataset,n=10))
}

# 3) Using descriptive activity names to name the activities in the data set: this has been done in the merge_data and get_mean_std functions
# 4) Appropriately labels the data set with descriptive activity names: this has been done inside the merge_data and get_mean_std functions as well
# 5) Create a second, independent tidy data set with the average of each variable for each activity and each subject: using the melt and cast functions to achieve this in the meltData_and_writeTidy function
meltData_and_writeTidy <- function(data_set, path_to_file) {
    # melt the data and cast it into tid data format. Melting the data will require reshape package
    require(reshape2)
    meltedData <- melt(data_set, id=c("subject","activityId","activity"))
    tidyData <- dcast(meltedData, formula = subject + activityId + activity ~ variable, mean)
    
    # reformat the column names of the tidy dataset
    col_names_vector <- colnames(tidyData)
    col_names_vector <- gsub("-mean()","Mean",col_names_vector,fixed=TRUE)
    col_names_vector <- gsub("-std()","Std",col_names_vector,fixed=TRUE)
    col_names_vector <- gsub("BodyBody","Body",col_names_vector,fixed=TRUE)
    colnames(tidyData) <- col_names_vector
    
    # write the output into a file with write.table function using row.names=FALSE
    write.table(tidyData, file=path_to_file, sep="\t", row.names=FALSE)
}

merged_data <- merge_data("UCI HAR Dataset")
get_mean_std_data_set <- get_mean_std(merged_data, "UCI HAR Dataset")
meltData_and_writeTidy(get_mean_std_data_set, "./tidy_Dataset.txt")

# check to ensure you can read the tidy dataset (this is not required in the assignment)
readTidyData <- function(path_to_file) {
    tidyDataset <- read.table(path_to_file)
    return (tidyDataset)
}
# read the tidy dataset in the text file just to get immediate assessment of the content.
tidyDataset <- readTidyData("./tidy_Dataset.txt")
