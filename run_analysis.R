run_analysis <- function(){
        
        ddir <- "./data/FUCI HAR Dataset" # set up configurations
        fpath <- function(...) { paste(ddir,...,sep="/") }
        
        #Load x data and merge it
        trainingset <- read.table(fpath("train/X_train.txt"))
        testset <- read.table(fpath("test/X_test.txt"))
        dt <- rbind(trainingset,testset) # bind the test and training set together to form one data table

        # first put the colnames in place so the dt makes sense. Use the features text file.
        features <- read.table(fpath("features.txt"))[,2]
        colnames(dt) <- features
        
        # Now pick out only the measures with mean or std
        chosen_ones <- grepl('-(mean|std)\\(',features)
        
        dt <- subset(dt,select=chosen_ones)

        #Standardize the column names 
        colnames(dt) <- gsub("mean", "Mean", colnames(dt))
        colnames(dt) <- gsub("std", "Std", colnames(dt))
        colnames(dt) <- gsub("^t", "Time", colnames(dt))
        colnames(dt) <- gsub("^f", "Frequency", colnames(dt))
        colnames(dt) <- gsub("\\(\\)", "", colnames(dt))
        colnames(dt) <- gsub("-", "", colnames(dt))
        colnames(dt) <- gsub("BodyBody", "Body", colnames(dt))
        colnames(dt) <- gsub("^", "MeanOf", colnames(dt))

        #Merge the two activity data sets, first with each other
        act_train <- read.table(fpath("train/y_train.txt"))
        act_test <- read.table(fpath("test/y_test.txt"))
        
        ## ... first with each other .... 
        activities <- rbind(act_train,act_test)[,1]
        ## ...taking care to give them labels as provided
        labels <- c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS",
                    "SITTING", "STANDING", "LAYING")
        activities <- labels[activities]
        
        # ... and then merge them with the main data table, dt
        dt <- cbind(Activity = activities,dt)

        # Again merge a training and a test set
        subs_train <- read.table(fpath("train/subject_train.txt"))
        subs_test <- read.table(fpath("test/subject_test.txt"))
        subjects <- rbind(subs_train,subs_test)[,1]
        
        # . . . and merge it with the dt we've been working with all along
        dt <- cbind(Subject = subjects,dt)

        library('dplyr') ## very important to make sure dplyr is available
        
        # now pipe dt through grouping and summarizing functions and store result in 
        ##              a new data table.
        
        avg_dt <- dt %>%
                group_by(Subject,Activity) %>%
                summarise_all(funs(mean))
        
        ## Save the new dt to a file
        write.table(avg_dt,row.name = FALSE,file = "tidy_dt.txt") 
 }
