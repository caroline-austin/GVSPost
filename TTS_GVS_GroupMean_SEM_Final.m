%% Script 8 for Dynamic GVS +Tilt
% This script is meant to take the mean of all of the taken SHOT data for
% each condition – velocity, vel. and. ang., and angle – and take an
% average over all the subjects for +/-4mA and the sham condition. 
% Then the SEM of each mean is to be plotted over top each mean line.

clc; clear; close all;

%% Load in adjusted data
subnum = 1011:1015;  % Subject List 
numsub = length(subnum);
subskip = 1013;  %DNF'd subjects or subjects that didn't complete this part

Color_List = [ "black";"green";"cyan"; "blue";"red";"green"; "cyan";"blue"];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];
datatype = 'BiasTime'; % Ask if this includes both bias scripts?????????

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
if ismac || isunix
    plots_path = [file_path '/Plots']; % specify where plots are saved
elseif ispc
    plots_path = [file_path '\Plots']; % specify where plots are saved
end

[filenames]=file_path_info2(code_path, file_path); % get files from file folder


subject = subnum(5);
subject_str = num2str(subject);


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
if ismac || isunix
    load(['S', subject_str, 'Group', datatype, '.mat']);
elseif ispc
    load(['S', subject_str, 'Group', datatype, '.mat ']);
end