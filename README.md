# A Cost-Sensitive Approach applied on Shallow and Deep Neural Networks for Classification of Imbalanced Data
A cost-sensitive learning approach for handling classification with imbalanced data

Welcome. This repository contains the data and scripts comprising the article 'A Cost-Sensitive Approach applied on Shallow and Deep Neural Networks for Classification of Imbalanced Data'

Included are the tools to allow you to easily run the code.

This readme is a brief overview and contains details for setting up and running the project. Please refer to the following:

<h1>Running the project</h1><br/>
<h2>Initial requirements</h2>

1. To the code, the environment needed is Matlab. So you need to install: 
- Matlab if run on CPU mode,
- Matlab 2016b or higher, Cuda toolkit and cuDNN linrary if run on GPU mode.
2. To run this project, the MatConvNet Toolbox 1.0-beta25 needs to be installed and compiled. You can dowload the Toolbox by clicking on this link: http://www.vlfeat.org/matconvnet/download/matconvnet-1.0-beta25.tar.gz
For further information about how to compile the toolbox, please refer to the following url: http://www.vlfeat.org/matconvnet/install/

<h2>Usage</h2>
There are several use cases for this project:

1. You can train and test the cost-sensitive approach on shallow neural networks such as Multi-Layer Perceptrons (MLPs), by using one of the 1D datasets: (ionosphere)/("pid" - Pima Indians Diabetes)/(WP_Breast_Cancer)/(SPECTF_Heart)/(yeast_8l)/(car)/(satimage)/(thyroid).

2. Or you can choose to train and test the approach on deep learning models such as Convolutional Neural Networks, by using one of the 2D datasets: (mnist10)/(mnist30)/(mnist40)/(mnist50)


You can choose to train and test the CNN (<b>see example 1 below </b>):
- among different prediction time interval (5-, 10-, 15-, and 20-min forecasting)
- with either the L2 Loss function (lambda=0) or the probabilistic loss function (lambda=1)
- on one of the following networks (freeways): H101_North_D7 / I5_North_D7 / I5_South_D7 / I5_North_D11 / I450_North_D7 / I210_West_D7 

2. You can choose to test the CNN using a an available CNN which was already trained using traffic data of 'H101_North_D7' freeway (<b>see example 3 below</b>)
If you wich to test using a CNN trained on another network (freeway), you first train the CNN using the desired network (use case 1) then call it for testing (use case 2).

3. You can train and test Deep Belief Networks (DBNs) by going into 'traffic_flow_code_DBN/examples/' directory and running the file 'proj_traffic_flow_prediction_DBN.m'

4. You can choose to test the DBN using a an available DBN which was already trained using traffic data of 'H101_North_D7' freeway (<b>see example 2 below</b>).
If you wich to test using a DBN trained on another network (freeway), you first train the CNN using the desired network (use case 3) then call it for testing (use case 4).


<b>PS. If you want to compare CNN and DBN performances with existant methods, you can try :</b>
- the Support Vector Machin (SVM) by going into 'traffic_flow_code_SVM/' directory and running the file 'proj_traffic_flow_prediction_SVM.m'
- the ARIMA by y going into 'traffic_flow_code_ARIMA/' directory and running the file 'proj_traffic_flow_prediction_ARIMA.m'
- the HW-ExpS by y going into 'traffic_flow_code_HW-exp/' directory and running the file 'main.m'

<h2>Examples for training and/or testing our models : </h2>
<h3>1. Exampe of training and testing the CNN model:</h3>
In this example, we want to predict the exact speed at 15-min forecasting (i.e., using regression) by training the CNN based on the probabilistic loss function. 

The default data is the 'US101-North District 7' freeway (i.e., H101-North-D7) from september 1 to september 30 (2017) from 6AM to 8:55PM. 3/4th of the data is used for training and 1/4th is for testing.

The measure of performance is RMSE which gives the error in miles/hour.

To do so, follow these steps:
1. run proj_traffic_flow_prediction_10wStr.m
2. select the following:
- Please forecasting for which you wish to predict speed (1)for 5-min, (2)for 10-min, (3)...): 1
- Please select the prediction type: (c)classification / (r)regression  r
- Please enter the k-fold (k-1 for training & 1 for testing)_(0 for testing):  4

- Please select the number of days (15, 21, 27, 30 or 59):  30
- Please enter the loss (0)L2 loss, (1)P loss:  1
- Please select the freeway: H101_North_D7 / H101_South_D7 / I5_North_D7 / I5_South_D7 / I5_North_D11 / I450_North_D7 / I210_West_D7 H101_North_D7

The code will:
- display a plot of the train RMSEs and test RMSEs per epoch.
- output the lowest test RMSE.
- display the weights of the 1st convolutional layer filters.

<h3>2. Example of testing the DBN model:</h3>
In this example, we want to predict the exact speed for network points of 'I5_North_D7' freeway at 15-min forecasting by testing/applying a DBN which was previously trained based on the probabilistic loss function using data of 'US101-North District 7' freeway (i.e., H101-North-D7) .

To do so, follow these steps:
1. Go to 'traffic_flow_code_DBN' directory and run the file 'proj_traffic_flow_prediction_DBN.m'.
2. select the following:
- Please enter the k-fold (k-1 for training & 1 for testing)_(0 for testing):  0

- Please enter the loss (0)L2 loss, (1)P loss:  1

- Please select the number of days (15, 21, 27, 30 or 59):  30

- Enter prediction point:  3

- Please select the testing freeway: H101_North_D7 / I5_North_D7 / I5_South_D7 / I5_North_D11 / I450_North_D7 / I210_West_D7: I5_North_D7

- Please select the input freeway used for training: H101_North_D7 / I5_North_D7 / I5_South_D7 / I5_North_D11 / I450_North_D7 / I210_West_D7: H101_North_D7

<b>The displayed result is :</b>
Classification error (testing):     5.53

<h3>3. Example of testing the CNN model:</h3>
In this example, we want to predict the exact speed for network points of 'I5_North_D11' freeway at 15-min forecasting by testing/applying a CNN which was previously trained based on the probabilistic loss function using data of 'US101-North District 7' freeway (i.e., H101-North-D7) .

To do so, follow these steps:

1. Go to 'traffic_flow_code_CNN' directory and run the file 'proj_traffic_flow_prediction_10wStr.m'.
2. select the following:
- Please forecasting for which you wish to predict speed (1)for 5-min, (2)for 10-min, (3)...): 3

- Please select the prediction type: (c)classification / (r)regression  r

- Please enter the loss (0)L2 loss, (1)P loss:  1

- Please select the freeway used for training: H101_North_D7 / I5_North_D7 / I5_South_D7 / I5_North_D11 / I450_North_D7 / I210_West_D7: H101_North_D7

- Please enter the k-fold (k-1 for training & 1 for testing)_(0 for testing):  0

- Please select the testing freeway: H101_North_D7 / I5_North_D7 / I5_South_D7 / I5_North_D11 / I450_North_D7 / I210_West_D7: I5_North_D11

- Please select the number of days (15, 21, 27, 30 or 59):  30

<b>The displayed result is :</b>
Lowest validation error is 3.821451 in epoch 1
