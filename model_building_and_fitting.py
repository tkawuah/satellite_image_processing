from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import VotingClassifier
from sklearn.neural_network import MLPClassifier
from sklearn import tree
from sklearn import svm
from sklearn.model_selection import cross_val_score, cross_validate
from sklearn.model_selection import StratifiedKFold
from sklearn.model_selection import RandomizedSearchCV
from sklearn.metrics import classification_report, confusion_matrix, accuracy_score,f1_score
import numpy as np
import matplotlib.pyplot as plt
#%%

#initialize models
RF = RandomForestClassifier()

SVM = svm.SVC(gamma = 'scale')

CART = tree.DecisionTreeClassifier()

MLP = MLPClassifier()

ECLF = VotingClassifier(estimators = [('rf', RF), ('svm', SVM), ('cart', CART), ('mlp', MLP)], voting = 'hard') #ensemble classifier
#%%
#define hyperparameter grids
RF_param_grid = {'n_estimators': [int(x) for x in np.linspace(start = 200, stop = 2000, num = 10)],
               'max_features': ['auto', 'sqrt'],
               'max_depth': [int(x) for x in np.linspace(10, 110, num = 11)],
               'min_samples_split': [2, 5, 10],
               'min_samples_leaf': [1, 2, 4],
               'bootstrap': [True, False]}

SVM_param_grid = {'C':[1,10,100,1000],
                 'gamma':[1,0.1,0.001,0.0001],
                 'kernel':['linear','rbf']
                 }

CART_param_grid = {'criterion': ['gini','entropy'],
                  'max_depth': [int(x) for x in np.linspace(10, 110, num = 11)],
                  'min_samples_split': [2, 5, 10, 20],
                  'min_samples_leaf': [1, 5, 10],
                  'max_leaf_nodes': [None, 5, 10, 20]
                  }

MLP_param_grid = {'hidden_layer_sizes': [(128,256,64),(150,100,50),(100,)],
                'activation': ['identity','logistic','tanh','relu'],
                'solver': ['lbfgs', 'sgd', 'adam'],
                'learning_rate': ['constant','invscaling','adaptive'],
                'max_iter': [10,100,500,1000],
                'alpha': 10.0 ** -np.arange(1, 10),
                'random_state':[0,1,2,3,4,5,6,7,8,9]
                }

#%%
##nested cross validation for hyper-parameter tunning and model skill estimation and comparison
inner_cv = StratifiedKFold(n_splits = 2, shuffle = True, random_state = 1)
outer_cv = StratifiedKFold(n_splits = 5, shuffle = True, random_state = 1)
#%%
#...initiate param search
RF_gscv = RandomizedSearchCV(estimator= RF, param_distributions= RF_param_grid, n_iter= 10, cv= inner_cv, refit= True, verbose= 2, random_state= 42)


SVM_gscv = RandomizedSearchCV(estimator= SVM, param_distributions= SVM_param_grid, n_iter= 10, cv= inner_cv, refit= True, verbose= 2, random_state= 42)


CART_gscv = RandomizedSearchCV(estimator= CART, param_distributions= CART_param_grid, n_iter= 10, cv= inner_cv, refit= True, verbose= 2, random_state= 42)


MLP_gscv = RandomizedSearchCV(estimator= MLP, param_distributions= MLP_param_grid, n_iter= 10, cv= inner_cv, refit= True, verbose= 2, random_state= 42)


#ECLF_gscv_best = VotingClassifier(estimators = [('rf_best', RF_gscv.best_estimator_), ('svm_best', SVM_gscv.best_estimator_),
#('cart_best', CART_gscv.best_estimator_), ('mlp_best', MLP_gscv.best_estimator_)], voting = 'hard') #best ensemble classifiers
#%%

#...nested cv for model skill estimation & comparison
scoring = {'ac':'accuracy', 'f1':'f1_macro'}

RF_scores = cross_validate(RF_gscv, all_data_img, all_data_lab, cv = outer_cv, scoring = scoring, return_train_score = True, return_estimator = True)
print("Accuracy: %0.2f (+/- %0.4f)" % (RF_scores['test_ac'].mean(), RF_scores['test_ac'].std() * 2)) # mean score and 95% CI
print("F1_macro: %0.2f (+/- %0.4f)" % (RF_scores['test_f1'].mean(), RF_scores['test_f1'].std() * 2))

SVM_scores = cross_validate(SVM_gscv, all_data_img, all_data_lab, cv = outer_cv, scoring = scoring, return_train_score=True, return_estimator = True)
print("Accuracy: %0.2f (+/- %0.4f)" % (SVM_scores['test_ac'].mean(), SVM_scores['test_ac'].std() * 2)) # mean score and 95% CI
print("F1_macro: %0.2f (+/- %0.4f)" % (SVM_scores['test_f1'].mean(), SVM_scores['test_f1'].std() * 2))

CART_scores = cross_validate(CART_gscv, all_data_img, all_data_lab, cv = outer_cv, scoring=scoring, return_train_score=True, return_estimator = True)
print("Accuracy: %0.2f (+/- %0.4f)" % (CART_scores['test_ac'].mean(), CART_scores['test_ac'].std() * 2)) # mean score and 95% CI
print("F1_macro: %0.2f (+/- %0.4f)" % (CART_scores['test_f1'].mean(), CART_scores['test_f1'].std() * 2))

