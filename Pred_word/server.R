library(shiny)
library(shinydashboard)
library(dplyr)
library(stringr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
    n_grams <- readRDS("gram_data")

    query_tks <- reactive((input$sentence %>% 
                    str_remove_all("[^a-zA-z\\s]") %>%
                    str_to_lower() %>% 
                    str_split(" "))[[1]])
    
    pred_word <- function(tks, n_grams){
      
      res <- n_grams %>% 
        filter(first == tks[1]) %>% 
        filter(second == tks[2]) %>% 
        filter(third == tks[3]) %>%
        filter(third == tks[4]) %>%
        arrange(desc(freq)) %>% slice(1)
      
      pred <- res$fifth[1]
      
      if (is.na(pred)) {
        res <- n_grams %>% 
          filter(first == tks[1]) %>% 
          filter(second == tks[2]) %>% 
          filter(third == tks[3]) %>%
          arrange(desc(freq)) %>% slice(1)
        pred <- res$fourth[1]
      }
      
      if (is.na(pred)) {
        res <-  n_grams %>% 
          filter(first == tks[2]) %>% 
          filter(second == tks[3]) %>% 
          arrange(desc(freq))
        pred <- res$third[1]
      } 
      
      if(is.na(pred)) {
        res <- n_grams %>% 
          filter(first == tks[3]) %>% 
          arrange(desc(freq))
        pred <- res$second[1]
      }
      
      if(is.na(pred)){
        pred <- "the"
      }
      
      pred
    }
    
    output$error <- renderText("input must be longer than 3 words")
    
    pred <- reactive({
        input$goButton
        isolate({
          tks <- query_tks()[(length(query_tks())-2): length(query_tks())]
          pred_word(tks, n_grams)
        })
    })
    
    observeEvent(input$goButton, {
      showModal(modalDialog(
        title = "Prediction",
        infoBox(
          "I think the next word should be: ", pred(), 
          icon = icon("thumbs-up", lib = "glyphicon"),
          color = "yellow", width = 12
        ),
        easyClose = TRUE
      ))
    })
})
