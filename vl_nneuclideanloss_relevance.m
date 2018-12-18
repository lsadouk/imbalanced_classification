function [ Y , benchmark_diff ] = euclideanloss_relevance(X, c, pd_model, pd_model_max, dzdy)
%EUCLIDEANLOSS Summary of this function goes here
%   Detailed explanation goes here

assert(numel(X) == numel(c));
%c= reshape(c,1,1,1,[]);
%assert(all(size(X) == size(c)));

  
if isempty(pd_model) % lambda = 0
    relevance = 0;
else % lambda =1 or 2
    relevance = 1- pdf(pd_model,c) ./ pd_model_max;
    %relevance(relevance < 0.5) = 0.5;
end
  
c= reshape(c,1,1,1,[]);
relevance= reshape(relevance,1,1,1,[]);
assert(all(size(X) == size(c)));

if nargin == 4 || (nargin == 5 && isempty(dzdy))
    % ORGINAL VERSION 
    %Y = 1 / 2 * sum((X - c).^ 2); % Y is divided by d(4) in cnn_train.m 
    
    %WEIGHTED version  Probability Density Function
    benchmark_diff = (X - c).^ 2 + abs(X - c) .* relevance ; % original
    %benchmark_diff = (X - c).^ 2 + abs(X - c)  .* 0.5 .* relevance ;
    %benchmark_diff = (X - c).^ 2 + abs(X - c)  .* (0.5 .* relevance +1) ;
    %benchmark_diff = (X - c).^ 2 + abs(X - c)  .* (1.* relevance +0.5) ;
    %benchmark_diff = (X - c).^ 2 + abs(X - c)  .* (1.* relevance +1) ;
    %benchmark_diff = (X - c).^ 2 + abs(X - c) .* 2 .* sqrt(relevance) ; %s
    %benchmark_diff = (X - c).^ 2  .* relevance ;
    %benchmark_diff = (X - c).^ 2 + abs(X - c) .* 1 ./(1 + exp(-10*relevance + 5)) ; %sigmoid 
    Y = 1 / 2 * sum( benchmark_diff ); % .* 2-pdf
    
elseif nargin == 5 && ~isempty(dzdy)
    
    assert(numel(dzdy) == 1);
    
    % ORIGINAL VERSION
    %Y = bsxfun(@times,dzdy ,(X - c));

    Xmc = X-c;
    Xmc(Xmc < 0) = -1;
    Xmc(Xmc >= 0) = 1;
    benchmark_diff = [];
    Y = bsxfun(@times,dzdy , (X - c) + 0.5 .* Xmc .* relevance  ); %original -- for normal, ++ for extremes
    %Y = bsxfun(@times,dzdy , (X - c) + 0.5 .* 0.5 .* Xmc .* relevance  ); 
     %Y = bsxfun(@times,dzdy , (X - c) + 0.5 .* Xmc .* (0.5 .* relevance +1)  );%%%%+ than L0 for normal, - for extremes%
     %Y = bsxfun(@times,dzdy , (X - c) + 0.5 .* Xmc .* (1 .* relevance +0.5)  ); %- for normal, + for extremes
     %Y = bsxfun(@times,dzdy , (X - c) + 0.5 .* Xmc .* (1 .* relevance +1)  ); %- for normal, same than L0 for extremes
     %Y = bsxfun(@times,dzdy , (X - c) + 0.5 .* Xmc .* 2 .* sqrt(relevance)  ); %-- for normal, ++ for extremes
     %Y = bsxfun(@times,dzdy , (X - c) + 0.5 .* Xmc .* 1 ./(1 + exp(-10*relevance + 5))  ); %-- for normal, ++ for extremes
    % Y = bsxfun(@times,dzdy , (X - c) .* relevance  ); %-- for normal, ++ for extremes
end

end
