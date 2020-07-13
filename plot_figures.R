library(ggplot2)
library(tidyr)
library(reshape)
library(ggpubr)

#VIF plots from spectral and texture indices
spec_in <- read.csv('D:/studies/phd/WV3_Data_JULY2019/010039360030_01/L_Sabie_subset/spectral_Indices_vif.csv')
text_in <- read.csv('D:/studies/phd/WV3_Data_JULY2019/010039360030_01/L_Sabie_subset/texture_indices_vif.csv')

s<- ggplot(spec_in, aes(x = reorder(variable, -vif), y = vif))+ geom_bar(stat = 'identity')+
  labs(x = 'Spectral indices', y = 'Variance Inflation Factor(VIF)') + theme_bw()+
  theme(axis.line = element_line(), panel.background = element_blank(),
        axis.text.x = element_text(size = 7, angle = 120))
s

t<- ggplot(text_in, aes(x = reorder(variable, -vif), y = vif))+ geom_bar(stat = 'identity')+
  labs(x = 'Texture features', y = '') + theme_bw()+
  theme(axis.line = element_line(), panel.background = element_blank(),
        axis.text.x = element_text(size = 7, angle = 120))
t

#recursive feature elimination plot
file_path <- 'D:/studies/phd/WV3_Data_JULY2019/010039360030_01/L_Sabie_subset/rfe_csv_selected_features_imp_scores.csv'

rfe_df <- read.csv(file_path)

head(rfe_df)

p<- ggplot(rfe_df, aes(x = reorder(Feature, -Score), y = Score))+ geom_bar(stat = 'identity', aes(fill = Dataset))+
  labs(x = 'Image features', y = 'Importance score') + theme_bw()+
  theme(axis.line = element_line(), panel.background = element_blank(),
        axis.text.x = element_text(size = 7, angle = 120))

p 

#combine plots
library(patchwork)

patchwork<-(s+t)/p
patchwork + plot_annotation(tag_levels = 'A')

# permutation mportance plots
file_path3<- 'D:/studies/phd/WV3_Data_JULY2019/010039360030_01/L_Sabie_subset/mlp_permImportance.csv'
file_path4<- 'D:/studies/phd/WV3_Data_JULY2019/010039360030_01/L_Sabie_subset/rf_permImportance.csv'

mlp_df = read.csv(file_path3)
rf_df = read.csv(file_path4)

mlp_plot <- ggplot(mlp_df, aes(x = reorder(Predictor, weight), y = weight))+ geom_bar(stat = 'identity', aes(fill = Dataset))+
  geom_errorbar(aes(ymin = weight - std, ymax = weight + std), width=0.6)+
  labs(x = 'Image features', y = 'Variable weight') + theme_bw()+
  theme(axis.line = element_line(), panel.background = element_blank(),
        axis.text.x = element_text(size = 7, angle = 120),
        axis.text.y = element_text(size = 7))

rf_plot <- ggplot(rf_df, aes(x = reorder(Predictor, weight), y = weight))+ geom_bar(stat = 'identity', aes(fill = Dataset))+
  geom_errorbar(aes(ymin = weight - std, ymax = weight + std), width=0.6) + 
  labs(x = 'Image features', y = 'Variable weight') + theme_bw()+
  theme(axis.line = element_line(), panel.background = element_blank(),
        axis.text.x = element_text(size = 7, angle = 120),
        axis.text.y = element_text(size = 7))

mlp_plot <- mlp_plot + coord_flip()
rf_plot <- rf_plot + coord_flip()

figure<-ggarrange(mlp_plot,rf_plot, ncol=2, nrow=1, labels = 'auto', common.legend = TRUE, legend="bottom")
figure


#accuracy plot
file_path2 <- 'D:/studies/phd/WV3_Data_JULY2019/010039360030_01/L_Sabie_subset/mlp_independent_accuracy.csv'

acc_df <- read.csv(file_path2)
head(acc_df)

acc_df.m <- melt(acc_df, id.vars = 'Accuracy_metric')
head(acc_df.m)

ggplot(acc_df.m, aes(variable, value)) + 
  geom_bar(stat = 'identity',aes(fill = Accuracy_metric), position = "dodge")


#... accuracy comparison plots from nested cv
cv_file <- 'D:/studies/phd/WV3_Data_JULY2019/010039360030_01/L_Sabie_subset/nested-cv_accuracy results.csv'

