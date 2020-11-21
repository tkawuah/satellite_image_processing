#import libraries

library(usdm)
library(raster)
library(rgdal)

#import raster files

img_bands <- stack('*/L_sabie_subset_img.tif')
indices <- stack('*/RadiometricIndices.tif')
ndsi <- raster('*/ndsi.tif')
si1 <- raster('*/SI1.tif')
si2 <- raster('*/SI2.tif')
si3 <- raster('*/SI3.tif')
si4 <- raster('*/SI4.tif')
si5 <- raster('*/SI5.tif')
si6 <- raster('*/SI6.tif')
si7 <- raster('*/SI7.tif')
si8 <- raster('*/SI8.tif')
si9 <- raster('*/SI9.tif')
texture1 <- stack('*/HaralickTextureExtraction_8977797e-d7ff-4fa3-bc14-ebeed46079f0.tif')
texture2 <- stack('*/HaralickTextureExtraction_2.tif')
wet_evi <- raster('*/subset_wet_season_evi.tif')
dry_evi <- raster('*/subset_dry_season_evi.tif')
elevation <- raster('*/subset_dem.tif')
aspect <- raster('*/subset_aspect.tif')
slope <- raster('*/subset_slope.tif')
tpi <- raster('*/subset_tpi.tif')
water_proximity <- raster('*/proximity_to_water_map.tif')


#resample to the same extent

si4 <- resample(si4, ndsi, method='bilinear')
wet_evi <- resample(wet_evi, ndsi, method='bilinear')
dry_evi <- resample(dry_evi, ndsi, method='bilinear')
elevation <- resample(elevation, ndsi, method='bilinear')
aspect <- resample(aspect, ndsi, method='bilinear')
slope <- resample(slope, ndsi, method='bilinear')
tpi <- resample(tpi, ndsi, method='bilinear')


#create a raster stack 

x_allindices <- stack(indices,ndsi,si1,si2,si3,si4,si5,si6,si7,si8,si9)
x_texturevariables <- stack(texture1,texture2)

 # (wet_evi,dry_evi,elevation,aspect,slope,tpi,water_proximity)

#run Variance Inflation Factor (stepwise elimination)
v <- vif(x_texturevariables)
v1 <- vifstep(x_texturevariables, th=10)

#retrieve results
v
v1

# extract less correlated features into a multiband image stacks


###################################### OLD CODE BLOCK ######################################################################################

spec_text <- stack(img_bands[[1]],img_bands[[8]],indices[[7]],indices[[8]],indices[[11]],indices[[14]],si5,texture1[[1]],texture1[[3]],texture1[[4]],texture1[[5]],
                   texture1[[6]],texture1[[7]],texture1[[8]],texture2[[1]],texture2[[2]],texture2[[3]],texture2[[4]],texture2[[5]],texture2[[7]],texture2[[9]],texture2[[10]])

spec_text_evi <- stack(img_bands[[1]],img_bands[[8]],indices[[7]],indices[[8]],indices[[11]],indices[[14]],si5,texture1[[1]],texture1[[3]],texture1[[4]],texture1[[5]],
                       texture1[[6]],texture1[[7]],texture1[[8]],texture2[[1]],texture2[[2]],texture2[[3]],texture2[[4]],texture2[[5]],texture2[[7]],texture2[[9]],texture2[[10]],
                       wet_evi,dry_evi)

spec_text_topo <- stack(img_bands[[1]],img_bands[[8]],indices[[7]],indices[[8]],indices[[11]],indices[[14]],si5,texture1[[1]],texture1[[3]],texture1[[4]],texture1[[5]],
                        texture1[[6]],texture1[[7]],texture1[[8]],texture2[[1]],texture2[[2]],texture2[[3]],texture2[[4]],texture2[[5]],texture2[[7]],texture2[[9]],texture2[[10]],
                        elevation,aspect,slope,tpi)

spect_text_water <- stack(img_bands[[1]],img_bands[[8]],indices[[7]],indices[[8]],indices[[11]],indices[[14]],si5,texture1[[1]],texture1[[3]],texture1[[4]],texture1[[5]],
                          texture1[[6]],texture1[[7]],texture1[[8]],texture2[[1]],texture2[[2]],texture2[[3]],texture2[[4]],texture2[[5]],texture2[[7]],texture2[[9]],texture2[[10]],
                          water_proximity)

all_features <- stack(img_bands[[1]],img_bands[[8]],indices[[7]],indices[[8]],indices[[11]],indices[[14]],si5,texture1[[1]],texture1[[3]],texture1[[4]],texture1[[5]],
                      texture1[[6]],texture1[[7]],texture1[[8]],texture2[[1]],texture2[[2]],texture2[[3]],texture2[[4]],texture2[[5]],texture2[[7]],texture2[[9]],texture2[[10]],
                      wet_evi,dry_evi,elevation,aspect,slope,tpi,water_proximity)

