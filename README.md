Getting and cleaning data - The project
==========

## Introduction (tl;dR)
This file contains a description of the R codes found in the file run_analysis.R
The R code combines different datasets from the Machine Learning Repository, and produces a tidy table.
This table includes data that are gathered from the gyro in a cellular phone, as well as the recorded activity of the indiviuals carrying the phone. The data can then be used to predict the activity of individuals by interpreting the gyro data. The table contains both observations (training data), and predictions (test data). The tidy table consists only of columns from the gyro that descripe means and standard deviations of other variables.

Packages used are:
+ sqldf
+ data.table
