## This is a R scrip extracting raw/messy data from UCI 2012 smartphones data set and generating a tidy data saved as 'tidydata.txt'
##(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) 

## Important: the function requires the downloaded data folder 'UCI HAR Dataset' in the current R working directory


run_analysis <- function(){


		if(!file.exists("UCI HAR Dataset")){
			stop( "please include 'UCI HAR Dataset' in your directory!" )
		}
## Task 1: Merges the training and the test sets to create one dataset.

		## Note: before read data into data frame, visual inspection of the txt file and found it's in fix width. 
		## Count the length of the value and specify the width using read_fwf function 
		test_X  <- read.fwf("./UCI HAR Dataset/test/X_test.txt",   rep(16,1,561), header = FALSE)
		train_X <- read.fwf("./UCI HAR Dataset/train/X_train.txt", rep(16,1,561), header = FALSE)

		## stack the two data frames together into new data frame "alldata" 
		alldata <- rbind(test_X,train_X)


## Task 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
		library(dplyr)
		## Note: downstream processing needs spliting string value, so here we turn off the stringAsFactor argument
		features <- read.delim("./UCI HAR Dataset/features.txt", sep="\n", header = FALSE, stringsAsFactor = FALSE)

		## The values started with extra order number, so get rid of it 
				## > head(features, 2)
				## 1 1 tBodyAcc-mean()-X
				## 2 2 tBodyAcc-mean()-Y
		colname <- strsplit(features[,1],split="[0-9] ") 
		SecondElement <- function(x){x[2]}
		colname <- sapply(colname,SecondElement)
		## Note: Above 3 lines can be done in one regular expression: sub("[0-9 ]+(\\w+)", "\\1", features[,1])

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
		alldata <- select(alldata, selected_name)
		

## Task 3: Uses descriptive activity names to name the activities in the dataset

		## Import activity index-label pair from file "activity_labels.txt"
		activity_labels <- read.delim("./UCI HAR Dataset/activity_labels.txt", header = FALSE, stringsAsFactor = FALSE)
		activity <- strsplit(activity_labels[,1],split="[0-9] ") 

		## Recall previous defined function ##SecondElement <- function(x){x[2]}
		activity <- sapply(activity,SecondElement)

		## Import activity index lable
		test_y  <- read.delim("./UCI HAR Dataset/test/Y_test.txt",   sep ="\n", header = FALSE)
		train_y <- read.delim("./UCI HAR Dataset/train/Y_train.txt", sep ="\n", header = FALSE)
		
		## Replace index label with actual activity label
		all_labels <- c(test_y[,1],train_y[,1])
		all_labels <- factor(all_labels, labels = activity)

		## Add a new column to the dataframe
		alldata <- mutate(alldata,activity_type = all_labels)


## Task 4: Appropriately label the dataset with descriptive variable names.

		## Here we replace all abbreviations with complete words, such as "acceleration" with "Acc", "time_domain_signal" instead of "t"
		colname_new <- sub("^t(.+)", "time_domain_signal_\\1", colname_new)
		colname_new <- sub("Body|BodyBody", "body", colname_new)
		colname_new <- sub("^f(.+)", "frequency_domain_signal_\\1", colname_new)
		colname_new <- sub("Acc", "_acceleration_", colname_new)
		colname_new <- sub("X", " on_x_axis", colname_new)
		colname_new <- sub("Y", " on_y_axis", colname_new)
		colname_new <- sub("Z", " on_z_axis", colname_new)
		colname_new <- sub("Mag", "_magnitude_", colname_new)
		colname_new <- sub("Gyro", "_gyroscope_", colname_new)
		colname_new <- sub("angle.(.*)\\.(.*)\\.", "angle_between_\\1 and \\2", colname_new)
		colnames(alldata)[1:561] = colname_new

		
## Task 5: From the dataset in step 4, creates a second, independent tidy dataset with the average of each variable for each activity and each subject.
		
		## Import subject index
		subject_test  <- read.delim("./UCI HAR Dataset/test/subject_test.txt",   sep="\n", header = FALSE)
		subject_train <- read.delim("./UCI HAR Dataset/train/subject_train.txt", sep="\n", header = FALSE)
		subject <- c(subject_test[,1],subject_train[,1])	
		list(mean = mean, median = median)

		## Add subject column to the dataframe and group data frame with subject and activity_type
		alldata <- mutate(alldata, subject = subject)  
		ff <- group_by(alldata,subject,activity_type) 

		## Generate a tidydata data frame and save as a txt file
		tidydata <- summarise_all(ff,funs(mean)) 
		write.table(tidydata,'tidydata.txt',row.name=FALSE)


}