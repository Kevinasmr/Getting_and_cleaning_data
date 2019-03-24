## Getting and cleaning data
Course project with Coursera

This repo explains how all of the scripts work and how they are connected
You will find in this repo :
1) a tidy data set
2) a code book that describes the variables, the data, and any transformations or work performed to clean up the data called CodeBook.md.
3) a README.md with the scripts. This repo explains how all of the scripts work and how they are connected.

The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

Here are the data for the project:

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

The tidy data is create by one R script called run_analysis.R, that does the following:
1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement.
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names.
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



## The code

The code contain some verification below the __verif__ ligne, it's just a view of the created table.


Starting by load the dplyr package and set the Working Directory to the __UCI HAR Dataset__ folder (where the data are)


We read this 2 files __features__ and __activity_labels__
<blockquote>## import features and activities labels 
<br/>features <- read.table("features.txt") 
<br/>activities <- read.table("activity_labels.txt")</blockquote>


Reading the measurements files from __test__ and __train__ folders and combine them in our futur final dataset with __rbind()__
<blockquote>## importing test ant train measurements
<br/>x_test <- read.table("test/X_test.txt")
<br/>x_train <- read.table("train/X_train.txt")
<br/>
<br/>## merging the 2 tables 
<br/>datamerged <- rbind(x_test,x_train)</blockquote>


We put the name of the variables from the __features__ table into our new main dataset __datamerged__
<blockquote>## renaming the variables with the second column of the features table
<br/>names(datamerged) <- features[ ,2]</blockquote>


We keep the measurements columns who talk about mean and standard deviation. We are looking for the words "std" and "mean" as keyword in the variables names and keep only these ones.
__datamerged__ has now 86 variables, against 561 before.
<blockquote>## keeping the measurements columns (mean and std (for standard deviation))
<br/>datamerged <- datamerged[grepl("std|mean",names(datamerged),ignore.case=TRUE)]</blockquote>


Reading the activities files from __test__ and __train__ folders and combine them with __rbind()__
<blockquote>## importing activities
<br/>test_activities <- read.table("test/Y_test.txt")
<br/>train_activities <- read.table("train/Y_train.txt")
<br/>
<br/>## merging the 2 tables 
<br/>activities_merged <- rbind(test_activities, train_activities)</blockquote>


We apply the 6 labels of the activities with a __for__ loop
<blockquote>## applying the activities labels
<br/>for (i in 1:nrow(activities_merged)){
<br/>				if (activities_merged[i,]==1) {activities_merged[i,]="Walking"}
<br/>				if (activities_merged[i,]==2) {activities_merged[i,]="Walking upstairs"}
<br/>				if (activities_merged[i,]==3) {activities_merged[i,]="Walking downstairs"}
<br/>				if (activities_merged[i,]==4) {activities_merged[i,]="Sitting"}
<br/>				if (activities_merged[i,]==5) {activities_merged[i,]="Standing"}
<br/>				if (activities_merged[i,]==6) {activities_merged[i,]="Laying"}
<br/>}</blockquote>


Reading the id files from __test__ and __train__ folders and combine them with __rbind()__
<blockquote>## import volounteers id
<br/>id_test <- read.table("test/subject_test.txt")
<br/>id_train <- read.table("train/subject_train.txt")
<br/>
<br/>## merging the 2 tables
<br/>id_merged <- rbind(id_test, id_train)</blockquote>
  

Finally, we can merge the id table (__id_merged__), the activities table (__activities_merged__) and the measurements table (__datamerged__) to get the finally and tidy data set. We rename the two first variables (the id and the activity)
<blockquote>## merging the last table
<br/>datamerged <- cbind(id_merged, activities_merged, datamerged)
<br/>
<br/>## renaming the 2 first variables (V1 and V1)
<br/>names(datamerged)[1:2] <- c("VolunteerID", "Activities")</blockquote>
  

We create the second tidy data set, with the average of each variable for each activity (__Activities__) and each subject (__VolunteerID__).
<blockquote>## group by the ID and the Activities
<br/>activity_group<-group_by(datamerged, VolunteerID, Activities) %>%
<br/>        summarise_all(funs(mean))</blockquote>