cv_score <- read.csv(cv_file)
head(cv_score)

p <- ggplot(cv_score, aes(x= Algorithm, y= Score))+
  geom_boxplot(notch = FALSE ,aes(fill= Metric,), position = position_dodge(0.8))+
  scale_fill_manual(values= c("gold", "darkgreen"))+ labs(y='Accuracy (%)')+
  stat_summary(fun.y=mean, geom="smooth", aes(group=1), lwd=1)+ theme_bw()+
  theme(axis.line = element_line(), panel.background = element_blank())
p

#... grazing lawn accuracy comparison from binary classification

#sabie
bin_acc_sabi <- read.csv('D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/sabi/thresholded bin maps/final_acc_metrics_accross_models.csv')
sab <- ggplot(bin_acc_sabi, aes(x = Algorithm, y = Score))+
  geom_bar(stat = 'identity', aes(fill = Metric), position = 'dodge')+
  scale_fill_brewer(palette = 'Set1')+
  labs(y = 'Accuracy level')

#satara
bin_acc_satara <- read.csv('D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/satara/thresholded bin maps/final_acc_metrics_accross_models.csv')
sat <- ggplot(bin_acc_satara, aes(x = Algorithm, y = Score))+
  geom_bar(stat = 'identity', aes(fill = Metric), position = 'dodge')+
  scale_fill_brewer(palette = 'Set1')+
  labs(y = '')

both <- ggarrange(sab, sat, nrow = 1, ncol = 2, common.legend = TRUE, legend = 'right', labels = c('A','B'),
                  font.label = list(face='plain', size = 11))
both

#... Grazing lawn and non grazing lawn area estimates
#sabi
area_sabi <- read.csv('D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/sabi/thresholded bin maps/glawn_and_non-glawn_area_estimate.csv')

dodge <- position_dodge(width=0.9)

sab_area <- ggplot(area_sabi, aes(x = Algorithm, y = Area, fill = Class))+ 
  geom_col(position = 'dodge')+
  geom_errorbar(aes(ymin = Area - stdErr, ymax = Area + stdErr), position = dodge, width=0.25)+
  scale_fill_manual(values= c("darkgreen", "gold"))+
  labs(x = 'Algorithm', y = bquote('Area'~(km^2)))
sab_area

#satara
area_satara <- read.csv('D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/satara/thresholded bin maps/glawn_and_non-glawn_area_estimate.csv')
sat_area <- ggplot(area_satara, aes(x = Algorithm, y = Area, fill = Class))+ 
  geom_col(position = 'dodge')+
  geom_errorbar(aes(ymin = Area - stdErr, ymax = Area + stdErr), position = dodge, width=0.25)+
  scale_fill_manual(values= c("darkgreen", "gold"))+
  labs(x = 'Algorithm', y = '')
sat_area

both_area <- ggarrange(sab_area, sat_area, nrow = 1, ncol = 2, common.legend = TRUE, legend = 'right', labels = c('A','B'),
                  font.label = list(face='plain', size = 11))
both_area

#####################################################################################

### ...thematic raster plots

library(raster)
library(ggplot2)
library(ggspatial)
library(grid)
library(gridExtra)
library(cowplot)
library(RColorBrewer)
library(ggpubr)
theme_set(theme_bw()) #set plot background theme

#open Sabie files
map_rf_sabie <- raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/sabi/thresholded bin maps/RF_gl_binMap0.5.tif")
map_mlp_sabie <- raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/sabi/thresholded bin maps/MLP_gl_binMap0.35.tif")
map_cart_sabie <- raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/sabi/thresholded bin maps/CART_gl_binMap0.6.tif")
map_svm_sabie <- raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/sabi/thresholded bin maps/SVM_gl_binMap0.4.tif")

#open Satara files
map_rf_satara <- raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/satara/thresholded bin maps/RF_gl_binMap0.35.tif")
map_mlp_satara <- raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/satara/thresholded bin maps/MLP_gl_binMap0.65.tif")
map_cart_satara <- raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/satara/thresholded bin maps/CART_gl_binMap0.35.tif")
map_svm_satara <- raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/satara/thresholded bin maps/SVM_gl_binMap0.25.tif")


