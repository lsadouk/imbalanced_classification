function imdb = setup_data(kfold, dataset)

%% output:
% a saved file'.mat' w/ variables: (a) imdb struct w. matrix image and
% normalized labels (in range [0,1])        
% (b) s_factor: the scaling factor max_data - min_data (to recover unnormalized original data)


%% 1. Load scenes/frames/images
ScenesPath = 'data/'; %'data/preprocessed_data/';
if(contains(dataset,'mnist'))
    filename = fullfile('data', 'mnist.mat'); 
    nb_instances_per_class = 600;
    if exist(filename, 'file')
        load(filename); % load variables 'label_balanced', 'image_balanced'
    else
        [trainX, trainY, ~, ~] = getMNIST(); % [trainX, trainY, testX, testY]
        label_balanced= trainY(1:nb_instances_per_class*10)'; % use only 6000 instances from testing dataset
        label_balanced= label_balanced+1; % from label=0->9 to label=1->10
        image_balanced(:,:,1,1:nb_instances_per_class*10) = trainX(:,:,1:nb_instances_per_class*10);
        save(filename, 'label_balanced', 'image_balanced');
    end
    %% impose imbalance ratio of 5-10-50 on 2 minority classes 1 and 3
    % results in minority classes (positives) having 120-60-12 instances instead of 600
    imbalance_ratio = setdiff(dataset,'mnist', 'stable');
    if isempty(imbalance_ratio), imbalance_ratio = 1;
    else,   imbalance_ratio = str2num(imbalance_ratio); end 
    %nb_imbalanced= nb_instances_per_class/imbalance_ratio;
    p_index_one = find(label_balanced==1); p_index_one_new = p_index_one(1:length(p_index_one)/imbalance_ratio);%length(p_index_one/imbalance_ratio)
    p_index_three = find(label_balanced==3); p_index_three_new = p_index_three(1:length(p_index_three)/imbalance_ratio);
    label = label_balanced(label_balanced~=1 & label_balanced~=3);
    label = [label, label_balanced(p_index_one_new), label_balanced(p_index_three_new)]; % new label w/ imbalanced data
    image = image_balanced(:,:,:,label_balanced~=1 & label_balanced~=3);
    image(:,:,:, end+1:end + length(p_index_one_new)+length(p_index_three_new)) = image_balanced(:,:,:,[p_index_one_new p_index_three_new]);
elseif(contains(dataset,'cifar')) %cifar
    filename = fullfile('data', 'cifar_raw.mat'); 
    %nb_instances_per_class = 1000;
    if exist(filename, 'file')
        load(filename); % load variables 'label_balanced', 'image_balanced'
    else
        [X, Y] = getCifar(); % [trainX, trainY, testX, testY]
        label_balanced=Y' + 1;  % from label=0->9 to label=1->10
        image_balanced = X; %image_balanced(:,:,1,1:nb_instances_per_class*10) = X;
        save(filename, 'label_balanced', 'image_balanced');
    end
    %% impose imbalance ratio of 5-10-50 on 2 minority classes 1 and 3
    % results in minority classes (positives) having 120-60-12 instances instead of 600
    imbalance_ratio = setdiff(dataset,'cifar', 'stable');
    if isempty(imbalance_ratio), imbalance_ratio = 1;
    else,   imbalance_ratio = str2num(imbalance_ratio); end 
    %nb_imbalanced= nb_instances_per_class/imbalance_ratio;
    p_index_one = find(label_balanced==1); p_index_one_new = p_index_one(1:length(p_index_one)/imbalance_ratio);%length(p_index_one/imbalance_ratio)
    p_index_three = find(label_balanced==3); p_index_three_new = p_index_three(1:length(p_index_three)/imbalance_ratio);
    label = label_balanced(label_balanced~=1 & label_balanced~=3);
    label = [label, label_balanced(p_index_one_new), label_balanced(p_index_three_new)]; % new label w/ imbalanced data
    image = image_balanced(:,:,:,label_balanced~=1 & label_balanced~=3);
    image(:,:,:, end+1:end + length(p_index_one_new)+length(p_index_three_new)) = image_balanced(:,:,:,[p_index_one_new p_index_three_new]);
