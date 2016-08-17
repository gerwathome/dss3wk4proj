### Introduction

This is the 4th week project for the Coursera course "Getting and Cleaning Data".  The data comes form the UCI Machine Learning Repository.  The original source of the data is:


>1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. *Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine*. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

>This data set is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

>Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.

From the original data README:

>The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained data set has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

>The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

>For each record it is provided:

> - Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
> - Triaxial Angular velocity from the gyroscope. 
> - A 561-feature vector with time and frequency domain variables. 
> - Its activity label. 
> - An identifier of the subject who carried out the experiment.

### Discussion of the Data

Initial unpacking of the zipped data revealed descriptive files in the base directory, with data files in train and test sub-directories.  Additional data were located in sub-directories to the test and train directories labeled "Inertial Signals".  A more detailed initial look at the data files is given in the file "preliminary_perusal.md"

Review of the features_info.text file reveals that data have been subjected to pre-processing.  The original raw data is not available.  The data in the "Inertial Signals" folders has been filtered for noise, and to separate the gravity acceleration from the body acceleration.  These processed measured data windows were then processed and summarized to yield the test and train data sets which we have been asked to use in this project.  A more detailed look at processing applied to this data set is given in the "CodeBook.md" file.

###Step by Step Completion of the Project Requirements

####*1. Merges the training and the test sets to create one data set.*
The test and train data sets each include three files:

|File|Content|File Length in Lines|File Width in Characters|
|----|-------------|-------|----------|
|test/subject_test.txt  |Integer 1:30 identifying test subject|2947|   2|
|test/y_test.txt        |Integer 1:6 identifying activity     |2947|   1|
|test/X_test.txt        |561 element feature vector             |2947|8977|
|train/subject_train.txt|Integer 1:30 identifying test subject|7352|   2|
|train/y_train.txt      |Integer 1:6 identifying activity     |7352|   1|
|train/X_train.txt      |561 element feature vector             |7352|8977|

The "features.txt" file contains abbreviated variable names for the 561 element feature vector. The names in the file include dashes, commas, and parentheses.  To make them suitable to be R variable names, they were edited to convert inappropriate characters to underscores.  The combined data set was created in the following manner:

1. Combine the three test files column wise into a data frame.
2. Combine the three train files column wise into a data frame.
3. Read in the features.txt file, and edit it as necessary.
4. Create a column name vector by adding "Subject" and "Activity" to the edited features vector.
5. Apply the column name vector to the test and train data frames.
6. Merge the test and train data frames row wise into the desired data set.

This data frame has only variables as columns and only observations as rows.  All data in this is from a single observational unit, and therefore it is a "tidy" data set.

####*2. Extracts only the measurements on the mean and standard deviation for each measurement.*
The appropriate columns were selected by creating a selection vector using grep on the column names, and then applying the selection vector to the combined data frame.  It is not completely clear which variables should be included, as the term "mean" shows up in some variable names where it does not necessarily signify that the value is the mean of a measurement.  For example, in the "angle" summary statistic, mean is included in the name of one of the vectors for which the angle is being computed.  Another questionable instance is the "meanFreq" summary statistic.  This is a weighted average of the frequency, although it is unclear how it is weighted; perhaps by energy at different frequencies.

For the purposes of this project, it is assumed that the only variables desired are those which are actually generated using the mean() and std() summary statistics.  This data set is a subset of the original combined data set, and is still a "tidy"" data set with variables in the columns and observations in the rows.

####*3. Uses descriptive activity names to name the activities in the data set.*
The file "activity_labels.txt" contains the names of each of the activities in the same order as the activity codes in the "y_{test,train}.txt" files. To convert the codes to descriptive names, it is only necessary to read the "activity_labels.txt" names into a vector, and then replace the activity code with the activity label of the same index.

####*4. Appropriately labels the data set with descriptive variable names.*
At this point, each of the variables/column names already has a label from the imported "features.txt" file.  What an "appropriately ... descriptive" label is can be very subjective.  How much clarity should be given up to prevent the labels from becoming too long?  In this case I have chosen to completely expand the variable names, making the names self explanatory (and very long).  These names are listed in the "CodeBook.md" file.

####*5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.*
The final data frame was created using the group_by and summarize functions in the dplyr package, in four steps.  For the purposes of the class project, steps 2 and 3 below are probably not necessary.  However, if I were trying to understand this data, I would certainly want to see the additional summary statistics.

1. Group by subject and activity, then summarize with mean.  This gives 30*6=180 rows.
2. Group by subject, then summarize with mean.  This gives average for all of the activities for each subject, for a total of 30 rows.  For inclusion in the final data frame it is necessary to add an "All" in the Activity column.
3. Group by activity, then summarize with mean. This gives the average of each activity for all of the subjects, for a total of 6 rows.  The Subject column is coded with a 0 to indicate this is an average for all of the subjects.
4. The three summary data frames prepared above are then combined row wise into the final independent summary data set of 116 rows.

As before, columns are still variables, and the various summary groupings of observations in the rows are still the observations.  This is still a "tidy"" data set.