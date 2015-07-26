A code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md.
=========================================================

The script uses the function approach. Each of the set of objectives are done in the function and then a call is made to the functions later in the code.

The functions used are as follow:
1. merged_data(directory) function. It is assumed that this file is in the same directory as the UCI HAR Dataset.
Merges the training and the test datasets to create one dataset. This also include adding new variable names that are descriptive. 

2. get_mean_std_data_set(dataset,directory) -- This function accepts the dataset and the location of the diredtory. Extract the mean and standard deviation using the column name that has mean OR std as a selective condition.

3. meltData_and_writeTidy(data_set, path_to_file) function uses the melt and cast functions to reshape the data and write out a tidy dataset in the format that we want.

4. readTidyData <- function(path_to_file) check to ensure you can read the tidy dataset (this is not required in the assignment but it will help for immediate assessment of the output)

=====================================================================================

The following are the names of the files used in this code with short description of each. 
 -'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.
