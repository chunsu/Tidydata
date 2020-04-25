# 					the code book for run_analysis.r
## Input variables
- `activity_labels`  types of activity conducted by the subject during the measurement
1. WALKING				
2. WALKING_UPSTAIRS
3. WALKING_DOWNSTAIRS
4. SITTING
5. STANDING			
6. LAYING		
- `test_X` and `train_X` values of measurements 
- `features`  names of the measurements
-  `test_Y` and `train_Y` label activity type with index 1 ~ 6
-  `subject_test` and `subject_train` label participated subject with index 1 ~ 30


## Variables generated:
- `alldata` is a dataframe with combined measurements from test and training datasets
- `colname` and `colname_new` are dataframes containing all the names of 561 measurements. The latter makes sure all names are unique for downstream processing
- `selected_name` and `selected_name_id` are dataframes containing the names and the index numbers of measurements on the mean and standard deviation as required by assignment task no.2
- `selected_data` is a dataframe with the measurements on the mean and standard deviation as required by assignment task no.2
- `all_labels` is a dataframe containing the type of activity for each observation row
- `subject` is a dataframe containing the participant's subject id for each observation row
- `ff` is the selected_data grouped by subject and activity_type
- `tidydata` is the final product dataframe containing the tidy data as required by task no.5 



