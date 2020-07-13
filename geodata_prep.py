from sklearn.model_selection import train_test_split
from sklearn import preprocessing
from osgeo import gdal, ogr, gdal_array
import matplotlib.pyplot as plt
import numpy as np
#%%

rLayer = 'D:/studies/phd/WV3_Data_July2019/010039360030_01/010039360030_01_P001_MUL/sabi_data_cliped.tif'
vLayer = 'D:/studies/phd/WV3_Data_July2019/010039360030_01/L_Sabie_subset/mapping land cover/Lcover_train_and_test.shp'


def rasterize(raster_ext, shp, attrib = 'new_C_ID'):
  """Takes an ESRI shapfile and rasterizes it in the boundary extent of a given raster.
  The created raster is a grayscale image with values corresponding to the entries in the attribute column C_ID
  Args:
      raster(str) = path to given raster
      shp(str) = path to ESRI shapefile
      attrib(str) = name of attribute column to be rasterized
  Returns: rasterized shapefile
  """
  raster_ds = gdal.Open(raster_ext) # read in the given raster
  source_ds = ogr.Open(shp) # read in the esri shapefile
  source_layer = source_ds.GetLayer()
  source_fn = 'D:/studies/phd/WV3_Data_July2019/010039360030_01/L_Sabie_subset/mapping land cover/Lcover_train_and_test.tif' # name of resulting raster file
  ncol = raster_ds.RasterXSize # get number of columns for given raster
  nrow = raster_ds.RasterYSize # get number of rows fro given raster
  proj = raster_ds.GetProjectionRef() # get projection of given raster
  ext = raster_ds.GetGeoTransform() # get extent of given raster
  target_ds = gdal.GetDriverByName('GTiff').Create(source_fn, ncol, nrow, 1, gdal.GDT_Byte) # create empty raster with info from given raster
  target_ds.SetProjection(proj) # set crs of target raster from given raster crs
  target_ds.SetGeoTransform(ext) # set extent/pixel size of target raster from extent of given raster
  gdal.RasterizeLayer(target_ds, [1], source_layer, options = ['ATTRIBUTE='+attrib]) # now rasterize
  
  return target_ds


def img_to_arr(input_file, dim_ordering = 'channels_last', dtype = 'float32'):
    """Takes in a raster file as input and converts to numpy array"""
    bands = [input_file.GetRasterBand(i) for i in range(1, input_file.RasterCount + 1)]
    arr = np.array([gdal_array.BandReadAsArray(band) for band in bands]).astype(dtype)
    if dim_ordering == 'channels_last':
        arr = np.transpose(arr, [1,2,0])
    return arr
#%%

#rasterize reference shp and convert rasters to np array 
x_img_arr = img_to_arr(gdal.Open(rLayer))
y_img_arr = img_to_arr(rasterize(rLayer,vLayer))

#%%

#reshape array data 
x_img_arr = x_img_arr.reshape(np.product(x_img_arr.shape[:2]),x_img_arr.shape[2])
y_img_arr = y_img_arr.reshape(-1)

#x_img_arr = img_to_arr(x_img).reshape(133*102,40)
#y_img_arr = img_to_arr(y_img).reshape(-1)
#
#
print(x_img_arr.shape, 'and ', y_img_arr.shape) 
#%%

#standardize data 
from numpy import inf
x_img_arr[x_img_arr == -inf] = 0
scaler = preprocessing.StandardScaler()
x_img_arr_scaled = scaler.fit_transform(x_img_arr)
#%%

#extract labeled pixels from both datasets... i.e. image (img) and reference (lab)
indices = np.where(y_img_arr>0)
all_data_img = x_img_arr_scaled[indices]
all_data_lab = y_img_arr[indices]-1

#%%
#split data into train and test 
train_img, test_img, train_lab, test_lab = train_test_split(all_data_img, all_data_lab, train_size = 0.7, random_state = 90, shuffle = True, stratify = all_data_lab)
#%%

#prepare satara imagery for prediction

satara_img = 'D:/studies/phd/WV3_Data_JULY2019/010039360040_01/010039360040_01_P001_MUL/satara_data_clipped.tif'

satara_img1 = gdal.Open(satara_img)
#%% image to array
satara_img_arr = img_to_arr(satara_img1)

#%%
#reshape array data 
satara_img_arr1 = satara_img_arr.reshape(np.product(satara_img_arr.shape[:2]),satara_img_arr.shape[2])

print(satara_img_arr1.shape) 

#%%
#standardize data 

satara_img_arr1[satara_img_arr1 == -inf] = 0

satara_img_arr1_scaled = scaler.fit_transform(satara_img_arr1)
