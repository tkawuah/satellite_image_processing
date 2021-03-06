library(sp)
library(sf)
library(usdm)
library(rgdal)
library(raster)
library(spatialEco)

#spatial metrics function
spat_met_func <- function(shp_extent, map){
  metric <- land.metrics(shp_extent, map, 
                         metrics = c('n.patches',
                                     'max.patch.area', 
                                     'min.patch.area', 
                                     'sd.patch.area', 
                                     'mean.patch.area',
                                     'patch.cohesion.index',
                                     'prop.landscape'))
  return(metric)
}

#import data

d <- readOGR(dsn = '*/spatial_analysis', 
             layer = 'distance_to_water_3')

svm_map <- raster('*/SVM_gl_binMap0.25.tif')



#... patch metrics for the Sabie and Satara landscapes as a whole

sabie_extent <- readOGR(dsn = '*/010039360030_01_P001_MUL', 
                        layer = 'clip_extent')
sabie_map <- raster('*/MLP_gl_binMap0.35.tif')

sabie_metrics <- spat_met_func(sabie_extent,sabie_map)
sabie_metrics

satara_extent <- readOGR(dsn = '*/010039360040_01_P001_MUL', 
                         layer = 'clip_extent')
satara_map <- raster('*/SVM_gl_binMap0.25.tif')

satara_metrics <- spat_met_func(satara_extent,satara_map)
satara_metrics
