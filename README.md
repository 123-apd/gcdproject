Getting and cleaning data - The project
==========


This file contains a description of the R codes found in the file run_analysis.R
The R code combines different datasets from the Machine Learning Repository, and produces a tidy table.
This table includes data that are gathered from the gyro in a cellular phone, as well as the recorded activity of the indiviuals carrying the phone. The data can then be used to predict the activity of individuals by interpreting the gyro data. The table contains both observations (training data), and predictions (test data). The tidy table consists only of columns from the gyro that descripe means and standard deviations of other variables.

### Packages used are:
+ sqldf
+ data.table

### An example of sql syntax applied in the R code:

tbl5 <- sqldf("select tbl4.*, labls.V2 actname from  labls, tbl4 where labls.V1 = tbl4.actid order by tbl4.key1")

### What it does:
Create a table named tbl5, by selecting all columns in the table tbl4, and combine with activity names in the table labls.
This creates a columns named actname in tbl5, and all values in tbl5 are sorted by the original order in tbl4 by looking at the column tbl4.key1.
