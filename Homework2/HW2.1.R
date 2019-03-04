#loading library
library(tidyverse)
library(mosaic)
library(FNN)

#loading data
data(SaratogaHouses)

#the medium model to outperform (baseline for comparison)
lm_medium = lm(price ~ lotSize + age + livingArea + pctCollege + bedrooms + 
                 fireplaces + bathrooms + rooms + heating + fuel + centralAir, data=SaratogaHouses)

#my "hand-built" model to test
lm_model = lm(price ~ (. - sewer - waterfront - fireplaces - rooms )*age, data=saratogaHouses)
  
#stock function to calculate root mean square error
rmse = function(y, yhat) {
  sqrt( mean( (y - yhat)^2 ) )
}
#####
# part 1: build a model to outperform the benchmark model
# The model hand build
#   y: price
#   x variables: - fireplaces - rooms - heating -fuel -waterfront -sewer
###

####
# Compare out-of-sample predictive performance
####

#count number of obs
n = nrow(SaratogaHouses)

rmse_vals = do(100)*{
  
  # re-split into train and test cases
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  saratoga_train = SaratogaHouses[train_cases,]
  saratoga_test = SaratogaHouses[test_cases,]
  
  # fit to this training set
  
  #baseline model for comparison first
  lm_medium = lm(price ~ lotSize + age + livingArea + pctCollege + bedrooms + 
                   fireplaces + bathrooms + rooms + heating + fuel + centralAir, data=saratoga_train)
  
  #hand-built model
  lm_model = lm(price ~ (. - sewer - waterfront - fireplaces - rooms ), data=saratoga_train)
  
  #predict on this testing set
  yhat_baseline_test = predict(lm_medium, saratoga_test)
  yhat_model_test = predict(lm_model, saratoga_test)
  
  c(rmse(saratoga_test$price, yhat_baseline_test),
    rmse(saratoga_test$price, yhat_model_test))
}

rmse_vals
colMeans(rmse_vals)
test_case <- seq(1,100,by=1)
rmse_vals = cbind(rmse_vals, test_case)
colnames(rmse_vals) <- c("baseline" , "model" , "test case")


plot(x = test_case, y = rmse_vals$baseline)
plot(x = test_case, y = rmse_vals$model)

###
# Part 2: Use KNN to predict and compare the accuracyy
####

#table to store average rmse for each K, starting from K = 2 
KNN_rmse <- data.frame(matrix(ncol = 2, nrow = 0))


for (k in 3:30){
  #count number of obs
  n = nrow(SaratogaHouses)
  
  #inner loop to calculate average over randomness of split
  rmse_vals = do(100)* {
  
  # re-split into train and test cases
  n_train = round(0.8*n)  # round to nearest integer
  n_test = n - n_train
  train_cases = sample.int(n, n_train, replace=FALSE)
  test_cases = setdiff(1:n, train_cases)
  saratoga_train = SaratogaHouses[train_cases,]
  saratoga_test = SaratogaHouses[test_cases,]  
    
  # construct the training and test-set feature matrices
  Xtrain = model.matrix(~ . - (price + sewer + waterfront + landValue + newConstruction) - 1, data=saratoga_train)
  Xtest = model.matrix(~ . - (price + sewer + waterfront + landValue + newConstruction) - 1, data=saratoga_test)
  
  # training and testing set responses
  ytrain = saratoga_train$price
  ytest = saratoga_test$price
  
  # now rescale/standardize
  scale_train = apply(Xtrain, 2, sd)  # calculate std dev for each column
  Xtilde_train = scale(Xtrain, scale = scale_train)
  Xtilde_test = scale(Xtest, scale = scale_train)  # use the training set scales
  
  # fit the model
  knn_model = knn.reg(Xtilde_train, Xtilde_test, ytrain, k = k)
  
  # calculate test-set performance
  rmse(ytest, knn_model$pred)
  }
  #print(colMeans(rmse_vals))
  #newK<-data.frame( k , colMeans(rmse_vals))
  
  KNN_rmse <- rbind( KNN_rmse , c(k , colMeans(rmse_vals)))
}

colnames(KNN_rmse) <- c("K_value", "average_RMSE")
KNN_rmse

#plot the results of KNN regression over K
ggplot(data = KNN_rmse, aes(x = K_value, y = average_RMSE)) + 
  geom_point(shape = "O") 
    

k_grid = exp(seq(log(2), log(300), length=100)) %>% round %>% unique
k_grid
