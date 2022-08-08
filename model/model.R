#' This file contains the code for the final ML model using the Titanic data set.
#' Final model is saved as an RDS in the Shiny project directory (app)
#' See the accompanying .Rmd for initial pre-processing and model testing with cross validation.

library(tidyverse)
library(caret)

## Load data, make sure wd is set to the directory containing data
dat <- read_csv("data/train.csv")

## Remove undesired columns and transform categorical columns to factor
## Make dummy vars out of Embarked
train <- dat %>%
    select(-PassengerId, -Name, -Cabin, -Ticket) %>%
    mutate(
        Survived = factor(Survived, labels=c("No","Yes")),
        Embarked = factor(Embarked),
        Sex = factor(Sex),
        Pclass = factor(Pclass)
    )
dmy <- dummyVars(" ~ Embarked", train)
dv <- data.frame(predict(dmy, train))
dv[is.na(dv)]<-0
train <- train %>% 
    select(-Embarked) %>%
    mutate(
        Cherbourg = as.factor(dv$Embarked.C), 
        Queenstown = as.factor(dv$Embarked.Q),
        Southampton = as.factor(dv$Embarked.S)
    )

## Impute NA's with KNN imputation
set.seed(64)
train <- as.data.frame(train)
knn <- preProcess(train[,-1], method = "knnImpute")
train[,-1] <- predict(knn, train[,-1])

## Build model
set.seed(64)
model <- train(Survived~., data=train, method="rf")

## Save two copies of the model. One in app folder and one in model folder
## Also saves knnImpute pre-processing model for the app
## The app will feed the necessary data to the model in exactly the right format
saveRDS(model, "app/final_model.rds")
saveRDS(model, "model/final_model.rds")
saveRDS(knn, "app/final_knn.rds")
saveRDS(knn, "model/final_knn.rds")
