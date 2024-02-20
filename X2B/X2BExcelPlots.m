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

subnum = 2034:2038;  % Subject List 
numsub = length(subnum);
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

sub_symbols = ["kpentagram";"k<";"khexagram";"k>"; "kdiamond";"kv";"ko";"k+"; "k*"; "kx"; "ksquare"; "k^";];
yoffset = [0.1;0.1;0.1;0.1;0.1;-0.1;-0.1;-0.1;-0.1;-0.1;0]; 
yoffset2 = [0.05; -0.05;0.05;-0.05;0.05;-0.05]; 
xoffset1 = [-100;-80;-60;-40;-20;0;20;40;60;80;100]; 
xoffset2 = [-0.25;-0.2;-0.15; -0.15; -0.1;-0.05;0;0.05;0.1;0.15;0.2;0.25]; 

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

    %% can add any indv. subject plots here
    % figure;
    % sgtitle(['S' subject_str ' Total Wins'])
    % subplot(2,1,1)
    % bar(main_results(:,1));
    % title ("Most Motion Sensation");
    % xticklabels([])
    % subplot(2,1,2)
    % bar(main_results(:,2));
    % xticklabels([Label.MainResultsRow])
    % title ("Most Tingling");

    % aggregating results
    total_results = total_results +main_results;
    sub_motion(:,sub) = main_results(:,1); 
    sub_tingle(:,sub) = main_results(:,2); 
end

%% can add any aggregate subj plots here
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

%%
figure;
sgtitle(['SAll Total Wins'])
subplot(2,1,1)
b=boxplot(sub_motion');
hold on;
for j = 1:numsub
    for i = 1:width(sub_motion')
        
        plot(i+xoffset2(j), sub_motion(i, j),sub_symbols(j),'MarkerSize',15,"LineWidth", 1.5);
        hold on;
    end
end
title ("Most Motion Sensation");
xticklabels([])

subplot(2,1,2)
boxplot(sub_tingle');
hold on;
for j = 1:numsub
    for i = 1:width(sub_motion')
        
        plot(i+xoffset2(j), sub_tingle(i, j),sub_symbols(j),'MarkerSize',15,"LineWidth", 1.5);
        hold on;
    end
end
xticklabels([Label.MainResultsRow])
title ("Most Tingling");

cd(code_path);