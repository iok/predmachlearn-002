# load thetraining set
trainRawData <- read.csv("pml-training.csv",na.strings=c("NA",""))

# discard NAs
NAs <- apply(trainRawData,2,function(x) {sum(is.na(x))}) 
validData <- trainRawData[,which(NAs == 0)]

# make training set and cross validation data sets
trainIndex <- createDataPartition(y = validData$classe, p=0.2,list=FALSE)
trainData <- validData[trainIndex,]
crossValid <- validData[-trainIndex,]

# remove columns with irrelavent data
removeIndex <- grep("timestamp|X|user_name|new_window",names(trainData))
trainData <- trainData[,-removeIndex]

# build model using random forests and include PCA
# Set Cross-Validated = 4 fold
modFit <- train(as.factor(trainData$classe)~ .,data=trainData,  preProcess=c("pca"),  method="rf",prox=TRUE, trControl = trainControl(method = "cv", number = 4, allowParallel=T))

# manually determine accuracy
predictions = predict(modFit, crossValid[-60])
table(predictions,crossValid$classe)
accuracy_true = sum(predictions ==crossValid$classe)/length(predictions)
accuracy_true #~91.8%

# make the prediction on the testing data set
predictRawData = read.csv("pml-testing.csv")
answers  <- predict(modFit,predictRawData);
