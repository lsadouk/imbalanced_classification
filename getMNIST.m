function [trainX, trainY, testX, testY] = getMNIST()
    path = fileparts(mfilename('fullpath'));
    
    % Download dataset
    if ~exist(fullfile(path,'data', 'train-images-idx3-ubyte.gz'), 'file') ...
        || ~exist(fullfile(path,'data', 'train-labels-idx1-ubyte.gz'), 'file') ...
        || ~exist(fullfile(path,'data', 't10k-images-idx3-ubyte.gz'), 'file') ...
        || ~exist(fullfile(path,'data', 't10k-labels-idx1-ubyte.gz'), 'file')
        fprintf('Downloading dataset...\n');
        websave(fullfile(path,'data', 'train-images-idx3-ubyte.gz'), ...
            'http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz');
        websave(fullfile(path,'data', 'train-labels-idx1-ubyte.gz'), ...
            'http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz');
        websave(fullfile(path,'data', 't10k-images-idx3-ubyte.gz'), ...
            'http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz');
        websave(fullfile(path,'data', 't10k-labels-idx1-ubyte.gz'), ...
            'http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz');
    end
    
    % Load dataset
    fprintf('Extracting dataset...\n');
    
    gunzip(fullfile(path,'data', 'train-images-idx3-ubyte.gz'));
    f = fopen(fullfile(path,'data', 'train-images-idx3-ubyte'), 'r', 'b');
    assert(fread(f, 1, 'int32') == 2051, 'magic number verification failed');
    assert(fread(f, 1, 'int32') == 60000, 'expected 60000 samples');
    assert(fread(f, 1, 'int32') == 28);
    assert(fread(f, 1, 'int32') == 28);
    trainX = fread(f, 60000 * 28 * 28, 'uint8=>uint8');
    trainX = reshape(trainX, 28, 28, 60000);
    trainX = permute(trainX, [2, 1, 3]);
    fclose(f);
    delete(fullfile(path,'data', 'train-images-idx3-ubyte'));

    gunzip(fullfile(path,'data', 'train-labels-idx1-ubyte.gz'));
    f = fopen(fullfile(path,'data', 'train-labels-idx1-ubyte'), 'r', 'b');
    assert(fread(f, 1, 'int32') == 2049, 'magic number verification failed');
    assert(fread(f, 1, 'int32') == 60000, 'expected 60000 samples');
    trainY = fread(f, 60000, 'uint8=>uint8');
    fclose(f);
    delete(fullfile(path,'data', 'train-labels-idx1-ubyte'));
    
    gunzip(fullfile(path,'data', 't10k-images-idx3-ubyte.gz'));
    f = fopen(fullfile(path,'data', 't10k-images-idx3-ubyte'), 'r', 'b');
    assert(fread(f, 1, 'int32') == 2051, 'magic number verification failed');
    assert(fread(f, 1, 'int32') == 10000, 'expected 60000 samples');
    assert(fread(f, 1, 'int32') == 28);
    assert(fread(f, 1, 'int32') == 28);
    testX = fread(f, 60000 * 28 * 28, 'uint8=>uint8');
    testX = reshape(testX, 28, 28, 10000);
    testX = permute(testX, [2, 1, 3]);
    fclose(f);
    delete(fullfile(path,'data', 't10k-images-idx3-ubyte'));

    gunzip(fullfile(path,'data', 't10k-labels-idx1-ubyte.gz'));
    f = fopen(fullfile(path,'data', 't10k-labels-idx1-ubyte'), 'r', 'b');
    assert(fread(f, 1, 'int32') == 2049, 'magic number verification failed');
    assert(fread(f, 1, 'int32') == 10000, 'expected 60000 samples');
    testY = fread(f, 60000, 'uint8=>uint8');
    fclose(f);
    delete(fullfile(path,'data', 't10k-labels-idx1-ubyte'));
end