MLP_scores = cross_validate(MLP_gscv, all_data_img, all_data_lab, cv = outer_cv, scoring=scoring, return_train_score=True, return_estimator = True)
print("Accuracy: %0.2f (+/- %0.4f)" % (MLP_scores['test_ac'].mean(), MLP_scores['test_ac'].std() * 2)) # mean score and 95% CI
print("F1_macro: %0.2f (+/- %0.4f)" % (MLP_scores['test_f1'].mean(), MLP_scores['test_f1'].std() * 2))
#%%
#...fit RandomizedSearch CV instances

RF_gscv.fit(all_data_img, all_data_lab)
SVM_gscv.fit(all_data_img, all_data_lab)
CART_gscv.fit(all_data_img, all_data_lab)
MLP_gscv.fit(all_data_img, all_data_lab)

#%%

#ECLF_scores = cross_val_score(ECLF_gscv_best, train_img, train_lab, cv = outer_cv)
#print("Accuracy: %0.2f (+/- %0.4f)" % (ECLF_scores.mean(), ECLF_scores.std() * 2)) # mean score and 95% CI

#...classify (thematic prediction)
rf_pred = RF_gscv.predict(test_img)


svm_pred = SVM_gscv.predict(x_img_arr_scaled)


cart_pred = CART_gscv.predict(test_img)


mlp_pred = MLP_gscv.predict(test_img)
#%%

#...predict probabilities
rf_probs = RF_gscv.predict_proba(test_img)

svm_probs = SVM_gscv.predict_proba(test_img)


cart_probs = CART_gscv.predict_proba(test_img)


mlp_probs = MLP_gscv.predict_proba(test_img)
#%%

#%%
#########


## Assess variable importance
#feat_labels = ['C', 'B', 'G', 'Y', 'R', 'RE', 'NIR1', 'NIR2']
#
#for f in zip(feat_labels, RF.feature_importances_):
#    print(f)
#
#
#plt.bar(range(x_img_arr.shape[1]), RF.feature_importances_)
#plt.xticks(range(x_img_arr.shape[1]), feat_labels, rotation = 90)
#plt.show()


#Finalize model with whole reference data
#%% New code based on winning hyperparams

#...best models from RandomSearchCV and nested cross-validation
rf_estimator = RandomForestClassifier(bootstrap=False, class_weight=None, criterion='gini',
                                      max_depth=20, max_features='auto', max_leaf_nodes=None,
                                      min_impurity_decrease=0.0, min_impurity_split=None,
                                      min_samples_leaf=1, min_samples_split=2,
                                      min_weight_fraction_leaf=0.0, n_estimators=2000,
                                      n_jobs=None, oob_score=False, random_state=None,
                                      verbose=0, warm_start=False)

svm_estimator = svm.SVC(C=1000, cache_size=200, class_weight=None, coef0=0.0,
                    decision_function_shape='ovr', degree=3, gamma=0.001, kernel='rbf',
                    max_iter=-1, probability=True, random_state=None, shrinking=True,
                    tol=0.001, verbose=False)

cart_estimator = tree.DecisionTreeClassifier(class_weight=None, criterion='gini', max_depth=80,
                                        max_features=None, max_leaf_nodes=None,
                                        min_impurity_decrease=0.0, min_impurity_split=None,
                                        min_samples_leaf=5, min_samples_split=20,
                                        min_weight_fraction_leaf=0.0, presort=False,
                                        random_state=None, splitter='best')

mlp_estimator = MLPClassifier(activation='logistic', alpha=1e-07, batch_size='auto', beta_1=0.9,
                              beta_2=0.999, early_stopping=False, epsilon=1e-08,
                              hidden_layer_sizes=(150, 100, 50), learning_rate='adaptive',
                              learning_rate_init=0.001, max_iter=100, momentum=0.9,
                              n_iter_no_change=10, nesterovs_momentum=True, power_t=0.5,
                              random_state=6, shuffle=True, solver='adam', tol=0.0001,
                              validation_fraction=0.1, verbose=False, warm_start=False)

#%%
#...train best models with all reference data
rf_estimator.fit(all_data_img, all_data_lab)

#%%
mlp_estimator.fit(all_data_img, all_data_lab)

#%%
cart_estimator.fit(all_data_img, all_data_lab)

#%%

svm_estimator.fit(all_data_img, all_data_lab)

#%%
#...classify (thematic prediction)
rf_pred = rf_estimator.predict(satara_img_arr1_scaled) #modified to predict satara image

#%%
mlp_pred = mlp_estimator.predict(x_img_arr_scaled)

#%%
cart_pred = cart_estimator.predict(satara_img_arr1_scaled) #modified to predict satara image

#%%
svm_pred = svm_estimator.predict(satara_img_arr1_scaled) #modified to predict satara image

#%%
#...predict probabilities
rf_probs = rf_estimator.predict_proba(satara_img_arr1_scaled) #modified to predict satara image

#%%
mlp_probs = mlp_estimator.predict_proba(x_img_arr_scaled)

#%%
cart_probs = cart_estimator.predict_proba(satara_img_arr1_scaled) #modified to predict satara image

#%%
svm_probs = svm_estimator.predict_proba(satara_img_arr1_scaled) #modified to predict satara image