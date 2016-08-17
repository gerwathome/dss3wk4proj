### Data File Perusal Using Shell Commands and vim

How many variable names?
```
 cd  "UCI HAR Dataset"
 wc -l features.txt
 561 features.txt
```
 Check for duplicate names; remove index column one
```
 cut -d" " -f2 features.txt | sort -u | wc -l
 477
```
 
 hmmm....  Do the duplicate names have duplicate values?

 Data files with file size:
``` 
  
  ls -l t*/*.txt
 -rw-rw-r-- 1 gerw gerw     7934 Aug  9 16:38 test/subject_test.txt
 -rw-rw-r-- 1 gerw gerw 26458166 Aug  9 16:38 test/X_test.txt
 -rw-rw-r-- 1 gerw gerw     5894 Aug  9 16:38 test/y_test.txt
 -rw-rw-r-- 1 gerw gerw    20152 Aug  9 16:38 train/subject_train.txt
 -rw-rw-r-- 1 gerw gerw 66006256 Aug  9 16:38 train/X_train.txt
 -rw-rw-r-- 1 gerw gerw    14704 Aug  9 16:38 train/y_train.txt
```

 Number of lines in each data file:
```
 wc -l t*/*.txt
 2947 test/subject_test.txt
 2947 test/X_test.txt
 2947 test/y_test.txt
 7352 train/subject_train.txt
 7352 train/X_train.txt
 7352 train/y_train.txt
``` 
 There appear to be 2947 + 7352 = 10,299 observations in the combined data set

 Number of columns in each data file:
```
 awk '{ print FILENAME, length($0); }' t*/*.txt | sort -u
 test/subject_test.txt 1
 test/subject_test.txt 2
 test/X_test.txt 8977 <= this file has a carriage return, rather than a new line
 test/y_test.txt 1
 train/subject_train.txt 1
 train/subject_train.txt 2
 train/X_train.txt 8977 <= this file has a carriage return, rather than a new line
 train/y_train.txt 1
```
 By inspection, subject...txt and y...txt files have a single column of numbers.  By inspection, X...txt files contain space delimited/fixed format values.  By inspection, each row of data in the X...txt files has 8976 characters, with each field using 16 spaces for a total of 561 values per line.

 From the data set README file:
 Each row of the data files describes measurements for a single volunteer and a single activity.  The subject...txt file is an identifying number for each volunteer:  1 to 30; check with shell commands:
``` 
     sort -nu test/subject_test.txt | tr '\n' ' '
     2 4 9 10 12 13 18 20 24
     sort -nu train/subject_train.txt | tr '\n' ' '
     1 3 5 6 7 8 11 14 15 16 17 19 21 22 23 25 26 27 28 29 30
```     
 The y...txt file is an identifying integer for the activity:  1 to 6; check with shell commands:
```
     sort -u test/y_test.txt | tr '\n' ' '
     1 2 3 4 5 6
     sort -u train/y_train.txt | tr '\n' ' '
     1 2 3 4 5 6
```
 The 6 actiivty labels are shown in the file "activity_labels.txt".  The X...txt files contains the 561 value feature vector of measurements.  The "features.txt" file contains the names for each of the 561 measurements. The "features.txt" file will need significant clean up to be used as names. 

 There appears to be no way to create a unique observation ID, other than by original order.  This is flawed, as it could easily change with different versions of the data set.  A DateTime field would be nice.

 The "features.txt" file contains variables with "BodyBody" in the name. It is unclear what this means, and is not explained in the "features_info.txt" file.

 Perusal of Inertial Signals File size:
