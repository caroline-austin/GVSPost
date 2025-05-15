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
        for dir = 1:2
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
for dir = 1:2
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
        forehead_power_group= reshape(forehead_power,[],1);
        shoulder_power_group= reshape(shoulder_power,[],1);
        neck_power_group= reshape(neck_power,[],1);
        boxplot([forehead_power_group shoulder_power_group neck_power_group]);
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