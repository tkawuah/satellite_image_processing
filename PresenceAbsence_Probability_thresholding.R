library('PresenceAbsence')

file_loc <- 'D:/studies/phd/MachineLearningTutorialPackage/results_maps_and_probs/satara/PresenceAbsence_prob_thresholding_satara.csv'

knp <- read.csv(file_loc)

threshold <- c(0, 0.05, 0.1, 0.15, 0.2, 0.25, 0.3, 0.35, 0.4, 0.45, 0.5, 0.55, 0.6, 0.65, 0.7, 0.75, 0.8, 0.85, 0.9, 0.95, 1)

par(mfrow=c(2,2))

p_rf <- error.threshold.plot(knp, threshold = threshold, which.model = 1, xlab = '', ylab = 'Accuracy Level', main = 'RF', color = TRUE,
                          opt.thresholds = TRUE, opt.methods = 3, 
                          add.legend = FALSE, opt.legend.cex = 1.0, 
                          opt.legend.text = c('Threshold'),pch = 8, vert.lines = TRUE)

p_mlp <- error.threshold.plot(knp, threshold = threshold, which.model = 2, xlab = '', ylab = '', main = 'MLP', color = TRUE,
                             opt.thresholds = TRUE, opt.methods = 3, 
                             add.legend = FALSE, opt.legend.cex = 1.0, 
                             opt.legend.text = c('Threshold'), pch = 8,vert.lines = TRUE)

p_cart <- error.threshold.plot(knp, threshold = threshold, which.model = 3,xlab = 'Probability Thresholds', ylab = 'Accuracy Level', main = 'CART', color = TRUE,
                             opt.thresholds = TRUE, opt.methods = 3, 
                             add.legend = FALSE, opt.legend.cex = 1.0, 
                             opt.legend.text = c('Threshold'), pch = 8,vert.lines = TRUE)

p_svm <- error.threshold.plot(knp, threshold = threshold, which.model = 4, xlab = 'Probability Thresholds', ylab = '', main = 'SVM', color = TRUE,
                             opt.thresholds = TRUE, opt.methods = 3, 
                             legend.cex = 1.0, opt.legend.cex = 1.0, 
                             opt.legend.text = c('Threshold'),pch = 8, vert.lines = TRUE)


