%% Script 7b for Dynamic GVS +Tilt
% this script calculates outcome measures (rms, total deflection ...) and
% then plots these outcomes for all trial types to help better visualize
% the data it takes its input from script 6 Aggregate and should include
% similar measure to the individual measures script
close all; 
clear; 
clc; 
%% set up
datatype = 'BiasTime';
Color_list = ['g'; 'c'; 'b'; 'r';  'g'; 'c'; 'b' ];
%% set up pathing
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory

if ismac || isunix
    plots_path = [file_path '/Plots/Measures']; % specify where plots are saved
    gvs_path = [file_path '/GVSProfiles'];
    tts_path = [file_path '/TTSProfiles'];
elseif ispc
    plots_path = [file_path '\Plots\Measures']; % specify where plots are saved
    gvs_path = [file_path '\GVSProfiles'];
    tts_path = [file_path '\TTSProfiles'];
end

[filenames]=file_path_info2(code_path, file_path); % get files from file folder

%load data file
cd(file_path);
if ismac || isunix
    load(['SAll' datatype '.mat']);
elseif ispc
    load(['SAll' datatype '.mat ']);
end

cd(code_path);

%% RMS calculation and plots
    rms4A = rms(All_shot_4A);
    rms4B = rms(All_shot_4B);
    rms5A = rms(All_shot_5A);
    rms5B = rms(All_shot_5B);
    rms6A = rms(All_shot_6A);
    rms6B = rms(All_shot_6B);

%     sub_num = size(save_shot_4A);
% 
%     for sub_pt = 1:sub_num(3)
% 
%         rot_4A = permute(save_shot_4A,[1 3 2]);
%         rms_rot_4A(:,sub_pt) = rms(rot_4A(:,sub_pt,:));
%         rot_4B = permute(save_shot_4B,[1 3 2]);
%         rms_rot_4B(:,sub_pt) = rms(rot_4B(:,sub_pt,:));
%         rot_5A = permute(save_shot_5A,[1 3 2]);
%         rms_rot_5A(:,sub_pt) = rms(rot_5A(:,sub_pt,:));
%         rot_5B = permute(save_shot_5B,[1 3 2]);
%         rms_rot_5B(:,sub_pt) = rms(rot_5B(:,sub_pt,:));
%         rot_6A = permute(save_shot_6A,[1 3 2]);
%         rms_rot_6A(:,sub_pt) = rms(rot_6A(:,sub_pt,:));
%         rot_6B = permute(save_shot_6B,[1 3 2]);
%         rms_rot_6B(:,sub_pt) = rms(rot_6B(:,sub_pt,:));
%     end

    % Making all missing data into NaN so it does not plot as 0 (assuming
    % there is a very low chance any true result is exactly 0):
