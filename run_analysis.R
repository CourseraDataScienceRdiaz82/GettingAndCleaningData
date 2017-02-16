#Variable Configuration
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Download the data files and extract the dataset files
#download.file(url,"temp.zip",method="curl")
#unzip("temp.zip",exdir = "./")
#file.remove("temp.zip")

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

#Cleaning Columns names
#features<-features[,2]
features = gsub('-mean()', 'Mean', features[,2])
features = gsub('-std()', 'Std', features)
features <- gsub('[-()]', '', features)

#Assign Columns names and convert activity to string label
colnames(merged)<-append(c("subject","activity"),as.character(features))
merged[["activity"]] <- activities[ match(merged[['activity']], activities[['V1']] ) , 'V2']

#(In this point is solved the Questions 1, and the data meets the questions 3 and 4)

extracted<-merged[,c("subject","activity",grep("Mean|Std", names(merged), value = TRUE))]

