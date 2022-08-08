#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(cowplot)

# Reading training data
# Assuming wd is this app directory
dat <- read_csv("train.csv")
ticket_summary <- dat %>% group_by(Pclass) %>% summarise(fare = mean(Fare)) %>% arrange(Pclass)
sex_surv <- dat %>% group_by(Sex) %>% summarize(s = sum(Survived)/n())
pclass_surv <- dat %>% group_by(Pclass) %>% summarize(s = sum(Survived)/n())
embarked_surv <- dat %>% group_by(Embarked) %>% summarize(s = sum(Survived)/n()) %>% filter(s<1)
sibsp_surv <- dat %>% group_by(SibSp) %>% summarize(s = sum(Survived)/n()) %>% add_row(SibSp=6:7, s=0) %>% arrange(SibSp)
parch_surv <- dat %>% group_by(Parch) %>% summarize(s = sum(Survived)/n())
age_surv <- dat %>% filter(!is.na(Age)) %>% select(Survived, Age) %>% mutate(Survived = as.factor(Survived))
levels(age_surv$Survived) <- c("No", "Yes")

# Assuming wd is this app directory
model <- readRDS("final_model.rds")
knn <- readRDS("final_knn.rds")

# Factors used for going back and forth between values in model and values in dataset
sexf <- factor(c("female","male"), levels=c("female","male"))
pclassf <- as.factor(c(1,2,3))
embarkedf <- factor(c(0,1), levels=c(0,1))


# Define server logic
shinyServer(function(input, output) {
    
    pred <- reactive({
        c <- 0
        q <- 0
        s <- 0
        
        if (input$embarked=="C") {
            c <- 2
            q <- 1
            s <- 1
        } else if (input$embarked=="Q") {
            c <- 1
            q <- 2
            s <- 1
        } else {
            c <- 1
            q <- 1
            s <- 2
        }
        
        inputs <- data.frame(
            Sex = sexf[as.numeric(input$sex)],
            Age = input$age,
            Pclass = pclassf[as.numeric(input$pclass)],
            SibSp = as.numeric(input$sibsp),
            Parch = as.numeric(input$parch),
            Fare = ticket_summary$fare[as.numeric(input$pclass)],
            Cherbourg = embarkedf[c],
            Queenstown = embarkedf[q],
            Southampton = embarkedf[s]
        )
        
        proc_inputs <- predict(knn, inputs)
        
        as.numeric(predict(model, proc_inputs))
    })
    
    center_text <- reactive(
        if (pred()==1) { 
            "Sorry!"
        } else if (pred()==2) {
            "Congrats!"
        } else {
            "Uncertain outcome." # Should never come up
        }
    )
    
    sub_text <- reactive(
        if (pred()==1) { 
            "You likely would not have made it..."
        } else if (pred()==2) {
            "You probably would've survived!"
        } else {
            "Please try other inputs." # Should never come up
        }
    )
    
    output$center_text <- renderText({
        center_text()
    })
    
    output$sub_text <- renderText({
        sub_text()
    })
    
    #' Plots: Showing survivorship by Sex, Age, SibSp, Parch, Pclass, Embarked
    #' Also shows where the user's inputted data is within each of these charts
    output$plt <- renderPlot({
        
        # Survivorship by sex
        g1 <- ggplot(sex_surv, 
                     aes(Sex, s, fill=factor(
                         ifelse(Sex==as.character(sexf[as.numeric(input$sex)]),"Highlighted","Normal")
                         )
                         )
                     )
        g1 <- g1 + geom_bar(stat="identity")
        g1 <- g1 + scale_fill_manual(values=c("blue","grey50")) + theme(legend.position = "none")
        g1 <- g1 + labs(x="Sex", y="Survivorship")
        
        
        # Survivorship by ticket class
        g2 <- ggplot(pclass_surv, 
                     aes(Pclass, s, fill=factor(
                         ifelse(Pclass==pclassf[as.numeric(input$pclass)],"Highlighted","Normal")
                     )
                     )
        )
        g2 <- g2 + geom_bar(stat="identity")
        g2 <- g2 + scale_fill_manual(values=c("blue","grey50")) + theme(legend.position = "none")
        g2 <- g2 + labs(x="Ticket Class", y="Survivorship")
        
        # Survivorship by embark point
        g3 <- ggplot(embarked_surv, 
                     aes(Embarked, s, fill=factor(
                         ifelse(Embarked==input$embarked,"Highlighted","Normal")
                     )
                     )
        )
        g3 <- g3 + geom_bar(stat="identity")
        g3 <- g3 + scale_fill_manual(values=c("blue","grey50")) + theme(legend.position = "none")
        g3 <- g3 + labs(x="Embarked From", y="Survivorship")
        
        # Survivorship by siblings/spouses
        g4 <- ggplot(sibsp_surv, 
                     aes(SibSp, s, fill=factor(
                         ifelse(SibSp==as.numeric(input$sibsp),"Highlighted","Normal")
                     )
                     )
        )
        g4 <- g4 + geom_bar(stat="identity")
        g4 <- g4 + scale_fill_manual(values=c("blue","grey50")) + theme(legend.position = "none")
        g4 <- g4 + labs(x="Num. Siblings/Spouses On Board", y="Survivorship")
        
        # Survivorship by parents/children
        g5 <- ggplot(parch_surv, 
                     aes(Parch, s, fill=factor(
                         ifelse(Parch==as.numeric(input$parch),"Highlighted","Normal")
                     )
                     )
        )
        g5 <- g5 + geom_bar(stat="identity")
        g5 <- g5 + scale_fill_manual(values=c("blue","grey50")) + theme(legend.position = "none")
        g5 <- g5 + labs(x="Num. Parents/Children On Board", y="Survivorship")
        
        # Survivorship by age
        g6 <- ggplot(age_surv,
                     aes(Survived, Age))
        g6 <- g6 + geom_boxplot() + geom_hline(yintercept=input$age, color = "blue", linetype="dashed", size = 2)
        g6 <- g6 + labs(x="Survived", y="Age")
        
        grid <- plot_grid(g1, g6, g4, g5, g2, g3, ncol = 3)
        grid
        
    })
})
