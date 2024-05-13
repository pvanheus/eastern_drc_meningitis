pacman::p_load(tidyverse, sf, geojsonsf, raster)

zones_sante <- st_read("geodata/RDC_Zones de santé.shp")
nord_kivu_zones_de_sante <- zones_sante %>% filter(PROVINCE=="Nord-Kivu")
ggplot() + geom_sf(data = nord_kivu_zones_de_sante, 
                   size=1.5, color="black", fill="cyan1") + ggtitle("Nord-Kivu Zones de Sante")

zone_colors = rep("lightblue", 34)
zone_colors[7] = "lightgreen" # set Goma to light green
zone_colors[27] = "yellow2" # set Mweso to yellow
zone_colors[34] = "pink"
ggplot() + geom_sf(data = nord_kivu_zones_de_sante, aes(fill = factor(Nom)),
                   size=1.5, color="black") + 
                     scale_fill_manual(values = zone_colors) +
                     coord_sf()
