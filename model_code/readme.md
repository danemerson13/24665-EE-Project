### 24-612 P4: EE Project Python Code READ-ME
Author: Dan Emerson

This zip contains three python notebooks, variousmodels_final.ipynb, xgboost_final.ipynb, and xgboost_final_empatica.ipynb.

The zip file also contains three .csv files which include all of the preprocessed data, from the JSI dataset as well as our own Empatica data. There are three files, pwrtbl_all.csv, which includes the feature expanded frequency domain JSI data, tbl_all.csv which includes the plain JSI data, and groupdata.csv which includes the Empatica data collected by our own group.

*In the GITHUB version of this code, these files can be created from the original Chiron data using the preprocessing MATLAB scripts.*

The first notebook, *variousmodels_final.ipynb* is used as a preliminary script to aide in selecting a specific model to progress with. The models were weakly tuned to get a general idea of which method might be the best idea going forward. The decision tree and xgboost models performed well, along with the neural network model. In the end, we decided to proceed with XGBoost as our ML model.

In the second notebook, *xgboost_final.ipynb*, the full dataset is loaded and partitioned, and then the XGBoost model is trained. There is a n additional excel sheet, ‘Model Training Tracker.xlsx’ which details the greedy optimization of hyper parameters for the XGBoost model. There are several plots generated to better understand the prediction by the model compared to the ground truth COSMED data.

In the third notebook, *xgboost_final_empatica*, a feature reduced dataset is used to train the model, such that its features are analogous to those we obtained from our Empatica wristband. Unfortunately, we found that the sampling rate of the Empatica wristband was too low to extract the same high frequency domain accelerometer features that we used in our final model training and tested on the JSI dataset. As such, this model performs worse on the JSI dataset test subjects, however, we are still clearly able to distinguish between the four activities included in our Empatica dataset, indicting that our model is successful at distinguishing activities.
