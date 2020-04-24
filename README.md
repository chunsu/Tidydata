# Tidydata


Getting and Cleaning Data Course Project
Version 1.0


Assignment submitted by Chunsu Xu


## About function `run_analysis.R`
This is a R scrip extracting raw/messy data from UCI 2012 smartphones data set, and it returns a tidy data saved as ?tidydata.txt?. link for the raw data: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The script requires downloaded data folder ?UCI HAR Dataset? in current R working directory.



## (Before reading data, we have to) understand the experiment design
we learned that there were 30 participants (subjects), performing 6 types of activities when 561 variables were measured/derived from the signals generated from the accelarator and gyroscope inside the smartphone the subjects were wearing. With these information in mind, I first inspected all txt files in a text editor, to understand what each file is about


## The function requires the following files:

-  `test_X.txt` and `train_X.txt` are the measured values and to be joined together as the assignment asked

-  `features.txt` is 561-row long, therefore is the variable list to be used as colomn names for the measured data

-  `Y_test.txt` and `Y_train.txt` each only contains 6 levels (1~6), indicating they are the activity index

-  `activity_labels.txt` is a 6-row long desciptive name list. This is should replace the above activity index

-  `subject_test.txt` and `subject_train.txt` each contains 30 levels (1~30), indicating they are subject index

-  I see no obvious use of `Inertial Signals` folders



How to read the tidy data
=========================
address <- "https://s3.amazonaws.com/coursera-uploads/user-longmysteriouscode/asst-3/massivelongcode.txt"
address <- sub("^https", "http", address)
data <- read.table(url(address), header = TRUE) 
View(data)


Notes: 
======
1. I did not decompose the variable names. It?s tempting to treat below 4 variables as 4 values of the same variable. However, I do not understand what does ?Autorregresion coefficients with Burg order equal to 4? mean and therefore I treat them as independent measures.

   tBodyAcc-arCoeff()-X,1
   tBodyAcc-arCoeff()-X,2
   tBodyAcc-arCoeff()-X,3
   tBodyAcc-arCoeff()-X,4

2. I choose wide form for generating the tidydata.txt. Please refer David Hood for discussion about wide or narrow/long form




Reference:
========
tidy data principle and some tips about this assignment

[1] Hadley Wickham. Tidy data. The Journal of Statistical Software, vol. 59, 2014.

[2] David Hood. https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/


