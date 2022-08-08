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
            h2("Personal Information"),
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
            h2("Trip Information"),
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
                tabPanel("Prediction Pane",
                    p(),
                    em("Instructions: Enter your (or some made-up) information in the sidebar and find out if you would have survived the Titanic!"),
                    h1(textOutput("center_text"), align = "center"),
                    h3(textOutput("sub_text"), align = "center"),
                    
                    hr(style = "border-color: black;"),
                    
                    p("The plots below show the distributions of each of the input variables vs. survivorship, as per our sample dataset (refer to the Documentation tab for more info). The blue bars/line show the currently selected inputs in the sidebar. Every time an input is changed, the corresponding highlighted bar/line will change to reflect the newly inputted value. You may see where you fit into the sample data through these plots, and get a sense for how your survivorship has been predicted."),
                    plotOutput("plt")
                ),
                tabPanel("Documentation",
                    p(),
                    p("Coming Soon...")
                )
            )
        )
    )
))
