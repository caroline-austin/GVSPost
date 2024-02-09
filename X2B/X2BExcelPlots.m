% Created by: Caroline Austin 2/6/24
% Script 2a of X2B data processing 
% This script reads in the output of script 1 (X2BGet files) and uses the
% data from the excel sheet to make plots summarizing the results of the
% experiment 

close all; 
clear all; 
clc; 


%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory % select data folder
plots_path = [file_path '/Plots']; % specify where plots are saved
cd(code_path); cd .. ;
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

subnum = 2034:2036;  % Subject List 
numsub = length(subnum);
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

%%
total_results = zeros(3,2);
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    subject_path = [file_path '/' subject_str];
    
    % load subject data 
    cd(subject_path);
    load(['S' subject_str '.mat']);

    main_results = cell2mat(main_results);
    figure;
    sgtitle(['S' subject_str ' Total Wins'])
    subplot(2,1,1)
    bar(main_results(:,1));
    title ("Most Motion Sensation");
    xticklabels([])
    subplot(2,1,2)
    bar(main_results(:,2));
    xticklabels([Label.MainResultsRow])
    title ("Most Tingling");

    total_results = total_results +main_results;
end

figure;
sgtitle(['SAll Total Wins'])
subplot(2,1,1)
bar(total_results(:,1));
title ("Most Motion Sensation");
xticklabels([])
subplot(2,1,2)
bar(total_results(:,2));
xticklabels([Label.MainResultsRow])
title ("Most Tingling");

cd(code_path);