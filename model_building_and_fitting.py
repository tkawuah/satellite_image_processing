from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import VotingClassifier
from sklearn.neural_network import MLPClassifier
from sklearn import tree
from sklearn import svm
from sklearn.metrics import classification_report, confusion_matrix
import numpy as np
import matplotlib.pyplot as plt


#create models 
RF = RandomForestClassifier()

SVM = svm.SVC(gamma = 'scale')

CART = tree.DecisionTreeClassifier()

MLP = MLPClassifier()

ECLF = VotingClassifier(estimators = [('rf', RF), ('svm', SVM), ('cart', CART), ('mlp', MLP)], voting = 'hard') #ensemble classifier


#fit model 
RF.fit(train_img, train_lab)
print('model fit done...', RF.score(train_img, train_lab))

SVM.fit(train_img, train_lab)

CART.fit(train_img, train_lab)

MLP.fit(train_img, train_lab)

ECLF.fit(train_img, train_lab)


#feat_labels = ['B02M','B03M','B04M','B08M','B02J','B03J','B04J','B08J',
#            'B02N','B03N','B04N','B08N','B02JA','B03JA','B04JA','B08JA',
#            'B05M','B06M','B07M','B11M','B12M','B8AM','B05J','B06J','B07J',
#            'B11J','B12J','B8AJ','B05N','B06N','B07N','B11N','B12N',
#            'B8AN','B05JA','B06JA','B07JA','B11JA','B12JA','B8AJA']
#
#for f in zip(feat_labels, RF.feature_importances_):
#    print(f)
#    
#    
#plt.bar(range(x_img_arr.shape[1]), RF.feature_importances_)
#plt.xticks(range(x_img_arr.shape[1]), feat_labels, rotation = 90)
#plt.show()


#model prediction
rf_pred = RF.predict(test_img)
#rf_map = rf_map.reshape(133,102)

svm_pred = SVM.predict(test_img)

cart_pred = CART.predict(test_img)

mlp_pred = MLP.predict(test_img)

eclf_pred = ECLF.predict(test_img)


#print prediction accuracy measures 
print(classification_report(test_lab, rf_pred))
print(confusion_matrix(test_lab, rf_pred))