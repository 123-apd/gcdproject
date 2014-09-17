
# Getting and Cleaning Data Project

# Settings
# The Code assumes that the working directory is C:/gcdproject, and that the data is stored in 
# C:/gcdproject/UCI HAR Dataset

setwd("C:/gcdproject")

# Packages
require(sqldf)
require(data.table)

# Getting data 

# Retrieving values from working directory
s_tr <- data.table(read.table("UCI HAR Dataset/train/subject_train.txt", comment.char = "", colClasses="numeric"))
y_tr <- data.table(read.table("UCI HAR Dataset/train/y_train.txt"))
x_tr <- data.table(read.table("UCI HAR Dataset/train/X_train.txt"))

s_ts <- data.table(read.table("UCI HAR Dataset/test/subject_test.txt", comment.char = "", colClasses="numeric"))
y_ts <- data.table(read.table("UCI HAR Dataset/test/y_test.txt"))
x_ts <- data.table(read.table("UCI HAR Dataset/test/X_test.txt"))

feats <- data.table(read.table("UCI HAR Dataset/features.txt"))
labls <- data.table(read.table("UCI HAR Dataset/activity_labels.txt"))
labls$V2 <- tolower(labls$V2)
labls$V2 <- gsub("_", '', labls$V2, fixed = T)
labls

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

# Making the table requested in step 2 in the assignment 
table_mean_std <- tbl5

# Finding columns that contain means
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
#fix(tbl_mean_tidy)

tbl_sql_names <- data.table(mname5)
# View(tbl_sql_names)

# Preparing for query

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

# Stores all field names for which we would like to compute averages. The resulting string is later used in the sqldf query.
for (i in 1:length(mname5) ) {
  addstr<- paste(str1, mname5[i], str2, sep = "")
  runstr <- paste(runstr, addstr, sep = ",")
}

runstr2 <- substring(runstr, 2, nchar(runstr))
runstr2

quer1 <- "select subjects, actname, "
quer2 <-  " from tbl_mean_tidy  group by subjects, actname"

# Executing query
bigquery <- paste(quer1, runstr2, quer2, sep = "")
tbl_new <- sqldf("select subjects, actname, avg(frequencybody_bodygyrojerkmagmeanfreq), avg(frequencybody_bodygyrojerkmagmeanfreq) from tbl_mean_tidy  group by subjects, actname")
fix(tbl_new)

fix(bigquery)

table_tidy_averages <- sqldf(bigquery)
fix(table_tidy_averages)

# Making field names more tidy
oldnames <- names(table_tidy_averages)
tidynames <- gsub("avg(", 'average_', oldnames, fixed = T)
tidynames <- gsub(")", '', tidynames, fixed = T)
tidynames <- gsub("actname", 'activity', tidynames, fixed = T)
setnames(table_tidy_averages,old = oldnames, new = tidynames)

# Stores table_tidy_averages as a csv file in the working directory
write.table(table_tidy_averages, "c:/gcdproject/table_tidy_averages.txt", sep=",")
