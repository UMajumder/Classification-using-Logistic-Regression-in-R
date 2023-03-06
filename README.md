In this project I workied with the UCI adult dataset. 
I attempted to build a model to predict if people in the data set belong in a certain class by salary, either making <=50k or >50k per year.

Data description:

age: continuous.

workclass: Private, Self-emp-not-inc, Self-emp-inc, Federal-gov, Local-gov, State-gov, Without-pay, Never-worked.

fnlwgt: continuous.

education: Bachelors, Some-college, 11th, HS-grad, Prof-school, Assoc-acdm, Assoc-voc, 9th, 7th-8th, 12th, Masters, 1st-4th, 10th, Doctorate, 5th-6th, Preschool.

education-num: continuous.

marital-status: Married-civ-spouse, Divorced, Never-married, Separated, Widowed, Married-spouse-absent, Married-AF-spouse.

occupation: Tech-support, Craft-repair, Other-service, Sales, Exec-managerial, Prof-specialty, Handlers-cleaners, Machine-op-inspct, Adm-clerical, Farming-fishing, Transport-moving, Priv-house-serv, Protective-serv, Armed-Forces.

relationship: Wife, Own-child, Husband, Not-in-family, Other-relative, Unmarried.

race: White, Asian-Pac-Islander, Amer-Indian-Eskimo, Other, Black.

sex: Female, Male.

capital-gain: continuous.

capital-loss: continuous.

hours-per-week: continuous.

native-country: United-States, Cambodia, England, Puerto-Rico, Canada, Germany, Outlying-US(Guam-USVI-etc), India, Japan, Greece, South, China, Cuba, Iran, Honduras, Philippines, Italy, Poland, Jamaica, 
Vietnam, Mexico, Portugal, Ireland, France, Dominican-Republic, Laos, Ecuador, Taiwan, Haiti, Columbia, Hungary, Guatemala, Nicaragua, Scotland, Thailand, Yugoslavia, El-Salvador, Trinadad&Tobago, Peru, 
Hong, Holand-Netherlands.

Libraries used: dplyr, Amelia, ggplot2, caTools

Firstly I performed some feature engineering like converting variables from character to factors, and grouping them based on common grounds to reduce the number of levels within them. Then I dealt with the NA values. 

After cleaning and organizing the data I dived into Exploratory Data Analysis using visualizations with ggplot2

#First I create a histogram of ages colored by income

![Plot_1](https://github.com/UMajumder/Classification_using_Logistic_Regression_in_R/blob/main/Plot_1.png)

#Then I checked the histogram of hours worked per week

#Finally I checked the barplot of region by income

Finally I built the Logistic regression model, and checked for performance metrices like Accuracy, Recall, and Precision using the confusion matrix.

##END##
