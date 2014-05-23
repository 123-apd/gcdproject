
# Getting and Cleaning Data Project

# Settings
rm(list=ls())
getwd()
setwd("C:/Users/ad2888/Desktop/Coursera/getcleandata")
setwd("C:/gcdproject")
dir()

# Packages
require(sqldf)
require(data.table)

# Getting data 1/2

# download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "projectdata.zip")

# Retrieving values from working directory
s_tr <- data.table(read.table("UCI HAR Dataset/train/subject_train.txt", comment.char = "", colClasses="numeric"))
y_tr <- data.table(read.table("UCI HAR Dataset/train/y_train.txt"))
x_tr <- data.table(read.table("UCI HAR Dataset/train/X_train.txt"))

s_ts <- data.table(read.table("UCI HAR Dataset/test/subject_test.txt", comment.char = "", colClasses="numeric"))
y_ts <- data.table(read.table("UCI HAR Dataset/test/y_test.txt"))
x_ts <- data.table(read.table("UCI HAR Dataset/test/X_test.txt"))

feats <- data.table(read.table("UCI HAR Dataset/features.txt"))
labls <- data.table(read.table("UCI HAR Dataset/activity_labels.txt"))

# Renaming feats
feats$V1 <- NULL
old_feat_names = names(feats)
new_feat_names = "features"
setnames(feats,old = old_feat_names, new = new_feat_names)
remove(old_feat_names); remove(new_feat_names)

# Renaming s_tr and s_ts
old_subj_names = names(s_tr)
new_subj_names = "subjects"
setnames(s_tr,old = old_subj_names, new = new_subj_names)
remove(old_subj_names); remove(new_subj_names)

old_subj_names = names(s_ts)
new_subj_names = "subjects"
setnames(s_ts,old = old_subj_names, new = new_subj_names)
remove(old_subj_names); remove(new_subj_names)

# Renaming y_tr and y_ts
old_y_names = names(y_tr)
new_y_names = "actid"
setnames(y_tr,old = old_y_names, new = new_y_names)
remove(old_y_names); remove(new_y_names)

old_y_names = names(y_ts)
new_y_names = "actid"
setnames(y_ts,old = old_y_names, new = new_y_names)
remove(old_y_names); remove(new_y_names)

# Indicator for training set
idtrain <- (1:nrow(x_tr))
idtrain[1:nrow(x_tr)] = "train"
DT_idtrain <- data.table(idtrain)
# Rename variable in DT_idtest for later matching
setnames(DT_idtrain,old = "idtrain", new = "idtraintest")

# Indicator for testing set
idtest <- (1:nrow(x_ts))
idtest[1:nrow(x_ts)] = "test"
DT_idtest <- data.table(idtest)
# Rename variable in DT_idtest for later matching
setnames(DT_idtest,old = "idtest", new = "idtraintest")

# Renaming x_tr and x_ts
old_x_names1 <- names(x_tr)
old_x_names2 <- names(x_ts)
setnames(x_tr,old = old_x_names1, new = as.character(feats$features))
setnames(x_ts,old = old_x_names2, new = as.character(feats$features))
remove(old_x_names1); remove(old_x_names2)


# Building table step 1 :  x_tr, s_tr,  y_tr and DT_idtrain
tbl1 <- cbind(x_tr, s_tr, y_tr,DT_idtrain)
names(tbl1)

# Building table step 2 : x_ts, s_ts, y_ts and DT_idtest
tbl2 <- cbind(x_ts, s_ts, y_ts, DT_idtest)
names(tbl2)

# Building table step 3 : tbl1 and tbl2
tbl3 <- rbind(tbl1, tbl2)

# fix(tbl3)

# Make key for activity labels
key1 <- seq(1,nrow(tbl3),by=1)
length(key1)

# Building table step 4 : add key for later indexing
tbl4 <- cbind(key1, tbl3)

# Add activity names to tbl4 from the feats table
tbl5 <- sqldf("select tbl4.*, labls.V2 actname from  labls, tbl4 where labls.V1 = tbl4.actid order by tbl4.key1")

# Findind columns that contain means
names_mean_idx <- grep("mean()",names(tbl5))
names_mean_idx

