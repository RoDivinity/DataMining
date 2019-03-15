#loading library
library(tidyverse)
library(mosaic)
library(class)
library(FNN)
library(knitr)

#read in data
urlfile<-'https://raw.githubusercontent.com/jgscott/ECO395M/master/data/brca.csv'
brca<-read.csv(url(urlfile))


n = nrow(brca)
threshold = sum(brca$recall == 1)/n+0.0001

# stock deviation function to measure accuracy
dev_out = function(model, y, dataset) {
  probhat = predict(model, newdata=dataset, type='response')
  p0 = 1-probhat
  phat = data.frame(p0 = p0, p1 = probhat)
  rc_pairs = cbind(seq_along(y), y)
  -2*sum(log(phat[rc_pairs]))
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

# performance check
rmse_vals = do(100)*{
  # re-split into train and test cases
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  DF_train = data[train_cases,]
  DF_test = data[test_cases,]
  
  # fit to this training set
  glm_result1 = glm(recall~radiologist*(age+history+symptoms+menopause+density), data=DF_train, family=binomial)
  glm_result2 = glm(recall~radiologist+age+history+symptoms+menopause+density, data=DF_train, family=binomial)
  #glm_result3 = glm(recall~(radiologist+age+history+symptoms+menopause+density)^2, data=DF_train, family=binomial)
  
  # predict on this testing set
  phat_test1 = predict(glm_result1, DF_test, type='response')
  yhat_test1 = ifelse(phat_test1 > threshold, 1, 0)
  e1 = sum(yhat_test1 != unlist(DF_test$recall))/n_test
  
  # predict on this testing set
  phat_test2 = predict(glm_result2, DF_test, type='response')
  yhat_test2 = ifelse(phat_test2 > threshold, 1, 0)
  e2 = sum(yhat_test2 != unlist(DF_test$recall))/n_test
  
  # predict on this testing set
  #phat_test3 = predict(glm_result3, DF_test, type='response')
  #yhat_test3 = ifelse(phat_test3 > threshold, 1, 0)
  #e3 = sum(yhat_test3 != unlist(DF_test$recall))/n_test 
  
  c(e1,e2)
}
colMeans(rmse_vals)



model=glm(recall~radiologist*(age+history+symptoms+menopause+density),data=brca)
#kable(as.data.frame(table2_1["coefficients"]), caption = "Table 2.2.2: Regression Result for the Best Model",padding = 2, align = "c")
#check to see how many different radiologists and who are they
factor(brca_sample$radiologist)

# generate the testing set
n = nrow(brca)
# get the sample
pretest_cases = sample.int(n,50,replace=FALSE)
brca_pretest = data[pretest_cases,]
brca_sample=data.frame(brca_pretest)
# replicate the data for 5 times so we can assign 5 different radiologists to the same patient
brca_samplerepeat=brca_sample[rep(1:nrow(brca_sample),each=5),-1]
# assign the same patient to different doctors
brca_samplerepeat$radiologist=c("radiologist13","radiologist34","radiologist66","radiologist89","radiologist95")
# get diagnose from doctors 
yhat_recall = predict(model, brca_samplerepeat)
brca_samplerepeat=cbind(brca_samplerepeat,yhat_recall)
# compare doctors 
brca_predict<-brca_samplerepeat%>%
  group_by(radiologist)%>%
  summarise(Prob_recall = mean(yhat_recall))
kable(brca_predict)

##2nd question
# First need to build model A which based solely on recall decision 
glm_modelA = glm(cancer ~ recall, data = brca)
phatA = predict(glm_modelA, brca, type='response')
yhatA = ifelse(phatA >= threshold, 1, 0)
#calculate confusion matrix
t1 = xtabs(~brca$cancer+yhatA) 

# Then model B which takes into account of patient's family history and other background as well
glm_modelB = glm(cancer ~ recall + history + symptoms + menopause, data = brca)
phatB = predict(glm_modelB, brca, type='response')
yhatB = ifelse(phatB >= threshold, 1, 0)
#calculate confusion matrix
t2 = xtabs(~brca$cancer+yhatB)

coef = summary(glm_modelB)
kable(as.data.frame(coef["coefficients"]), caption = "Table 2.1.2: Regression Result for the Best Model",padding = 2, align = "c")

df = as.data.frame(t1)
t1 = data.frame(yhat0 = c(df$Freq[1],df$Freq[2]),yhat1 = c(df$Freq[3],df$Freq[4]))
row.names(t1) <- c("cancer = 0", "cancer = 1")
kable(t1, caption = "Confusion Matrix of the Model A",padding = 2, align = "c", col.names = c("prediction = 0", "prediction = 1"))

df = as.data.frame(t2)
t2 = data.frame(yhat0 = c(df$Freq[1],df$Freq[2]),yhat1 = c(df$Freq[3],df$Freq[4]))
row.names(t2) <- c("cancer = 0", "cancer = 1")
kable(t2, caption = "Confusion Matrix of the Model B",padding = 2, align = "c", col.names = c("prediction = 0", "prediction = 1"))
