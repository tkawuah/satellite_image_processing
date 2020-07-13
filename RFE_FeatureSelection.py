import numpy as np
import matplotlib.pyplot as plt
from sklearn.feature_selection import RFECV
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import StratifiedKFold

# define model instance 
rfc = RandomForestClassifier(
    bootstrap = True, 
    max_depth = 70,
    min_samples_leaf = 2,
    min_samples_split = 2,
    n_estimators = 600,
    oob_score = True,
    random_state = 1)

# define RFE-CV model
rfecv = RFECV(
    estimator = rfc, 
    step = 1, 
    cv = StratifiedKFold(10), 
    scoring = 'accuracy')

#fit RFE-CV
rfecv.fit(train_img, train_lab)

#print optimal number of features 
print('Optimal number of features: {}'.format(rfecv.n_features_))

#print feature importance scores
rfecv.estimator_.feature_importances_

#print feature rankings
rfecv.ranking_

#relationship between number of features and accuracy 
plt.figure(figsize=(16, 9))
plt.title('Recursive Feature Elimination with Cross-Validation', fontsize=18, fontweight='bold', pad=20)
plt.xlabel('Number of features selected', fontsize=14, labelpad=20)
plt.ylabel('% Correct Classification', fontsize=14, labelpad=20)
plt.plot(range(1, len(rfecv.grid_scores_) + 1), rfecv.grid_scores_, color='#303F9F', linewidth=3)

plt.show()