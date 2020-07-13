from osgeo import gdal, ogr, gdal_array
import numpy as np
#%%
#...reshape array to 2D
x_img_arr1 = img_to_arr(gdal.Open(satara_img)) #modified to satara image

#%% thematic maps
map_rf = rf_pred.reshape(x_img_arr1.shape[0],x_img_arr1.shape[1])
map_cart = cart_pred.reshape(x_img_arr1.shape[0],x_img_arr1.shape[1])
map_svm = svm_pred.reshape(x_img_arr1.shape[0],x_img_arr1.shape[1])

#%% grazing lawn probability surface

gl_rf_prob = rf_probs[:,3].reshape(x_img_arr1.shape[0],x_img_arr1.shape[1])
gl_cart_prob = cart_probs[:,3].reshape(x_img_arr1.shape[0],x_img_arr1.shape[1])
gl_svm_prob = svm_probs[:,3].reshape(x_img_arr1.shape[0],x_img_arr1.shape[1])
# gl_mlp_prob = mlp_probs[:,3].reshape(x_img_arr1.shape[0],x_img_arr1.shape[1])

#%%
x_img = gdal.Open(satara_img) #modified to satara image

file_name = 'D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/SVM_gl_prob_satara.tif'
x_pixels = x_img.RasterXSize
y_pixels = x_img.RasterYSize
driver = gdal.GetDriverByName('GTiff')
dtype = str(gl_svm_prob.dtype)


datatype_mapping = {'byte': gdal.GDT_Byte, 'uint8': gdal.GDT_Byte, 'uint16': gdal.GDT_UInt16, 
                        'int8': gdal.GDT_Byte, 'int16': gdal.GDT_Int16, 'int32': gdal.GDT_Int32,
                        'uint32': gdal.GDT_UInt32, 'float32': gdal.GDT_Float32, 'float64':gdal.GDT_Float64}


out_ds = driver.Create(file_name, x_pixels, y_pixels, 1, datatype_mapping[dtype])
out_ds.GetRasterBand(1).WriteArray(gl_svm_prob)


geo_trans = x_img.GetGeoTransform()
proj = x_img.GetProjection()
out_ds.SetGeoTransform(geo_trans)
out_ds.SetProjection(proj)
out_ds = None