``` 
 ls -l t*/I*/*
 -rw-rw-r-- 1 gerw gerw  6041350 Aug  9 16:38 test/Inertial Signals/body_acc_x_test.txt
 -rw-rw-r-- 1 gerw gerw  6041350 Aug  9 16:38 test/Inertial Signals/body_acc_y_test.txt
 -rw-rw-r-- 1 gerw gerw  6041350 Aug  9 16:38 test/Inertial Signals/body_acc_z_test.txt
 -rw-rw-r-- 1 gerw gerw  6041350 Aug  9 16:38 test/Inertial Signals/body_gyro_x_test.txt
 -rw-rw-r-- 1 gerw gerw  6041350 Aug  9 16:38 test/Inertial Signals/body_gyro_y_test.txt
 -rw-rw-r-- 1 gerw gerw  6041350 Aug  9 16:38 test/Inertial Signals/body_gyro_z_test.txt
 -rw-rw-r-- 1 gerw gerw  6041350 Aug  9 16:38 test/Inertial Signals/total_acc_x_test.txt
 -rw-rw-r-- 1 gerw gerw  6041350 Aug  9 16:38 test/Inertial Signals/total_acc_y_test.txt
 -rw-rw-r-- 1 gerw gerw  6041350 Aug  9 16:38 test/Inertial Signals/total_acc_z_test.txt
 -rw-rw-r-- 1 gerw gerw 15071600 Aug  9 16:38 train/Inertial Signals/body_acc_x_train.txt
 -rw-rw-r-- 1 gerw gerw 15071600 Aug  9 16:38 train/Inertial Signals/body_acc_y_train.txt
 -rw-rw-r-- 1 gerw gerw 15071600 Aug  9 16:38 train/Inertial Signals/body_acc_z_train.txt
 -rw-rw-r-- 1 gerw gerw 15071600 Aug  9 16:38 train/Inertial Signals/body_gyro_x_train.txt
 -rw-rw-r-- 1 gerw gerw 15071600 Aug  9 16:38 train/Inertial Signals/body_gyro_y_train.txt
 -rw-rw-r-- 1 gerw gerw 15071600 Aug  9 16:38 train/Inertial Signals/body_gyro_z_train.txt
 -rw-rw-r-- 1 gerw gerw 15071600 Aug  9 16:38 train/Inertial Signals/total_acc_x_train.txt
 -rw-rw-r-- 1 gerw gerw 15071600 Aug  9 16:38 train/Inertial Signals/total_acc_y_train.txt
 -rw-rw-r-- 1 gerw gerw 15071600 Aug  9 16:38 train/Inertial Signals/total_acc_z_train.txt
```
 File number of lines:
``` 
 wc -l t*/I*/*
 32947 test/Inertial Signals/body_acc_x_test.txt
 2947 test/Inertial Signals/body_acc_y_test.txt
 2947 test/Inertial Signals/body_acc_z_test.txt
 2947 test/Inertial Signals/body_gyro_x_test.txt
 2947 test/Inertial Signals/body_gyro_y_test.txt
 2947 test/Inertial Signals/body_gyro_z_test.txt
 2947 test/Inertial Signals/total_acc_x_test.txt
 2947 test/Inertial Signals/total_acc_y_test.txt
 2947 test/Inertial Signals/total_acc_z_test.txt
 7352 train/Inertial Signals/body_acc_x_train.txt
 7352 train/Inertial Signals/body_acc_y_train.txt
 7352 train/Inertial Signals/body_acc_z_train.txt
 7352 train/Inertial Signals/body_gyro_x_train.txt
 7352 train/Inertial Signals/body_gyro_y_train.txt
 7352 train/Inertial Signals/body_gyro_z_train.txt
 7352 train/Inertial Signals/total_acc_x_train.txt
 7352 train/Inertial Signals/total_acc_y_train.txt
 7352 train/Inertial Signals/total_acc_z_train.txt
``` 
 There appear to be 2947 + 7352 = 10,299 observations in the combined data set

 Number of columns in each data file:
```
 awk '{ print FILENAME, length($0); }' t*/I*/*.txt | sort -u
 test/Inertial Signals/body_acc_x_test.txt 2049
 test/Inertial Signals/body_acc_y_test.txt 2049
 test/Inertial Signals/body_acc_z_test.txt 2049
 test/Inertial Signals/body_gyro_x_test.txt 2049
 test/Inertial Signals/body_gyro_y_test.txt 2049
 test/Inertial Signals/body_gyro_z_test.txt 2049
 test/Inertial Signals/total_acc_x_test.txt 2049
 test/Inertial Signals/total_acc_y_test.txt 2049
 test/Inertial Signals/total_acc_z_test.txt 2049
 train/Inertial Signals/body_acc_x_train.txt 2049
 train/Inertial Signals/body_acc_y_train.txt 2049
 train/Inertial Signals/body_acc_z_train.txt 2049
 train/Inertial Signals/body_gyro_x_train.txt 2049
 train/Inertial Signals/body_gyro_y_train.txt 2049
 train/Inertial Signals/body_gyro_z_train.txt 2049
 train/Inertial Signals/total_acc_x_train.txt 2049
 train/Inertial Signals/total_acc_y_train.txt 2049
 train/Inertial Signals/total_acc_z_train.txt 2049
```
 carriage return for line ending aads 1 character  
 2048 / 16 = 128 data fields  
 from README:  2.56 sec window at 50 hz => 128 values  
 => each row is the filtered data from one window  
 Nine files each from test and train include:  
 -body acceleration for X,Y, and Z  
 -gravity acceleration for X,Y, and Z  
 -gyro angular velocity for X,Y, and Z  
 Acceleration is in gravity units.  what is the time derivative of gravity units?  Since they are calculating jerk, it might make more sense to use a more conventional unit like m/sec2.
 Gyro angular velocity is in radians per second.