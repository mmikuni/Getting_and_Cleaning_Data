#reading in the data
x1 <- read.table("UCI HAR Dataset/test/X_test.txt")
x2 <- read.table("UCI HAR Dataset/train/X_train.txt")

y1 <- read.table("UCI HAR Dataset/test/y_test.txt")
y2 <- read.table("UCI HAR Dataset/train/y_train.txt")

subject1 <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject2 <- read.table("UCI HAR Dataset/train/subject_train.txt")

#combines the test/training tables
x <- rbind(x1, x2)
y <- rbind(y1, y2)
subject <- rbind(subject1, subject2)
names(subject) <- "Subject"

#getting feature list
features <- read.table("UCI HAR Dataset/features.txt")

#gets column numbers with 'mean' or 'std' in the title
mean.std.cols <- grep('mean|std', features[, 2])

#subsets based on only columns with mean or std
x <- x[, mean.std.cols]
names(x) <- features[mean.std.cols,][, 2]

#activities
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

#assigning values in activities to the y table
#http://stackoverflow.com/questions/6112260/conditional-merge-replacement-in-r
y[, 1] <- activities$V2[match(y$V1, activities$V1)]
names(y) <- "Activity"

#creates new data set
tidy.data <- cbind(subject, y, x)

#aggregates the data
agg.tidy.data <- aggregate(tidy.data[, 3:81], by = list(tidy.data$Subject, tidy.data$Activity), FUN = mean)
colnames(agg.tidy.data)[1:2] <- c("Subject", "Activity")

write.table(tidy.data, "tidy.data.txt")
write.table(agg.tidy.data, "agg.tidy.data.txt")
