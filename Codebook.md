# getting-cleaningdata
getting and cleaning data - course project - codebook
sskuri1
********************************************************
The script run_analysis.R performs the 5 steps described in the course project instructions and this codebook contains additional information about the variables, data and transformations used in the course project.
********************************************************
Data source:
The site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
A full description of the data used in this project can be found at The UCI Machine Learning Repository
********************************************************
Data Set Information
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.
The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.
********************************************************
Attribute Information
Following data was provided for each record in the dataset:
Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
Triaxial Angular velocity from the gyroscope.
A 561-feature vector with time and frequency domain variables.
Its activity label.
An identifier of the subject who carried out the experiment.
********************************************************
The run_analysis.R script performs the following steps to clean the data:
I. loads the packages plyr and dplyr
II. Merges the training and the test sets to create one data set in 5 steps.
	A. Reading data
		1. Read X_train.txt, y_train.txt and subject_train.txt from the "./data/train" folder and store them in trainingSet, trainingActivity and trainingSubject variables respectively.
		2. Read X_test.txt, y_test.txt and subject_test.txt from the "./data/test" folder and store them in testingSet, testingActivity and testingSubject variables respectively.
	B. Merging data
		3. Concatenate testingSet & trainingSet to generate a 10299x561 data frame called setComplete; concatenate testingActivity & trainingActivity to generate a 10299x1 data frame called activityComplete; concatenate testingSubject to trainingSubject to generate a 10299x1 data frame, subjectComplete.
	C. Naming the columns
		4. Name the column in activityComplete as activity ID and subjectComplete as subject
	D. combine to create complete dataset	
		5. combine setComplete, subjectComplete and activityComplete into a 10299 x564 dataframe called dataComplete
III. Extracts only the measurements on the mean and standard deviation for each measurement. 
	Subset the dataComplete dataframe using the grep command on the column names to extract only the mean and std columns along with subject and activity id resulting in a dataframe 10299x 68 named dataMeanStd	
IV. Uses descriptive activity names to name the activities in the data set
	A. read the acitivity labels from the activity_labels.txt in the folder
	B. based on the activity id set the activity labels in the dataframe using a for loop (ths was added as an extra column resulting in a 10299x69 dataframe)
	### this exercise was done on the dataComplete dataframe in addition to the dataMeanStd dataframne
V. Appropriately labels the data set with descriptive variable names. 
	Use gsub function for pattern replacement to clean up the data labels.
	### this exercise was done on the dataComplete dataframe in addition to the dataMeanStd dataframne
VI. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.	
	There are 30 unique subjects and 6 unique activities, which result in a 180 combinations of the two. Then, for each combination, we calculate the mean of each measurement with the corresponding combination resulting in a 180x69 data frame. Write the result out to "tidydata.txt" file in current working directory.	
