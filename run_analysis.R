
#Import training datasets.
#Note: the dataset doesn't contain headers. We have to import features dataset to get the headers and assign to the below data sets.
x_train <- read.table("train//x_train.txt", sep="", header = FALSE)
y_train <- read.table("train//y_train.txt", sep="", header = FALSE)
x_test <- read.table("test//x_test.txt", sep="", header = FALSE)
y_test <- read.table("test//y_test.txt", sep="", header = FALSE)
#Merge the text and train datasets
x_merged <- rbind(x_train,x_test)
y_merged <- rbind(y_train,y_test)
#Importing features files to get the names of the columns for the above datasets
features <- read.table("features.txt")
nameFeatures<- as.vector(features$V2) # the import contains index and feature name. We assign it to a vector# Now get the column label for mean and std measurements
colNameMeanStd<-nameFeatures[grepl("mean|std",nameFeatures)]
colIndMeanStd<-grep("mean|std",nameFeatures)

#Now select only the required extract form the merged data sets
x_mean_std <-select(x_merged,colIndMeanStd)
setnames(x_mean_std,colNameMeanStd)
setnames(y_merged,"Activity_ID")

#import activity label details 
activityLabel <- read.table("activity_labels.txt")
setnames(activityLabel,c("Activity_ID","Activity_Name"))
activityDetailsLabeled <- merge(y_merged,activityLabel,by = "Activity_ID")

#bind the variables with activity details
measurementsAndActivityCombined <- cbind(activityDetailsLabeled,x_mean_std)


#import subject details
train_subject = read.table("train//subject_train.txt", sep="", header = FALSE)
test_subject = read.table("test//subject_test.txt", sep="", header = FALSE)

merged_subject <- rbind(train_subject,test_subject)

setnames(merged_subject,"Subject")


#merge variables with subject details
measurementsAndActivityCombinedWithSubject <- cbind(merged_subject,measurementsAndActivityCombined) 


#reshape the data
melted_data <- melt(measurementsAndActivityCombinedWithSubject, id=names(measurementsAndActivityCombinedWithSubject[,1:3]), measure.vars = names(measurementsAndActivityCombinedWithSubject[,4:49]))

casted_data<-dcast(melted_data, Subject+Activity_Name ~variable, mean)   


write.table(casted_data, file="tidy_set.txt")



                    




