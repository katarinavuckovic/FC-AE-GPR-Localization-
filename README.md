# CSI-Based Data-driven Localization Framework using Small-scale Training Datasets in Single-site MIMO Systems
Implementation of the [paper](https://arxiv.org/abs/2304.11455)
# 1. Dataset 
Dataset Generation using [DeepMIMO](https://www.deepmimo.net/) 
- Details on scenarios and channel parameters required to generate the dataset may be found in the paper.
- Example code for dataset generation is in "Dataset/DatasetGeneration_ADP_loc.m"
- Note: the sample code is not enought to generate the dataset.  You will need to download code and data from the DeepMIMO website to generate the dataset. Go to the DeepMIMO dataset via the above link and follow the instructions to generate the datasets. 
# 2. Augmented Dataset
- File location Dataset/Data augmentation.m
- The augmented dataset uses augmentation techniques on the ADPs to create a large ADP dataset used for training the FC-AE.
- The augmented dataset for training the FC-AE is unlabbeled (does not have locations labels).
- The file "Data augmentation.m" splits the dataset generated in 1 into 0.5% train and the rest is for testing. the 0.5% is augmented using rotation, flippting abd shifting to generate the AugADP dataset that will be used in the next step for training the FC-AE, and the remaining 99.5% of the dataswset becomes the ADP_test dataset. The ADP_test dataset is used to test the FC-AE. The encoded version of ADP_test dataset is also alter used in 4 for the GPR model.
# 3. FC-AE (Fully Connected Auto Encoder)
- File location: FC-AE-GPR/FC_AE_Models.ipynb
- The FC_AE_Models.ipynb notebook has the encoder models (train and test). 
- The purpose of the FC-AE is to encode the larger ADPs. The FC-AE encodes 64x64, 32x32, 16x16 and 8x8 ADPs to 4x4 encoded ADP. 
- By reducing the size of ADP to 4x4 prior to training the GPR model, we reduce the GPR training complexity. 
- The FC-AE folder contains the jupter notebook with the FC-AE models.
- To train the FC-AE, use the augmented dataset from step 2.
# 3. GPR
- File location for the GPR model training: FC-AE-GPR/GPR_train_kfold.m
- File location for the GPR model testing: FC-AE-GPR/GPR_test_kfold.m
- First the GPR model is trained for different training dataset sizes over 50-folds.
- This code in "GPR_train_kfold.m" is for the encoded 16x16 ADP data. However, the same code is used for other ADP dataset.
- After training is complete, the models are evaluted in "GPR_test_kfold.m." The code predicts the location and then calculates the error. 
- The code in "GPR_train_kfold.m" and "GPR_test_kfold.m"  is for the encoded 16x16 ADP data. However, the same code is used for other ADP dataset.

# 4. CNN Model (Benchmark)
- The paper compares the FC-AE-GPR to a CNN Fingerpriting model.
- File Location: CNN/CNN_ADP_Localization.ipynb
- The notebook has models for  64x64, 32x32, 16x16, 8x8 ADPs and 4x4 ADP inputs. 
- The code iterates over 50-fold and calculates the RMSE for each fold. Then calculates the mean RMSE.
# 5. Normalized Correlation-based Grid Search (Benchmark)
- The paper compares the FC-AE-GPR to a to a non-parameteric grid search model.
- File location: Grid Search/correlation_based_localization.m
- The code iterates over 50-fold and calculates the RMSE for each fold. Then calculates the mean RMSE.
