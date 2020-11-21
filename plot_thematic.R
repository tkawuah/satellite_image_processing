library(raster)
library(ggplot2)
library(grid)
library(gridExtra)
library(cowplot)
library(RColorBrewer)
library(ggpubr)
library(ggspatial)

#open files
#sabi
map1994<-raster('*/sabi/MLP_map1.tif')
#satara
map2018<-raster('*/satara/SVM_map_satara1.tif')

# function to prep thematic raster data for plotting
prep_raster <- function(thema_img){
  img_points <- rasterToPoints(thema_img) #raster to points
  img_df <- data.frame(img_points) #raster points to dataframe
  colnames(img_df)<-c("longitude","latitude","map_label") #set column names
  
  #add class names in a new column
  img_df$class<-0
  img_df$class[img_df$map_label==1]<-"Woody evergreen"
  img_df$class[img_df$map_label==2]<-"Woody deciduous"
  img_df$class[img_df$map_label==3]<-"Bunch grass"
  img_df$class[img_df$map_label==4]<-"Grazin lawn"
  img_df$class[img_df$map_label==5]<-"Water body"
  img_df$class[img_df$map_label==6]<-"Bare"
  img_df$class[img_df$map_label==7]<-"Built-up"
  img_df$class[img_df$map_label==8]<-"Shadow"
  return(img_df)
}

#process imported raster
map1994.df <- prep_raster(map1994) #lower sabie
map2018.df <- prep_raster(map2018) #satara
  
#create legend color
leg<- c('Bare', 'Built-up', 'Bunch grass', 'Grazing lawn', 'Shadow', 'Water body','Woody deciduous', 'Woody evergreen')
cPalette<- c('#FFFFFF', '#FF0000', '#FFFF00', '#FF00FF', '#000000', '#0000FF','#808000', '#00FF00')


#make plot
RE_p1<-ggplot(data=map1994.df, aes(y=latitude, x=longitude)) +
  geom_raster(aes(fill=class))+ scale_fill_manual(values = cPalette, labels=leg)+
  ggtitle("Lower Sabie")+labs(x="",y="")+theme_bw()+
  coord_sf(crs = "+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs")+
  annotation_scale(location = "br", width_hint = 0.5, style = "ticks")+
  theme(plot.margin = unit(c(0,0,0,0), "cm"), axis.title = element_blank(), 
        plot.title = element_text(hjust = 0.5, size = 10), axis.text = element_blank(),
        axis.ticks = element_blank())



RE_p3<-ggplot(data=map2018.df, aes(y=latitude, x=longitude)) +
  geom_raster(aes(fill=class))+ scale_fill_manual(values = cPalette, labels=leg)+
  ggtitle("Satara")+labs(x="",y="")+theme_bw()+
  coord_sf(crs = "+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs")+
  annotation_scale(location = "br", width_hint = 0.5, style = "ticks")+
  theme(plot.margin = unit(c(0,0,0,0), "cm"), axis.title = element_blank(), 
        plot.title = element_text(hjust = 0.5, size = 10), axis.text = element_blank(),
        axis.ticks = element_blank())


figure<-ggarrange(RE_p1,RE_p3, ncol=2, nrow=1, common.legend = TRUE, legend="bottom")
figure
