%dataset= 'par
%data = csvread('data/parkinson_allData.csv', 1,0);
%data_new = data(:, 6:end); % delete the first 5 columns
data = csvread('data/energydata_complete.csv', 1,1); % delete date in 1st column and 2 random variables at the end
data = data(:, 1:end-2); % % delete date in 1st column and 2 random variables at the end

csvwrite('data/energydata.csv',data,1,0)