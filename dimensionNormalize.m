function [XNorm, mu, stddev] = dimensionNormalize(X)
% This function provides feature normalization by taking in the input X and
% calculating the normalized inputs along with the mean and standard
% deviation for each feature/time . we want the mu and std by
% direction(x/y/z)
% X = (d x 1 x 9  x n) [d=dimension, 3 directions * 3 sensors, n samples) 
% mean = (1 x d) 
% stddev = (1 x d)

% Declare variables
XNorm = X; % d*1*9*n
data = zeros(size(X,1),1,1,size(X,4));


% Calculates mean and std dev for each feature
nb_channels = size(X,3); % 9
for i=1:nb_channels %x,y,z , x,y,z, x,y,z
    data = X(:,:,i,:);
    mu = mean(data(:)); 
    stddev = std(data(:)); 
    XNorm(:,:,i,:) = (X(:,:,i,:)-mu)/stddev;
end