names_mean <- names(tbl5)[names_mean_idx]
names_mean

tbl_mean <- subset(tbl5, select=c(names_mean))
tbl_mean_names_old <- names(tbl_mean)
mname1 <- tbl_mean_names_old

# Making understandable names in tbl_mean according to the principles of tidy data

mname2 <-gsub("___", '', mname1, fixed = T)
mname2 <-gsub("__", '', mname1, fixed = T)
mname2 <-gsub("_", '', mname1, fixed = T)
mname3 <- tolower(mname2)
mname3
mname3 <- gsub("tbody", 'timebody_', mname3, fixed = T)
mname3
mname4 <- gsub("fbody", 'frequencybody_', mname3, fixed = T)
mname4

mname5 <- gsub("tgravity", 'timegravity_', mname4, fixed = T)
mname5

# Changes names in the table tbl_mean, and adds relevant columns from tbl5 NOT containing info from the phone
setnames(tbl_mean,old = tbl_mean_names_old, new = mname5)
tbl_mean_tidy <- cbind(tbl5$key1, tbl_mean, tbl5$subjects, tbl5$idtraintest, tbl5$actname)
setnames(tbl_mean_tidy,old = c("tbl5$key1","tbl5$subjects", "tbl5$idtraintest", "tbl5$actname"), new =c("key1", "subjects", "idtraintest", "actname"))
fix(tbl_mean_tidy)


tbl_sql_names <- data.table(mname5)
View(tbl_sql_names)

# Preparing for monster MEAN query

i = 0
#qstr <- paste(
str<-paste("modelCheck(var",i,"_d.bug)",sep="")
str1<-paste("(","avg",sep="")
str1<-paste("avg","(",sep="")

str2 <- paste(")",sep="")

str1
str2

qstr2 <- paste(str1, mname5[1], str2, sep = "")
qstr2

runstr <- ""
addstr <- ""

for (i in 1:length(mname5) ) {
  #print(i)
  #newstr <- paste(str1,mname5[i],str2, sep = "")
  #print(newstr)
  addstr<- paste(str1, mname5[i], str2, sep = "")
  runstr <- paste(runstr, addstr, sep = ",")
  print(addstr)
}

runstr2 <- substring(runstr, 2, nchar(runstr))
runstr2

# sparr1 <- "select subjects, actname, avg(timebody_accmeanx) from tbl_mean_tidy  group by subjects, actname"

quer1 <- "select subjects, actname, "
quer2 <-  " from tbl_mean_tidy  group by subjects, actname"

# Executing monster MEAN query
bigquery <- paste(quer1, runstr2, quer2, sep = "")
bigquery

sqxxx <- sqldf(bigquery)
fix(sqxxx)


# Preparing for monster STDEV query
# FORTSETT HER I DAG


sqx1 <- sqldf("select subjects, actname, avg(timebody_accmeanx) from tbl_mean_tidy  group by subjects, actname")

sqx2 <- sqldf("select subjects, actname, avg(timebody_accmeanx), 
              avg(timegravity_accmeanx),
              avg(timebody_accjerkmeanx),
              avg(timebody_gyromeanx)
              from tbl_mean_tidy  group by subjects, actname")

sqx3 <- sqldf("select * from tbl_mean_tidy Pivot (avg(subjects) for subjects  ")

sgx4 <- sqldf(sparr1)





# Create a second, independent tidy data set with the average of each variable for each activity and each subject.
# sqx1 <- sqldf("select IncomeGroup, stdev(Rank)  from dtx group by IncomeGroup")

# sqx1 <- sqldf("select tbl_mean, stdev(Rank)  from dtx group by IncomeGroup")

# Findind columns that contain standard deviations !!!!!!
names_std_idx <- grep("std()",names(tbl5))
names_std_idx
names_std <- names(tbl5)[names_std_idx]
names_std
tbl_std <- subset(tbl5, select=c(names_std))

# Making understandable names in tbl_mean according to the principles of tidy data

# Tidy table step 1
tbl_tidy1 <- cbind(tbl_mean, tbl_std)
fix(tbl_tidy1)


# Write dataset as .csv
