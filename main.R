source("./plotbox_ggplot.R")
source("./minivic.R")
# source("./plotbox.R")


par(mfrow = c(1, 1))

price_data = read.csv('full_population.csv')
names(price_data)[1] <- "Site"

determine_color <- function(Median_Price){
  if(Median_Price <= 100000)
    "#feedde"
  else if(Median_Price <= 500000 & Median_Price > 100000)
    "#fdd0a2"
  else if (Median_Price <= 800000 & Median_Price > 500000)
    "#fdae6b"
  else if(Median_Price >= 800000 & Median_Price < 1000000)
    "#fd8d3c"
  else if(Median_Price >= 1000000 & Median_Price < 2000000)
    "#e6550d"
  else
    '#a63603'
  
}

new_prices <- price_data[price_data$Type == 'House', ]
new_prices$color <- as.character(sapply(new_prices$Median_Price, determine_color))

plotList <- list() 
plotIndex <- 1

library(plotly)

for(i in 2007:2016)
  local({
    one_year <- new_prices[new_prices$Year == i,]
    g <- minivic(one_year, city_colors = one_year$color, city_names = FALSE, city_name_colors = rep("white", 76))
    g <- g + theme_bw() + xlab(i) + ylab("") +
      theme(
        axis.text.y = element_blank(), 
        axis.ticks.y = element_blank(),
        axis.text.x = element_blank(), 
        axis.ticks.x = element_blank(),
        legend.position = "none"
      )
    plotly_g <- ggplotly(g)
    plotly_g <- style(plotly_g, hoverinfo = "VICcity")
    
    plotList[[plotIndex]] <<- plotly_g
    plotIndex <<- plotIndex + 1
})

all <- subplot(plotList, nrows = 2)
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

#
# new_prices_2015 <- new_prices[new_prices$Year == 2015,]

# minivic(
#  new_prices_2015$Site, city_colors = new_prices_2015$color, 
#  city_names = TRUE,city_name_colors = rep("white", 76)
#)