%     rms_rot_4A(rms_rot_4A == 0) = NaN;
%     rms_rot_4B(rms_rot_4B == 0) = NaN;
%     rms_rot_5A(rms_rot_5A == 0) = NaN;
%     rms_rot_5B(rms_rot_5B == 0) = NaN;
%     rms_rot_6A(rms_rot_6A == 0) = NaN;
%     rms_rot_6B(rms_rot_6B == 0) = NaN;
    
    rmsA = [ rms4A; rms5A; rms6A ];
    rmsB = [ rms4B; rms5B; rms6B ];


    
    %make bar plot, put data from A profiles on top and B profiles on bottom
    figure;
    subplot(2,1,1)
    A=bar([1, 2, 3 ], rmsA'); 
    title ("A Profiles");
    xticklabels(["SumOfSin4", "SumOfSin5", "SumOfSin6"]);
    ylabel("Degrees")
    legend (["-4mA Vel", "-4 Ang & Vel", "-4 Ang",  "0mA","+4mA Vel", "+4 Ang & Vel", "+4 Ang"], 'Location','north','AutoUpdate','off');
    for j = 1:length(rmsA)
        A(j).FaceColor = Color_list(j,:);
    end
    hold on; 
    %shape = {'+','*','x','s','d','^','p','h','>','<'};
    %bar_space_4A = linspace(0.65,1.35,7);
    %bar_space_5A = linspace(1.65,2.35,7);
    %bar_space_6A = linspace(2.65,3.35,7);
    s = rng;

%     for prof_ad = 1:7  
%         for alt_ticker = 1:width(rms_rot_4A)
%             color = rand(1,3);
%             plot(bar_space_4A(prof_ad),rms_rot_4A(prof_ad,alt_ticker),shape{alt_ticker},'Color',color); hold on;
%             plot(bar_space_5A(prof_ad),rms_rot_5A(prof_ad,alt_ticker),shape{alt_ticker},'Color',color);
%             plot(bar_space_6A(prof_ad),rms_rot_6A(prof_ad,alt_ticker),shape{alt_ticker},'Color',color);
%         end
%         rng(s);
%     end

    subplot(2,1,2)
    B=bar([1, 2, 3], rmsB'); 
    xticklabels(["SumOfSin4", "SumOfSin5", "SumOfSin6"]);
    ylabel("Degrees")
    title ("B Profiles");
    %legend (["-4mA Vel", "-4 Ang & Vel", "-4 Ang", "0mA",  "+4mA Vel", "+4 Ang & Vel", "+4 Ang"],'Location','north','AutoUpdate','off');
    for j = 1:length(rmsB)
        B(j).FaceColor = Color_list(j,:);
    end
    hold on;

%     for prof_ad = 1:7
%         for alt_ticker = 1:width(rms_rot_4A)
%             color = rand(1,3);
%             plot(bar_space_4A(prof_ad),rms_rot_4B(prof_ad,alt_ticker),shape{alt_ticker},'Color',color); hold on;
%             plot(bar_space_5A(prof_ad),rms_rot_5B(prof_ad,alt_ticker),shape{alt_ticker},'Color',color);
%             plot(bar_space_6A(prof_ad),rms_rot_6B(prof_ad,alt_ticker),shape{alt_ticker},'Color',color);
%         end
%         rng(s);
%     end


    sgtitle(['RMS Subject Avg' datatype]);

    cd(plots_path);
    saveas(gcf, [ 'RMS_All' datatype ]); 
    cd(code_path);
    hold off;  
    
    %% variance calculations and plots
    var4A = var(All_shot_4A);
    var4B = var(All_shot_4B);
    var5A = var(All_shot_5A);
    var5B = var(All_shot_5B);
    var6A = var(All_shot_6A);
    var6B = var(All_shot_6B);
    
    varA = [ var4A; var5A; var6A ];
    varB = [ var4B; var5B; var6B ];
    
    %make plot put A profiles on top and B profiles on bottom
    figure;
    subplot(2,1,1)
    A=bar([1, 2, 3], varA'); 
    title ("A Profiles");
    xticklabels(["SumOfSin4", "SumOfSin5", "SumOfSin6"]);
    ylabel("(Degrees)^2");
    legend ([ "-4mA Vel", "-4 Ang & Vel", "-4 Ang",   "0mA","+4mA Vel", "+4 Ang & Vel", "+4 Ang"], 'Location','north');
    for j = 1:length(varA)
        A(j).FaceColor = Color_list(j,:);
    end
    
    hold on; 
    
    subplot(2,1,2)
    B=bar([1, 2, 3], varB');
    xticklabels(["SumOfSin4", "SumOfSin5", "SumOfSin6"]);
    title ("B Profiles");
    ylabel("(Degrees)^2");
    legend ([ "-4mA Vel", "-4 Ang & Vel", "-4 Ang", "0mA",  "+4mA Vel", "+4 Ang & Vel", "+4 Ang"],'Location','north');
    for j = 1:length(varB)
        B(j).FaceColor = Color_list(j,:);
    end
    sgtitle(['Variance Subject Avg' datatype]);

    cd(plots_path);
    saveas(gcf, [ 'Variance_All'  datatype]); 
    cd(code_path);
    hold off;  
%% total deflection calculation and plot