else % all other datasets
    % read csv file which contains letters (e.g. nominal values)
    dataset_file = fullfile( ScenesPath, strcat(dataset,'.csv'));
    data = csvread_with_letters(dataset_file,1,0);
    image = data(:,2:end); % Nx6
    label = data(:,1)'; % 1xN
    %% reshape data from Nx6 (N=#samples, 6=#columns/features) to 6x1x1xN
    nb_samples = size(image,1);
    nb_features = size(image,2);
    image = reshape(image', nb_features,1,1,nb_samples);
end



%% 2. shuffle the dataset
randNdx=randperm(length(label));
image=image(:,:,:,randNdx); % 10*20*3*177120
label=label(1, randNdx); % 1*177120

%% 3. split data into training & testing set
if(kfold == 0) % NO TRAINING PHASE all images are for testing
    trainData=[];
    trainLabel=[];
    testData=image;
    testLabel=label;
else % if(kfold ~= 0)
    %kfold = 4; % 3fold for training (first 21days) & 1fold for testing (last 7 days)
    sizekmul =size(image,4)-mod(size(image,4),kfold);  % for 10-fold cross validation %177120
    trainData=image(:,:,:,1:sizekmul/kfold*(kfold-1)); %3/4 samples are for training
    trainLabel=label(:,1:sizekmul/kfold*(kfold-1)); %3/4 samples are for training (10*20*3*132840)
    testData=image(:,:,:,sizekmul/kfold*(kfold-1)+1:sizekmul);%1/4 samples are for training %44280
    testLabel=label(:,sizekmul/kfold*(kfold-1)+1:sizekmul);%1/4 samples are for training
     
%% 4. balance the training dataset for classification only (not for regression)-----------------------
%         % balancing number of samples in each class to give to the classifier
%         % 1. find maximum number of samples in  classes
%         %             Nb_Sample_perClass=max([length(rockClassNdx),length(rockflapClassNdx),length(flapClassNdx)]);
%         % or: according to fahd's code total number of samples/
%     if(isequal(opts.prediction_type,'c'))
%         nb_classes = length(unique(trainLabel));
%         Nb_Sample_perClass=floor(length(trainLabel)/nb_classes); %18977samples/clas
%         % 2. randomly resampling two other class with less number of data
%         % points to Nb_Sample_perClass
%         balanced_data = zeros(size(trainData,1), size(trainData,2), size(trainData,3), Nb_Sample_perClass*nb_classes); %10*20*3*132839
%         for i=1:nb_classes
%             class_iNdx=(find(trainLabel==i));  %class1
%             balanced_data(:,:,:,(i-1)*Nb_Sample_perClass+1 : i*Nb_Sample_perClass) = balance_trainingData(trainData, class_iNdx, Nb_Sample_perClass); %2649 %26500
%             trainLabel(1,(i-1)*Nb_Sample_perClass+1 : i*Nb_Sample_perClass) = i;
%         end 
%         trainLabel = trainLabel(1,1:Nb_Sample_perClass*nb_classes); % from 1*132840 to 1*132839
%         randNdx=randperm(length(trainLabel));
%         trainData=balanced_data(:,:,:, randNdx);
%         trainLabel=trainLabel(1,randNdx);
%     end
% end
% test_data: class1=40, c2=710, c3=2534, c4=2671, c5=3115, c6=7427, c7=27783

%% 4. put all data into final dataset 'imdb'
nb_train = length(trainLabel); %or size(trainLabel,2)  132839
nb_test = length(testLabel); %44280
nb_total = nb_train + nb_test; %177119
image_size = [size(testData,1) size(testData,2) size(testData,3)]; 
imdb.images.data   = zeros(image_size(1), image_size(2),image_size(3), nb_total, 'single');
imdb.images.labels = zeros(1, nb_total, 'single'); % 1*n
imdb.images.set    = zeros(1, nb_total, 'uint8');

if(kfold ~= 0) % NO TRAINING PHASE all images are for testing
    imdb.images.data(:,:,:,1:nb_train) = trainData;
    imdb.images.labels(1, 1:nb_train) = single(trainLabel);
    imdb.images.set(1, 1:nb_train) = 1;
end

imdb.images.data(:,:,:,nb_train+1:nb_train+nb_test) = testData;
imdb.images.labels(1, nb_train+1:nb_train+nb_test) = single(testLabel);
imdb.images.set(:, nb_train+1:nb_train+nb_test) = 2;

%% 5. normalize the data inputs X
imdb.images.data = dimensionNormalize(imdb.images.data); % normalize each attribute separately

%% 6. normalize the labels Y (max label = 24)
%label = label ./max(label); % range of label from 0 to 1
%s_factor = max(imdb.images.labels)-min(imdb.images.labels);
%imdb.images.labels = (imdb.images.labels-min(imdb.images.labels)) ./ s_factor ; % range from 0 to 1

imdb_filename = fullfile('data_preprocessed', strcat('imdb_',dataset,'_c.mat'));
save(imdb_filename ,'imdb');

end
