### Discussion of Data Processing and the Meaning of the Variables

The basic data has several layers of processing.  The first level filters the time domain data for noise and to separate body acceleration from gravity acceleration.  This yields the following 9 data sets (three directional components for each variable).  These are the files located in the "Inertial Signals" folder.  The units of the acceleration variables are "gravities" and the units of the gyro measurements are "radians per second":
```
-tBodyAcc-XYZ
-tGravityAcc-XYZ
-tBodyGyro-XYZ
```
The derivative is then taken of the two body variables to yield jerk estimates in two variables of three components each.  As a side note, apparently my basic physics education is somewhat lacking, as I was previously unaware that the time derivative of acceleration is jerk, and the time derivative of jerk is jounce.  These intermediate calculations are not available:
```
-tBodyAccJerk-XYZ
-tBodyGyroJerk-XYZ
```
Next the three directional components of the above 5 variables were added vectorially to yield a directionless magnitude.  These intermediate calculations are not available:
```
-tBodyAccMag
-tGravityAccMag
-tBodyAccJerkMag
-tBodyGyroMag
-tBodyGyroJerkMag
```
Note that all of the above 20 data sets each include 128 values, just as the original raw moving window time domain data measurements.  Next. FFT's were applied to a selection of the above variables to convert them from the time domain to the frequency domain.  The time domain gravity variables do not have a comparable frequency domain variable, as they were created by use of a frequency filter on the raw accelerometer time domain data.
```
-fBodyAcc-XYZ
-fBodyAccJerk-XYZ
-fBodyGyro-XYZ
-fBodyAccMag
-fBodyAccJerkMag
-fBodyGyroMag
-fBodyGyroJerkMag
```
A variety of summary statistics were generated from each of these data sets.  The summary statistics are what make up the data sets found in the test and train directories.
They include the following 
```
-mean(): Mean value
-std(): Standard deviation
-mad(): Median absolute deviation 
-max(): Largest value in array
-min(): Smallest value in array
-sma(): Signal magnitude area
-energy(): Energy measure. Sum of the squares divided by the number of values. 
-iqr(): Interquartile range 
-entropy(): Signal entropy
-arCoeff(): Autorregresion coefficients with Burg order equal to 4
-correlation(): correlation coefficient between two signals
-maxInds(): index of the frequency component with largest magnitude
-meanFreq(): Weighted average of the frequency components to obtain a mean frequency
-skewness(): skewness of the frequency domain signal 
-kurtosis(): kurtosis of the frequency domain signal 
-bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
-angle(): Angle between to vectors.
```
### Issues With Variable Names
The complete set of summary statistics are what are included in the 561 element "feature vector", with the names for each of the 561 elements given in the "features.txt" file.  There is a labeling problem with the "bandsEnergy()" statistic.  14 different bands are included for 3 different variables, and each is repeated three times.  These three repetitions are probably intended to be for the XYZ directions, but they are not labeled uniquely in the "features.txt file", leading to some uncertainty as to their actual meaning.  For the purposes of this class project, this problem will be ignored, as we are not asked to use the bandsEnergy summary statistic. An alternate approach would be to assign an X, Y and Z to each successive occurrence of the same variable name.  This should probably be followed up by correspondence with the original data authors to ensure that this approach was correct.

Another issue with the "features.txt" file is the meaning of magnitude variables in the frequency domain including the term "BodyBody".  This shows up in 39 variables, and any meaning is not obvious.  When paired with comparable time domain magnitude variables, it appears that the duplicate use of "Body" is an error.  This will be assumed to be true for this work, and duplicate instances of "Body" will be eliminated.  The table below compares the time and frequency domain variable names from the features.txt file for the standard deviation of magnitudes.  Gravity variables are excluded because they occur only in the time domain.  Note the unexplained BodyBody occurrence in the frequency domain.

|Time Domain           |Frequency Domain          |
|:--------------------:|:------------------------:|
|tBodyAccMag-std()     |fBodyAccMag-std()         |
|tBodyAccJerkMag-std() |fBodyBodyAccJerkMag-std() |
|tBodyGyroMag-std()    |fBodyBodyGyroMag-std()    |
|tBodyGyroJerkMag-std()|fBodyBodyGyroJerkMag-std()|

The basic data measurements have units (gravities and radians per second), but the statistics given in the features vector have been normalized, and are unit less. This doesn't necessarily make any sense for some of the variables, such as for the angle measurements, which are assumed to be in radians.  Fortunately, the questionable variables are not included in the assigned class project.

