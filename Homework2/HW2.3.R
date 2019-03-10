#loading library
library(tidyverse)
library(mosaic)
library(class)
library(FNN)


data_file<-'https://raw.githubusercontent.com/RoDivinity/DataMining/master/Data/online_news.csv'
data<-read.csv(url(data_file))
head(data)

##drop the unused variable
data<- data[-c(1) ]

## define threshold for share -> viral
data$viral = ifelse(data$shares > 1400, 1, 0)

n = nrow(data)

######
##Define functions to measure accuracy
#######

#function to return the confusion matrix for threshold 1st/classification 2nd
classification_confusion_matrix <- function(lm_model , data){
  ###Predictions in sample
  yhat_test = predict(lm_model, data)
  class_test = ifelse(yhat_test > 0.5, 1, 0)
  ###Create the matrix
  matrix = table(y = data$viral, yhat = class_test)
  return(matrix)
}

#function to return the confusion matrix for classification 1st/ threshold 2nd
threshold_confusion_matrix <- function(lm_model , data){
  ###Predictions in sample
  yhat_test = predict(lm_model, data)
  class_test = ifelse(yhat_test > 1400, 1, 0)
  ###Create the matrix
  matrix = table(y = data$viral, yhat = class_test)
  return(matrix)
}

##function to calculate error rate
error_rate = function(matrix){
  (matrix[2,1] + matrix[1,2]) / sum(matrix)
}

##function to calculate true positive rate
TPR = function(matrix){
  matrix[2,2] / sum(matrix[2,])
}

##function to calculate false positive rate
FPR = function(matrix){
  matrix [1,2] / sum(matrix[,2])
}

##function to calculate accuracy (1 - error rate)
accuracy = function(error){
  1 - error
}
##function to rearrange values into matrix
toMatrix = function(a){
  matrix <- a[c(1:4)]
  dim(matrix) <- c(2,2)
  return(matrix)
}

##################  Main routine  #####################


###
# Loop 100 times to average out the effect of randomness
# Each iteration do the following:
#   * Split train/test set
#   * Regression first / threshold second for:
#       * A simple linear probability model: with/without poly terms and/or interaction
#       * Logistic regression model (Logit)
#     => Measure performance for 2 models, store value for averaging  (1)
#   * Threshold first / regress/classification second for:
#       * A simple linear probability model: with/without poly terms and/or interaction
#       * Logistic regression model (Logit)
#     => Measure performance for 2 models, store value for averaging (2)
# Done 100 loops:
#   Report which is the best model + overall (error rate, true positive, false positive, confusion matrix)
#   Compare between case (1) and (2)
##


performance = do(100)*{

  ## Split into training and testing sets
  n_train = round(0.8*n)  
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  data_train = data[train_cases,]
  data_test = data[test_cases,]

## regress first, threshold second for LPM without max/min polarity and global rate (case 1)
lpm1 = lm(shares ~ (.  - viral - is_weekend - weekday_is_sunday - min_positive_polarity -
                       max_positive_polarity - min_negative_polarity - max_negative_polarity -
                       global_rate_positive_words - global_rate_negative_words - abs_title_sentiment_polarity ), data=data_train)

## model emphasized on word counts and keywords
lpm_advance = lm(shares ~ poly(n_tokens_title,2) + poly(n_tokens_content, 2) + poly(num_keywords , 2) + 
                   n_tokens_content*num_keywords, data=data_train)

############################
##### Now for (2) case #####
############################

### threshold first, regress second for LPM  (case 2)
lpm2 = lm(viral ~ (.  - viral - is_weekend - weekday_is_sunday - min_positive_polarity -
                     max_positive_polarity - min_negative_polarity - max_negative_polarity -
                     global_rate_positive_words - global_rate_negative_words - abs_title_sentiment_polarity ), data=data_train)

### simple binomial logistic regression for classification (case 2)
glm1 = glm(viral ~ (.  - shares - is_weekend - weekday_is_sunday - min_positive_polarity -
                      max_positive_polarity - min_negative_polarity - max_negative_polarity -
                      global_rate_positive_words - global_rate_negative_words - abs_title_sentiment_polarity ), data=data_train, family=binomial)


###
# Now measure performance for each case
#     * First create confusion matrix for each model
#     * Obtain confusion matrix for each one
#     * Push all values into the performance array
###

#out of sample confusion matrix for model 1
matrix1 = threshold_confusion_matrix(lpm1 , data_test)
#out of sample confusion matrix for model 2
matrix2 = threshold_confusion_matrix(lpm_advance , data_test)
#out of sample confusion matrix for model 3
matrix3 = classification_confusion_matrix(lpm2 , data_test)
#out of sample confusion matrix for model 4
matrix4 = classification_confusion_matrix(glm1 , data_test)

#pushing values in
c( matrix1, matrix2, matrix3, matrix4)
}
performance
means = colMeans(performance)
means[c(1:4)]
avg_matrix1 = toMatrix(means[c(1:4)])

