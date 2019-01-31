# A Cost-Sensitive Learning Approach applied on Shallow and Deep Neural Networks for Classification of Imbalanced Data
A cost-sensitive learning approach for handling classification with imbalanced data

Welcome. This repository contains the data and scripts comprising the article 'A Cost-Sensitive Learning Approach applied on Shallow and Deep Neural Networks for Classification of Imbalanced Data'

Included are the tools to allow you to easily run the code.

This readme is a brief overview and contains details for setting up and running the project. Please refer to the following:

<h1>Running the project</h1><br/>
<h2>Initial requirements</h2>

1. To the code, the environment needed is Matlab. So you need to install: 
    * Matlab if run on CPU mode,
    * Matlab 2016b or higher, Cuda toolkit and cuDNN linrary if run on GPU mode.
2. To run this project, the MatConvNet Toolbox 1.0-beta25 needs to be installed (and saved into the main directory) and compiled. You can dowload the Toolbox by clicking on this link: http://www.vlfeat.org/matconvnet/download/matconvnet-1.0-beta25.tar.gz
For further information about how to compile the toolbox, please refer to the following url: http://www.vlfeat.org/matconvnet/install/

<h2>Usage</h2>
1. You can train and test the neural network by running the file 'proj_regression.m' (<b>see examples below </b>):

- using either the standard (baseline) algorithm (e.g., the standard loss function) or the cost-sensitive learning algorithm (e.g., the cost-sensitive version of the loss function) applied on ones of the following loss functions:  <b>L<sub>2</sub></b>, L<sub>2</sub> &#959; &#963;, Mshinge, Mshinge<sub>2</sub>, Mshinge<sub>2</sub>, log &#959; &#963;

- using either shallow and deep neural networks: 
    *  shallow neural networks such as Multi-Layer Perceptrons (MLPs), by using one of the 1D datasets: (ionosphere) / ("pid" - Pima Indians Diabetes) / (WP_Breast_Cancer) / (SPECTF_Heart) / (yeast_8l) / (car) / (satimage) / (thyroid).
    *  deep learning models such as Convolutional Neural Networks, by using one of the 2D datasets: (mnist10) / (mnist30) / (mnist40) / (mnist50).

2. You can compare the standard or cost-sensitive learning algorithm to one of existent methods including: 
- <b>undersampling method</b>: training the neural network (MLP or CNN) with the undersampling strategy,
- <b>oversampling method</b>: training the neural network (MLP or CNN) with the oversampling strategy,
- <b>ST1 method (Alejo et al. 2007)</b>: from the paper ["Improving the performance of the RBF neural networks trained with imbalanced samples"](https://pdfs.semanticscholar.org/483f/afc0a2901fb184a4e18d0cb57a44e3dcf893.pdf) .


<h2>Examples for training and/or testing our models : </h2>
<h3>1. Example of training and testing our cost-sensitive learning algorithm using the Mshinge<sub>2</sub> loss function</h3>
In this example, we want to train our CNN using our cost-sensitive learning algorithm applied on the Mshinge(sub)2(/sub) loss function on the "Mnist30" dataset (whose numbers 1 and 3 have 20 instances while the rest of the numbers 0,2,4,5,6,7,8,9 have all 600 instances).

To do so, first, change the learning rate in the code to the following (opts.learningRate =0.0001). Then, follow these steps:
1. run proj_classification.m
2. select the following:
     * Please select the method for handling imbalanced data (o)data pre-processing: Oversampling, (u)data pre-processing: Undersampling, (n)nothing  n
     * Please enter the loss (0)log, (1)CS log, (2)msHinge, (3)CS msHinge, (4)L2, (5)CS-ST L2, (6)our CS L2,(7)CS_sum L2,(8)sq.hinge,(9)CS sq.hinge,(10)L2 estimate,(11)CS L2 estimate,(12)cub.hinge,(13)CS cub.hinge 9
     * Please set the weighting parameter - Example: (2)for MLPs and (50)for CNNs 50
     * Please select the dataset:(ionosphere)/("pid" - Pima Indians Diabetes) /(WP_Breast_Cancer)/(SPECTF_Heart)/(yeast_8l)/(car)/(satimage)/(thyroid)/(mnist10)/(mnist30)/(mnist40)/(mnist50) mnist30

The code :
- outputs the lowest Geometric Mean (G-Mean) for the testing set.
- displays a plot of the objective function and G-Mean per epoch for both training and testing sets.
- displays the weights of the 1st convolutional layer filters.

<h3>2. Example of training and testing the over-sampling technique using the L(sub)2(/sub) loss function</h3>
In this example, we want to train an MLP using the over-sampling technique applied on the L(sub)2(/sub) loss function on the "SPECTF_Heart" dataset.

To do so, first, change the learning rate in the code to the following (opts.learningRate =0.01). Then, follow these steps:
1. run proj_classification.m
2. select the following:
     * Please select the method for handling imbalanced data (o)data pre-processing: Oversampling, (u)data pre-processing: Undersampling, (n)nothing  no
     * Please enter the loss (0)log, (1)CS log, (2)msHinge, (3)CS msHinge, (4)L2, (5)CS-ST L2, (6)our CS L2,(7)CS_sum L2,(8)sq.hinge,(9)CS sq.hinge,(10)L2 estimate,(11)CS L2 estimate,(12)cub.hinge,(13)CS cub.hinge 5
     * Please set the weighting parameter - Example: (2)for MLPs and (50)for CNNs 2
     * Please select the dataset:(ionosphere)/("pid" - Pima Indians Diabetes) /(WP_Breast_Cancer)/(SPECTF_Heart)/(yeast_8l)/(car)/(satimage)/(thyroid)/(mnist10)/(mnist30)/(mnist40)/(mnist50) SPECTF_Heart
     
     
