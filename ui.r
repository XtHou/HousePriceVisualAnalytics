# ui.R
# import library
library(shiny)
library(ggplot2)
library(plotly)

# Define UI for application that draws a scatter plot and a map
shinyUI(fluidPage(
  
  # Application title
  headerPanel("Victoria property price exploration"),
  
  # add sidebar with two parts: one for choosing coral type, one for smoother
  sidebarPanel(
    fluidRow(
      radioButtons( 
        "type_choice", "Choose which kind of property you want to see:",
        list("House" = "House", 
             "Units/Apartment" = "Units/Apartment", 
             "Vacant House Block" = "Vacant House Block"),
        selected = "House"),
      radioButtons( "data_choice", "Choose which kind of data you want to see:",
                    c( "Median Price" = "Median_Price", 
                       "No of Sales" = "No_of_Sales", 
                       "Mean Price" = "Mean_Price"), 
                    selected = "Median_Price"
                    ),
      
      tags$div(class="header", checked=NA,
               tags$p("This is a dashboard designed to explore Victorian cities. There are three kinds of properties you can view, the House, Unit/Apartment and Vacant house block. You can select what you want to explore from three kinds of data, the median price, the mean price and the bumber of sales.Also you can play with the timeline bar"), 
               tags$p("There are two tabsets. The first one named 'geo analysis' includes a group of minimap from 2007 to 2016 and a proportional symbols map with animation. The data will change by your selection. Also you can play with the timeline bar."),
               tags$p("The second tabset named 'stastic analysis' includes two scatter plots. The left one indicates the weekly loan ratio and weekly rent ratio from 2006-2016. The right plot indicates how the price as well as number of sales change versus time. You can play the two plots with the timeline bar at the same time. Under the two plots there is a line chart. This is the data you choosed of Victoria, you can see the trend of the overall level of Victoria. "),
               tags$p("Below are the data sources: "),
               tags$a(href="https://www.propertyandlandtitles.vic.gov.au/property-information/property-prices", "Click here for Price dataset"),
               tags$p(""),
               tags$a(href="http://www.abs.gov.au/websitedbs/D3310114.nsf/Home/Census", "Click here for Population dataset"),
               tags$p("")
               )
      ),
    conditionalPanel(
      condition = "input.tabs == 1",
      tags$div(
        tags$img(src = "minimap.png", width = "100%", height = "100%")
        )
      )
    ),
  
  mainPanel(
    tabsetPanel(
      id = 'tabs',
      tabPanel("Geo analysis", value = 1, fluidRow(
        plotlyOutput("minimap", width = "100%"),
        plotlyOutput("plotly_map", width = "100%", height = 600)
        )
        ),
      tabPanel("Statistic analysis", value = 2, fluidRow(
        plotlyOutput("newprice", width = "100%", height = "100%"),
        plotOutput("vic_price", height = 80, width = "100%")
        )
        )
      )
    )
  )
)