#function for preparing thematic images for plotting
raster_to_plot <- function(img){
  img_rtp <- rasterToPoints(img) #convert raster to points
  img_rtp_df <- data.frame(img_rtp) #convert points to dataframe for ggplot
  colnames(img_rtp_df)<-c("longitude","latitude","map_label") #give colums names to dataframe
  #add class names in a new column
  img_rtp_df$class<-0
  img_rtp_df$class[img_rtp_df$map_label==1]<-"Other"
  img_rtp_df$class[img_rtp_df$map_label==2]<-"Grazing lawn"
  return(img_rtp_df)
}

#function to plot map, where df is the result of the raster_to_plot function
plot_raster <- function(df){
  #create legend color
  leg<- c('Grazing lawn', 'Other')
  cPalette<- c("darkgreen", "gold")
  #make plot
  map_plot <- ggplot(data = df, aes(y = latitude, x = longitude)) +
    geom_raster(aes(fill = class))+ 
    coord_sf(crs = "+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs")+
    annotation_scale(location = "br", width_hint = 0.5, style = "ticks")+
    scale_fill_manual(values = cPalette, labels=leg)+
    labs(title = '')+
    theme(axis.text = element_blank(), axis.ticks = element_blank(), 
          axis.title = element_blank())
  return(map_plot)
}

#run functions and create sabie plots
cart_plot_sabie <- plot_raster(raster_to_plot(map_cart_sabie))
mlp_plot_sabie <- plot_raster(raster_to_plot(map_mlp_sabie))
rf_plot_sabie <- plot_raster(raster_to_plot(map_rf_sabie))
svm_plot_sabie <- plot_raster(raster_to_plot(map_svm_sabie))

#run functions and create satara plots
cart_plot_satara <- plot_raster(raster_to_plot(map_cart_satara))
mlp_plot_satara <- plot_raster(raster_to_plot(map_mlp_satara))
rf_plot_satara <- plot_raster(raster_to_plot(map_rf_satara))
svm_plot_satara <- plot_raster(raster_to_plot(map_svm_satara))

ggarrange(cart_plot_sabie,cart_plot_satara,mlp_plot_sabie,mlp_plot_satara,
          rf_plot_sabie,rf_plot_satara,svm_plot_sabie,svm_plot_satara, nrow = 4, ncol = 2, 
          common.legend = TRUE, legend = 'right', 
          labels = c('CART-Lower Sabie','CART-Satara', 'MLP-Lower Sabie', 'MLP-Satara', 
                     'RF-Lower Sabie','RF-Satara', 'SVM-Lower Sabie', 'SVM-Satara'),
          font.label = list(face='plain', size = 11))


##############################################################################################

#####.... continuous raster plots

library(raster)
library(RColorBrewer)
library(ggspatial)
library(viridis)
library(ggpubr)
library(patchwork)
theme_set(theme_bw())

#sabie files
sab_probs_rf<-raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/sabi/RF_gl_prob.tif")
sab_probs_mlp<-raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/sabi/MLP_gl_prob.tif")
sab_probs_cart<-raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/sabi/CART_gl_prob.tif")
sab_probs_svm<-raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/sabi/SVM_gl_prob.tif")


#satara files
sat_probs_rf<-raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/satara/RF_gl_prob_satara.tif")
sat_probs_mlp<-raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/satara/MLP_gl_prob_satara.tif")
sat_probs_cart<-raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/satara/CART_gl_prob_satara.tif")
sat_probs_svm<-raster("D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/satara/SVM_gl_prob_satara.tif")

#sabie raster to points
rtp_sab_probs_rf <- rasterToPoints(sab_probs_rf)
rtp_sab_probs_mlp <- rasterToPoints(sab_probs_mlp)
rtp_sab_probs_cart <- rasterToPoints(sab_probs_cart)
rtp_sab_probs_svm <- rasterToPoints(sab_probs_svm)

#satara raster to points
rtp_sat_probs_rf <- rasterToPoints(sat_probs_rf)
rtp_sat_probs_mlp <- rasterToPoints(sat_probs_mlp)
rtp_sat_probs_cart <- rasterToPoints(sat_probs_cart)
rtp_sat_probs_svm <- rasterToPoints(sat_probs_svm)

#convert sabie raster points to dataframe for ggplot
df_rtp_sab_probs_rf <- data.frame(rtp_sab_probs_rf)
df_rtp_sab_probs_mlp <- data.frame(rtp_sab_probs_mlp)
df_rtp_sab_probs_cart <- data.frame(rtp_sab_probs_cart)
df_rtp_sab_probs_svm <- data.frame(rtp_sab_probs_svm)

