%% script 4 of IMU data analysis
% Created by: Caroline Austin
% Modified by: Caroline Austin
% Date: 3/27/2025
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IMU data in the form of 'Allimu.mat'
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear; close all;
restoredefaultpath;
code_path = pwd;

%% Experimental Methods Specifications
file_path = uigetdir; %user selects file directory './Subject Data/'; %I replaced this so the person can directly choose where to pull the data from

subnum = [2034:2043];  % Subject List 2001:2010 2001:2010
numsub = length(subnum);
subskip = [2001 2004 2008 2010];  %DNF'd subjects

sub_symbols = ["kpentagram-";"k<-";"khexagram-";"k>-"; "kdiamond-";"kv-";"ko-";"k+-"; "k*-"; "kx-"; "ksquare-"; "k^-";];
yoffset1 = [0.1;0.1;0.1;0.1;0.1;-0.1;-0.1;-0.1;-0.1;-0.1;0]; 
yoffset2 = [0.05; -0.05;0.05;-0.05;0.05;-0.05]; 
xoffset1 = [-100;-80;-60;-40;-20;0;20;40;60;80;100]; 
xoffset2 = [-0.25;-0.2;-0.15; -0.15; -0.1;-0.05;0;0.05;0.1;0.15;0.2;0.25]; 

% colors- first 5 are color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
orange = [0.9020, 0.6235, 0.0000];  % golden orange
skyblue = [0.3373, 0.7059, 0.9137]; % sky blue
pink = [0.8353, 0.3686, 0.0000];    % strong warm pink
teal = [0.2667, 0.4471, 0.3843];    % muted teal
% yellow = [0.9451, 0.8941, 0.2588];  % soft yellow
brown = [0.7059, 0.3961, 0.1137];   % medium brown
yellow = [255 190 50]/255;
black = [0 0 0];

cd([file_path]);
load(['Allimu.mat'])
cd(code_path);

imu_dir = Label.imu_angles;
plots = [" "];

