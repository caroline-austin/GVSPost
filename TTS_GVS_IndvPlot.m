%% Script 5a for Dynamic GVS +Tilt
% This script generates 12 plots a positive and negative plot for each
% A/B physcial motion profile
% each plot includes the shot report for the sham and + or - GVS, a plot of
% the angular velocity and a plot of the GVS profiles applied. 
% run this script after running GroupByProfile and/or the
% optional shot ajustment/correction scripts. 
close all; 
clear all; 
clc; 
%% set up
subnum = 1011:1014;  % Subject List 
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part
datatype = 'BiasTime';

Color_List = [ "black";"green";"cyan"; "blue";"red";"green"; "cyan";"blue"];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

%% generate plots for each subject
for sub = 1:numsub 
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    %set up file/plot save locations
%     subject_path = [file_path, '\PS' , subject_str];
    subject_path = [file_path, '\' , subject_str];
    subject_plot_path = [plots_path '\' subject_str];
    mkdir(subject_plot_path);

    %load in the matlab file conaining a single subjects data that has been
    %sorted by profile 
    cd(subject_path);
    load(['S', subject_str, 'Group', datatype, '.mat ']);
%     load(['PS', subject_str, '.mat ']);
    cd(code_path);
%% Plot 4A with function
    %find the indices for the positive (additive) GVS trials 
    [pos_prof] = find(contains(Label.shot_4A, 'P'));
    PlotGVSTTSPerception(Label.shot_4A,Label.GVS_4A, ...
        tilt_4A(1:trial_end,:),shot_4A(1:trial_end,:),GVS_4A(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof,match_list);
    %add title to the plot
    subplot(3,1,1)
    title(['4A Additive GVS Affects on Tilt Perception ' datatype])
    %save plot
    cd(subject_plot_path);
    saveas(gcf, [ 'Positive_4A_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;

    % find the indices for the negative (canceling) GVS trials
    [neg_prof] = find(contains(Label.shot_4A, 'N'));
    [zero_prof] = find(contains(Label.shot_4A, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_4A,Label.GVS_4A, ...
        tilt_4A(1:trial_end,:),shot_4A(1:trial_end,:),GVS_4A(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    %add title to the plot
    subplot(3,1,1)
    title(['4A Canceling GVS Affects on Tilt Perception ' datatype])
    %save plot
    cd(subject_plot_path);
    saveas(gcf, [ 'Negative_4A_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;
%% Plot 4B with function
    %find the indices for the positive (additive) GVS trials
    [pos_prof] = find(contains(Label.shot_4B, 'P'));
    PlotGVSTTSPerception(Label.shot_4B,Label.GVS_4B, ...
        tilt_4B(1:trial_end,:),shot_4B(1:trial_end,:),GVS_4B(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof, match_list);
    %add title to the plot
    subplot(3,1,1)
    title(['4B Additive GVS Affects on Tilt Perception ' datatype])
    %save plot
    cd(subject_plot_path);
    saveas(gcf, [ 'Positive_4B_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;

    %find the indices for the negative (canceling) GVS trials
    [neg_prof] = find(contains(Label.shot_4B, 'N'));
    [zero_prof] = find(contains(Label.shot_4B, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_4B,Label.GVS_4B, ...
        tilt_4B(1:trial_end,:),shot_4B(1:trial_end,:),GVS_4B(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    %add title to the plot
    subplot(3,1,1)
    title(['4B Canceling GVS Affects on Tilt Perception ' datatype])
    %save plot
    cd(subject_plot_path);
    saveas(gcf, [ 'Negative_4B_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;
%% Plot 5A with function
    %find the indices for the positive (additive) GVS trials
    [pos_prof] = find(contains(Label.shot_5A, 'P'));
    PlotGVSTTSPerception(Label.shot_5A,Label.GVS_5A, ...
        tilt_5A(1:trial_end,:),shot_5A(1:trial_end,:),GVS_5A(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof,match_list);
    %add title to the plot
    subplot(3,1,1)
    title(['5A Additive GVS Affects on Tilt Perception ' datatype])
    %save plot
    cd(subject_plot_path);
    saveas(gcf, [ 'Positive_5A_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;

    % find the indices for the negative (canceling) GVS trials
    [neg_prof] = find(contains(Label.shot_5A, 'N'));
    [zero_prof] = find(contains(Label.shot_5A, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_5A,Label.GVS_5A, ...
        tilt_5A(1:trial_end,:),shot_5A(1:trial_end,:),GVS_5A(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    %add title to the plot
    subplot(3,1,1)
    title(['5A Negative GVS Affects on Tilt Perception ' datatype])
    %save plot
    cd(subject_plot_path);
    saveas(gcf, [ 'Negative_5A_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;
%% Plot 5B with function
    %find the indices for the positive (additive) GVS trials
    [pos_prof] = find(contains(Label.shot_5B, 'P'));
    PlotGVSTTSPerception(Label.shot_5B,Label.GVS_5B, ...
        tilt_5B(1:trial_end,:),shot_5B(1:trial_end,:),GVS_5B(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof, match_list);
    %add title to the plot
    subplot(3,1,1)
    title(['5B Positive GVS Affects on Tilt Perception ' datatype])
    %save plot
    cd(subject_plot_path);
    saveas(gcf, [ 'Positive_5B_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;

    % find the indices for the negative (canceling) GVS trials
    [neg_prof] = find(contains(Label.shot_5B, 'N'));
    [zero_prof] = find(contains(Label.shot_5B, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_5B,Label.GVS_5B, ...
        tilt_5B(1:trial_end,:),shot_5B(1:trial_end,:),GVS_5B(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    %add title to the plot
    subplot(3,1,1)
    title(['5B Negative GVS Affects on Tilt Perception ' datatype])
    %save plot
    cd(subject_plot_path);
    saveas(gcf, [ 'Negative_5B_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;    
%% Plot 6A with function
    %find the indices for the positive (additive) GVS trials
    [pos_prof] = find(contains(Label.shot_6A, 'P'));
    PlotGVSTTSPerception(Label.shot_6A,Label.GVS_6A, ...
        tilt_6A(1:trial_end,:),shot_6A(1:trial_end,:),GVS_6A(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof,match_list);
    %add title to the plot
    subplot(3,1,1)
    title(['6A Positive GVS Affects on Tilt Perception ' datatype])
    %save plot
    cd(subject_plot_path);
    saveas(gcf, [ 'Positive_6A_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;

    % find the indices for the negative (canceling) GVS trials
    [neg_prof] = find(contains(Label.shot_6A, 'N'));
    [zero_prof] = find(contains(Label.shot_6A, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_6A,Label.GVS_6A, ...
        tilt_6A(1:trial_end,:),shot_6A(1:trial_end,:),GVS_6A(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    %add title to the plot
    subplot(3,1,1)
    title(['6A Negative GVS Affects on Tilt Perception ' datatype])
    %save plot
    cd(subject_plot_path);
    saveas(gcf, [ 'Negative_6A_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;
%% Plot 6B with function
    %find the indices for the positive (additive) GVS trials
    [pos_prof] = find(contains(Label.shot_6B, 'P'));
    PlotGVSTTSPerception(Label.shot_6B,Label.GVS_6B, ...
        tilt_6B(1:trial_end,:),shot_6B(1:trial_end,:),GVS_6B(1:trial_end,:), ...
        time(1:trial_end),Color_List,pos_prof,match_list);
    %add title to the plot
    subplot(3,1,1)
    title(['6B Positive GVS Affects on Tilt Perception ' datatype])
    %save plot
    cd(subject_plot_path);
    saveas(gcf, [ 'Positive_6B_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;
    
    % find the indices for the negative (canceling) GVS trials
    [neg_prof] = find(contains(Label.shot_6B, 'N'));
    [zero_prof] = find(contains(Label.shot_6B, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_6B,Label.GVS_6B, ...
        tilt_6B(1:trial_end,:),shot_6B(1:trial_end,:),GVS_6B(1:trial_end,:), ...
        time(1:trial_end),Color_List,neg_prof,match_list);
    %add title to the plot
    subplot(3,1,1)
    title(['6B Negative GVS Affects on Tilt Perception ' datatype])
    %save plot
    cd(subject_plot_path);
    saveas(gcf, [ 'Negative_6B_4_00mA_Perception' datatype subject_str]); 
    cd(code_path);
    hold off;    
end