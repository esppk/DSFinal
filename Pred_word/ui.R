library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(
  dashboardHeader(title = "Predicting Next Word"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home"),
      menuItem("About", tabName = "about")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "home",
        fluidRow(
          valueBox("A Data Science Specialization Capstone Project", color = "teal",
                   subtitle = "Predicting Next Word", width = 12)
          ),
        
        fluidRow(
          column(width = 12, offset = 3,
            box(
              title = "What do you want to predict for?",width = 6, solidHeader = TRUE,
              status = "success", 
              h5("Let's type in an incomplete sentence to predict. It may take a sec..."),
              conditionalPanel(condition = "input.sentence.split(' ').length<=3",
              htmlOutput("error", container = tags$div, class="alert alert-danger", role="alert")),
              textInput("sentence", "Feel free to replace the sentence below", "I really want to thank"),
              actionButton("goButton", "Go!", width = '100%', class="btn btn-success")
            )))
      ),
      tabItem(tabName = "about",
              h2("A Data Science Specialization Capstone Project"),
              h6("by Emrick"))
  )
)))
