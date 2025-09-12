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
% control_profile = 2; % have to set as 1 for the aoyama bc of how the
% current was run
interest_profile = 3:5;
profile_freq = [0 0 0.25 0.5 1];
index = 0;
index2 = 0;
freq_power_anova = table;
freq_power_log_anova = table;
power_val_anova = table;
mag_anova = table;

for profile = interest_profile
    for config = 1:num_config
        for dir = 1:3
            for freq = 1:length(freq_interest)
                if profile_freq(profile) ~= freq_interest(freq) || freq_interest(freq) == 0% only care about the frequencies that match the GVS freq
                    continue
                else
                    if freq_interest(freq) == 0.25
                        val_index = 1;
                    elseif freq_interest(freq) == 0.5
                        val_index = 2;
                    elseif freq_interest(freq) == 1
                        val_index = 3;
                    else 
                        val_index =0;
                    end
                    if config == 3
                        control_profile =1;
                    else
                        control_profile =2;
                    end
                end

                
                index = index +1;
                % Label.power_stats(index) = strjoin([Config(config) Profiles_safe(profile) imu_dir(dir+3)]);
                power_control(:,index) = changem(squeeze(power_interest_reduced(control_current,control_profile,config,:,dir,freq)), nan);               
                power_eval(:,index) = changem(squeeze(power_interest_reduced(interest_current,profile,config,:,dir,freq)), nan);

                power_log_control(:,index) = changem(squeeze(power_interest_log_reduced(control_current,control_profile,config,:,dir,freq)), nan);               
                power_log_eval(:,index) = changem(squeeze(power_interest_log_reduced(interest_current,profile,config,:,dir,freq)), nan);
                               
                num_subs = height(power_eval);

                   % save data into table 
                power_val_control(:,index) = changem(squeeze(power_values_reduced(control_current,control_profile,config,:,dir,val_index)), nan);               
                power_val_eval(:,index) = changem(squeeze(power_values_reduced(interest_current,profile,config,:,dir,val_index)), nan);
                                %%% %save data into table
                power_val_anova.data((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = power_val_eval(:,index);
                power_val_anova.data((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = power_val_control(:,index); 
                 
                power_val_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "exp";
                power_val_anova.type((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = "control";                

                power_val_anova.config((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = Config(config);
                power_val_anova.config((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = Config(config);

                power_val_anova.dir((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = imu_dir(dir+3);
                power_val_anova.dir((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = imu_dir(dir+3);

                power_val_anova.freq_interest((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2) ) = freq_interest(freq);

                power_val_anova.sub((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 1:num_subs;
                power_val_anova.sub((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = 1:num_subs;

                % save data into table 
                mag_control(:,index) = changem(squeeze(mag_interest_reduced(control_current,control_profile,config,:,dir,val_index)), nan);               
                mag_eval(:,index) = changem(squeeze(mag_interest_reduced(interest_current,profile,config,:,dir,val_index)), nan);
                                %%% %save data into table
                mag_anova.data((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = mag_eval(:,index);
                mag_anova.data((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = mag_control(:,index); 
                 
                mag_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "exp";
                mag_anova.type((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = "control";                

                mag_anova.config((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = Config(config);
                mag_anova.config((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = Config(config);

                mag_anova.dir((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = imu_dir(dir+3);
                mag_anova.dir((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = imu_dir(dir+3);

                mag_anova.freq_interest((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2) ) = freq_interest(freq);

                mag_anova.sub((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 1:num_subs;
                mag_anova.sub((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = 1:num_subs;

                % save data into table
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


                 % save data into table
                freq_power_log_anova.data((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = power_log_eval(:,index);
                freq_power_log_anova.data((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = power_log_control(:,index);  

                     
                freq_power_log_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "exp";
                freq_power_log_anova.type((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = "control";                

                freq_power_log_anova.config((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = Config(config);
                freq_power_log_anova.config((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = Config(config);

                freq_power_log_anova.dir((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = imu_dir(dir+3);
                freq_power_log_anova.dir((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = imu_dir(dir+3);

                freq_power_log_anova.freq_interest((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2) ) = freq_interest(freq);

                freq_power_log_anova.sub((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 1:num_subs;
                freq_power_log_anova.sub((index*num_subs*2 - num_subs +1):(index*num_subs*2) ) = 1:num_subs;


                if (config == 1 && dir == 2 )  % binaural config and pitch direction 
                    continue
                elseif (config ==2 || config ==3) && (dir == 1 || dir ==3) % pitch montage and not pitch direction
                    continue
                end
                index2 = index2+1;
                Label.power_stats(index2) = strjoin([Config(config) Profiles_safe(profile) imu_dir(dir+3)]);
                power_control_mat(:,index2) = power_control(:,index);             
                power_eval_mat(:,index2) =  power_eval(:,index);

                power_log_control_mat(:,index2) = power_log_control(:,index);             
                power_log_eval_mat(:,index2) =  power_log_eval(:,index);

                if freq<=3
                    power_val_control_mat(:,index2) = power_val_control(:,index);             
                    power_val_eval_mat(:,index2) =  power_val_eval(:,index);
                end

            end
        end
    end
end

 freq_power_anova( any(ismissing(freq_power_anova),2), :) = [];
 freq_power_log_anova( any(ismissing(freq_power_log_anova),2), :) = [];
 power_val_anova( any(ismissing(power_val_anova),2), :) = [];
 mag_anova( any(ismissing(mag_anova),2), :) = [];
% power_control_save = power_control(~isnan(power_control));
% power_eval_save = power_eval(~isnan(power_eval));

for i = 1:length(power_eval_mat)
    p_power(i) = signrank(power_control_mat(:,i),power_eval_mat(:,i));
end
%
cd(file_path)
writetable(freq_power_anova, "freq_power_anova.csv");
cd(code_path)

cd(file_path)
writetable(freq_power_log_anova, "freq_power_log_anova.csv");
cd(code_path)

cd(file_path)
writetable(power_val_anova, "power_val_anova.csv");
cd(code_path)

cd(file_path)
writetable(mag_anova, "mag_anova.csv");
cd(code_path)

%% plots for freq_power_anova

bilateral_power = freq_power_anova(freq_power_anova.config == "Binaural",:);
bilateral_roll_power = bilateral_power(bilateral_power.dir == "roll",:);
bilateral_yaw_power = bilateral_power(bilateral_power.dir == "yaw",:);

pitch_power = freq_power_anova(freq_power_anova.dir == "pitch",:);
pitch_power = pitch_power(pitch_power.config ~= "Binaural",:);

bilateral_roll_power.type(bilateral_roll_power.type == "exp" ) = "GVS"; 
bilateral_roll_power.type(bilateral_roll_power.type == "control" ) = "Sham"; 

bilateral_yaw_power.type(bilateral_yaw_power.type == "exp" ) = "GVS"; 
bilateral_yaw_power.type(bilateral_yaw_power.type == "control" ) = "Sham"; 

pitch_power.type(pitch_power.type == "exp" ) = "GVS"; 
pitch_power.type(pitch_power.type == "control" ) = "Sham"; 

pitch_power.config(pitch_power.config == "Cevete" ) = "Forehead"; 
pitch_power.config(pitch_power.config == "Aoyama" ) = "Temples"; 

%% plots for freq_power_log_anova

bilateral_power_log = freq_power_log_anova(freq_power_log_anova.config == "Binaural",:);
bilateral_roll_power_log = bilateral_power_log(bilateral_power_log.dir == "roll",:);
bilateral_yaw_power_log = bilateral_power_log(bilateral_power_log.dir == "yaw",:);

pitch_power_log = freq_power_log_anova(freq_power_log_anova.dir == "pitch",:);
pitch_power_log = pitch_power_log(pitch_power_log.config ~= "Binaural",:);

bilateral_roll_power_log.type(bilateral_roll_power_log.type == "exp" ) = "GVS"; 
bilateral_roll_power_log.type(bilateral_roll_power_log.type == "control" ) = "Sham"; 

bilateral_yaw_power_log.type(bilateral_yaw_power_log.type == "exp" ) = "GVS"; 
bilateral_yaw_power_log.type(bilateral_yaw_power_log.type == "control" ) = "Sham"; 

pitch_power_log.type(pitch_power_log.type == "exp" ) = "GVS"; 
pitch_power_log.type(pitch_power_log.type == "control" ) = "Sham"; 

pitch_power_log.config(pitch_power_log.config == "Cevete" ) = "Forehead"; 
pitch_power_log.config(pitch_power_log.config == "Aoyama" ) = "Temples"; 

%%
bilateral_power_val = power_val_anova(power_val_anova.config == "Binaural",:);
bilateral_roll_power_val = bilateral_power_val(bilateral_power_val.dir == "roll",:);
bilateral_yaw_power_val = bilateral_power_val(bilateral_power_val.dir == "yaw",:);

pitch_power_val = power_val_anova(power_val_anova.dir == "pitch",:);
pitch_power_val = pitch_power_val(pitch_power_val.config ~= "Binaural",:);

bilateral_roll_power_val.type(bilateral_roll_power_val.type == "exp" ) = "GVS"; 
bilateral_roll_power_val.type(bilateral_roll_power_val.type == "control" ) = "Sham"; 

bilateral_yaw_power_val.type(bilateral_yaw_power_val.type == "exp" ) = "GVS"; 
bilateral_yaw_power_val.type(bilateral_yaw_power_val.type == "control" ) = "Sham"; 

pitch_power_val.type(pitch_power_val.type == "exp" ) = "GVS"; 
pitch_power_val.type(pitch_power_val.type == "control" ) = "Sham"; 

pitch_power_val.config(pitch_power_val.config == "Cevete" ) = "Forehead"; 
pitch_power_val.config(pitch_power_val.config == "Aoyama" ) = "Temples"; 

%%
bilateral_mag = mag_anova(mag_anova.config == "Binaural",:);
bilateral_roll_mag = bilateral_mag(bilateral_mag.dir == "roll",:);
bilateral_yaw_mag = bilateral_mag(bilateral_mag.dir == "yaw",:);

pitch_mag = mag_anova(mag_anova.dir == "pitch",:);
pitch_mag = pitch_mag(pitch_mag.config ~= "Binaural",:);

bilateral_roll_mag.type(bilateral_roll_mag.type == "exp" ) = "GVS"; 
bilateral_roll_mag.type(bilateral_roll_mag.type == "control" ) = "Sham"; 

bilateral_yaw_mag.type(bilateral_yaw_mag.type == "exp" ) = "GVS"; 
bilateral_yaw_mag.type(bilateral_yaw_mag.type == "control" ) = "Sham"; 

pitch_mag.type(pitch_mag.type == "exp" ) = "GVS"; 
pitch_mag.type(pitch_mag.type == "control" ) = "Sham"; 

pitch_mag.config(pitch_mag.config == "Cevete" ) = "Forehead"; 
pitch_mag.config(pitch_power_val.config == "Aoyama" ) = "Temples"; 
%%

bilateral_roll_power_data = cell2mat(table2cell(bilateral_roll_power(:,1)));
bilateral_roll_power_group = strcat(string(bilateral_roll_power.freq_interest), " Hz ", string(bilateral_roll_power.type));

bilateral_yaw_power_data = cell2mat(table2cell(bilateral_yaw_power(:,1)));
bilateral_yaw_power_group = strcat(string(bilateral_yaw_power.freq_interest), " Hz ", string(bilateral_yaw_power.type) );

pitch_power_data = cell2mat(table2cell(pitch_power(:,1)));
pitch_power_group = strcat( string(pitch_power.freq_interest), " Hz ", string(pitch_power.type));
pitch_power_group_montage = strcat(  string(pitch_power.config), " ", string(pitch_power.type));




%%

bilateral_roll_power_log_data = cell2mat(table2cell(bilateral_roll_power_log(:,1)));
bilateral_roll_power_log_group = strcat(string(bilateral_roll_power_log.freq_interest), " Hz ", string(bilateral_roll_power_log.type));

bilateral_yaw_power_log_data = cell2mat(table2cell(bilateral_yaw_power_log(:,1)));
bilateral_yaw_power_log_group = strcat(string(bilateral_yaw_power_log.freq_interest), " Hz ", string(bilateral_yaw_power_log.type) );

pitch_power_log_data = cell2mat(table2cell(pitch_power_log(:,1)));
pitch_power_log_group = strcat( string(pitch_power_log.freq_interest), " Hz ", string(pitch_power_log.type));
pitch_power_log_group_montage = strcat(  string(pitch_power_log.config), " ", string(pitch_power_log.type));

%%
bilateral_roll_power_val_data = cell2mat(table2cell(bilateral_roll_power_val(:,1)));
bilateral_roll_power_val_group = strcat(string(bilateral_roll_power_val.freq_interest), " Hz ", string(bilateral_roll_power_val.type));

bilateral_yaw_power_val_data = cell2mat(table2cell(bilateral_yaw_power_val(:,1)));
bilateral_yaw_power_val_group = strcat(string(bilateral_yaw_power_val.freq_interest), " Hz ", string(bilateral_yaw_power_val.type) );

pitch_power_val_data = cell2mat(table2cell(pitch_power_val(:,1)));
pitch_power_val_group = strcat( string(pitch_power_val.freq_interest), " Hz ", string(pitch_power_val.type));
pitch_power_val_group_montage = strcat(  string(pitch_power_val.config), " ", string(pitch_power_val.type));

%%
bilateral_roll_mag_data = cell2mat(table2cell(bilateral_roll_mag(:,1)));
bilateral_roll_mag_group = strcat(string(bilateral_roll_mag.freq_interest), " Hz ", string(bilateral_roll_mag.type));

bilateral_yaw_mag_data = cell2mat(table2cell(bilateral_yaw_mag(:,1)));
bilateral_yaw_mag_group = strcat(string(bilateral_yaw_mag.freq_interest), " Hz ", string(bilateral_yaw_mag.type) );

pitch_mag_data = cell2mat(table2cell(pitch_mag(:,1)));
pitch_mag_group = strcat( string(pitch_mag.freq_interest), " Hz ", string(pitch_mag.type));
pitch_mag_group_montage = strcat(  string(pitch_mag.freq_interest), " Hz ", string(pitch_mag.type), " ", strrep(string(pitch_mag.config), "Aoyama", "Temples"));

%%
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

%% stats for angle displacement 
control_current = 1; 
interest_current = 3; 
% control_profile = 2; % have to update in loop bc it is different for
% aoyama
interest_profile = 1:2;
profile_freq = [0 0 0.25 0.5 1];
index = 0;
index2 = 0;
ang_disp_anova = table;
sub_include = [2 3 5 6 7 9];

for profile = interest_profile
    for config = 1:num_config
        for dir = 1:2

               index = index +1;
                % Label.power_stats(index) = strjoin([Config(config) Profiles_safe(profile) imu_dir(dir+3)]);

                if config == 3
                    control_profile =1;
                else
                    control_profile =2;
                end

                displacement_control(:,index) = changem(squeeze(angle_drift_reduced(control_current,control_profile,config,sub_include,dir)), nan);
                
                if profile == 1
                
                    displacement_eval(:,index) = changem(squeeze(angle_drift_reduced(interest_current,profile,config,sub_include,dir)), nan);
                elseif profile ==2
                    displacement_eval(:,index) = changem(squeeze(angle_drift_reduced(interest_current,profile,config,sub_include,dir)), nan);
                end
                
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
                drift_control(:,index2) = changem(squeeze(angle_drift_reduced(control_current,control_profile,config,sub_include,dir)), nan);
                
                drift_eval(:,index2) = changem(squeeze(angle_drift_reduced(interest_current,profile,config,sub_include,dir)), nan);
                            
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
bilateral_roll_disp.type(bilateral_roll_disp.type == "control" ) = "Sham"; 

bilateral_roll_disp.profile(bilateral_roll_disp.profile == "DCRight_Front" ) = "+ DC ";
bilateral_roll_disp.profile(bilateral_roll_disp.profile == "DCLeft_Back" ) = "- DC "; 

pitch_disp.type(pitch_disp.type == "exp" ) = "GVS"; 
pitch_disp.type(pitch_disp.type == "control" ) = "Sham"; 

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
% figure;
% tiledlayout(1,2,"TileSpacing","tight", "Padding","tight")
% nexttile
% boxplot(bilateral_roll_disp_data , bilateral_roll_disp_group) 
% ylabel("Sway Displacement (deg)")
% % xlabel("Experimental Condition")
% title("Binaural Roll Sway")
% ylim([-82 82]);
% 
% nexttile
% boxplot(pitch_disp_data , pitch_disp_group)
% % ylabel("Sway Displacement (deg)")
% xlabel("Experimental Condition")
% title("Forehead + Temples Pitch Sway")
% ylim([-10 10]);
% sgtitle("Sway For Montage-Direction Combinations of Interest")
% 
% figure;
% tiledlayout(1,2,"TileSpacing","tight", "Padding","tight")
% nexttile
% boxplot(pitch_disp_data (1:24), pitch_disp_group_montage(1:24))
% ylabel("Sway Displacement (deg)")
% xlabel("Experimental Condition")
% title("DC +")
% ylim([-10 10]);
% 
% nexttile
% boxplot(pitch_disp_data (25:48), pitch_disp_group_montage(25:48))
% % ylabel("Sway Displacement (deg)")
% xlabel("Experimental Condition")
% title("DC -")
% ylim([-10 10]);

%% paper plot option 1
% figure('Position', [100, 100, 1200, 900]);
% tiledlayout(2,3,"TileSpacing","tight", "Padding","tight")
% 
% colors = [0 0 0; .5 .5 .5; 0 0 0; .5 .5 .5; 0 0 0; .5 .5 .5];
% nexttile(3)
% % boxplot(pitch_power_data , pitch_power_group, 'Colors', colors)
% 
% % Unique groups and color map
% uniqueGroups = categories(categorical(pitch_power_group));
% % Plot using boxchart
% for i = 1:numel(uniqueGroups)
%     idx = pitch_power_group == uniqueGroups{i};
%     boxchart(ones(sum(idx),1)*i, pitch_power_data(idx), 'BoxFaceColor', colors(i,:));
%     hold on;
% end
% 
% xticks([1 2 3 4 5 6])
% xticklabels(uniqueGroups)
% 
% % ylabel("Sway at Freq. of Interest (dB/Hz)")
% % xlabel("Experimental Condition")
% title("Forehead + Temples Pitch Sway")
% ylim([-40 30]);
% 
% nexttile(1)
% % boxplot(bilateral_roll_power_data , bilateral_roll_power_group)
% 
% % Unique groups and color map
% uniqueGroups = categories(categorical(bilateral_roll_power_group));
% % Plot using boxchart
% for i = 1:numel(uniqueGroups)
%     idx = bilateral_roll_power_group == uniqueGroups{i};
%     boxchart(ones(sum(idx),1)*i, bilateral_roll_power_data(idx), 'BoxFaceColor', colors(i,:));
%     hold on;
% end
% 
% xticks([1 2 3 4 5 6])
% xticklabels(uniqueGroups)
% 
% ylabel("Sway at Freq. of Interest (dB/Hz)")
% % xlabel("Experimental Condition")
% title("Binaural Roll Sway")
% ylim([-40 30]);
% 
% nexttile(2)
% % boxplot(bilateral_yaw_power_data , bilateral_yaw_power_group)
% 
% % Unique groups and color map
% uniqueGroups = categories(categorical(bilateral_yaw_power_group));
% % Plot using boxchart
% for i = 1:numel(uniqueGroups)
%     idx = bilateral_yaw_power_group == uniqueGroups{i};
%     boxchart(ones(sum(idx),1)*i, bilateral_yaw_power_data(idx), 'BoxFaceColor', colors(i,:));
%     hold on;
% end
% 
% % ylabel("Sway at Freq. of Interest (dB/Hz)")
% % xlabel("Experimental Condition")
% title("Binaural Yaw Sway")
% ylim([-40 30]);
% 
% xticks([1 2 3 4 5 6])
% xticklabels(uniqueGroups)
% 
% nexttile(6)
% boxplot(pitch_disp_data([1:30 37:42]) , pitch_disp_group([1:30 37:42]))
% 
% pitch_disp_data_plot = pitch_disp_data([1:30 37:42]);
% pitch_disp_group_plot = pitch_disp_group([1:30 37:42]);
% % Unique groups and color map
% uniqueGroups = categories(categorical(pitch_disp_group_plot));
% % Plot using boxchart
% for i = 1:numel(uniqueGroups)
%     idx = pitch_disp_group_plot == uniqueGroups{i};
%     boxchart(ones(sum(idx),1)*i, pitch_disp_data_plot(idx), 'BoxFaceColor', colors(i,:));
%     hold on;
% end
% 
% ylabel("Sway Displacement (deg)")
% % xlabel("Experimental Condition")
% title("Forehead + Temples Pitch Sway")
% ylim([-8 16]);
% xticks([1 2 3])
% xticklabels(["+DC" "Sham" "-DC"])
% 
% nexttile(4)
% % boxplot(bilateral_roll_disp_data(1:18) , bilateral_roll_disp_group(1:18))
% 
% bilateral_roll_disp_data_plot = bilateral_roll_disp_data(1:18);
% bilateral_roll_disp_group_plot = bilateral_roll_disp_group(1:18);
% % Unique groups and color map
% uniqueGroups = categories(categorical(pitch_disp_group_plot));
% % Plot using boxchart
% for i = 1:numel(uniqueGroups)
%     idx = bilateral_roll_disp_group_plot == uniqueGroups{i};
%     boxchart(ones(sum(idx),1)*i, bilateral_roll_disp_data_plot(idx), 'BoxFaceColor', colors(i,:));
%     hold on;
% end
% 
% % ylabel("Sway Displacement (deg)")
% % xlabel("Experimental Condition")
% title("Binaural Roll Sway")
% ylim([-8 16]);
% xticks([1 2 3])
% xticklabels(["+DC" "Sham" "-DC"])
% % sgtitle("Sway For Montage-Direction Combinations of Interest")


%% paper plot option 2 (going with this one)
f = figure('Position', [100, 100, 1200, 900]);
tiledlayout(2,3,"TileSpacing","tight", "Padding","tight")

colors = [ .5 .5 .5; .5 .5 .5 ; .5 .5 .5;0 0 0; 0 0 0;0 0 0];
nexttile(3)
% boxplot(pitch_power_val_data , pitch_power_val_group, 'Colors', colors)

% Unique groups and color map
uniqueGroups = categories(categorical(pitch_power_val_group));
uniqueGroups = uniqueGroups([2 4 6 1 3 5]);
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = pitch_power_val_group == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, pitch_power_val_data(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

xticks([1 2 3 4 5 6])
xticklabels(uniqueGroups)
yscale('log')
yticks([0.01 0.1 1])
yticklabels([0.01 0.1 1])

% ylabel("Sway at Freq. of Interest (dB/Hz)")
% xlabel("Experimental Condition")
title("Forehead + Temples: Pitch Sway", 'FontSize', 15)
ylim([0.0025 1.25]);

nexttile(1)
% boxplot(bilateral_roll_power_val_data , bilateral_roll_power_val_group)

% Unique groups and color map
uniqueGroups = categories(categorical(bilateral_roll_power_val_group));
uniqueGroups = uniqueGroups([2 4 6 1 3 5]);
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = bilateral_roll_power_val_group == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, bilateral_roll_power_val_data(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

xticks([1 2 3 4 5 6])
xticklabels(uniqueGroups)
yscale('log')
yticks([0.01 0.1 1])
yticklabels([0.01 0.1 1])

ylabel("Sway Power at Freq. of Interest (deg)")
% xlabel("Experimental Condition")
title("Binaural: Roll Sway", 'FontSize', 15)
ylim([0.0025 1.25]);

nexttile(2)
% boxplot(bilateral_yaw_power_val_data , bilateral_yaw_power_val_group)

% Unique groups and color map
uniqueGroups = categories(categorical(bilateral_yaw_power_val_group));
uniqueGroups = uniqueGroups([2 4 6 1 3 5]);
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = bilateral_yaw_power_val_group == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, bilateral_yaw_power_val_data(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

% ylabel("Sway at Freq. of Interest (dB/Hz)")
% xlabel("Experimental Condition")
title("Binaural: Yaw Sway", 'FontSize', 15)
ylim([0.0025 1.25]);

xticks([1 2 3 4 5 6])
xticklabels(uniqueGroups)
yscale('log')
yticks([0.01 0.1 1])
yticklabels([0.01 0.1 1])

colors = [ 0 0 0; .5 .5 .5; 0 0 0];
nexttile(6)
boxplot(pitch_disp_data([1:30 37:42]) , pitch_disp_group([1:30 37:42]))

pitch_disp_data_plot = pitch_disp_data([1:30 37:42]);
pitch_disp_group_plot = pitch_disp_group([1:30 37:42]);
% Unique groups and color map
uniqueGroups = categories(categorical(pitch_disp_group_plot));
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = pitch_disp_group_plot == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, pitch_disp_data_plot(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

ylabel("Sway Displacement (deg)")
% xlabel("Experimental Condition")
title("Forehead + Temples: Pitch Sway", 'FontSize', 15)
% ylim([-12 12]);
ylim([-8 8]);
xticks([1 2 3])
xticklabels(["+DC" "Sham" "-DC"])

nexttile(4)
% boxplot(bilateral_roll_disp_data(1:18) , bilateral_roll_disp_group(1:18))

bilateral_roll_disp_data_plot = bilateral_roll_disp_data(1:18);
bilateral_roll_disp_group_plot = bilateral_roll_disp_group(1:18);
% Unique groups and color map
uniqueGroups = categories(categorical(pitch_disp_group_plot));
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = bilateral_roll_disp_group_plot == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, bilateral_roll_disp_data_plot(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

ylabel("Sway Displacement (deg)")
% xlabel("Experimental Condition")
title("Binaural: Roll Sway", 'FontSize', 15)
% ylim([-8 16]);
ylim([-8 8]);
xticks([1 2 3])
xticklabels(["+DC" "Sham" "-DC"])
% sgtitle("Sway For Montage-Direction Combinations of Interest")

%% paper plot option 3
figure('Position', [100, 100, 1200, 900]);
tiledlayout(2,3,"TileSpacing","tight", "Padding","tight")

colors = [0 0 0; .5 .5 .5; 0 0 0; .5 .5 .5; 0 0 0; .5 .5 .5];
nexttile(3)
% boxplot(pitch_power_log_data , pitch_power_log_group, 'Colors', colors)

% Unique groups and color map
uniqueGroups = categories(categorical(pitch_power_log_group));
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = pitch_power_log_group == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, pitch_power_log_data(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

xticks([1 2 3 4 5 6])
xticklabels(uniqueGroups)

% ylabel("Sway at Freq. of Interest (dB/Hz)")
% xlabel("Experimental Condition")
title("Forehead + Temples Pitch Sway")
ylim([-40 30]);

nexttile(1)
% boxplot(bilateral_roll_power_log_data , bilateral_roll_power_log_group)

% Unique groups and color map
uniqueGroups = categories(categorical(bilateral_roll_power_log_group));
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = bilateral_roll_power_log_group == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, bilateral_roll_power_log_data(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

xticks([1 2 3 4 5 6])
xticklabels(uniqueGroups)

ylabel("Sway at Freq. of Interest (dB/Hz)")
% xlabel("Experimental Condition")
title("Binaural Roll Sway")
ylim([-40 30]);

nexttile(2)
% boxplot(bilateral_yaw_power_log_data , bilateral_yaw_power_log_group)

% Unique groups and color map
uniqueGroups = categories(categorical(bilateral_yaw_power_log_group));
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = bilateral_yaw_power_log_group == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, bilateral_yaw_power_log_data(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

% ylabel("Sway at Freq. of Interest (dB/Hz)")
% xlabel("Experimental Condition")
title("Binaural Yaw Sway")
ylim([-40 30]);

xticks([1 2 3 4 5 6])
xticklabels(uniqueGroups)

nexttile(6)
boxplot(pitch_disp_data([1:30 37:42]) , pitch_disp_group([1:30 37:42]))

pitch_disp_data_plot = pitch_disp_data([1:30 37:42]);
pitch_disp_group_plot = pitch_disp_group([1:30 37:42]);
% Unique groups and color map
uniqueGroups = categories(categorical(pitch_disp_group_plot));
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = pitch_disp_group_plot == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, pitch_disp_data_plot(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

ylabel("Sway Displacement (deg)")
% xlabel("Experimental Condition")
title("Forehead + Temples Pitch Sway")
ylim([-8 16]);
xticks([1 2 3])
xticklabels(["+DC" "Sham" "-DC"])

nexttile(4)
% boxplot(bilateral_roll_disp_data(1:18) , bilateral_roll_disp_group(1:18))

bilateral_roll_disp_data_plot = bilateral_roll_disp_data(1:18);
bilateral_roll_disp_group_plot = bilateral_roll_disp_group(1:18);
% Unique groups and color map
uniqueGroups = categories(categorical(pitch_disp_group_plot));
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = bilateral_roll_disp_group_plot == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, bilateral_roll_disp_data_plot(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

% ylabel("Sway Displacement (deg)")
% xlabel("Experimental Condition")
title("Binaural Roll Sway")
ylim([-8 16]);
xticks([1 2 3])
xticklabels(["+DC" "Sham" "-DC"])
% sgtitle("Sway For Montage-Direction Combinations of Interest")


%% paper plot option 4 (going with this one)
f = figure('Position', [100, 100, 1200, 900]);
tiledlayout(2,3,"TileSpacing","tight", "Padding","tight")

colors = [ .5 .5 .5; .5 .5 .5 ; .5 .5 .5;.5 .5 .5; .5 .5 .5 ; .5 .5 .5; 0 0 0; 0 0 0;0 0 0; 0 0 0; 0 0 0;0 0 0];
nexttile(3)
% boxplot(pitch_mag_data , pitch_mag_group, 'Colors', colors)

% Unique groups and color map
uniqueGroups = categories(categorical(pitch_mag_group_montage));
% uniqueGroups = uniqueGroups([2 4 6 1 3 5]);
uniqueGroups = uniqueGroups([3 4 7 8 11 12 1 2 5 6 9 10]);
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = pitch_mag_group_montage == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, pitch_mag_data(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

xticks([1 2 3 4 5 6 7 8 9 10 11 12])
xticklabels(uniqueGroups)
yscale('log')
yticks([0.005 0.05 .5 5])
% yticklabels([0.01 0.1 1])

% ylabel("Sway at Freq. of Interest (dB/Hz)")
% xlabel("Experimental Condition")
title("Forehead + Temples: Pitch Sway", 'FontSize', 15)
ylim([0.005 5]);

nexttile(1)
colors = [ .5 .5 .5; .5 .5 .5 ; .5 .5 .5;0 0 0; 0 0 0;0 0 0];
% boxplot(bilateral_roll_mag_data , bilateral_roll_mag_group)

% Unique groups and color map
uniqueGroups = categories(categorical(bilateral_roll_mag_group));
uniqueGroups = uniqueGroups([2 4 6 1 3 5]);
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = bilateral_roll_mag_group == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, bilateral_roll_mag_data(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

xticks([1 2 3 4 5 6])
xticklabels(uniqueGroups)
yscale('log')
yticks([0.005 0.05 .5 5])
% yticklabels([0.01 0.1 1])

ylabel("Sway Power at Freq. of Interest (deg)")
% xlabel("Experimental Condition")
title("Binaural: Roll Sway", 'FontSize', 15)
ylim([0.005 5]);

nexttile(2)
% boxplot(bilateral_yaw_mag_data , bilateral_yaw_mag_group)

% Unique groups and color map
uniqueGroups = categories(categorical(bilateral_yaw_mag_group));
uniqueGroups = uniqueGroups([2 4 6 1 3 5]);
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = bilateral_yaw_mag_group == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, bilateral_yaw_mag_data(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

% ylabel("Sway at Freq. of Interest (dB/Hz)")
% xlabel("Experimental Condition")
title("Binaural: Yaw Sway", 'FontSize', 15)
ylim([0.005 5]);

xticks([1 2 3 4 5 6])
xticklabels(uniqueGroups)
yscale('log')
yticks([0.005 0.05 .5 5])
% yticklabels([0.01 0.1 1])

colors = [ 0 0 0; .5 .5 .5; 0 0 0];
nexttile(6)
boxplot(pitch_disp_data([1:30 37:42]) , pitch_disp_group([1:30 37:42]))

pitch_disp_data_plot = pitch_disp_data([1:30 37:42]);
pitch_disp_group_plot = pitch_disp_group([1:30 37:42]);
% Unique groups and color map
uniqueGroups = categories(categorical(pitch_disp_group_plot));
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = pitch_disp_group_plot == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, pitch_disp_data_plot(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

ylabel("Sway Displacement (deg)")
% xlabel("Experimental Condition")
title("Forehead + Temples: Pitch Sway", 'FontSize', 15)
% ylim([-12 12]);
ylim([-8 8]);
xticks([1 2 3])
xticklabels(["+DC" "Sham" "-DC"])

nexttile(4)
% boxplot(bilateral_roll_disp_data(1:18) , bilateral_roll_disp_group(1:18))

bilateral_roll_disp_data_plot = bilateral_roll_disp_data(1:18);
bilateral_roll_disp_group_plot = bilateral_roll_disp_group(1:18);
% Unique groups and color map
uniqueGroups = categories(categorical(pitch_disp_group_plot));
% Plot using boxchart
for i = 1:numel(uniqueGroups)
    idx = bilateral_roll_disp_group_plot == uniqueGroups{i};
    boxchart(ones(sum(idx),1)*i, bilateral_roll_disp_data_plot(idx), 'BoxFaceColor', colors(i,:));
    hold on;
end

ylabel("Sway Displacement (deg)")
% xlabel("Experimental Condition")
title("Binaural: Roll Sway", 'FontSize', 15)
% ylim([-8 16]);
ylim([-8 8]);
xticks([1 2 3])
xticklabels(["+DC" "Sham" "-DC"])
% sgtitle("Sway For Montage-Direction Combinations of Interest")