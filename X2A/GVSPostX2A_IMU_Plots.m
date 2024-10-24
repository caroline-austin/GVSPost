%% script 3
% Created by: Caroline Austin
% Modified by: Caroline Austin
% 10/23/24

clear all; close all; clc;
code_path = pwd;

%% Experimental Methods Specifications
file_path = uigetdir; %user selects file directory './Subject Data/'; %I replaced this so the person can directly choose where to pull the data from

subnum = [2001:2010];  % Subject List 2001:2010 2001:2010
numsub = length(subnum);
subskip = [2001 2008 2010];  %DNF'd subjects

%% plot info
 plots = ['1 2'];

 % plot 1 creates box plots for the rms metric
 % plot 2 plots the raw data for a given trial

 %% initialize  

% colors- first 5 are color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
yellow = [255 190 50]/255;
Color_list = [blue; green; yellow; red; navy; purple];

%naming variables 
Profiles = ["DC Right/Front"; "DC Left/Back"; "Sin 0.25Hz"; "Sin 0.5Hz"; "Sin 1Hz"];
Profiles_safe = ["DCRight-Front"; "DCLeft-Back"; "Sin0_25Hz"; "Sin0_5Hz"; "Sin1Hz"];
num_profiles = length(Profiles);



%% load data 
cd([file_path]);
load(['Allimu.mat'])
cd(code_path);

config = Label.Config;
num_config = length(config);
current_amp = Label.CurrentAmp ;
num_current = length(current_amp);
imu_dir = ['x' 'y' 'z' "roll" "pitch" "yaw"];


if contains(plots,'1 ')
%% plot 1
f1 = figure();
tiledlayout(3,1, 'Padding', 'none', 'TileSpacing', 'compact'); 
sgtitle ('Roll direction RMS of 0.5Hz Profiles ')
f2 = figure();
tiledlayout(3,1, 'Padding', 'none', 'TileSpacing', 'compact'); 
sgtitle ('Pitch direction RMS of 0.5Hz Profiles ')
f3 = figure();
tiledlayout(3,1, 'Padding', 'none', 'TileSpacing', 'compact'); 
sgtitle ('Yaw direction RMS of 0.5Hz Profiles ')
% organize data into plotting variable
    for j = 1:num_config
        for i = 1:num_current
            rms_plot.(config(j)).(imu_dir(4))(:,i) = rms_save{i,4,j}(:,4);
            rms_plot.(config(j)).(imu_dir(5))(:,i) = rms_save{i,4,j}(:,5);
            rms_plot.(config(j)).(imu_dir(6))(:,i) = rms_save{i,4,j}(:,6);

        end
        figure(f1)
        nexttile
        boxplot(rms_plot.(config(j)).(imu_dir(4)));
        hold on;
        title(config(j));
        xticks([1,2,3,4,5,6,7,8,9]);
        xticklabels(["0.1" ,"0.5" ,"1" ,"1.5" ,"2", "2.5" ,"3" ,"3.5" ,"4"]);
        if j ==2
            ylabel("RMS (deg/s)")
        elseif j == 3
        xlabel("Current Amplitude (mA)")
        end
        ylim([0 0.25]);
        grid minor
        

        figure(f2)
        nexttile
        boxplot(rms_plot.(config(j)).(imu_dir(5)));
        hold on;
        title(config(j));
        xticks([1,2,3,4,5,6,7,8,9]);
        xticklabels(["0.1" ,"0.5" ,"1" ,"1.5" ,"2", "2.5" ,"3" ,"3.5" ,"4"]);
        if j ==2
            ylabel("RMS (deg/s)")
        elseif j == 3
        xlabel("Current Amplitude (mA)")
        end
        ylim([0 0.31]);
        grid minor

        figure(f3)
        nexttile
        boxplot(rms_plot.(config(j)).(imu_dir(6)));
        hold on;
        title(config(j));
        xticks([1,2,3,4,5,6,7,8,9]);
        xticklabels(["0.1" ,"0.5" ,"1" ,"1.5" ,"2", "2.5" ,"3" ,"3.5" ,"4"]);
        if j ==2
            ylabel("RMS (deg/s)")
        elseif j == 3
        xlabel("Current Amplitude (mA)")
        end
        ylim([0 0.25]);
        grid minor

    end

end

if contains(plots,'2 ')
%% plot 2

% organize data into plotting variable


end




