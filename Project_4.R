
# Getting the data
adult = read.csv("D:\\PROJECTS\\4_Logit\\adult_sal.csv")
head(adult)

# We notice that there is a double indexation, so let's remove the first column using dplyr
library(dplyr)
adult = select(adult, -X) ## [ Note: fnlwgt: final sampling weight]
head(adult)  #Now we re good to go
str(adult)

# But notice that some variables are character whereas they should be factors
# Lets make them factors(categorical)

adult$type_employer = factor(adult$type_employer)
adult$education = factor(adult$education)
adult$marital = factor(adult$marital)
adult$occupation = factor(adult$occupation)
adult$relationship = factor(adult$relationship)
adult$race = factor(adult$race)
adult$sex = factor(adult$sex)
adult$country = factor(adult$country)
adult$income = factor(adult$income)

str(adult)

# We Notice that a lot of these columns have too many factors than may be necessary.
# We can use feature engineering to group some of these levels together

# Lets start with type_employer
# First lets check the frequency of each level
table(adult$type_employer)
# We see there are two groups as 'Never-worked' and 'Without-pay',
# So we can club them as unemployed
unemp = function(job){
  job = as.character(job)
  if(job == 'Never-worked' | job == 'Without-pay'){
    return('Unemployed')
  }else{return(job)}
}

adult$type_employer = sapply(adult$type_employer,unemp)
table(adult$type_employer)
# We can further group self-emp-incorporated and self-emp-not-incorporated employees
# as self-employed
self_emp = function(job){
  job = as.character(job)
  if(job == 'Self-emp-inc' | job == 'Self-emp-not-inc'){
    return('Self-emp')
  }else{return(job)}
}
adult$type_employer = sapply(adult$type_employer, self_emp)
table(adult$type_employer)

# And also the State-gov and Local-gov employees as SL-gov
sl_emp = function(job){
  job = as.character(job)
  if(job == 'State-gov' | job == 'Local-gov'){
    return('SL-gov')
  }else{return(job)}
}
adult$type_employer = sapply(adult$type_employer, sl_emp)
table(adult$type_employer)

# Now lets take a look at the marital column
table(adult$marital)
# Lets reduce the 7 levels into only 3: married, Not-married, never-married
mar_status = function(mar){
  mar = as.character(mar)
  if(mar == 'Divorced' | mar == 'Separated' | mar == 'Widowed'){
    return('Not-married')
  }else if( mar == 'Never-married'){
    return(mar)
  }else{return('Married')}
}
adult$marital = sapply(adult$marital,mar_status)
table(adult$marital)

# Now lets consider country
table(adult$country)
# Lets group the countries by continent
Asia <- c('China','Hong','India','Iran','Cambodia','Japan', 'Laos' ,
          'Philippines' ,'Vietnam' ,'Taiwan', 'Thailand')
North.America <- c('Canada','United-States','Puerto-Rico' )
Europe <- c('England' ,'France', 'Germany' ,'Greece','Holand-Netherlands','Hungary',
            'Ireland','Italy','Poland','Portugal','Scotland','Yugoslavia')
South.America <- c('Columbia','Cuba','Dominican-Republic','Ecuador',
                   'El-Salvador','Guatemala','Haiti','Honduras',
                   'Mexico','Nicaragua','Outlying-US(Guam-USVI-etc)','Peru',
                   'Jamaica','Trinadad&Tobago')
Other <- c('South')

group_country = function(cntry){
  cntry = as.character(cntry)
  if(cntry %in% Asia){
    return('Asia')
  }else if(cntry %in% North.America){
    return('North.America')
  }else if(cntry %in% Europe){
    return('Europe')
  }else if(cntry %in% South.America){
    return('South.America')
  }else{return('Other')}
}

adult$country = sapply(adult$country, group_country)
table(adult$country)
str(adult)

# Now since it changed the three columns into character, lets convert them back to factor
adult$type_employer = factor(adult$type_employer)
adult$marital = factor(adult$marital)
adult$country = factor(adult$country)

str(adult)

# Now lets deal with the missing data

# Using the Amelia library we can check which columns had missing values
library(Amelia)
missmap(adult, col = c('yellow','black'), legend = F)
# We see both occupation and type_employer have missing values 
table(adult$type_employer)
table(adult$occupation)
# We see in both these columns missing values are marked as '?'
# Lets transform them to 'NA'
adult[adult == '?'] = NA

table(adult$type_employer)
table(adult$occupation)
# we see '?' is still there but frequency is zero
# so lets re-factor them
adult$type_employer = factor(adult$type_employer)
adult$occupation = factor(adult$occupation)

# Now checking once again 
table(adult$type_employer)  
table(adult$occupation)   ## Good to go

# Percentage of missing data for type_employer
miss_1 = (sum(is.na(adult$type_employer))/nrow(adult))*100
miss_1 # it is around 5.63%
# percentage of missing data for occupation
miss_2 = (sum(is.na(adult$occupation))/nrow(adult))*100
miss_2 # It is around 5.66%

# Since both of them are very small percentage of total data,and 
# also non-numeric we will drop them
adult = na.omit(adult)

# Now lets check the missingmap once again
missmap(adult, col = c('yellow','black'), legend = F) # No missing values


# Now lets perform some EDA using visualizations techniques
library(ggplot2)
str(adult)

# Use ggplot2 to create a histogram of ages, colored by income
plot_1 = ggplot(adult, aes(age)) + geom_histogram(aes(fill = income),
                                                  color = 'black', binwidth = 1)
plot_1
# very few people less than the age of 25 earns >50k, but as age increases till 50
# the number of people earning more than 50k rises, after which it steadily falls

# Plot a histogram of hours worked per week
plot_2 = ggplot(adult, aes(hr_per_week)) + geom_histogram(fill = 'blue',binwidth = 5)
plot_2
# We see highest number of people works 40 hours per week

# Rename the country column to region column to better reflect the factor levels
adult = rename(adult, region = country)
head(adult)

#Create a barplot of region with the fill color defined by income class. 
plot_3 = ggplot(adult, aes(region)) + geom_bar(aes(fill = income),color = 'black')
plot_3
# The highest number of people earning more than 50k are from North America
# Which may be the case because most of the data is from North America only


# Now we move to training and building the logistic regression model

# This model intends to to classify people into two groups: Above or Below 50k in Salary.

head(adult)
str(adult)

# Splitting the data into train and test
library(caTools)
set.seed(101)
split_data = sample.split(adult$income, SplitRatio = 0.7)
data.train = subset(adult, split_data == T)
data.test = subset(adult, split_data == F)

# Training the model
model = glm(income~., family = binomial(logit), data = data.train)
summary(model)

# The Akaike information criterion (AIC) is a mathematical method for evaluating 
# how well a model fits the data it was generated from. 
new.step.model = step(model)
summary(new.step.model)

# Creating a confusion matrix
data.test$predicted.income = predict(model, newdata = data.test, type = 'response')
table(data.test$income,data.test$predicted.income>0.5)

# Lets check some performance metrics
#accuracy
accuracy = (6372+1423)/(6372+548+872+1423)
accuracy

#recall
6372/(6372+548)

#precision
6372/(6372+872)

##END##