############################### NEW CODE BLOCK #####################################################

post_vif_data <- stack(img_bands[[1]],img_bands[[2]],img_bands[[3]],img_bands[[4]],img_bands[[5]],img_bands[[6]],img_bands[[7]],img_bands[[8]],
                       indices[[7]],indices[[8]],indices[[11]],indices[[14]],si5,si9,
                       texture1[[1]],texture1[[3]],texture1[[4]],texture1[[5]],texture1[[6]],texture1[[7]],texture1[[8]],
                       texture2[[1]],texture2[[2]],texture2[[3]],texture2[[4]],texture2[[5]],texture2[[7]],texture2[[9]],texture2[[10]])

post_rf_rfe <- stack(img_bands[[1]],img_bands[[2]],img_bands[[3]],img_bands[[4]],img_bands[[5]],img_bands[[6]],img_bands[[7]],img_bands[[8]],
                     indices[[7]],indices[[8]],indices[[11]],indices[[14]],si5,si9,
                     texture1[[1]],texture1[[3]],texture1[[4]],texture1[[5]],texture1[[6]],texture1[[7]],texture1[[8]],
                     texture2[[1]],texture2[[2]],texture2[[4]],texture2[[7]],texture2[[9]])

#write image stacks to file

writeRaster(spec_text, filename="D:/studies/phd/WV3_Data_JULY2019/010039360030_01/L_Sabie_subset/spec_text.tif", options="INTERLEAVE=BAND", overwrite=TRUE)
writeRaster(spec_text_evi, filename="D:/studies/phd/WV3_Data_JULY2019/010039360030_01/L_Sabie_subset/spec_text_evi.tif", options="INTERLEAVE=BAND", overwrite=TRUE)
writeRaster(spec_text_topo, filename="D:/studies/phd/WV3_Data_JULY2019/010039360030_01/L_Sabie_subset/spec_text_topo.tif", options="INTERLEAVE=BAND", overwrite=TRUE)
writeRaster(spect_text_water, filename="D:/studies/phd/WV3_Data_JULY2019/010039360030_01/L_Sabie_subset/spec_text_water.tif", options="INTERLEAVE=BAND", overwrite=TRUE)
writeRaster(all_features, filename="D:/studies/phd/WV3_Data_JULY2019/010039360030_01/L_Sabie_subset/all_features.tif", options="INTERLEAVE=BAND", overwrite=TRUE)

writeRaster(post_vif_data, filename="D:/studies/phd/WV3_Data_JULY2019/010039360030_01/L_Sabie_subset/post_vif_data.tif", options="INTERLEAVE=BAND", overwrite=TRUE)
writeRaster(post_rf_rfe, filename="D:/studies/phd/WV3_Data_JULY2019/010039360030_01/L_Sabie_subset/post_rf_rfe_data.tif", options="INTERLEAVE=BAND", overwrite=TRUE)
###################################################


#...this is temporal
img <- stack('D:/studies/phd/WV3_Data_JULY2019/010039360040_01/010039360040_01_P001_MUL/19JUL07081130-M2AS-010039360040_01_P001.tif')
text_1 <- stack('D:/studies/phd/WV3_Data_JULY2019/010039360040_01/010039360040_01_P001_MUL/HaralickTextureExtraction_1.tif')
text_2 <- stack('D:/studies/phd/WV3_Data_JULY2019/010039360040_01/010039360040_01_P001_MUL/HaralickTextureExtraction_2.tif')
index <- stack('D:/studies/phd/WV3_Data_JULY2019/010039360040_01/010039360040_01_P001_MUL/indices.tif')
si5 <- raster('D:/studies/phd/WV3_Data_JULY2019/010039360040_01/010039360040_01_P001_MUL/SI5.tif')
si9 <- raster('D:/studies/phd/WV3_Data_JULY2019/010039360040_01/010039360040_01_P001_MUL/SI9.tif')

# merger files
satara_img <- stack(img,index, si5, si9, text_1[[1]],text_1[[3]],text_1[[4]],text_1[[5]],text_1[[6]],text_1[[7]],text_1[[8]],
                  text_2[[1]],text_2[[2]],text_2[[4]],text_2[[7]],text_2[[9]])

# save image
writeRaster(satara_img, filename="D:/studies/phd/WV3_Data_JULY2019/010039360040_01/010039360040_01_P001_MUL/satara_data.tif", options="INTERLEAVE=BAND", overwrite=TRUE)
