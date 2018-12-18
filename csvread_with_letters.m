function data = csvread_with_letters(dataset_file,R1,C1)
% INPUTS:
%   dataset filename (with fullpath)
%   R1: Starting row offset, specified as a nonnegative integer. The first row has an offset of 0.
%   C1: Starting column offset, specified as a nonnegative integer. The first column has an offset of 0.
   
%data = csvread(fullfile( ScenesPath, strcat(dataset,'.csv')), 1,0); % skip 1st row (header row)
    % Remove quotes
    fid = fopen('temp2.csv','w');
    s = fileread(dataset_file);
    s = strrep(s,'"','');
    s = strrep(s,'nominal','');
    s = strrep(s,'missing_value',''); % missing values are replaced by 0
    fprintf(fid,s);
    fclose(fid);

    %% Open new, quote free, file
    %fid = fopen('temp.csv','r');
    %fclose(fid);
    %% Get doubles
    data = csvread('temp2.csv', R1,C1);