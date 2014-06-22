Prediction Assignment Writeup
======================
Intro
---------
Weight Lifting Exercises Dataset is used as a training dataset for a prediction assignment in Practical Machine Learning class. The goal is to predict a class of the exercise based on data from multiple sensors. Five classes are availavle:

- exactly according to the specification (Class A)
- throwing the elbows to the front (Class B)
- lifting the dumbbell only halfway (Class C)
- lowering the dumbbell only halfway (Class D) 
- throwing the hips to the front (Class E)


Pre-processing
--------
The following are the main components of pre processing:

* Discarding NA
* Performing PCA
* Removing irrelavent and non-numerci rows from the set: timestamp, X(column numver), user_name, new_window


Training and Cross Validation
--------
The training/testing split was 20 to 80, greatly reducing learning time. Even with such low percent of data going into testing set, the accuracy reached over 91%. Random forests algorithm was used to built the model.

Number of folds in K-fold cross-validation was set to four through trainControl parameter. preProcess parameter of train function was set to include PCA.

```
modFit <- train(as.factor(trainData$classe)~ .,data=trainData,  preProcess=c("pca"),  method="rf",prox=TRUE, trControl = trainControl(method = "cv", number = 4, allowParallel=T))
```

Random forests model reported the best achived accuracy of 0.913.

```
Random Forest 

3927 samples
  53 predictors
   5 classes: 'A', 'B', 'C', 'D', 'E' 

Pre-processing: principal component signal extraction, scaled, centered 
Resampling: Cross-Validated (4 fold) 

Summary of sample sizes: 2944, 2946, 2946, 2945 

Resampling results across tuning parameters:

  mtry  Accuracy  Kappa  Accuracy SD  Kappa SD
  2     0.913     0.89   0.0133       0.0168  
  27    0.893     0.864  0.015        0.0189  
  53    0.892     0.863  0.0156       0.0198  

Accuracy was used to select the optimal model using  the largest value.
The final value used for the model was mtry = 2. 
```

Independent Corss Validation
--------
Even though the random forests model stores about cross validation, we can verify it independently in the following way:

```
predictions = predict(modFit, crossValid[-60])
table(predictions,crossValid$classe)

```
Result:

```
predictions    A    B    C    D    E
          A 4311  153   31   36   13
          B   57 2685  175   23   56
          C   45  147 2469  222   68
          D   45   24   44 2263   57
          E    6   28   18   28 2691
```
Calculate accuracy:
```
accuracy_true = sum(predictions ==crossValid$classe)/length(predictions)
accuracy_true #~91.8%
```
Result:
```
[1] 0.9187002
```