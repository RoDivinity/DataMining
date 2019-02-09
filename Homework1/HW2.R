#load library 
library(tidyverse)
library(mapdata)
#install map package
install.packages("mapdata")


#load map for plotting

###            ##
#    Testing    #
##            ###
jp <- ggplot2::map_data('world2', 'japan')
usa <- map_data('world2', 'USA')
ggplot(usa, aes(x = long, y = lat, group = group)) +
  geom_polygon()


####    Data and summary of how it looks like     ####
airport <- read.csv('~/Downloads/ABIA.csv')

## Drop all the missing values from arrival delay ##
airport_no_NA <- subset(airport, ArrDelay.isNA)

head(airport)

#calculate mean for month
arr_delay = airport %>%
    group_by(Month) %>%
    summarize(ArrDelay.mean = mean(as.numeric(ArrDelay),na.rm=TRUE))
head(arr_delay)

arr_delay
ggplot(arr_delay , aes (x = factor(Month) , y = ArrDelay.mean) ) +
  geom_bar(stat = 'identity')


#Looking at fall season only
fall_airport <- subset(airport , Month == 9 | Month == 10 | Month == 11)
fall_airport
cancellation =  fall_airport %>%
                group_by(CancellationCode) %>%
                summarize(sum_delay = sum(Cancelled == 1))
cancellation
no_of_weather_delay = sum((as.numeric(airport$WeatherDelay) != 0), na.rm = TRUE)
no_of_weather_delay
sum_of_delay = sum(as.numeric(airport$WeatherDelay), na.rm =TRUE)
mean = sum_of_delay/no_of_weather_delay
mean

no_of_weather_delay = sum((as.numeric(fall_airport$WeatherDelay) != 0), na.rm = TRUE)
no_of_weather_delay
sum_of_delay = sum(as.numeric(fall_airport$WeatherDelay), na.rm =TRUE)
mean = sum_of_delay/no_of_weather_delay
mean
######
arr_delay = airport %>%
  group_by(DayOfWeek) %>%
  #group_by(Month) %>%
  summarize(ArrDelay_mean = mean(as.numeric(ArrDelay),na.rm=TRUE))
  
head(arr_delay)
ggplot(arr_delay , aes (x = factor(DayOfWeek) , y = ArrDelay.mean) ) +
  geom_bar(stat = 'identity')

head(airport)
#labels = c("12am" , "1am" , "2am" , "3am" , "4am" , "5am" , "6am" , "7am" , "8am" )
time_cut <- cut(as.numeric(airport$DepTime), breaks = 100, label =FALSE)
head(time_cut)
summarize(as.numeric(airport$DepTime))
