# run_analysis.R
# George R. Williams
# 17-Aug-2016
# An R script for the Coursera class "Getting and Cleaning Data" week 4 project.
# Throughout this script there are bits of code commented out.  These bits were
#     used to help understand issues and check results.  They are no longer
#     necessary to get the desired result, and are therefore commented out.

### Preliminaries:  get and unzip the data:
# get the data file
data_src <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data_targ <- "getdata_projectfiles_UCI_HAR_Dataset.zip"
if(!file.exists(data_targ)){
    download.file(data_src, data_targ)
}
# unzip the data
if(!file.exists("UCI HAR Dataset")){
    unzip(data_targ)
}

# At this point, a look at the unzipped data files was done from the command line.
# This is described in the file "preliminary_perusal.md"

### On to the defined project tasks:
#-------------------------------------------------------------------------------
# 1. Merges the training and the test sets to create one data set.
#-------------------------------------------------------------------------------
# Strategy for merging the files:
# - import the six data files (see "preliminary_perusal.md")
# - cbind the subject, y and X files for test and train separately
#       (subject ID, activity description and data, respectively)
# - add a column variable identifying whether it is test or train
# - import and clean up the "features.txt" file
#    > this included getting rid extra parens, commas and dashes
#    > it also included converting BodyBody to Body
# - add column names for subject ID, activity and data_set
# - assign column names to test and train data sets
# - rbind the test and train data sets
library(dplyr)
basedir <- "UCI HAR Dataset/"

# import test data and combine into a data frame
fn <- paste0(basedir,"test/subject_test.txt")
test_subject <-read.table(fn)
fn <- paste0(basedir,"test/y_test.txt")
test_activity <-read.table(fn)
fn <- paste0(basedir,"test/X_test.txt")
test_data <-read.table(fn)
test_df <- as.data.frame(cbind(test_subject, test_activity, test_data, "test"))

# import train data and combine into a data frame
fn <- paste0(basedir,"train/subject_train.txt")
train_subject <-read.table(fn)
fn <- paste0(basedir,"train/y_train.txt")
train_activity <-read.table(fn)
fn <- paste0(basedir,"train/X_train.txt")
train_data <-read.table(fn)
train_df <- as.data.frame(cbind(train_subject, train_activity, train_data,"train"))

# import and edit feature names
feature_names <- as.vector(read.table(paste0(basedir,"features.txt"))[,2])
edited_names <- gsub("-", "_", feature_names, perl=TRUE)
edited_names <- gsub(",", "_", edited_names, perl=TRUE)
edited_names <- gsub("\\(\\)", "", edited_names, perl=TRUE)
edited_names <- gsub("\\)_", "_", edited_names, perl=TRUE)
edited_names <- gsub("\\)$", "", edited_names, perl=TRUE)
edited_names <- gsub("[()]", "_", edited_names, perl=TRUE)
edited_names <- gsub("BodyBody", "Body", edited_names, perl=TRUE)

check_edit <- as.data.frame(cbind(feature_names, edited_names))
# View(check_edit)

# name and merge data frames
base_col_names <- c("Subject", "Activity", edited_names, "Data_Set_Type")
colnames(test_df) <- base_col_names
colnames(train_df) <- base_col_names

base_df <- rbind(test_df, train_df)
# write.csv(base_df, "base.csv", row.names=FALSE)

#-------------------------------------------------------------------------------
# 2. Extracts only the measurements on the mean and standard deviation for each 
#    measurement.
#-------------------------------------------------------------------------------
# strategy: use grep to identify mean and sd columns for extraction
# The following are purposely omitted, as they are not "mean and standard
#    deviation for each measurement" as requested, but rather the mean of
#    several measurements or used to define angle between vectors:
#        gravityMean
#        tBodyAccMean
#        tBodyAccJerkMean
#        tBodyGyroMean
#        tBodyGyroJerkMean
#        meanFreq()
# The only features extracted have "mean()" or "std()" in the name in the
#     "features.txt" file.

# check that the grep patterns work for both edited and unedited names
test_mean_feature <- grepl("mean\\(\\)", feature_names)
test_mean_edited <- grepl("_mean(_|$)", edited_names)
# identical(test_mean_feature,test_mean_edited)
# [1] TRUE

test_std_feature <- grepl("std\\(\\)", feature_names)
test_std_edited <- grepl("_std(_|$)", edited_names)
# identical(test_std_feature,test_std_edited)
# [1] TRUE

# The first two columns are Subject and Activity
# The last column is Data_Set_Type, i.e. test or train
select_cols <- c(1, 2, grep("(_mean(_|$))|(_std(_|$))",colnames(base_df)),
                            length(colnames(base_df)))
