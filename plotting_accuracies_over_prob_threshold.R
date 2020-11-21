library(ggplot2)
library(patchwork)
library(ggpubr)

#import dataset
cart_acc_sabie <- read.csv('*/CART_gl_binMaps_acc_metrics.csv')

mlp_acc_sabie <- read.csv('*/MLP_gl_binMaps_acc_metrics.csv')

rf_acc_sabie <- read.csv('*/RF_gl_binMaps_acc_metrics.csv')

svm_acc_sabie <- read.csv('*/SVM_gl_binMaps_acc_metrics.csv')


cart_acc_satara <- read.csv('*/CART_gl_binMaps_acc_metrics.csv')

mlp_acc_satara <- read.csv('*/MLP_gl_binMaps_acc_metrics.csv')

rf_acc_satara <- read.csv('*/RF_gl_binMaps_acc_metrics.csv')

svm_acc_satara <- read.csv('*/SVM_gl_binMaps_acc_metrics.csv')


#cart sabie
cart_sabie <- ggplot(data = cart_acc_sabie, aes(x = threshold, y = acc_value, group = Metric))+
  geom_line(aes(color = Metric), size = 1.2)+
  scale_color_brewer(palette = 'Set1')+
  scale_x_continuous(limits = c(0.00,1.00), breaks = c(0.00,0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.90, 1.00))+
  geom_vline(xintercept = 0.6, color = 'darkred', size = 1, linetype = 'dashed')+
  labs(x = 'Probability threshold', y = 'Accuracy level', title = 'CART-Lower Sabie')+
  theme(panel.grid = element_blank(), plot.title = element_text(hjust = 0.5, size = 10), 
        axis.title = element_blank())

#mlp sabie
mlp_sabie <- ggplot(data = mlp_acc_sabie, aes(x = threshold, y = acc_value, group = Metric))+
  geom_line(aes(color = Metric), size = 1.2)+
  scale_color_brewer(palette = 'Set1')+
  scale_x_continuous(limits = c(0.00,1.00), breaks = c(0.00,0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.90, 1.00))+
  geom_vline(xintercept = 0.35, color = 'darkred', size = 1, linetype = 'dashed')+
  labs(x = 'Probability threshold', y = 'Accuracy level', title = 'MLP-Lower Sabie')+
  theme(panel.grid = element_blank(), plot.title = element_text(hjust = 0.5, size = 10), 
        axis.title = element_blank())

#rf sabie
rf_sabie <- ggplot(data = rf_acc_sabie, aes(x = threshold, y = acc_value, group = Metric))+
  geom_line(aes(color = Metric), size = 1.2)+
  scale_color_brewer(palette = 'Set1')+
  scale_x_continuous(limits = c(0.00,1.00), breaks = c(0.00,0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.90, 1.00))+
  geom_vline(xintercept = 0.5, color = 'darkred', size = 1, linetype = 'dashed')+
  labs(x = 'Probability threshold', y = 'Accuracy level', title = 'RF-Lower Sabie')+
  theme(panel.grid = element_blank(), plot.title = element_text(hjust = 0.5, size = 10), 
        axis.title = element_blank())

#svm sabie
svm_sabie <- ggplot(data = svm_acc_sabie, aes(x = threshold, y = acc_value, group = Metric))+
  geom_line(aes(color = Metric), size = 1.2)+
  scale_color_brewer(palette = 'Set1')+
  scale_x_continuous(limits = c(0.00,1.00), breaks = c(0.00,0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.90, 1.00))+
  geom_vline(xintercept = 0.4, color = 'darkred', size = 1, linetype = 'dashed')+
  labs(x = 'Probability threshold', y = 'Accuracy level', title = 'SVM-Lower Sabie')+
  theme(panel.grid = element_blank(), plot.title = element_text(hjust = 0.5, size = 10), 
        axis.title = element_blank())

#cart satara
cart_satara <- ggplot(data = cart_acc_satara, aes(x = threshold, y = acc_value, group = Metric))+
  geom_line(aes(color = Metric), size = 1.2)+
  scale_color_brewer(palette = 'Set1')+
  scale_x_continuous(limits = c(0.00,1.00), breaks = c(0.00,0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.90, 1.00))+
  geom_vline(xintercept = 0.35, color = 'darkred', size = 1, linetype = 'dashed')+
  labs(x = 'Probability threshold', y = 'Accuracy level', title = 'CART-Satara')+
  theme(panel.grid = element_blank(), plot.title = element_text(hjust = 0.5, size = 10), 
        axis.title = element_blank())

#mlp satara
mlp_satara <- ggplot(data = mlp_acc_satara, aes(x = threshold, y = acc_value, group = Metric))+
  geom_line(aes(color = Metric), size = 1.2)+
  scale_color_brewer(palette = 'Set1')+
  scale_x_continuous(limits = c(0.00,1.00), breaks = c(0.00,0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.90, 1.00))+
  geom_vline(xintercept = 0.65, color = 'darkred', size = 1, linetype = 'dashed')+
  labs(x = 'Probability threshold', y = 'Accuracy level', title = 'MLP-Satara')+
  theme(panel.grid = element_blank(), plot.title = element_text(hjust = 0.5, size = 10), 
        axis.title = element_blank())
             
#rf satara
rf_satara <- ggplot(data = rf_acc_satara, aes(x = threshold, y = acc_value, group = Metric))+
  geom_line(aes(color = Metric), size = 1.2)+
  scale_color_brewer(palette = 'Set1')+
  scale_x_continuous(limits = c(0.00,1.00), breaks = c(0.00,0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.90, 1.00))+
  geom_vline(xintercept = 0.35, color = 'darkred', size = 1, linetype = 'dashed')+
  labs(x = 'Probability threshold', y = 'Accuracy level', title = 'RF-Satara')+
  theme(panel.grid = element_blank(), plot.title = element_text(hjust = 0.5, size = 10), 
        axis.title = element_blank())

#svm satara
svm_satara <- ggplot(data = svm_acc_satara, aes(x = threshold, y = acc_value, group = Metric))+
  geom_line(aes(color = Metric), size = 1.2)+
  scale_color_brewer(palette = 'Set1')+
  scale_x_continuous(limits = c(0.00,1.00), breaks = c(0.00,0.10, 0.20, 0.30, 0.40, 0.50, 0.60, 0.70, 0.80, 0.90, 1.00))+
  geom_vline(xintercept = 0.25, color = 'darkred', size = 1, linetype = 'dashed')+
  labs(x = 'Probability threshold', y = 'Accuracy level', title = 'SVM-Satara')+
  theme(panel.grid = element_blank(), plot.title = element_text(hjust = 0.5, size = 10), 
        axis.title = element_blank())

figure<-ggarrange(cart_sabie, cart_satara, mlp_sabie, mlp_satara, rf_sabie, rf_satara, svm_sabie, svm_satara, ncol=2, nrow=4, common.legend = TRUE, legend="right")
figure

annotate_figure(figure, left = text_grob('Accuracy level', rot = 90), bottom = text_grob('Probability threshold'))
