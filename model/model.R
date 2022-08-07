#' This file contains the code for the final ML model using the Titanic data set.
#' Final model is saved as an RDS in the Shiny project directory (app)
#' See the accompanying .Rmd for initial pre-processing and model testing with cross validation.

## Load data
dat <- read_csv("../data/train.csv")

## Remove undesired columns and transform categorical columns to factor
train <- dat %>%
    select(-PassengerId, -Name, -Cabin, -Ticket) %>%
    mutate(
        Survived = factor(Survived, labels=c("No","Yes")),
        Embarked = factor(Embarked),
        Sex = factor(Sex),
        Pclass = factor(Pclass)
    )

## Impute NA's in Age column with KNN imputation
set.seed(64)
tf <- as.data.frame(select(train, -Survived))
Survived <- train$Survived

knni <- preProcess(tf, method = "knnImpute")
ptf <- predict(knni, tf)

ptrain <- cbind(ptf, Survived)

## Remove rows with Embarked = NA (only 2)
ptrain <- ptrain[which(!is.na(ptrain$Embarked)),]

## Build model
set.seed(64)
model <- train(Survived~., data=ptrain, method="rf")

## Save model. One in app folder and one in 
