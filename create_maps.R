#load libraries

library(sp)
library(sf)
library(rgdal)
library(raster)
library(ggplot2)
theme_set(theme_bw())
library(ggspatial)
library(RStoolbox)
library(patchwork)
library(cowplot)

#import data SA boundary
ZAF <- readOGR(dsn= "*/datasets", layer = "gadm36_ZAF_0")
ZAF <- st_as_sf(ZAF) # converts fom sp to sf object

#import KNP boundary
KNP <- readOGR(dsn = "*/datasets", layer = "my_KNP_boundary1")
KNP <- st_as_sf(KNP)

#import Sabie boundary
sabie <- readOGR("*/010039360030_01_P001_MUL", layer = "new_extent2")
sabie <- st_as_sf(sabie)

#import Satara boundary
satara <- readOGR("*/010039360040_01_P001_MUL", layer = "clip_extent")
satara <- st_as_sf(satara)

#import water source layers
sab_water <- readOGR('*/spatial analysis', layer = 'water_source1')
sab_water <- st_as_sf(sab_water)

sat_water <- readOGR('*/spatial_analysis', layer = 'water_source1')
sat_water <- st_as_sf(sat_water)

#import satara raster
sat_ras <- brick("*/satara_data_clipped.tif", 
                       package="raster")

#import sabie raster
sab_ras <- brick("*/sabi_data_cliped.tif",
                      package="raster")

#set RGB plot satara and sabie rasters
sat_rgb <- ggRGB(sat_ras, r = 7, g = 5, b = 2, stretch="hist")
sab_rgb <- ggRGB(sab_ras, r = 7, g = 5, b = 2, stretch="hist")

#add map themes to satara and sabie plots
sat_plot <- sat_rgb +
  geom_sf(data = sat_water, aes(fill = Hydrology), show.legend = FALSE)+
  scale_fill_manual(values = c('blue')) + 
  coord_sf(crs = "+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs")+
  theme(panel.grid = element_blank(), axis.title = element_blank(),
        axis.text = element_text(size = 7),
        panel.grid.major = element_line(color = gray(.5), linetype = "dashed", size = 0.5),
        panel.background = element_rect(fill = "gray100"),
        plot.margin = unit(c(0,0,0,0), "cm"))+
  annotation_scale(location = "br", width_hint = 0.5, style = "ticks")

sab_plot <- sab_rgb +
  geom_sf(data = sab_water, aes(fill = Hydrology), show.legend = FALSE)+
  scale_fill_manual(values = c('blue')) + 
  coord_sf(crs = "+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs")+
  theme(panel.grid = element_blank(), axis.title = element_blank(),
        axis.text = element_text(size = 7),
        panel.grid.major = element_line(color = gray(.5), linetype = "dashed", size = 0.5),
        panel.background = element_rect(fill = "gray100"),
        plot.margin = unit(c(0,0,0,0), "cm"))+
  scale_y_continuous(position = "right")+
  annotation_scale(location = "br", width_hint = 0.5, style = "ticks")


#plot map of sites in KNP in ZAF
level_0 <- ggplot(data = ZAF)+
  geom_sf()+
  annotate(geom = "text", x = 23, y = -30, label = "South Africa", 
           fontface = "italic", size = 4)+
  geom_sf(data = KNP, aes(fill = Geology))+ 
  scale_fill_manual(values = c("brown", "lightgreen", "yellow"))+
  geom_sf(data = sabie, fill = "black")+
  geom_sf(data = satara, fill = "black")+
  theme(panel.grid = element_blank(), axis.title = element_blank(), 
        axis.text = element_blank(), axis.ticks = element_blank(), legend.position = 'none')

#zoom to KNP extent
level_1 <- level_0 +
  coord_sf(xlim = c(31, 32.5), ylim = c(-26, -22.4)) +
  annotate(geom = "text", x = 31.9, y = -25.05, label = "Lower Sabie", 
           fontface = "bold", size = 2) +
  annotate(geom = "text", x = 31.8, y = -24.42, label = "Satara", 
           fontface = "bold", size = 2) +
  annotation_scale(location = "br", width_hint = 0.5, style = "ticks")+
  annotation_north_arrow(location = "br", which_north = "true",
                         pad_x = unit(0.40, "in"), pad_y = unit(0.2, "in"),
                         style = north_arrow_fancy_orienteering)+
  theme(axis.text = element_text(size = 6), axis.ticks = element_line(), 
        axis.title = element_blank(),
        plot.margin = unit(c(0,0,0,0), "cm"), legend.position = 'right')


#add level_0 as inset
level_2 <- level_1 + 
  annotation_custom(
    grob = ggplotGrob(level_0),
    xmin = 30.4,
    xmax = 33.5,
    ymin = -23,
    ymax = -22.175
  )+
  theme(plot.margin = unit(c(0,0,0,0), "cm"))

#arrange plots to create final map
patchwork <- level_2|(sat_plot/sab_plot)
patchwork + plot_annotation(tag_levels = 'A')


arrowA <- data.frame(x1 = 3.5, x2 = 8, y1 = 9.6, y2 = 14.5)
arrowB <- data.frame(x1 = 3.6, x2 = 8, y1 = 6.4, y2 = 6.4)

ggdraw(xlim = c(0, 20), ylim = c(0, 20)) +
  draw_plot(level_2, x = 0, y = 0, width = 8, height = 20) +
  draw_plot(sat_plot, x = 1, y = 10, width = 20, height = 10) +
  draw_plot(sab_plot, x = 1, y = 0, width = 20, height = 10) +
  geom_segment(aes(x = x1, y = y1, xend = x2, yend = y2), data = arrowA, 
               arrow = arrow(), lineend = "round") +
  geom_segment(aes(x = x1, y = y1, xend = x2, yend = y2), data = arrowB, 
               arrow = arrow(), lineend = "round") +
  theme(plot.margin = unit(c(0,0,0,0), "cm"))

