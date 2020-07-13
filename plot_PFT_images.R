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
library(ggpubr)

#import images
evgrn <- brick("D:/studies/phd/fieldwork_photos/evergreen/IMG_1756.jpg", 
               package="raster")

decid <- brick("D:/studies/phd/fieldwork_photos/deciduous/IMG_1949.jpg", 
                 package="raster")

bunch <- brick("D:/studies/phd/fieldwork_photos/bunch_grass/IMG_1615.jpg", 
               package="raster")

lawn <- brick("D:/studies/phd/fieldwork_photos/grazing_lawn/IMG_2885.jpg", 
               package="raster")

par(mfrow = c(2, 2)) # Create a 2 x 2 plotting matrix

evgrn_plot <-ggRGB(evgrn, r= 1, g= 2, b= 3)+
  theme(panel.grid = element_blank(), axis.title = element_blank(), 
        axis.text = element_blank(), axis.ticks = element_blank())

decid_plot <- ggRGB(decid, r= 1, g= 2, b= 3)+
  theme(panel.grid = element_blank(), axis.title = element_blank(), 
        axis.text = element_blank(), axis.ticks = element_blank())

bunch_plot <- ggRGB(bunch, r= 1, g= 2, b= 3)+
  theme(panel.grid = element_blank(), axis.title = element_blank(), 
        axis.text = element_blank(), axis.ticks = element_blank())

lawn_plot <- ggRGB(lawn, r= 1, g= 2, b= 3)+
  theme(panel.grid = element_blank(), axis.title = element_blank(), 
        axis.text = element_blank(), axis.ticks = element_blank())

patchwork <- (evgrn_plot+decid_plot)/(bunch_plot+lawn_plot)
patchwork + plot_annotation(tag_levels = 'a')

figure<-ggarrange(evgrn_plot,decid_plot,bunch_plot,lawn_plot, ncol=2, nrow=2, 
                  labels = 'auto')
figure
