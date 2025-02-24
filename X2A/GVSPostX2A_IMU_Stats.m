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
index2 = 0;
freq_power_anova = table;

for profile = interest_profile
    for config = 1:num_config
        for dir = 1:3
            for freq = 1:length(freq_interest)
                if profile_freq(profile) ~= freq_interest(freq) % only care about the frequencies that math the GVS freq
                    continue
                end

                
                index = index +1;
                % Label.power_stats(index) = strjoin([Config(config) Profiles_safe(profile) imu_dir(dir+3)]);
                power_control(:,index) = changem(squeeze(power_interest_reduced(control_current,control_profile,config,:,dir,freq)), nan);
                
                
                power_eval(:,index) = changem(squeeze(power_interest_reduced(interest_current,profile,config,:,dir,freq)), nan);
                
                % save data into table
                num_subs = height(power_eval);

                freq_power_anova.data((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = power_eval(:,index);
                freq_power_anova.data((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = power_control(:,index);                
                      
                freq_power_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "exp";
                freq_power_anova.type((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = "control";                

                freq_power_anova.config((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = Config(config);
                freq_power_anova.config((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = Config(config);

                freq_power_anova.dir((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = imu_dir(dir+3);
                freq_power_anova.dir((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = imu_dir(dir+3);

                freq_power_anova.freq_interest((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2) ) = freq_interest(freq);

                freq_power_anova.sub((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 1:num_subs;
                freq_power_anova.sub((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = 1:num_subs;

                if (config == 1 && dir == 2 )  % binaural config and pitch direction 
                    continue
                elseif (config ==2 || config ==3) && (dir == 1 || dir ==3) % pitch montage and not pitch direction
                    continue
                end
                index2 = index2+1;
                Label.power_stats(index2) = strjoin([Config(config) Profiles_safe(profile) imu_dir(dir+3)]);
                power_control_mat(:,index2) = power_control(:,index);             
                power_eval_mat(:,index2) =  power_eval(:,index);

            end
        end
    end
end

 freq_power_anova( any(ismissing(freq_power_anova),2), :) = [];
% power_control_save = power_control(~isnan(power_control));
% power_eval_save = power_eval(~isnan(power_eval));

for i = 1:length(power_eval_mat)
    p_power(i) = signrank(power_control_mat(:,i),power_eval_mat(:,i));
end
%%
cd(file_path)
writetable(freq_power_anova, "freq_power_anova.csv");
cd(code_path)

%% plots for freq_power_anova

bilateral_power = freq_power_anova(freq_power_anova.config == "Binaural",:);
bilateral_roll_power = bilateral_power(bilateral_power.dir == "roll",:);
bilateral_yaw_power = bilateral_power(bilateral_power.dir == "yaw",:);

pitch_power = freq_power_anova(freq_power_anova.dir == "pitch",:);
pitch_power = pitch_power(pitch_power.config ~= "Binaural",:);

bilateral_roll_power.type(bilateral_roll_power.type == "exp" ) = "GVS"; 
bilateral_roll_power.type(bilateral_roll_power.type == "control" ) = "Control"; 

bilateral_yaw_power.type(bilateral_yaw_power.type == "exp" ) = "GVS"; 
bilateral_yaw_power.type(bilateral_yaw_power.type == "control" ) = "Control"; 

pitch_power.type(pitch_power.type == "exp" ) = "GVS"; 
pitch_power.type(pitch_power.type == "control" ) = "Control"; 

pitch_power.config(pitch_power.config == "Cevete" ) = "Forehead"; 
pitch_power.config(pitch_power.config == "Aoyama" ) = "Temples"; 
%%

bilateral_roll_power_data = cell2mat(table2cell(bilateral_roll_power(:,1)));
bilateral_roll_power_group = strcat(string(bilateral_roll_power.freq_interest), " Hz ", string(bilateral_roll_power.type));

bilateral_yaw_power_data = cell2mat(table2cell(bilateral_yaw_power(:,1)));
bilateral_yaw_power_group = strcat(string(bilateral_yaw_power.freq_interest), " Hz ", string(bilateral_yaw_power.type) );

pitch_power_data = cell2mat(table2cell(pitch_power(:,1)));
pitch_power_group = strcat( string(pitch_power.freq_interest), " Hz ", string(pitch_power.type));
pitch_power_group_montage = strcat(  string(pitch_power.config), " ", string(pitch_power.type));

%%
figure; 
tiledlayout(1,3,"TileSpacing","tight", "Padding","tight")
nexttile
boxplot(bilateral_roll_power_data , bilateral_roll_power_group)
ylabel("Sway at Freq. of Interest (dB/Hz)")
% xlabel("Experimental Condition")
title("Binaural Roll Sway")
ylim([-30 30]);

nexttile
boxplot(bilateral_yaw_power_data , bilateral_yaw_power_group)
% ylabel("Sway at Freq. of Interest (dB/Hz)")
xlabel("Experimental Condition")
title("Binaural Yaw Sway")
ylim([-30 30]);

nexttile
boxplot(pitch_power_data , pitch_power_group)
% ylabel("Sway at Freq. of Interest (dB/Hz)")
% xlabel("Experimental Condition")
title("Forehead + Temples Pitch Sway")
ylim([-30 30]);

sgtitle("Sway For Montage-Direction Combinations of Interest")

figure;
tiledlayout(1,3,"TileSpacing","tight", "Padding","tight")
nexttile
boxplot(pitch_power_data(1:24) , pitch_power_group_montage(1:24))
ylabel("Sway at Freq. of Interest (dB/Hz)")
title("Sine 0.25Hz")
ylim([-21 21]);

nexttile
boxplot(pitch_power_data (25:48) , pitch_power_group_montage(25:48))
xlabel("Experimental Condition")
title("Sine 0.5Hz")
ylim([-21 21]);

nexttile
boxplot(pitch_power_data (49:72) , pitch_power_group_montage(49:72))
title("Sine 1Hz")
ylim([-21 21]);

%% stats for angle displacement 
control_current = 1; 
interest_current = 3; 
control_profile = 2;
interest_profile = 1:2;
profile_freq = [0 0 0.25 0.5 1];
index = 0;
index2 = 0;
ang_disp_anova = table;

for profile = interest_profile
    for config = 1:num_config
        for dir = 1:2

               index = index +1;
                % Label.power_stats(index) = strjoin([Config(config) Profiles_safe(profile) imu_dir(dir+3)]);
                displacement_control(:,index) = changem(squeeze(angle_drift_reduced(control_current,control_profile,config,:,dir)), nan);
                
                
                displacement_eval(:,index) = changem(squeeze(angle_drift_reduced(interest_current,profile,config,:,dir)), nan);
                
                % save data into table
                num_subs = height(displacement_eval);

                ang_disp_anova.data((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = displacement_eval(:,index);
                ang_disp_anova.data((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = displacement_control(:,index);                
                      
                ang_disp_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "exp";
                ang_disp_anova.type((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = "control";                

                ang_disp_anova.config((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = Config(config);
                ang_disp_anova.config((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = Config(config);

                ang_disp_anova.dir((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = imu_dir(dir+3);
                ang_disp_anova.dir((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = imu_dir(dir+3);

                ang_disp_anova.profile((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2) ) = Profiles_safe(profile);

                ang_disp_anova.sub((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 1:num_subs;
                ang_disp_anova.sub((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = 1:num_subs;


                if config == 1 && dir == 2 % binaural config and pitch direction
                    continue
                elseif (config ==2 || config ==3) && (dir == 1 || dir ==3) % pitch montage and not pitch direction
                    continue
                end
                
               index2 = index2+1;
                Label.angle_drift_stats(index2) = strjoin([Config(config) Profiles_safe(profile) imu_dir(dir+3)]);
                drift_control(:,index2) = changem(squeeze(angle_drift_reduced(control_current,control_profile,config,:,dir)), nan);
                
                drift_eval(:,index2) = changem(squeeze(angle_drift_reduced(interest_current,profile,config,:,dir)), nan);
                            
        end
    end
end

% for i = 1:width(drift_eval)
%     p_drift(i) = signrank(drift_control(:,i),drift_eval(:,i));
% end


for i = 1:width(drift_eval)/2
    p_drift(i) = signrank(drift_eval(:,i),drift_eval(:,i+3)); % comparing positive and negative responses (rather than to the control response)
end

%% save table as csv to load into R
cd(file_path)
writetable(ang_disp_anova, "ang_disp_anova.csv");
cd(code_path)

%% plots for ang_disp_anova

bilateral_disp = ang_disp_anova(ang_disp_anova.config == "Binaural",:);
bilateral_roll_disp = bilateral_disp(bilateral_disp.dir == "roll",:);

pitch_disp = ang_disp_anova(ang_disp_anova.dir == "pitch",:);
pitch_disp = pitch_disp(pitch_disp.config ~= "Binaural",:);

bilateral_roll_disp.type(bilateral_roll_disp.type == "exp" ) = "GVS"; 
bilateral_roll_disp.type(bilateral_roll_disp.type == "control" ) = "Control"; 

bilateral_roll_disp.profile(bilateral_roll_disp.profile == "DCRight_Front" ) = "+ DC ";
bilateral_roll_disp.profile(bilateral_roll_disp.profile == "DCLeft_Back" ) = "- DC "; 

pitch_disp.type(pitch_disp.type == "exp" ) = "GVS"; 
pitch_disp.type(pitch_disp.type == "control" ) = "Control"; 

pitch_disp.profile(pitch_disp.profile == "DCRight_Front" ) = "+ DC "; 
pitch_disp.profile(pitch_disp.profile == "DCLeft_Back" ) = "- DC "; 

pitch_disp.config(pitch_disp.config == "Cevete" ) = "Forehead "; 
pitch_disp.config(pitch_disp.config == "Aoyama" ) = "Temples "; 

%%

bilateral_roll_disp_data = cell2mat(table2cell(bilateral_roll_disp(:,1)));
bilateral_roll_disp_group = strcat(string(bilateral_roll_disp.profile), string( bilateral_roll_disp.type) );

pitch_disp_data = cell2mat(table2cell(pitch_disp(:,1)));
pitch_disp_group = strcat( string(pitch_disp.profile), string(pitch_disp.type) );
pitch_disp_group_montage = strcat( string(pitch_disp.config), string(pitch_disp.type ));

%%
figure;
tiledlayout(1,2,"TileSpacing","tight", "Padding","tight")
nexttile
boxplot(bilateral_roll_disp_data , bilateral_roll_disp_group)
ylabel("Sway Displacement (deg)")
% xlabel("Experimental Condition")
title("Binaural Roll Sway")
ylim([-82 82]);

nexttile
boxplot(pitch_disp_data , pitch_disp_group)
% ylabel("Sway Displacement (deg)")
xlabel("Experimental Condition")
title("Forehead + Temples Pitch Sway")
ylim([-10 10]);
sgtitle("Sway For Montage-Direction Combinations of Interest")

figure;
tiledlayout(1,2,"TileSpacing","tight", "Padding","tight")
nexttile
boxplot(pitch_disp_data (1:36), pitch_disp_group_montage(1:36))
ylabel("Sway Displacement (deg)")
xlabel("Experimental Condition")
title("DC +")
ylim([-10 10]);

nexttile
boxplot(pitch_disp_data (37:72), pitch_disp_group_montage(37:72))
% ylabel("Sway Displacement (deg)")
xlabel("Experimental Condition")
title("DC -")
ylim([-10 10]);

%%%%%%