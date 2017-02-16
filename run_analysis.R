#Data Source
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Download the data files and extract the dataset files
#download.file(url,"temp.zip",method="curl")
#unzip("temp.zip",exdir = "./")
#∫file.reove("temp.zip")

#read all the neccesary files
features<-read.table("UCI HAR Dataset/features.txt")
activities<-read.table("UCI HAR Dataset/activity_labels.txt")

x_test<-read.table("UCI HAR Dataset/test/X_test.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
activity_test<-read.table("UCI HAR Dataset/test/Y_test.txt")

x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
activity_train<-read.table("UCI HAR Dataset/train/Y_train.txt")

#Adding activity and subjects columns for both datasets.
x_test<-cbind(c(subject_test,activity_test),x_test)
x_train<-cbind(c(subject_train,activity_train),x_train)

#Merging training and test datasets
merged<-rbind(x_test,x_train)

#Assign Columns names and convert activity to string label (** Solved Questions 1, and Question 3 **)
colnames(merged)<-append(c("subject","activity"),as.character(features[,2]))
merged[["activity"]] <- activities[ match(merged[['activity']], activities[['V1']] ) , 'V2']

#Extract only desired columns (** Solved Question 2 **)
extracted<-merged[,c("subject","activity",grep("mean[(]|std[(]", names(merged), value = TRUE))]

#Format columns names (** Solved Question 4 **)
names(extracted) <- gsub("[()][-]{0,1}", "", names(extracted))
names(extracted) <- gsub("-std", "Std", names(extracted))
names(extracted) <- gsub("-mean", "Mean", names(extracted))

#Create a new tidy set with the means by subject and activity
library(dplyr)
tidy<-extracted %>%
    group_by(subject,activity) %>%
    summarise_each(funs(mean(., na.rm=TRUE)))

#Save the tidy set to txt file (** Solved Question 5 **)
write.table(tidy, "tidy.txt", row.name=FALSE)