#convert satara raster points to dataframe for ggplot
df_rtp_sat_probs_rf <- data.frame(rtp_sat_probs_rf)
df_rtp_sat_probs_mlp <- data.frame(rtp_sat_probs_mlp)
df_rtp_sat_probs_cart <- data.frame(rtp_sat_probs_cart)
df_rtp_sat_probs_svm <- data.frame(rtp_sat_probs_svm)

#give appropriate column names to sabie data
colnames(df_rtp_sab_probs_rf)<-c("longitude","latitude","Value")
colnames(df_rtp_sab_probs_mlp)<-c("longitude","latitude","Value")
colnames(df_rtp_sab_probs_cart)<-c("longitude","latitude","Value")
colnames(df_rtp_sab_probs_svm)<-c("longitude","latitude","Value")

#give appropriate column names to satara data
colnames(df_rtp_sat_probs_rf)<-c("longitude","latitude","Value")
colnames(df_rtp_sat_probs_mlp)<-c("longitude","latitude","Value")
colnames(df_rtp_sat_probs_cart)<-c("longitude","latitude","Value")
colnames(df_rtp_sat_probs_svm)<-c("longitude","latitude","Value")

#plot sabie raster
rf_sabie  <- ggplot(df_rtp_sab_probs_rf, aes(x = longitude, y = latitude))+
  geom_raster(aes(fill = Value))+
  scale_fill_gradientn(colours = terrain.colors(n = 16, rev = TRUE))+
  coord_sf(crs = "+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs")+
  annotation_scale(location = "br", width_hint = 0.5, style = "ticks")+
  annotation_north_arrow(location = "br", which_north = "true",
                         pad_x = unit(0.40, "in"), pad_y = unit(0.2, "in"),
                         style = north_arrow_fancy_orienteering)+
  labs(title = 'RF-Lower Sabie')+
  theme(plot.margin = unit(c(0,0,0,0), "cm"), axis.title = element_blank(), 
        plot.title = element_text(hjust = 0.5, size = 10), axis.text = element_blank(),
        axis.ticks = element_blank())

mlp_sabie <- ggplot(df_rtp_sab_probs_mlp, aes(x = longitude, y = latitude))+
  geom_raster(aes(fill = Value))+
  scale_fill_gradientn(colours = terrain.colors(n = 16, rev = TRUE))+
  coord_sf(crs = "+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs")+
  annotation_scale(location = "br", width_hint = 0.5, style = "ticks")+
  annotation_north_arrow(location = "br", which_north = "true",
                         pad_x = unit(0.40, "in"), pad_y = unit(0.2, "in"),
                         style = north_arrow_fancy_orienteering)+
  labs(title = 'MLP-Lower Sabie')+
  theme(plot.margin = unit(c(0,0,0,0), "cm"), axis.title = element_blank(), 
        plot.title = element_text(hjust = 0.5, size = 10), axis.text = element_blank(),
        axis.ticks = element_blank())

cart_sabie <- ggplot(df_rtp_sab_probs_cart, aes(x = longitude, y = latitude))+
  geom_raster(aes(fill = Value))+
  scale_fill_gradientn(colours = terrain.colors(n = 16, rev = TRUE))+
  coord_sf(crs = "+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs")+
  annotation_scale(location = "br", width_hint = 0.5, style = "ticks")+
  annotation_north_arrow(location = "br", which_north = "true",
                         pad_x = unit(0.40, "in"), pad_y = unit(0.2, "in"),
                         style = north_arrow_fancy_orienteering)+
  labs(title = 'CART-Lower Sabie')+
  theme(plot.margin = unit(c(0,0,0,0), "cm"), axis.title = element_blank(), 
        plot.title = element_text(hjust = 0.5, size = 10), axis.text = element_blank(),
        axis.ticks = element_blank())

svm_sabie <- ggplot(df_rtp_sab_probs_svm, aes(x = longitude, y = latitude))+
  geom_raster(aes(fill = Value))+
  scale_fill_gradientn(colours = terrain.colors(n = 16, rev = TRUE))+
  coord_sf(crs = "+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs")+
  annotation_scale(location = "br", width_hint = 0.5, style = "ticks")+
  annotation_north_arrow(location = "br", which_north = "true",
                         pad_x = unit(0.40, "in"), pad_y = unit(0.2, "in"),
                         style = north_arrow_fancy_orienteering)+
  labs(title = 'SVM-Lower Sabie')+
  theme(plot.margin = unit(c(0,0,0,0), "cm"), axis.title = element_blank(), 
        plot.title = element_text(hjust = 0.5, size = 10), axis.text = element_blank(),
        axis.ticks = element_blank())

