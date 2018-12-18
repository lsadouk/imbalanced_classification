function imdb = balance_data(method,  imdb, dataset)
% This function is called by undersampling (u) or oversampling (o) methods
% are called by the user
% Goal: balance the training dataset for regression i.e., undersample or
%  oversample if selected by user, then return the balanced data
% inputs of this function are:
    % method is the method selected (undersampling, oversampling)
    % opts.pd_model_pmeasure if selected method is under, or over-sampling
    % opts.pd_model_max_pmeasure if selected method is under, or over-sampling
    % opts.kfold for k-fold cross validation
    % dataset is the name of the dataset selected by the user
% outputs is imdb, a struct containing input X and output Y
%% 4. 

    
index = find(imdb.images.set ==  1); % take only testing data
labels = imdb.images.labels(1,index); %label = label(:);
data = imdb.images.data(:,:,:, index); %label = label(:);
nb_classes = max(imdb.images.labels);
[freq,~] = hist(labels,unique(labels)); % compute frequency of occurence for each event/label/class    

if isequal(method, 'u') % do undersampling    
    [min_freq, min_class] = min(freq); %compute max frequency for event that occurs the most often
    nb_samples = min_freq * nb_classes;
else                    % 'o', do oversampling
    [max_freq, max_class] = max(freq); %compute max frequency for event that occurs the most often
    nb_samples = max_freq * nb_classes;
end

balanced_data = zeros(size(data,1),size(data,2), size(data,3), nb_samples);
balanced_labels = zeros(size(labels,1), nb_samples);
count = 1;
if isequal(method, 'o') % do oversampling      % oversample rare instances
    for i=1:nb_classes
        ind = find(labels ==i);
        if i ~= max_class % of selected label i is not the label with max occurence % we should not resample instances whose label has max freq occurence
            sampled_ind = datasample(ind, max_freq);    
        else
            sampled_ind = ind;
        end
        balanced_labels(1,count:count+max_freq-1) = labels(:, sampled_ind); % =i;
        balanced_data(:,:,:,count:count+max_freq-1) = data(:,:,:,sampled_ind); 
        count = (count+max_freq-1)+1;
    end    
else % undersampling 'u'
    for i=1:nb_classes
        ind = find(labels ==i);
        if i ~= min_class % of selected label i is not the label with max occurence % we should not resample instances whose label has max freq occurence
            sampled_ind = randsample(ind, min_freq);    
        else
            sampled_ind = ind;
        end
        balanced_labels(1,count:count+min_freq-1) = labels(:, sampled_ind);
        balanced_data(:,:,:,count:count+min_freq-1) = data(:,:,:,sampled_ind); 
        count = (count+min_freq-1)+1;
    end    
end

    
% shuffle training dataset
randNdx=randperm(nb_samples);
balanced_data = balanced_data(:,:,:,randNdx); % 10*20*3*177120
balanced_labels = balanced_labels(:, randNdx); % 1*177120


% assign testing data and labels into imdb
test_indices = find(imdb.images.set == 2);
imdb.images.set = imdb.images.set(test_indices);
imdb.images.data = imdb.images.data(:,:,:, test_indices);
imdb.images.labels = imdb.images.labels(:, test_indices);

% assign balanced training data and label to imdb
imdb.images.set(end+1:end+nb_samples) = 1;
imdb.images.data(:,:,:,end+1:end+nb_samples) = balanced_data;
imdb.images.labels(:,end+1:end+nb_samples) = balanced_labels;

imdb_filename = fullfile('data_preprocessed', strcat('imdb_',dataset,'_r','_balanced_', method, '.mat'));
save(imdb_filename ,'imdb');
end