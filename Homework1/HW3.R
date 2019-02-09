#loading library
library (mosaic)
library(FNN)

#load data file
sclass <- read.csv('~/Downloads/sclass.csv')

#The variables involved
summary(sclass)

# Focus on 2 trim levels: 350 and 65 AMG
sclass350 = subset(sclass, trim == '350')
dim(sclass350)

sclass65AMG = subset(sclass, trim == '65 AMG')
summary(sclass65AMG)
nrow(sclass350)
##                      ###
# First part for trim 350 #
####                     ##

#Training model for 350 trim
#First split the data into training and testing set
N = nrow(sclass350)
N_train = floor(N*.8)
N_test = N - N_train

#####
# Train/test split
#####

# randomly sample a set of data points to include in the training set
train_ind = sample.int(N, N_train, replace=FALSE)

# Define the training and testing set
D_train = sclass350[train_ind,]
D_test = sclass350[-train_ind,]

# optional book-keeping step:
# reorder the rows of the testing set by the mileage variable
# this isn't necessary, but it will allow us to make a pretty plot later
D_test = arrange(D_test, mileage)
head(D_test)

# Now separate the training and testing sets into features (X) = mileage and outcome (y) = price
X_train = select(D_train, mileage)
y_train = select(D_train, price)
X_test = select(D_test, mileage)
y_test = select(D_test, price)

#create a vector to store RMSE for each k 
k_rmse <- rep (0, N_test - 2)

# define a helper function for calculating RMSE
rmse = function(y, ypred) {
  sqrt((sum((y - ypred)^2 ))/N_test)
}

#Unable to run k = 2 
#knn_temp = knn.reg(train = X_train, test = X_test, y = y_train, k=2)

#run a for loop with different value for k
for ( i in 1: (N_test - 2 ) ){
  number =  2 + i
  #print(paste(number))
  knn_temp = knn.reg(train = X_train, test = X_test, y = y_train, k = number)
  #names(knn_temp)
  ypred_knn_temp = knn_temp$pred
  k_rmse[i] <- rmse(y_test, ypred_knn_temp)
}

#Find optimal k 
optimal_k = which.min(k_rmse)
optimal_k

#Plot the RMSE for different k
plot (k_rmse)

##PLot knn for optimal k

knn_optimal = knn.reg(train = X_train, test = X_test, y = y_train , k = optimal_k + 2)

ypred_knn_optimal = knn_optimal$pred
ypred_knn_optimal
D_test$ypred_knn_optimal = ypred_knn_optimal

#plot to compare models
p_test = ggplot(data = D_test) + 
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') 


p_test + geom_point(aes(x = mileage, y = ypred_knn_optimal), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn_optimal), color='red')


##


##                         ###
# Second part for trim 65AMG #
####                        ##

#First split the data into training and testing set
N = nrow(sclass65AMG)
N_train = floor(N*.8)
N_test = N - N_train

#####
# Train/test split
#####

# randomly sample a set of data points to include in the training set
train_ind = sample.int(N, N_train, replace=FALSE)

# Define the training and testing set
D_train = sclass65AMG[train_ind,]
D_test = sclass65AMG[-train_ind,]

# optional book-keeping step:
# reorder the rows of the testing set by the mileage variable
# this isn't necessary, but it will allow us to make a pretty plot later
D_test = arrange(D_test, mileage)
head(D_test)

# Now separate the training and testing sets into features (X) = mileage and outcome (y) = price
X_train = select(D_train, mileage)
y_train = select(D_train, price)
X_test = select(D_test, mileage)
y_test = select(D_test, price)

#create a vector to store RMSE for each k 
k_rmse <- rep (0, N_test - 2)

# define a helper function for calculating RMSE
rmse = function(y, ypred) {
  sqrt((sum((y - ypred)^2 ))/N_test)
}

#Unable to run k = 2 
#knn_temp = knn.reg(train = X_train, test = X_test, y = y_train, k=2)

#sample 1 run
knn_temp = knn.reg(train = X_train, test = X_test, y = y_train, k=3)
head(y_test)
ypred_knn_temp = knn_temp$pred
ypred_knn_temp

#double check if function for rmse works
sum((y_test - ypred_knn_temp)^2)
y_diff <- y_test - ypred_knn_temp
y_diff
sqrt(sum(y_diff^2) / 84)
test = rmse(y_test, ypred_knn_temp)
test


number = 0
#run a for loop with different value for k
for ( i in 1: (N_test - 2 ) ){
  number =  2 + i
  #print(paste(number))
  knn_temp = knn.reg(train = X_train, test = X_test, y = y_train, k = number)
  #names(knn_temp)
  ypred_knn_temp = knn_temp$pred
  k_rmse[i] <- rmse(y_test, ypred_knn_temp)
}

#Find optimal k 
optimal_k = which.min(k_rmse)
optimal_k

#Plot the RMSE for different k
plot (k_rmse)

##PLot knn for optimal k

knn_optimal = knn.reg(train = X_train, test = X_test, y = y_train , k = optimal_k + 2)

ypred_knn_optimal = knn_optimal$pred
ypred_knn_optimal
D_test$ypred_knn_optimal = ypred_knn_optimal

#plot to compare models
p_test = ggplot(data = D_test) + 
  geom_point(mapping = aes(x = mileage, y = price), color='lightgrey') 


p_test + geom_point(aes(x = mileage, y = ypred_knn_optimal), color='red')

p_test + geom_path(aes(x = mileage, y = ypred_knn_optimal), color='red')

