#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Would You Have Survived the Titanic?"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            em("Input your data below to buy your ticket for a trans-Atlantic trip on the Titanic!"),
            h3("Personal Information"),
            selectInput("sex",
                        "Sex:",
                        choices = c("Female" = 1, "Male" = 2)
                        ),
            sliderInput("age",
                        "Age:",
                        min = 0,
                        max = 100,
                        value = 30),
            sliderInput("sibsp",
                        "Number of Siblings/Spouses (On Board):",
                        min = 0,
                        max = 8,
                        value = 2
                        ),
            sliderInput("parch",
                        "Number of Parents/Children (On Board):",
                        min = 0,
                        max = 6,
                        value = 2
            ),
            hr(),
            h3("Trip Information"),
            selectInput("pclass",
                        "Choose a Ticket Class",
                        choices = c("First Class (£84)" = 1, "Second Class (£21)" = 2, "Third Class (£14)" = 3)
            ),
            selectInput("embarked",
                        "Where Will You Embark From?",
                        choices = c("Cherbourg" = "C", "Queenstown" = "Q", "Southampton" = "S")
                        )
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Prediction",
                    p(),
                    h1(textOutput("center_text"), align = "center"),
                    h3(textOutput("sub_text"), align = "center"),
                    
                    hr(style = "border-color: black;"),
                    
                    p("The plots below show the distributions of each of the input variables vs. survivorship, as per our sample dataset (refer to the Documentation tab for more info). The blue bars/line show the currently selected inputs in the sidebar. Every time an input is changed, the corresponding highlighted bar/line will change to reflect the newly inputted value. You may see where you fit into the sample data through these plots, and get a sense for how your survivorship has been predicted."),
                    plotOutput("plt")
                ),
                tabPanel("Documentation",
                    p(),
                    h3("Overview"),
                    p("Hello and welcome to the 'Would You Have Survived the Titanic?' application. This application is meant to take some information about you (real or made-up), and tell you if you would've survived the Titanic! The application is backed by a random forest model built using training data from the famous Kaggle Titanic dataset. The inputs used in this application follow from the features available in that dataset, and are described below in the Inputs section. As each input is entered, the final outcome is re-calculated and displayed as either 'Congrats!' if you likely (>50% chance) would have survived, or 'Sorry!' if you likely would not have survived. Hit the 'Prediction' tab and enter some inputs to try it out yourself!"),
                    h3("Inputs"),
                    p("To calculate whether you would've survived or not, the following inputs must be entered in the sidebar to the left:"),
                    tags$ul(
                        tags$li("Sex"),
                        tags$li("Age"),
                        tags$li("Number of Siblings/Spouses (On Board): This is the total number of your siblings and your spouses (combined) that will join you on board the Titanic."),
                        tags$li("Number of Parents/Children (On Board): This is the total number of your parents and your children (combined) that will join you on board the Titanic."),
                        tags$li("Ticket Class: The class of ticket you have purchased, which vary by price. The higher class tickets cost more, but typically buy you a better room and service."),
                        tags$li("Where Will You Embark From?: A choice of where you will board the Titanic, with the choices being: Cherbourg (France), Queenstown (Ireland), and Southampton (England).")
                    ),
                    h3("Prediction"),
                    p("The prediction is either displayed as 'Congrats!' if you have a >=50% chance of survival, or 'Sorry!' if you have a <50% chance of survival."),
                    h3("Dynamic Plots"),
                    p("The plots below the prediction itself in the 'Prediction' tab show a distributions of survivorship (percent of people in the relevant category who survived) against each of the inputs entered, with the exception of the Age plot. The Age plot shows the age distribution of those who survived and those who did not. These data are from the real sample data used to train the model. As you select your inputs, that input's respective category will be highlighted in blue on the relevant plot. For example, if you were to select 'Male' for the Sex input, the bar showing the survivorship of males is highlighted in the Survivorship vs. Sex plot. In this way, you are able to see where you would have stood in the sample data if you were on the Titanic, and also take a glimpse into the prediction itself. You can try maximizing your chances of survival by choosing categories with higher displayed survivorship!")
                )
            )
        )
    )
))
