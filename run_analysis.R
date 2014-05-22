#Reads in raw data collected from the accelerometers from the Samsung Galaxy S 
#smartphone located at 
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#which was pulled from a data project created at UC Irvine
#http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.
#Cleans, merges and puts the average of the mean and standard deviation column values 
#for each activity and each subject into a tidy data set named tidydata.txt

#get column names from features.txt
colnameslist<-read.table("UCI HAR Dataset/features.txt")
colnames<-as.character(colnameslist[,2])
#read in test data from X_test.txt using colnames for column names 
xtest<-read.table("UCI HAR Dataset/test/X_test.txt", col.names=colnames)
#read in Activity column from y_test.txt
ytest<-read.table("UCI HAR Dataset/test/y_test.txt", col.names=c("Activity"))
#read in Subject column from subject_test.txt
subtest<-read.table("UCI HAR Dataset/test/subject_test.txt", col.names=c("Subject"))
#combine columns and data from xtest, ytest, and subtest into testdata dataframe
testdata<-cbind(subtest, ytest, xtest)

#read in train data from x_train.txt using colnames for column names
xtrain<-read.table("UCI HAR Dataset/train/X_train.txt", col.names=colnames)
#read in Activity column from y_train.txt
ytrain<-read.table("UCI HAR Dataset/train/y_train.txt", col.names=c("Activity"))
#read in Subject column from subject_train.txt
subtrain<-read.table("UCI HAR Dataset/train/subject_train.txt", col.names=c("Subject"))
#combine columns and data from subtrain, ytrain, and subtrain into traindata dataframe
traindata<-cbind(subtrain, ytrain, xtrain)
#Combine testdata and traindata into alldata
alldata<-rbind(testdata, traindata)

#Filter out variables Subject, Activity, and any mean and 
#standard deviation variables 
filteredData<-alldata[, grep("mean\\>|std|Activity|Subject", colnames(alldata))]


#update column names to make them descriptive
colnames(filteredData)<-gsub("\\.+\\.", "", colnames(filteredData))
colnames(filteredData)<-gsub("^t", "time", colnames(filteredData))
colnames(filteredData)<-gsub("^f", "frequency", colnames(filteredData))
colnames(filteredData)<-gsub("BodyBody", "Body", colnames(filteredData))
colnames(filteredData)<-gsub("Gyro", "Gyroscope", colnames(filteredData))
colnames(filteredData)<-gsub("Acc", "Acceleration", colnames(filteredData))

#get averages by subject and activity and put into tidyData
tidyData<-aggregate(filteredData, list(Subjects=filteredData$Subject, Activities=filteredData$Activity), mean)
#remove the Subject and Activity columns because Subjects and Activities columns were added 
#during the aggregate function
remove<-c("Subject", "Activity")
tidyData<-tidyData[,!(names(tidyData) %in% remove)]

#Write tidyData to tidydata.txt file
write.table(tidyData, "tidydata.txt", sep="\t")