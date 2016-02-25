
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(shiny)
library(plotly)
library(shinydashboard)
library(googleVis)
library(data.table)

library(shiny)
library(shinydashboard)


header <- dashboardHeader(title = "EU Open Data explorer")
sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem(text = "Main", tabName = "main")
    ),
    selectInput(
        inputId =  "year", 
        label = " Select Year:", 
        choices = 1994:2015
    ),
    radioButtons("age", "Age: ",
                 c("< 25 years" = "Y_LT25",
                   "> 25 years" = "Y25-74",
                   "All" = "TOTAL")),
    uiOutput("ui"),
    htmlOutput("helptext")
)

body <- dashboardBody(
    tabItems(
        tabItem(tabName = "main",
                fluidRow(
                    tabBox(title="eurostat data", id="tabs", height = "700px", width = "700px",
                           tabPanel("Bar Plot", value="barplot", htmlOutput("gvisbarplot")),
                           tabPanel("Map", value="map", htmlOutput("maptitle"), htmlOutput("gvismap"), 
                                    helpText("Grey areas: no data available")),
                           tabPanel("Annual Plot", value="contryplot",  htmlOutput("gviscontryplot")),
                           tabPanel("Current values", value="values", 
                                    h4("Selected Year:"), verbatimTextOutput("oyear"), 
                                    h4("Selected Ages:"), verbatimTextOutput("oage"), 
                                    h4("Selected country:"), verbatimTextOutput("ocountry")),
                           tabPanel("Description", value="datasource", box(width=9, includeMarkdown("datasource.md")))
                    )
                )
                
        )
    )

)
dashboardPage(header, sidebar, body, skin = "blue")