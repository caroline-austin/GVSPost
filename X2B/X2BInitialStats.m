%% script 3
% Created by: Caroline Austin
% Modified by: Caroline Austin
% exports data to .csv for R analysis and runs basic non-parametric tests
% and creates box plots for the metrics
% 10/23/24

clear all; close all; clc;
code_path = pwd;

%% Experimental Methods Specifications
file_path = uigetdir; %user selects file directory './Subject Data/'; %I replaced this so the person can directly choose where to pull the data from

subnum = [2034:2043];  % Subject List 2001:2010 2001:2010
numsub = length(subnum);
subskip = [2001 2004 2008 2010];  %DNF'd subjects


 %% initialize  


%naming variables 
Profiles = [ "Sin 0.5Hz"];
Profiles_safe = [ "Sin0_5Hz"];
num_profiles = length(Profiles);
Config = ["Forhead" "Shoulder" "Neck"];



%% load data 
cd([file_path]);
load(['Allimu.mat'])
cd(code_path);

imu_dir = ["roll" "pitch" "yaw" ];


%% power_interest stats 
control_current = 1; 
interest_current = 3; 
control_profile = 2;
interest_profile = 1;
profile_freq = [ 0.5 ];
index = 0;
index2 = 0;
freq_power_anova = table;
freq_interest = [ 0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.5 0.6 0.75 0.8 0.9 1 1.1 1.2 1.25];

for profile = interest_profile
    for trial = [1:8, 11:18, 21:28] % update to dynamic variable
        if trial <10
            replicate_order = trial;
        elseif trial <20
            replicate_order = trial-10;
        else
            replicate_order = trial-20;
        end
        config = Label.all_config_sort(:,trial);

        for dir = 1:2
            for freq = 1:length(freq_interest)
                if profile_freq(profile) ~= freq_interest(freq) % only care about the frequencies that math the GVS freq
                    continue
                end

                
                index = index +1;            
                
                power_eval(:,index) = changem(squeeze(power_interest_sort(trial,:,dir,freq)), nan);
                
                % save data into table
                num_subs = height(power_eval);

                freq_power_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = power_eval(:,index);
                 
                freq_power_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "exp";

                freq_power_anova.order((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = replicate_order;

                freq_power_anova.config((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) =Config(config);

                freq_power_anova.dir((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = imu_dir(dir);

                freq_power_anova.freq_interest((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2) ) = freq_interest(freq);

                freq_power_anova.sub((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 1:num_subs;


                index2 = index2+1;
                Label.power_stats(index2) = strjoin([ "trial" num2str(trial) imu_dir(dir) Config(max(config))]);
                power_eval_mat(:,index2) =  power_eval(:,index);

            end
        end
    end
end

freq_power_anova( any(ismissing(freq_power_anova),2), :) = [];
power_eval_save = power_eval(~isnan(power_eval));

% for i = 1:length(power_eval_mat)
%     p_power(i) = signrank(power_control_mat(:,i),power_eval_mat(:,i));
% end
% %%
cd(file_path)
writetable(freq_power_anova, "freq_power_anova.csv");
cd(code_path)
%%


% %% plots
% figure; 
% tiledlayout(1,3,"TileSpacing","tight", "Padding","tight")
% nexttile
% boxplot(bilateral_roll_power_data , bilateral_roll_power_group)
% ylabel("Sway at Freq. of Interest (dB/Hz)")
% % xlabel("Experimental Condition")
% title("Binaural Roll Sway")
% ylim([-30 30]);
% 
% nexttile
% boxplot(bilateral_yaw_power_data , bilateral_yaw_power_group)
% % ylabel("Sway at Freq. of Interest (dB/Hz)")
% xlabel("Experimental Condition")
% title("Binaural Yaw Sway")
% ylim([-30 30]);
% 
% nexttile
% boxplot(pitch_power_data , pitch_power_group)
% % ylabel("Sway at Freq. of Interest (dB/Hz)")
% % xlabel("Experimental Condition")
% title("Forehead + Temples Pitch Sway")
% ylim([-30 30]);
% 
% sgtitle("Sway For Montage-Direction Combinations of Interest")
% 
% figure;
% tiledlayout(1,3,"TileSpacing","tight", "Padding","tight")
% nexttile
% boxplot(pitch_power_data(1:24) , pitch_power_group_montage(1:24))
% ylabel("Sway at Freq. of Interest (dB/Hz)")
% title("Sine 0.25Hz")
% ylim([-21 21]);
% 
% nexttile
% boxplot(pitch_power_data (25:48) , pitch_power_group_montage(25:48))
% xlabel("Experimental Condition")
% title("Sine 0.5Hz")
% ylim([-21 21]);
% 
% nexttile
% boxplot(pitch_power_data (49:72) , pitch_power_group_montage(49:72))
% title("Sine 1Hz")
% ylim([-21 21]);
% 
% 
% 
% %% paper plot 
% figure('Position', [100, 100, 1200, 900]);
% tiledlayout(2,3,"TileSpacing","tight", "Padding","tight")
% 
% 
% nexttile
% boxplot(pitch_power_data , pitch_power_group)
% % ylabel("Sway at Freq. of Interest (dB/Hz)")
% % xlabel("Experimental Condition")
% title("Forehead + Temples Pitch Sway")
% ylim([-40 30]);


