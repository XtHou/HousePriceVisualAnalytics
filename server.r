# server.R
# setwd("/srv/shiny-server/sample-apps/myRProject1")
library(shiny)
library(ggplot2)
library(plotly)
library(maptools)
library(geojsonio)
library(ggmap)
library(viridis)
library(RColorBrewer)

source("./plotbox_ggplot.R")
source("./minivic.R")

pdf(NULL)

# read data
prices = read.csv('full_population.csv')
vic_prices = read.csv('data_Victoria_price_2006-2017.csv')
vic_prices$Year.f = as.factor(vic_prices$Year)
prices$Year.f = as.factor(prices$Year)
library(plotly)
vis_map = geojson_read("VIC_LGA_POLYGON_shp.json",  what = "sp")
vis_map_fortified = fortify(vis_map) # transform


# Define a server for the Shiny app
shinyServer(function(input, output) {

  # static line chart
  output$vic_price = renderPlot({
    ggplot(subset(vic_prices,Type == input$type_choice), aes_string(x="Year.f", y=input$data_choice, group = 1)) + 
      geom_line(color="red") +
      theme(axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
            axis.title.x=element_blank())
    }
    )
 
  # plot minimap
  output$minimap = renderPlotly({
    par(mfrow = c(1, 1))
    names(prices)[1] = "Site"
    new_prices = subset(prices,Type == input$type_choice)
    column_name = input$data_choice
    
    if(input$data_choice == 'Mean_Price'){
      determine_color = function(Median_Price){
        if(Median_Price <= 100000)
          "#f7fcf5"
        else if (Median_Price <= 500000 & Median_Price > 100000)
          "#c7e9c0"
        else if (Median_Price <= 800000 & Median_Price > 500000)
          "#a1d99b"
        else if(Median_Price <= 1000000 & Median_Price > 800000)
          "#74c476"
        else if(Median_Price <= 2000000 & Median_Price > 1000000)
          "#31a354"
        else
          '#006d2c'
      }
      new_prices$color = as.character(sapply(new_prices[, column_name], determine_color))
    }
    
    if(input$data_choice == 'No_of_Sales'){
      determine_color = function(No_of_Sales){
        if(No_of_Sales <= 1000)
          "#f7fcf5"
        else if (No_of_Sales <= 2000 & No_of_Sales > 1000)
          "#c7e9c0"
        else if (No_of_Sales <= 5000 & No_of_Sales > 2000)
          "#a1d99b"
        else if(No_of_Sales <= 8000 & No_of_Sales > 5000)
          "#74c476"
        else if(No_of_Sales <= 10000 & No_of_Sales > 8000)
          "#31a354"
        else
          '#006d2c'
      }
      new_prices$color = as.character(sapply(new_prices[, column_name], determine_color))
    }
    else{
      determine_color = function(Mean_Price){
        if(Mean_Price <= 100000)
          "#f7fcf5"
        else if (Mean_Price <= 500000 & Mean_Price > 100000)
          "#c7e9c0"
        else if (Mean_Price <= 800000 & Mean_Price > 500000)
          "#a1d99b"
        else if(Mean_Price <= 1000000 & Mean_Price > 800000)
          "#74c476"
        else if(Mean_Price <= 2000000 & Mean_Price > 1000000)
          "#31a354"
        else
          '#006d2c'
      }
      new_prices$color = as.character(sapply(new_prices[, column_name], determine_color))
      }
    
    plotList = list() 
    plotIndex = 1

    for(i in 2007:2016)
      local({
        one_year = new_prices[new_prices$Year == i,]
        g = minivic(one_year$Site, cities_info = one_year[, column_name], city_colors = one_year$color, city_names = FALSE, city_name_colors = rep("white", 76))
        g = g + theme_bw() + xlab(i) + ylab("") +
          theme(
            axis.text.y = element_blank(), 
            axis.ticks.y = element_blank(),
            axis.text.x = element_blank(), 
            axis.ticks.x = element_blank(),
            legend.position = "none"
          )
        plotly_g = ggplotly(g)
        plotly_g = style(plotly_g, hoverinfo = "VICcity")
        
        plotList[[plotIndex]] <<- plotly_g
        plotIndex <<- plotIndex + 1
      })
    
    all = subplot(plotList, nrows = 2)
    all
    
    all %>% layout(annotations = list(
      list(x = 0.08, y = 1.05, text = "2007", showarrow = F, xref='paper', yref='paper'),
      list(x = 0.29, y = 1.05, text = "2008", showarrow = F, xref='paper', yref='paper'),
      list(x = 0.50, y = 1.05, text = "2009", showarrow = F, xref='paper', yref='paper'),
      list(x = 0.71, y = 1.05, text = "2010", showarrow = F, xref='paper', yref='paper'),
      list(x = 0.92, y = 1.05, text = "2011", showarrow = F, xref='paper', yref='paper'),
      
      list(x = 0.08, y = 0.50, text = "2012", showarrow = F, xref='paper', yref='paper'),
      list(x = 0.29, y = 0.50, text = "2013", showarrow = F, xref='paper', yref='paper'),
      list(x = 0.50, y = 0.50, text = "2014", showarrow = F, xref='paper', yref='paper'),
      list(x = 0.71, y = 0.50, text = "2015", showarrow = F, xref='paper', yref='paper'),
      list(x = 0.92, y = 0.50, text = "2016", showarrow = F, xref='paper', yref='paper'))
    )
  })
    

  # plotly map
  output$plotly_map = renderPlotly({
    price_data = subset(prices,Type == input$type_choice)
    names(price_data)[1] = "Site"
   
    if(input$data_choice == 'Median_Price'){
      price_data <- mutate(price_data, mytext=paste("City council: ", Site, "\n", "Median Price: ", Median_Price, sep=""))
      p = ggplot(price_data) +
        geom_polygon(data = vis_map_fortified, aes(x=long, y = lat, group = id), fill="grey", colour = "black", alpha=0.2) +
        geom_point(aes(x=lon, y=lat, size=Median_Price, color=Median_Price, text=mytext, frame = Year, ids=Site, alpha=0.2) ) +
        scale_size_continuous(range=c(1,15)) +
        theme_void() +
        coord_map() +
        theme(legend.position = "right") + scale_colour_gradient(low = 'lightgreen', high = 'darkgreen')
    }
    if(input$data_choice == 'Mean_Price'){
      price_data <- mutate(price_data, mytext=paste("City council: ", Site, "\n", "Mean Price: ", Mean_Price, sep=""))
      p = ggplot(price_data) +
        geom_polygon(data = vis_map_fortified, aes(x=long, y = lat, group = id), fill="grey", colour = "black", alpha=0.2) +
        geom_point(aes(x=lon, y=lat, size=Mean_Price, color=Mean_Price, text=mytext, frame = Year, ids=Site, alpha=0.2) ) +
        scale_size_continuous(range=c(1,15)) +
        theme_void() +
        coord_map() +
        theme(legend.position = "right") + scale_colour_gradient(low = 'lightgreen', high = 'darkgreen')
    }
    if(input$data_choice == 'No_of_Sales'){
      price_data <- mutate(price_data, mytext=paste("City council: ", Site, "\n", "No of Sales: ", No_of_Sales, sep=""))
      p = ggplot(price_data) +
        geom_polygon(data = vis_map_fortified, aes(x=long, y = lat, group = id), fill="grey", colour = "black", alpha=0.2) +
        geom_point(aes(x=lon, y=lat, size=No_of_Sales, color=No_of_Sales, text=mytext, frame = Year, ids=Site, alpha=0.2) ) +
        scale_size_continuous(range=c(1,15)) +
        theme_void() +
        coord_map() +
        theme(legend.position = "right") + scale_colour_gradient(low = 'lightgreen', high = 'darkgreen')
    }
    
    plot_g = ggplotly(p, tooltip="text")
    plot_g %>% 
      animation_opts(
        1000, easing = "elastic", redraw = TRUE
      )
    }
    )
  
  
  # multi-plot animation 
  output$newprice = renderPlotly({
    prices$ratio_text=paste('Site: ', prices$Site, '<br>Weekly rent ratio: ', 
                                   prices$WeeklyRentRatio, '<br>Weekly loan ratio: ', 
                                   prices$WeeklyLoanRatio)
    
    filterd_data = subset(prices, Type == input$type_choice)
    print(head(filterd_data))
    
    p1 = plot_ly(filterd_data, y = ~WeeklyLoanRatio, x = ~WeeklyRentRatio, 
                  hoverinfo = "text", text = ~ratio_text) %>%
      add_markers(frame = ~Year.f, ids = ~Site, color =I("blue"), 
                  name = ~'Weekly ratio') %>%
      layout(xaxis = list(range = c(3, 15))) %>%
      layout(yaxis = list(range = c(0, 30)), showlegend = TRUE) 
    
    if(input$data_choice == 'Mean_Price'){
      p2 = plot_ly(filterd_data, x = ~Site, y = ~Mean_Price, 
                    hoverinfo = "text", text = ~paste(
                      'Site: ', filterd_data$Site,
                      '<br>Mean Price: ', filterd_data$Mean_Price
                    )) %>%
        add_markers(frame = ~Year.f, ids = ~Site, color = I("red"), 
                    name = ~'Mean Price') %>%
        layout(xaxis = list(tickfont = list(size = 8), tickangle = 45), 
               yaxis = list(range = c(0, 2100000)), showlegend=TRUE)
    }
    
    if(input$data_choice == 'No_of_Sales'){
      p2 = plot_ly(filterd_data, x = ~Site, y = ~No_of_Sales, 
                    hoverinfo = "text", text = ~paste(
                      'Site: ', filterd_data$Site,
                      '<br>No of Sales: ', filterd_data$No_of_Sales
                    )) %>%
        add_markers(frame = ~Year.f, ids = ~Site, color = I("red"), 
                    name = ~'No. of sales') %>%
        layout(xaxis = list(tickfont = list(size = 8), tickangle = 45),
               yaxis = list(range = c(0, 2000)), showlegend=TRUE)
    }
    
    if(input$data_choice == 'Median_Price'){
      p2 = plot_ly(filterd_data, x = ~Site, y = ~Median_Price, 
                    hoverinfo = "text", text = ~paste(
                      'Site: ', filterd_data$Site,
                      '<br>Median price: ', filterd_data$Median_Price
                    )) %>%
        add_markers(frame = ~Year.f, ids = ~Site, color = I("red"), 
                    name = ~'Median Price') %>%
        layout(xaxis = list(tickfont = list(size = 8), tickangle = 45), 
               yaxis = list(range = c(0, 2100000)), showlegend=TRUE)
    }
    p = subplot(p1, p2, nrows = 1, widths = c(0.3, 0.7))
  }
  )
  }
)