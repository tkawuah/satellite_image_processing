import eli5
from eli5.sklearn import PermutationImportance
import numpy as np
import matplotlib.pylot as plt
import pandas as pd 

#fetch best performing model 
best_model = RF_gscv.best_estimator_
best_model2 = MLP_gscv.best_estimator_

#fit permutation importance on test data
perm = PermutationImportance(best_model).fit(test_img, test_lab)
perm2 = PermutationImportance(best_model2).fit(test_img, test_lab)

#show weights 
wghts = eli5.format_as_dataframe(eli5.explain_weights(perm))
wghts2 = eli5.format_as_dataframe(eli5.explain_weights(perm2))

#write dataframes to csv 
wghts.to_csv('D:/studies/phd/WV3_Data_July2019/010039360030_01/L_Sabie_subset/rf_permImportance.csv', encoding='utf-8', index=False)
wghts2.to_csv('D:/studies/phd/WV3_Data_July2019/010039360030_01/L_Sabie_subset/mlp_permImportance.csv', encoding='utf-8', index=False)


gLawn = mlp_map_prob[:,3]
w = x_img_arr[:,-9]
plt.scatter(w,gLawn)
plt.xlabel('proximity_to_water')
plt.ylabel('gLawn_probability')
plt.show()