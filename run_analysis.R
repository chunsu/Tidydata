## This is a R scrip extracting raw/messy data from UCI 2012 smartphones data set and generating a tidy data saved as 'tidydata.txt'
##(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 

## Important: the function requires the downloaded data folder 'UCI HAR Dataset' in the current R working directory

run_analysis <- function(){


		if(!file.exists("UCI HAR Dataset")){
			stop( "please include 'UCI HAR Dataset' in your directory!" )
		}
## Task 1: Merges the training and the test sets to create one dataset.

		test_X  <- read.table("./UCI HAR Dataset/test/X_test.txt")
		train_X <- read.table("./UCI HAR Dataset/train/X_train.txt")

		## stack the two data frames together into new data frame "alldata" 
		alldata <- rbind(test_X,train_X)


## Task 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
		library(dplyr)
		## Note: downstream processing needs spliting string value, so here we turn off the stringAsFactor argument
		features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactor = FALSE)
		colname <- features[,2]

		## Note: during the downstream processing, mutate function treats some of the feature names as duplicates, so here we make them unique
		## E.g. "fBodyAcc-bandsEnergy()-17,24" "fBodyAcc-bandsEnergy()-25,32" "fBodyAcc-bandsEnergy()-33,40" considered duplicates
		colname_new <- make.names(colname, unique=TRUE, allow_ = TRUE)

		## Extracts names only for mean (mean) and standard deviation (std) 
				## >colname_new
				## [1] "tBodyAcc.mean...X"   "tBodyAcc.mean...Y"   "tBodyAcc.mean...Z"    "tBodyAcc.std...X"                    
		  		## [5] "tBodyAcc.std...Y"    "tBodyAcc.std...Z"    "tBodyAcc.mad...X"     "tBodyAcc.mad...Y"  
		  		## ....
		## we want "fBodyAccJerk.mean.." and "fBodyAccJerk.std.." but not "fBodyAccJerk-meanFreq" as the last is not a mean of measurement
		selected_name <- grep('\\.(mean|std)\\.+',colname_new,value = TRUE)
		selected_name_id <- grep('\\.(mean|std)\\.+',colname_new)
		selected_data <- select(alldata, selected_name_id)
		

## Task 3: Uses descriptive activity names to name the activities in the dataset

		## Import activity index-label pair from file "activity_labels.txt"
		activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

		activity <- activity_labels[,2]

		## Import activity index lable
		test_y  <- read.table("./UCI HAR Dataset/test/Y_test.txt")
		train_y <- read.table("./UCI HAR Dataset/train/Y_train.txt")
		
		## Replace index label with actual activity label
		all_labels <- c(test_y[,1],train_y[,1])
		all_labels <- factor(all_labels, labels = activity)

		## Add a new column to the dataframe
		selected_data <- mutate(selected_data,activity_type = all_labels)


## Task 4: Appropriately label the dataset with descriptive variable names.

		## Here we replace all abbreviations with complete words, such as "acceleration" with "Acc", "time_domain_signal" instead of "t"
		selected_name <- sub("^(f|t)(.+)(mean|std)","\\3_ \\1 \\2", selected_name)
		selected_name <- sub("std", "standard_deviation_of", selected_name)
		selected_name <- sub(" t ", "time_domain_signal", selected_name)
		selected_name <- sub("Body|BodyBody", "_body", selected_name)
		selected_name <- sub(" f ", "frequency_domain_signal", selected_name)
		selected_name <- sub("Acc", "_acceleration", selected_name)
		selected_name <- sub("Jerk", "_jeck", selected_name)
		selected_name <- sub("X", "_on_x_axis", selected_name)
		selected_name <- sub("Y", "_on_y_axis", selected_name)
		selected_name <- sub("Z", "_on_z_axis", selected_name)
		selected_name <- sub("Mag", "_magnitude", selected_name)
		selected_name <- sub("Gyro", "_gyroscope", selected_name)
		selected_name <- sub("\\.+", "", selected_name)
	
		colnames(selected_data)[1:length(selected_name_id)] = selected_name
		write.table(selected_name,'selected_features.txt')

		
## Task 5: From the dataset in step 4, creates a second, independent tidy dataset with the average of each variable for each activity and each subject.
		
		## Import subject index
		subject_test  <- read.table("./UCI HAR Dataset/test/subject_test.txt")
		subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
		subject <- c(subject_test[,1],subject_train[,1])	
		list(mean = mean, median = median)

		## Add subject column to the dataframe and group data frame with subject and activity_type
		selected_data <- mutate(selected_data, subject = subject)  
		ff <- group_by(selected_data,subject,activity_type) 

		## Generate a tidydata data frame and save as a txt file
		tidydata <- summarise_all(ff,funs(mean)) 
		write.table(tidydata,'tidydata.txt',row.name=FALSE)


}