# check
len_mean <-sum(test_mean_edited)
len_std <- sum(test_std_edited)
len_added_cols <- 3 # "Subject", "Activity", and "Data_Set_Type"
# length(select_cols) == len_added_cols + len_mean + len_std
# [1] TRUE

# This subset of base_df is also a tidy dataset.  The only change from base_df
#     is that fewer columns/variables have been selected
sub_df <- base_df[,select_cols]

#-------------------------------------------------------------------------------
# 3. Uses descriptive activity names to name the activities in the data set
#-------------------------------------------------------------------------------
# strategy: replace activity codes with activities from "activity_labels.txt"
# The activity_labels.txt file has two columns, but we only need the second column
activity_names <- as.vector(read.table(paste0(basedir,"activity_labels.txt"))[,2])

# Fortunately, the descriptive names are easily indexed by the Activity integer.
sub_df <- mutate(sub_df, Activity = activity_names[Activity])
# sub_df now has the appropriate descriptive names in the Activity column

#-------------------------------------------------------------------------------
# 4. Appropriately labels the data set with descriptive variable names.
#-------------------------------------------------------------------------------
# strategy:  edit variable names to make them more descriptive
# These descriptive names are modeled after the information provided in the
#     README.txt and the features_info.txt files provided in the data set.
old_col_names <- colnames(sub_df)
new_col_names <- gsub("^t", "Time_Domain_", old_col_names)
new_col_names <- gsub("^f", "Frequency_Domain_", new_col_names)
new_col_names <- gsub("([XYZ])$", "in_\\1_Direction", new_col_names)
new_col_names <- gsub("Acc", "_Acceleration", new_col_names)
new_col_names <- gsub("Jerk", "_Jerk", new_col_names)
new_col_names <- gsub("Gyro", "_Gyro", new_col_names)
new_col_names <- gsub("Mag", "_Magnitude", new_col_names)
new_col_names <- gsub("std", "standard_deviation", new_col_names)
check_new_names <- cbind(old_col_names, new_col_names)
# head(check_new_names)
# tail(check_new_names)
# View(check_new_names)
colnames(sub_df) <- new_col_names
# sub_df now has more descriptive column names (i.e. variable names)
# View(sub_df)

#-------------------------------------------------------------------------------
# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.
#-------------------------------------------------------------------------------
# strategy: use roup_by and summarize functions from dplyr
# the data frame is also sorted to make it easier to read
grouped_df <- arrange(group_by(sub_df, Subject, Activity), Subject, Activity)
select_vars <- grepl("^(Time|Frequency)",names(grouped_df), perl=TRUE)
summary_df <- as.data.frame(summarize_if(grouped_df, select_vars, mean),
                            stringsAsFactors = FALSE)

# It would also be desirable to understand averages by Subject and Activity alone
group_subject_df <- arrange(group_by(sub_df, Subject), Subject, Activity)
sum_subject_df <- summarize_if(group_subject_df, select_vars, mean)
sum_subject_df <- as.data.frame(append(sum_subject_df, list("All"), after=1),
                                stringsAsFactors = FALSE)
colnames(sum_subject_df)[2] <-"Activity"

group_activity_df <- arrange(group_by(sub_df, Activity), Subject, Activity)
sum_activity_df <- summarize_if(group_activity_df, select_vars, mean)
sum_activity_df <- as.data.frame(append(sum_activity_df, list(as.integer(0)), after=0),
                                 stringsAsFactors = FALSE)
colnames(sum_activity_df)[1] <-"Subject"

final_df <- rbind(summary_df, sum_subject_df, sum_activity_df)

# for reading into Code Book:
write.table(colnames(final_df),"var_names.txt", row.names=FALSE,
            col.names=FALSE, quote=FALSE)

# View(summary_df)
# View(sum_subject_df)
# View(sum_activity_df)
# View(final_df)

# final_df is the final answer to the assigned problem
# It summarizes the 10299 data observations for 66 variables into 180 averages
#     for the 6 activities of each of the 30 subjects.  It also includes
#     averages over all activities for each subject, and averages over each
#     activity for all subjects for a total of 180 + 30 + 6 = 216 rows.  This
#     is still a tidy dataset as it still meets the three part definition as
#     described above.  In addition, the data set has been sorted on Subject,
#     and then Activity to make it easier to read.

write.table(final_df,"dss3wk4proj.txt",row.names=FALSE)

# Because of the long variable names. it is a little easier to look at in a
#     spreadsheet where the column names may be word wrapped
write.csv(final_df,"dss3wk4proj.csv",row.names=FALSE)

check_df <- read.table("dss3wk4proj.txt",header=TRUE, stringsAsFactors = FALSE)

# write.csv(check_df,"ck_dss3wk4proj.csv",row.names=FALSE)
# View(check_df)
# the csv files written from the final_df and the check_df are identical

