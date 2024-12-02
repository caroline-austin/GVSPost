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
subskip = [2001 2004 2008 2010];  %DNF'd subjects


 %% initialize  


%naming variables 
Profiles = ["DC Right/Front"; "DC Left/Back"; "Sin 0.25Hz"; "Sin 0.5Hz"; "Sin 1Hz"];
Profiles_safe = ["DCRight_Front"; "DCLeft_Back"; "Sin0_25Hz"; "Sin0_5Hz"; "Sin1Hz"];
num_profiles = length(Profiles);



%% load data 
cd([file_path]);
load(['Allimu.mat'])
cd(code_path);

Config = Label.Config;
num_config = length(Config);
Current_amp = Label.CurrentAmp ;
num_current = length(Current_amp);
imu_dir = ['x' 'y' 'z' "roll" "pitch" "yaw" "yaw" "pitch" "roll"];


%% power_interest stats (with log transform)
control_current = 1; 
interest_current = 3; 
control_profile = 2;
interest_profile = 3:5;
profile_freq = [0 0 0.25 0.5 1];
index = 0;

for profile = interest_profile
    for config = 1:num_config
        for dir = 1:3
            for freq = 1:length(freq_interest)

                if profile_freq(profile) ~= freq_interest(freq) % only care about the frequencies that math the GVS freq
                    continue
                elseif config == 1 && dir == 2 % binaural config and pitch direction
                    continue
                elseif (config ==2 || config ==3) && (dir == 1 || dir ==3) % pitch montage and not pitch direction
                    continue
                end
                
                index = index +1;
                Label.power_stats(index) = strjoin([Config(config) Profiles_safe(profile) imu_dir(dir+3)]);
                power_control(:,index) = changem(squeeze(power_interest_reduced(control_current,control_profile,config,:,dir,freq)), nan);
                
                
                power_eval(:,index) = changem(squeeze(power_interest_reduced(interest_current,profile,config,:,dir,freq)), nan);
                

            end
        end
    end
end

% power_control_save = power_control(~isnan(power_control));
% power_eval_save = power_eval(~isnan(power_eval));

for i = 1:length(power_eval)
    p_power(i) = signrank(power_control(:,i),power_eval(:,i));
end

%% stats for angle displacement 
control_current = 1; 
interest_current = 3; 
control_profile = 2;
interest_profile = 1:2;
profile_freq = [0 0 0.25 0.5 1];
index = 0;

for profile = interest_profile
    for config = 1:num_config
        for dir = 1:2
                if config == 1 && dir == 2 % binaural config and pitch direction
                    continue
                elseif (config ==2 || config ==3) && (dir == 1 || dir ==3) % pitch montage and not pitch direction
                    continue
                end
                
                index = index +1;
                Label.angle_drift_stats(index) = strjoin([Config(config) Profiles_safe(profile) imu_dir(dir+3)]);
                drift_control(:,index) = changem(squeeze(angle_drift_reduced(control_current,control_profile,config,:,dir)), nan);
                
                drift_eval(:,index) = changem(squeeze(angle_drift_reduced(interest_current,profile,config,:,dir)), nan);
                

            
        end
    end
end

% for i = 1:width(drift_eval)
%     p_drift(i) = signrank(drift_control(:,i),drift_eval(:,i));
% end

for i = 1:width(drift_eval)/2
    p_drift(i) = signrank(drift_eval(:,i),drift_eval(:,i+3)); % comparing positive and negative responses (rather than to the control response)
end