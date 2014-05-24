Getting and cleaning data - The project
==========


This file contains a description of the R codes found in the file run_analysis.R
The R code combines different datasets from the Machine Learning Repository, and produces a tidy table.
This table includes data that are gathered from the gyro in a cellular phone, as well as the recorded activity of the indiviuals carrying the phone. The data can then be used to predict the activity of individuals by interpreting the gyro data. The table contains two sets of the recorded data( training data and test data). 

### More information on the datasetes available here:
[UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)

As you may have noticed, the assignment has been subject to a lot of discussion on the Coursera forums due to the many ways the assignment can be solved. Below are two lists. List A contains the different steps the assignment requests. List B shows how I have interpreted and solved the different steps.

### List A - The assignments
1. Merge the training and the test sets to create one data set.

2. Extract only the measurements on the mean and standard deviation for each measurement.

3. Use descriptive activity names to name the activities in the data set.

4. Appropriately labels the data set with descriptive activity names.

5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

### List B - My interpretations and solutions
1. I've merged the txt files subject_train.txt, y_train.txt, x_train.txt, subject_test.txt, y_test.txt, X_test.txt, features.txt and labels.txt 

2. Fields (columns) in the files y_train.ttxt, y_test.txt, x_train.txt and x_test.txt NOT containing the substrings mean and std after the files have been combined with the file features.txt, have been dropped from the dataset. The resulting table is named table_mean_std. Note that the principles of tidy variable names will not be appplied fully until step 5.

3. Labels / activitynames have been edited. Letters are now lowercase, and "_" have been removed. Labels have also been added to the dataset, so that the activity in each record (row) can be identified by name and not only the corresponding integer ID (This could just as well have been a part of the next step).

4. According to the principles of tidy data and the suggestions in the Coursera lecture "Editing text variables", the names of variables should be: all lower case when possible, descriptive, not duplicated, and not have underscores or dots or white spaces. Here's an example of variable names in the dataset: tBodyAcc-mean()-Y. It's hard to come up with a name that is tidy and still sufficiently descriptive. My suggestion is to remove parentheses and other symbols, make all letters lower case, and explain the "t" in tbody. Thus, this particular name will look like this: timebody_accmeany. I've added an underscore which should not be there according to the list above, but I think it looks nicer and makes the names easier to read.

5. My interpretation of this step is to focus on the averages of the averages that have been listed under step 2. I could just as well have included the average of the standard deviaton fields in the very same table, but I don't think it would make much sence to look at an aggregated average of standard devations. The table from this step is named table_tidy_averages. The first and second fields are subjects and activities. The remaining fields are pupulated with the averages of the fields containing averages for each feature from the dataset.

### Packages used in the code are:
+ sqldf
+ data.table


### An example of some simple sql syntax applied in the R code:

tbl5 <- sqldf("select tbl4.*, labls.V2 actname from  labls, tbl4 where labls.V1 = tbl4.actid order by tbl4.key1")

### What it does:
Create a table named tbl5, by selecting all columns in the table tbl4, and combine with activity names in the table labls.
This creates a columns named actname in tbl5, and all values in tbl5 are sorted by the original order in tbl4 by looking at the column tbl4.key1.

### An example of a more advanced sql query:
sqx1 <- sqldf("select subjects, actname, avg(timebody_accmeanx) from tbl_mean_tidy  group by subjects, actname")

### What it does:
It produces a part of the table requested in step 5 of the assignment. Note however that this table contains only ONE column with averages for ONE feature listed by subject and activity. In order to have all the requested fields added to the quiery and resulting table, I wrote a For Loop to include them in the string applied in the sqldf function.

It'll all be clear once you have a look at the code in the 