%%
% plot the sway angle over time - separate plot for each subject and sway
% direction and then separate subplots for each montage - with replicates
% overlayed.
if contains(plots, "1 ")
%%

    for sub = 1:numsub
        subject = subnum(sub);
        subject_str = num2str(subject);
        for dir = 2%1:2
        figure;
        subplot(3,1,1)
        for trial = 1:30
            if trial < 11
                subplot(3,1,1)
                ylabel("Forehead (deg)")
                ylim([-4 4])
            elseif trial <21
                subplot(3,1,2)
                ylabel("Shoulder (deg)")
                ylim([-4 4])
            else
                subplot(3,1,3)
                ylabel("Neck (deg)")
                ylim([-4 4])
            end
            plot(squeeze(all_trials_sort(trial, sub,dir,:))');
            hold on;

        end
        sgtitle([subject_str imu_dir(dir)])
        end
        
    end
end

% plots the power interest results for the 0.5 Hz frequency - separate
% subplots for each participant comparing the 3 montages
if contains(plots, "2 ")
%%
for dir = 2%1:2
    forehead_power= power_interest_sort(1:8, :,dir,10); % only consider 1:8 because these are the 3mA trials 
    shoulder_power= power_interest_sort(11:18, :,dir,10);
    neck_power= power_interest_sort(21:28, :,dir,10);
    figure;
    tiledlayout(numsub,1, "TileSpacing","tight", "Padding","tight")
    for sub = 1:numsub
        subject = subnum(sub);
        subject_str = num2str(subject);
        nexttile
        boxplot([forehead_power(:,sub) shoulder_power(:,sub) neck_power(:,sub)]);
        ylim([-40 10])
        ylabel(strcat([subject_str "(deg)"]))
        if sub ~= numsub
            xticklabels([]);
        else
            xticklabels(["Forehead" "Shoulder" "Neck"]); 
        end

    end
    if dir ==1
        sgtitle("Roll Sway Power at 0.5Hz")
    elseif dir ==2
        sgtitle("Pitch Sway Power at 0.5Hz")
    end
end
end

% plots the power interest results for the 0.5 Hz frequency - data is
% pooled across replicate trials and subjects and compared only at the
% montage level
if contains(plots, "3 ")
    %%
    for dir = 1:2
        figure;
        forehead_power= power_interest_sort(1:8, :,dir,10);
        shoulder_power= power_interest_sort(11:18, :,dir,10);
        neck_power= power_interest_sort(21:28, :,dir,10);
        mean_forehead_power = mean(forehead_power);
        mean_shoulder_power = mean(shoulder_power);
        mean_neck_power = mean(neck_power);
        median_forehead_power = median(forehead_power);
        median_shoulder_power = median(shoulder_power);
        median_neck_power = median(neck_power);

        max_forehead_power = max(forehead_power);
        max_shoulder_power = max(shoulder_power);
        max_neck_power = max(neck_power);
        forehead_power_group= reshape(forehead_power,[],1);
        shoulder_power_group= reshape(shoulder_power,[],1);
        neck_power_group= reshape(neck_power,[],1);
        % boxplot([forehead_power_group shoulder_power_group neck_power_group]);
        boxchart([forehead_power_group shoulder_power_group neck_power_group], 'BoxFaceColor', [0 0 0]);
        % boxchart([median_forehead_power; median_shoulder_power; median_neck_power]', 'BoxFaceColor', [0 0 0]);
        % boxchart([max_forehead_power; max_shoulder_power; max_neck_power]', 'BoxFaceColor', [0 0 0]);
        hold on; 
        for sub = 1:numsub % num of sub
            plot(1+xoffset2(sub), median_forehead_power(sub), sub_symbols(sub))
            plot(2+xoffset2(sub), median_shoulder_power(sub), sub_symbols(sub))
            plot(3+xoffset2(sub), median_neck_power(sub), sub_symbols(sub))
            % plot(1+xoffset2(sub), max_forehead_power(sub), sub_symbols(sub))
            % plot(2+xoffset2(sub), max_shoulder_power(sub), sub_symbols(sub))
            % plot(3+xoffset2(sub), max_neck_power(sub), sub_symbols(sub))
        end
        xticklabels(["Forehead" "Shoulder" "Neck"]); 
        ylim([-46 10])
        if dir ==1
            sgtitle("Roll Sway Power at 0.5Hz")
        elseif dir ==2
            sgtitle("Pitch Sway Power at 0.5Hz")
        end
        ylabel('Sway at Freq of Interest (deg dB/Hz)');
    end
end

% plots the mag interest results for the 0.5 Hz frequency - data is
% pooled across replicate trials and subjects and compared only at the
% montage level

if contains(plots, "3b ") % use for paper
    %%
    for dir = 2%1:2
        f=figure;
        set(f, 'DefaultAxesFontSize', 14);
        forehead_power= mag_interest_sort(1:8, :,dir,1);
        shoulder_power= mag_interest_sort(11:18, :,dir,1);
        neck_power= mag_interest_sort(21:28, :,dir,1);
        % forehead_power= sum(mag_interest_sort(1:8, :,dir,:),4);
        % shoulder_power= sum(mag_interest_sort(11:18, :,dir,:),4);
        % neck_power= sum(mag_interest_sort(21:28, :,dir,:),4);
        mean_forehead_power = mean(forehead_power);
        mean_shoulder_power = mean(shoulder_power);
        mean_neck_power = mean(neck_power);
        median_forehead_power = median(forehead_power, 'omitnan');
        median_shoulder_power = median(shoulder_power, 'omitnan');
        median_neck_power = median(neck_power, 'omitnan');
        max_forehead_power = max(forehead_power);
        max_shoulder_power = max(shoulder_power);
        max_neck_power = max(neck_power);
        forehead_power_group= reshape(forehead_power,[],1);
        shoulder_power_group= reshape(shoulder_power,[],1);
        neck_power_group= reshape(neck_power,[],1);
        % boxplot([forehead_power_group shoulder_power_group neck_power_group]);
        % boxchart([forehead_power_group shoulder_power_group neck_power_group], 'BoxFaceColor', [0 0 0]);
        boxchart([1 1 1 1 1 1 1 1 1 1],[median_forehead_power;]', 'BoxFaceColor', orange);
        hold on; 
        boxchart([2 2 2 2 2 2 2 2 2 2],[ median_shoulder_power; ]', 'BoxFaceColor', green);
        hold on;
        boxchart([3 3 3 3 3 3 3 3 3 3],[median_neck_power]', 'BoxFaceColor', pink);
        % boxchart([max_forehead_power; max_shoulder_power; max_neck_power]', 'BoxFaceColor', [0 0 0]);
        hold on; 
        % for sub = 1:numsub % num of sub
        %     plot(1+xoffset2(sub), median_forehead_power(sub), sub_symbols(sub))
        %     plot(2+xoffset2(sub), median_shoulder_power(sub), sub_symbols(sub))
        %     plot(3+xoffset2(sub), median_neck_power(sub), sub_symbols(sub))
        %     % plot(1+xoffset2(sub), max_forehead_power(sub), sub_symbols(sub))
        %     % plot(2+xoffset2(sub), max_shoulder_power(sub), sub_symbols(sub))
        %     % plot(3+xoffset2(sub), max_neck_power(sub), sub_symbols(sub))
        % end
        xticks([1 2 3])
        xticklabels(["Forehead"  "Shoulder"  "Neck"]); 
        yscale('log')
        ylim([0.05 0.5])
        % ylim([0.001 1])
        % yticks([0.01 0.1 1])
        % yticklabels([0.01 0.1 1])
        yticks([0.05 0.5 5])
        yticklabels([0.05 0.5 5])
        grid on
        if dir ==1
            sgtitle("Roll Sway Power at 0.5Hz")
        elseif dir ==2
            sgtitle("Pitch Sway Power at 0.5Hz", 'Fontsize', 17)
        end
        ylabel('Sway at Freq of Interest (deg)');
    end
end

% plots the psd interest results for the 0.5 Hz frequency - data is
% pooled across replicate trials and subjects and compared only at the
% montage level
if contains(plots, "3c ")
    %%
    for dir = 2%1:2
        figure;
        forehead_power= psd_interest_sort(1:8, :,dir,1);
        shoulder_power= psd_interest_sort(11:18, :,dir,1);
        neck_power= psd_interest_sort(21:28, :,dir,1);
        % forehead_power= sum(psd_interest_sort(1:8, :,dir,3),4);
        % shoulder_power= sum(psd_interest_sort(11:18, :,dir,3),4);
        % neck_power= sum(psd_interest_sort(21:28, :,dir,3),4);
        mean_forehead_power = mean(forehead_power);
        mean_shoulder_power = mean(shoulder_power);
        mean_neck_power = mean(neck_power);
        median_forehead_power = median(forehead_power, 'omitnan');
        median_shoulder_power = median(shoulder_power, 'omitnan');
        median_neck_power = median(neck_power, 'omitnan');
        forehead_power_group= reshape(forehead_power,[],1);
        shoulder_power_group= reshape(shoulder_power,[],1);
        neck_power_group= reshape(neck_power,[],1);
        % boxplot([forehead_power_group shoulder_power_group neck_power_group]);
        % boxchart([forehead_power_group shoulder_power_group neck_power_group], 'BoxFaceColor', [0 0 0]);
        boxchart([median_forehead_power; median_shoulder_power; median_neck_power]', 'BoxFaceColor', [0 0 0]);
        hold on; 
        for sub = 1:numsub % num of sub
            plot(1+xoffset2(sub), median_forehead_power(sub), sub_symbols(sub))
            plot(2+xoffset2(sub), median_shoulder_power(sub), sub_symbols(sub))
            plot(3+xoffset2(sub), median_neck_power(sub), sub_symbols(sub))
        end
        xticklabels(["Forehead" "Shoulder" "Neck"]); 
        yscale('log')
        ylim([0.005 1])
        yticklabels([0.01 0.1 1])
        if dir ==1
            sgtitle("Roll Sway Power at 0.5Hz")
        elseif dir ==2
            sgtitle("Pitch Sway Power at 0.5Hz")
        end
        ylabel('Sway at Freq of Interest (deg)');
    end
end

% plots the psd interest results for the 0.5 Hz frequency - data is
% pooled across replicate trials and subjects and compared only at the
% montage level
if contains(plots, "3d ")
    %%
    for dir = 2%1:2
        figure;
        forehead_power= psd_05_sort(1:8, :,dir,1);
        shoulder_power= psd_05_sort(11:18, :,dir,1);
        neck_power= psd_05_sort(21:28, :,dir,1);
        % forehead_power= sum(psd_05_sort(1:8, :,dir,3),4);
        % shoulder_power= sum(psd_05_sort(11:18, :,dir,3),4);
        % neck_power= sum(psd_05_sort(21:28, :,dir,3),4);
        mean_forehead_power = mean(forehead_power);
        mean_shoulder_power = mean(shoulder_power);
        mean_neck_power = mean(neck_power);
        median_forehead_power = median(forehead_power, 'omitnan');
        median_shoulder_power = median(shoulder_power, 'omitnan');
        median_neck_power = median(neck_power, 'omitnan');
        forehead_power_group= reshape(forehead_power,[],1);
        shoulder_power_group= reshape(shoulder_power,[],1);
        neck_power_group= reshape(neck_power,[],1);
        % boxplot([forehead_power_group shoulder_power_group neck_power_group]);
        % boxchart([forehead_power_group shoulder_power_group neck_power_group], 'BoxFaceColor', [0 0 0]);
        boxchart([median_forehead_power; median_shoulder_power; median_neck_power]', 'BoxFaceColor', [0 0 0]);
        hold on; 
        for sub = 1:numsub % num of sub
            plot(1+xoffset2(sub), median_forehead_power(sub), sub_symbols(sub))
            plot(2+xoffset2(sub), median_shoulder_power(sub), sub_symbols(sub))
            plot(3+xoffset2(sub), median_neck_power(sub), sub_symbols(sub))
        end
        xticklabels(["Forehead" "Shoulder" "Neck"]); 
        % yscale('log')
        % ylim([0.005 1])
        % yticklabels([0.01 0.1 1])
        if dir ==1
            sgtitle("Roll Sway Power at 0.5Hz")
        elseif dir ==2
            sgtitle("Pitch Sway Power at 0.5Hz")
        end
        ylabel('Sway at Freq of Interest (deg)');
    end
end
% plots the power interest results for the 0.5 Hz frequency - data is
% pooled across replicate trials and subjects and compared only at the
% montage level
if contains(plots, "4 ")
    %%
    for dir = 1:2
        figure;
        forehead_power= squeeze(median(power_interest_sort(1:8, :,dir,:)));
        shoulder_power= squeeze(median(power_interest_sort(11:18, :,dir,:)));
        neck_power= squeeze(median(power_interest_sort(21:28, :,dir,:)));
        % forehead_power_group= reshape(forehead_power,[],1);
        % shoulder_power_group= reshape(shoulder_power,[],1);
        % neck_power_group= reshape(neck_power,[],1);
        boxplot([forehead_power ]);
        ylim([-46 10])
        xticklabels(freq_interest); 
        ylabel('Sway at Freq of Interest (deg dB/Hz)');
        if dir ==1
            sgtitle("Forehead Roll Sway Power at 0.5Hz")
        elseif dir ==2
            sgtitle("Forehead Pitch Sway Power at 0.5Hz")
        end

        figure;
        boxplot([ shoulder_power ]);
        ylim([-46 10])
        xticklabels(freq_interest); 
        ylabel('Sway at Freq of Interest (deg dB/Hz)');
        if dir ==1
            sgtitle("Shoulder Roll Sway Power at 0.5Hz")
        elseif dir ==2
            sgtitle("Shoulder Pitch Sway Power at 0.5Hz")
        end

        figure;
        boxplot([ neck_power]);
        ylabel('Sway at Freq of Interest (deg dB/Hz)');
        xticklabels(freq_interest); 
        ylim([-46 10])
        if dir ==1
            sgtitle("Neck Roll Sway Power at 0.5Hz")
        elseif dir ==2
            sgtitle("Neck Pitch Sway Power at 0.5Hz")
        end
        ylabel('Sway at Freq of Interest (deg dB/Hz)');
    end
end