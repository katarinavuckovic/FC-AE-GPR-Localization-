# CSI-Based Data-driven Localization Framework using Small-scale Training Datasets in Single-site MIMO Systems
Implementation of the [paper](https://arxiv.org/abs/2304.11455)
# Dataset 
Dataset Generation using [DeepMIMO](https://www.deepmimo.net/) 
Details on ccenarios and channel parameters required to generate the dataset may be found in the paper. 
# FC-AE (Fully Connected Auto Encoder)
- The purpose of the FC-AE is to encode the larger ADPs. The FC-AE encodes 64x64, 32x32,16x16 and 8x8 ADPs to 4x4 encoded ADP. 
- By reducing the size of ADP to 4x4 prior to training the GPR model, we reduce the GPR training complexity. 
- The FC-AE folder contains the jupter notebook with the FC-AE models. 
