% This script reads in GIST2v9 output files

close all; 
clear all; 
clc; 

%%

%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
cd ..
[filenames]=file_path_info2(code_path, file_path); % get files from file folder
cd(code_path);

%get info on GIST (and other) files
num_files = length(filenames);
cd ..
csv_filenames = get_filetype(filenames, 'csv');
% xcel_filenames = get_filetype(filenames, '.xlsx');
cd(code_path);
num_csv_files = length(csv_filenames);
cd(file_path)
TrialKey= readtable("TrialKey.xlsx");
cd(code_path)

%% 
% match the GVS (mat) and TTS (csv) files based on a common string in the
% filenames if they match then proceed with making comparison plots 
for i = 1:num_csv_files   
    current_csv_file = char(csv_filenames(i));
    if ~ contains(current_csv_file, "GIST_")
        continue
    end

    csv_num = str2num(current_csv_file(20:21)); %19:20 11:12
    for j = 1:height(TrialKey)
        
        if csv_num == (TrialKey.TTSTrial(j))
        end
    end
end