Getting and cleaning data - The project
==========


This file contains a description of the R codes found in the file run_analysis.R
The R code combines different datasets from the Machine Learning Repository, and produces a tidy table.
This table includes data that are gathered from the gyro in a cellular phone, as well as the recorded activity of the indiviuals carrying the phone. The data can then be used to predict the activity of individuals by interpreting the gyro data. The table contains two sets of the recorded data( training data and test data). 

### More information on the datasetes available here:
[UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)

As you may have noticed, the assignment has been subject to a lot of discussion on the Coursera forums due to the many ways the assignment can be solved. Below are two lists. List A contains the different steps the assignment requests. List B shows how I have interpreted and solved the different steps.

### List A - The assignments
1. Merges the training and the test sets to create one data set.

2. Extract only the measurements on the mean and standard deviation for each measurement.

3. Use descriptive activity names to name the activities in the data set.

4. Appropriately labels the data set with descriptive activity names.

5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

### List B - My interpretations and solutions



### Packages used are:
+ sqldf
+ data.table



### An example of sql syntax applied in the R code:

tbl5 <- sqldf("select tbl4.*, labls.V2 actname from  labls, tbl4 where labls.V1 = tbl4.actid order by tbl4.key1")

### What it does:
Create a table named tbl5, by selecting all columns in the table tbl4, and combine with activity names in the table labls.
This creates a columns named actname in tbl5, and all values in tbl5 are sorted by the original order in tbl4 by looking at the column tbl4.key1.