#plot satara raster
rf_satara <- ggplot(df_rtp_sat_probs_rf, aes(x = longitude, y = latitude))+
  geom_raster(aes(fill = Value))+
  scale_fill_gradientn(colours = terrain.colors(n = 16, rev = TRUE))+
  coord_sf(crs = "+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs")+
  annotation_scale(location = "br", width_hint = 0.5, style = "ticks")+
  annotation_north_arrow(location = "br", which_north = "true",
                         pad_x = unit(0.40, "in"), pad_y = unit(0.2, "in"),
                         style = north_arrow_fancy_orienteering)+
  labs(title = 'RF-Satara')+
  theme(plot.margin = unit(c(0,0,0,0), "cm"), axis.title = element_blank(), 
        plot.title = element_text(hjust = 0.5, size = 10), axis.text = element_blank(),
        axis.ticks = element_blank())

mlp_satara <- ggplot(df_rtp_sat_probs_mlp, aes(x = longitude, y = latitude))+
  geom_raster(aes(fill = Value))+
  scale_fill_gradientn(colours = terrain.colors(n = 16, rev = TRUE))+
  coord_sf(crs = "+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs")+
  annotation_scale(location = "br", width_hint = 0.5, style = "ticks")+
  annotation_north_arrow(location = "br", which_north = "true",
                         pad_x = unit(0.40, "in"), pad_y = unit(0.2, "in"),
                         style = north_arrow_fancy_orienteering)+
  labs(title = 'MLP-Satara')+
  theme(plot.margin = unit(c(0,0,0,0), "cm"), axis.title = element_blank(), 
        plot.title = element_text(hjust = 0.5, size = 10), axis.text = element_blank(),
        axis.ticks = element_blank())

cart_satara <- ggplot(df_rtp_sat_probs_cart, aes(x = longitude, y = latitude))+
  geom_raster(aes(fill = Value))+
  scale_fill_gradientn(colours = terrain.colors(n = 16, rev = TRUE))+
  coord_sf(crs = "+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs")+
  annotation_scale(location = "br", width_hint = 0.5, style = "ticks")+
  annotation_north_arrow(location = "br", which_north = "true",
                         pad_x = unit(0.40, "in"), pad_y = unit(0.2, "in"),
                         style = north_arrow_fancy_orienteering)+
  labs(title = 'CART-Satara')+
  theme(plot.margin = unit(c(0,0,0,0), "cm"), axis.title = element_blank(), 
        plot.title = element_text(hjust = 0.5, size = 10), axis.text = element_blank(),
        axis.ticks = element_blank())

svm_satara <- ggplot(df_rtp_sat_probs_svm, aes(x = longitude, y = latitude))+
  geom_raster(aes(fill = Value))+
  scale_fill_gradientn(colours = terrain.colors(n = 16, rev = TRUE))+
  coord_sf(crs = "+proj=utm +zone=36 +south +datum=WGS84 +units=m +no_defs")+
  annotation_scale(location = "br", width_hint = 0.5, style = "ticks")+
  annotation_north_arrow(location = "br", which_north = "true",
                         pad_x = unit(0.40, "in"), pad_y = unit(0.2, "in"),
                         style = north_arrow_fancy_orienteering)+
  labs(title = 'SVM-Satara')+
  theme(plot.margin = unit(c(0,0,0,0), "cm"), axis.title = element_blank(), 
        plot.title = element_text(hjust = 0.5, size = 10), axis.text = element_blank(),
        axis.ticks = element_blank())

(cart_sabie|cart_satara)/(mlp_sabie|mlp_satara)/(rf_sabie|rf_satara)/(svm_sabie|svm_satara)

ggarrange(cart_sabie, cart_satara, mlp_sabie, mlp_satara, rf_sabie, 
                  rf_satara, svm_sabie, svm_satara, ncol=2, nrow=4, common.legend = TRUE, 
                  legend="right")


#annotate_figure(figure, left = text_grob('Latitude', rot = 90), 
#                bottom = text_grob('Longitude'))


#######################################################################

############ spatial metrics ####################

