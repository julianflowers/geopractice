library(readr)
library(ggmap)
library(janitor)
library(leaflet)

## Download GP data from data.gov.uk
gpdata <- read_tsv("http://data.gov.uk/data/resource/nhschoices/GP.csv")

gpdata <- gpdata %>% clean_names()

loc <- gpdata %>% select(latitude, longitude)
loc <- slice(loc, 5:30)
mymap <- get_map("England", source = "google", maptype = "roadmap", zoom = 6)
ggmap(mymap) + geom_jitter(aes( y = latitude, x= longitude), colour = organisationtype, 
                          data = gpdata, size = 1, alpha = 0.5
                          ) + coord


### Leaflet

gpdata %>%
  leaflet() %>%
  addTiles() %>%
  addMarkers(~longitude, ~latitude, popup = ~organisationcode )
###

library(viridis)
  gpclus <- read_csv("cluster.csv") %>% clean_names() %>% rename(organisationcode = x_area)

gpdata1 <- gpdata %>% left_join(gpclus)

mymap1 <- get_map("London", source = "google", maptype = "roadmap",  zoom = 10)
map1 <- ggmap(mymap1) + geom_jitter(aes( y = latitude, x= longitude, colour = `_cluster`), 
                           data = gpdata1, size = 1.5, alpha = 0.9) +
  scale_color_viridis(option = "D") + coord_map()

mymap2 <- get_map("Newcastle", source = "google", maptype = "roadmap",  zoom = 9)

map2 <- ggmap(mymap2) + geom_jitter(aes( y = latitude, x= longitude, colour = as.character(`_cluster`)), 
                                    data = gpdata1, size = 1.5, alpha = 0.9) +
  scale_color_viridis(option = "D", discrete = TRUE) + coord_map()
map2


gpclus1 <- gpdata1 %>%
  filter(`_cluster` == 15)

clusmap <- get_map("England", source = "google", maptype = "roadmap",  zoom = 6)
ggmap(clusmap) + geom_jitter(aes( y = latitude, x= longitude, colour = as.character(`_cluster`)), 
                            data = gpclus1, size = 1.5, alpha = 0.9) +
  scale_color_viridis(option = "D", discrete = TRUE) + coord_map() 

gpdata1 %>% 
  group_by(`_cluster`) %>%
  count()
