clc; clear; close all;

% This code plots all of the adjustments made to the data on bar graphs.

%% set up
subnum = 1011:1021;  % Subject List 
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

datatype = ["BiasTimeGain", "BiasTime" ,"Bias"];

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
if ismac || isunix
    plots_path = [file_path '/Plots']; % specify where plots are saved
elseif ispc
    plots_path = [file_path '\Plots']; % specify where plots are saved
end

[filenames]=file_path_info2(code_path, file_path); % get files from file folder
gain_vec = zeros(length(numsub),1);
bias_vec = zeros(length(numsub),1);
time_vec = zeros(length(numsub),1);

%% generate plots for each subject
for sub = 1:numsub 
    subject = subnum(sub);
    subject_str = num2str(subject);
    
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end

    %set up file/plot save locations
    if ismac || isunix
            subject_path = [file_path, '/' , subject_str];
            subject_plot_path = [plots_path '/' subject_str];
    elseif ispc
            subject_path = [file_path, '\' , subject_str];
            subject_plot_path = [plots_path '\' subject_str];
    end

    mkdir(subject_plot_path);

    %load in the matlab file conaining a single subjects data that has been
    %sorted by profile 
    cd(subject_path);

    for adj = 1:length(datatype)
        str = convertStringsToChars(datatype(adj));
        if ismac || isunix
            load(['S', subject_str, 'Group', str, '.mat']);
        elseif ispc
            load(['S', subject_str, 'Group', str, '.mat ']);
        end
    end

    gain_vec(sub,1) = avg_gain_rms_min;
    bias_vec(sub,1) = bias_correction;
    time_vec(sub,1) = avg_time_rms_min;



    cd(code_path);
end

%% Plotting:
figure();
bar(gain_vec)
xlabel('Subject','FontSize',17,'interpreter','latex'); ylabel('Gain Correction','FontSize',17,'interpreter','latex');
title('Gain Correction over all Subjects','FontSize',17,'interpreter','latex');

figure();
bar(bias_vec)
xlabel('Subject','FontSize',17,'interpreter','latex'); ylabel('Bias Correction','FontSize',17,'interpreter','latex');
title('Bias Correction over all Subjects','FontSize',17,'interpreter','latex');

figure();
bar(time_vec)
xlabel('Subject','FontSize',17,'interpreter','latex'); ylabel('Time Correction (Seconds)','FontSize',17,'interpreter','latex');
title('Time Correction over all Subjects','FontSize',17,'interpreter','latex');





