#https://stackoverflow.com/questions/72434010/color-different-countries-with-r-based-on-ggplot-and-map-data
library(RColorBrewer)
library(maptools)
library(ggplot2)
library(rworldmap)

map.world = map_data(map='world')
map.world = merge(df[1:22,], map.world, by= "region",all.y=TRUE)
map.world = map.world[order(map.world$order), ] # <---

ggplot() + 
  geom_map(data = map.world,map = map.world, aes(
    map_id = region,
    x=long,
    y=lat,
    fill= Freq
  )) + 
  coord_quickmap()
