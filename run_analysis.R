
library(dplyr)

getwd()
setwd("D:/Formation/Spécialisation Data Science/Cours 3 - Getting and cleaning data/Week 4/Course Project/data/UCI HAR Dataset")


############ FEATURES AND ACTIVITIES LABELS ############

## import features and activities labels
features <- read.table("features.txt")
activities <- read.table("activity_labels.txt")



############ TEST AND TRAIN MEASUREMENTS ############

## importing test ant train measurements
x_test <- read.table("test/X_test.txt")
x_train <- read.table("train/X_train.txt")

## merging the 2 tables 
datamerged <- rbind(x_test,x_train)

## renaming the variables with the second column of the features table
names(datamerged) <- features[ ,2]

## keeping the measurements columns (mean and std (for standard deviation))
datamerged <- datamerged[grepl("std|mean",names(datamerged),ignore.case=TRUE)]
## datamerged has now 86 variables (561 before)

## Verif
View(head(datamerged,3))


############ ACTIVITIES ############

## importing activities
test_activities <- read.table("test/Y_test.txt")
train_activities <- read.table("train/Y_train.txt")

## merging the 2 tables 
activities_merged <- rbind(test_activities, train_activities)

## applying the activities labels
for (i in 1:nrow(activities_merged)){
        if (activities_merged[i,]==1) {activities_merged[i,]="Walking"}
        if (activities_merged[i,]==2) {activities_merged[i,]="Walking upstairs"}
        if (activities_merged[i,]==3) {activities_merged[i,]="Walking downstairs"}
        if (activities_merged[i,]==4) {activities_merged[i,]="Sitting"}
        if (activities_merged[i,]==5) {activities_merged[i,]="Standing"}
        if (activities_merged[i,]==6) {activities_merged[i,]="Laying"}
}

## Verif
View(head(activities_merged,200))



############ VOLOUNTEERS ID ############

## import volounteers id
id_test <- read.table("test/subject_test.txt")
id_train <- read.table("train/subject_train.txt")

## merging the 2 tables
id_merged <- rbind(id_test, id_train)

## Verif
View(id_merged)


################## GET THE FINAL TABLE ################## 
### (with the ID, the activities and the measurements) ###


## merging the last table
datamerged <- cbind(id_merged, activities_merged, datamerged)

## renaming the 2 first variables (V1 and V1)
names(datamerged)[1:2] <- c("VolunteerID", "Activities")

## Verif
View(head(datamerged,20))



################### Second independant tidy data set ###################
# with the average of each variable for each activity and each subject #

## group by the ID and the Activities
activity_group<-group_by(datamerged, VolunteerID, Activities) %>%
        summarise_all(funs(mean))
View(activity_group)


