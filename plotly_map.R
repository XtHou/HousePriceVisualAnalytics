library(maptools)
library(geojsonio)
library(ggmap)
library(viridis)
library(plotly)
vis_map <- geojson_read("VIC_LGA_POLYGON_shp.json",  what = "sp")

vis_map_fortified <- fortify(vis_map) # transform

price_data <- read.csv("data_price_2006-2016.csv")
# price_data <- price_data[price_data$Year == 2007, ]
price_data <- price_data[price_data$Type == "House", ]
names(price_data)[1] <- "Site"

price_data <- mutate(price_data, mytext=paste("City council: ", Site, "\n", "Median Price: ", Median_Price, sep=""))

p <- ggplot(price_data) +
  geom_polygon(data = vis_map_fortified, aes(x=long, y = lat, group = id), fill="grey", colour = "black", alpha=0.2) +
  geom_point(aes(x=lon, y=lat, size=Median_Price, color=Median_Price, text=mytext, frame = Year, ids=Site, alpha=0.2) ) +
  scale_size_continuous(range=c(1,15)) +
  theme_void() +
  coord_map() +
  theme(legend.position = "none")

plot_g <- ggplotly(p, tooltip="text")
plot_g %>% 
  animation_opts(
    1000, easing = "elastic", redraw = TRUE
  )