library(ggplot2)

spat_met<- read.csv('D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/sabi/spatial analysis/spat_metrics_sabi.csv')

m1<- ggplot(data=spat_met, aes(x=distance, y=n.patches, group=1)) +
  geom_line(color="black", size= 1)+
  geom_point()+geom_smooth(method = 'lm', linetype = 'dashed', color = 'red')+
  labs(x= 'Distance (km)', y='NP')+
  theme(axis.text = element_text(size=12),axis.title =element_text(size=12))

m2<- ggplot(data=spat_met, aes(x=distance, y=max.patch, group=1)) +
  geom_line(color="black", size= 1)+
  geom_point()+geom_smooth(method = 'lm', linetype = 'dashed', color = 'red')+
  labs(x='', y=bquote('MPA'~(km^2)))+
  theme(axis.text = element_text(size=12),axis.title =element_text(size=12))

m3<- ggplot(data=spat_met, aes(x=distance, y=cohesion, group=1)) +
  geom_line(color="black", size= 1)+
  geom_point()+geom_smooth(method = 'lm', linetype = 'dashed', color = 'red')+
  labs(x='', y='CI', title = 'Lower Sabie')+
  theme(axis.text = element_text(size=12),axis.title =element_text(size=12) )

spat_met_sat<- read.csv('D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/satara/spatial_analysis/spatial_metrics.csv')

m11<- ggplot(data=spat_met_sat, aes(x=distance, y=n.patches, group=1)) +
  geom_line(color="black", size= 1)+
  geom_point()+geom_smooth(method = 'lm', linetype = 'dashed', color = 'red')+
  labs(x= 'Distance (km)', y='')+
  theme(axis.text = element_text(size=12),axis.title =element_text(size=12))

m22<- ggplot(data=spat_met_sat, aes(x=distance, y=max.patch, group=1)) +
  geom_line(color="black", size= 1)+
  geom_point()+geom_smooth(method = 'lm', linetype = 'dashed', color = 'red')+
  labs(x='', y='')+
  theme(axis.text = element_text(size=12),axis.title =element_text(size=12))

m33<- ggplot(data=spat_met_sat, aes(x=distance, y=cohesion, group=1)) +
  geom_line(color="black", size= 1)+
  geom_point()+geom_smooth(method = 'lm', linetype = 'dashed', color = 'red')+
  labs(x='', y='', title = 'Satara')+
  theme(axis.text = element_text(size=12),axis.title =element_text(size=12) )


patchwork<-(m3/m2/m1)|(m33/m22/m11)
patchwork 

sab <- lm(cohesion~distance, data = spat_met)
sat <- lm(cohesion~distance, data = spat_met_sat)


#...Plotting patch size (area) distribution
psd <- read.csv('D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/sabi/spatial analysis/patch_size_dist.csv')
p1 <- ggplot(aes(y= Area, x=Landscape), data = psd)+geom_boxplot(width = 0.3, outlier.size = 0.3)+
  stat_summary(fun.y = mean, geom = "errorbar", aes(ymax = ..y.., ymin = ..y..),
               linetype = "dashed")+
  scale_y_log10()+
  labs(x = 'Landscape', y = bquote('Log of patch size'~(m^2))) + theme_bw()+
  theme(axis.line = element_line(), panel.background = element_blank())
p1

#...plotting summary spatial metrics for both L. Sabie and Satara landscapes
summary_data <- read.csv('D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/summary_of_spat_mets.csv')

prop<- ggplot(summary_data, aes(x = landscape, y = PROP))+ geom_bar(stat = 'identity',width = 0.3)+
  labs(x = '', y = 'Proportion of total area (%)') + theme_bw()+
  theme(axis.line = element_line(), panel.background = element_blank())
prop

np<- ggplot(summary_data, aes(x = landscape, y = NP))+ geom_bar(stat = 'identity',width = 0.3)+
  labs(x = '', y = 'Number of Patches') + theme_bw()+
  theme(axis.line = element_line(), panel.background = element_blank())
np

ci<- ggplot(summary_data, aes(x = landscape, y = CI))+ geom_bar(stat = 'identity',width = 0.3)+
  labs(x = 'Landscape', y = 'Cohesion Index') + theme_bw()+
  theme(axis.line = element_line(), panel.background = element_blank())
ci

patchwork<-(np+prop)/(ci+p1)
patchwork + plot_annotation(tag_levels = 'A')