### Variables Used in Final Data Set
Below are the variable names used for the subset of variables (mean and standard deviation only) required for the class project.  The names have been expanded to make them self explanatory.  As stated in the original data README file, the feature variables have been normalized and are bounded within a range of [-1,1 ]. They are therefore unit less.
```
Subject
Activity
Time_Domain_Body_Acceleration_mean_in_X_Direction
Time_Domain_Body_Acceleration_mean_in_Y_Direction
Time_Domain_Body_Acceleration_mean_in_Z_Direction
Time_Domain_Body_Acceleration_standard_deviation_in_X_Direction
Time_Domain_Body_Acceleration_standard_deviation_in_Y_Direction
Time_Domain_Body_Acceleration_standard_deviation_in_Z_Direction
Time_Domain_Gravity_Acceleration_mean_in_X_Direction
Time_Domain_Gravity_Acceleration_mean_in_Y_Direction
Time_Domain_Gravity_Acceleration_mean_in_Z_Direction
Time_Domain_Gravity_Acceleration_standard_deviation_in_X_Direction
Time_Domain_Gravity_Acceleration_standard_deviation_in_Y_Direction
Time_Domain_Gravity_Acceleration_standard_deviation_in_Z_Direction
Time_Domain_Body_Acceleration_Jerk_mean_in_X_Direction
Time_Domain_Body_Acceleration_Jerk_mean_in_Y_Direction
Time_Domain_Body_Acceleration_Jerk_mean_in_Z_Direction
Time_Domain_Body_Acceleration_Jerk_standard_deviation_in_X_Direction
Time_Domain_Body_Acceleration_Jerk_standard_deviation_in_Y_Direction
Time_Domain_Body_Acceleration_Jerk_standard_deviation_in_Z_Direction
Time_Domain_Body_Gyro_mean_in_X_Direction
Time_Domain_Body_Gyro_mean_in_Y_Direction
Time_Domain_Body_Gyro_mean_in_Z_Direction
Time_Domain_Body_Gyro_standard_deviation_in_X_Direction
Time_Domain_Body_Gyro_standard_deviation_in_Y_Direction
Time_Domain_Body_Gyro_standard_deviation_in_Z_Direction
Time_Domain_Body_Gyro_Jerk_mean_in_X_Direction
Time_Domain_Body_Gyro_Jerk_mean_in_Y_Direction
Time_Domain_Body_Gyro_Jerk_mean_in_Z_Direction
Time_Domain_Body_Gyro_Jerk_standard_deviation_in_X_Direction
Time_Domain_Body_Gyro_Jerk_standard_deviation_in_Y_Direction
Time_Domain_Body_Gyro_Jerk_standard_deviation_in_Z_Direction
Time_Domain_Body_Acceleration_Magnitude_mean
Time_Domain_Body_Acceleration_Magnitude_standard_deviation
Time_Domain_Gravity_Acceleration_Magnitude_mean
Time_Domain_Gravity_Acceleration_Magnitude_standard_deviation
Time_Domain_Body_Acceleration_Jerk_Magnitude_mean
Time_Domain_Body_Acceleration_Jerk_Magnitude_standard_deviation
Time_Domain_Body_Gyro_Magnitude_mean
Time_Domain_Body_Gyro_Magnitude_standard_deviation
Time_Domain_Body_Gyro_Jerk_Magnitude_mean
Time_Domain_Body_Gyro_Jerk_Magnitude_standard_deviation
Frequency_Domain_Body_Acceleration_mean_in_X_Direction
Frequency_Domain_Body_Acceleration_mean_in_Y_Direction
Frequency_Domain_Body_Acceleration_mean_in_Z_Direction
Frequency_Domain_Body_Acceleration_standard_deviation_in_X_Direction
Frequency_Domain_Body_Acceleration_standard_deviation_in_Y_Direction
Frequency_Domain_Body_Acceleration_standard_deviation_in_Z_Direction
Frequency_Domain_Body_Acceleration_Jerk_mean_in_X_Direction
Frequency_Domain_Body_Acceleration_Jerk_mean_in_Y_Direction
Frequency_Domain_Body_Acceleration_Jerk_mean_in_Z_Direction
Frequency_Domain_Body_Acceleration_Jerk_standard_deviation_in_X_Direction
Frequency_Domain_Body_Acceleration_Jerk_standard_deviation_in_Y_Direction
Frequency_Domain_Body_Acceleration_Jerk_standard_deviation_in_Z_Direction
Frequency_Domain_Body_Gyro_mean_in_X_Direction
Frequency_Domain_Body_Gyro_mean_in_Y_Direction
Frequency_Domain_Body_Gyro_mean_in_Z_Direction
Frequency_Domain_Body_Gyro_standard_deviation_in_X_Direction
Frequency_Domain_Body_Gyro_standard_deviation_in_Y_Direction
Frequency_Domain_Body_Gyro_standard_deviation_in_Z_Direction
Frequency_Domain_Body_Acceleration_Magnitude_mean
Frequency_Domain_Body_Acceleration_Magnitude_standard_deviation
Frequency_Domain_Body_Acceleration_Jerk_Magnitude_mean
Frequency_Domain_Body_Acceleration_Jerk_Magnitude_standard_deviation
Frequency_Domain_Body_Gyro_Magnitude_mean
Frequency_Domain_Body_Gyro_Magnitude_standard_deviation
Frequency_Domain_Body_Gyro_Jerk_Magnitude_mean
Frequency_Domain_Body_Gyro_Jerk_Magnitude_standard_deviation
```