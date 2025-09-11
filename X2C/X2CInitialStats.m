%% script 3
% Created by: Caroline Austin
% Modified by: Caroline Austin
% exports data to .csv for R analysis 
% 8/21/25

clear all; close all; clc;
code_path = pwd;

%% Experimental Methods Specifications
file_path = uigetdir; %user selects file directory './Subject Data/'; %I replaced this so the person can directly choose where to pull the data from

subnum = [2044:2048, 2050,2052, 2063:2065];  % Subject List 2001:2010 2001:2010
numsub = length(subnum);
subskip = [2001 2049 2004 2008 2010];  %DNF'd subjects


 %% initialize  


%naming variables 
Profiles = [ "Sin 0.5Hz"];
Profiles_safe = [ "Sin0_5Hz"];
num_profiles = length(Profiles);
Config = [ "Three" "Four" ];



%% load data 
cd([file_path]);
load(['Allimu.mat']) % from X2C IMU metrics
Label_IMU = Label;
load(['AllVerbal.mat']) % from 
cd(code_path);

imu_dir = ["roll" "pitch" "yaw" ];

%% Verbal report data export
verbal = table;
% verbal.condition1 = ["Neck" "Neck"  "Shoulder" ]';
% verbal.condition2 = ["Shoulder" "Forehead" "Forehead" ]';
verbal.condition1 = ["Four 1mA"   "Four 2mA" "Four 3mA" "Four 4mA" "Four 1mA"  "Four 2mA" "Four 3mA" "Four 4mA" "Four 1mA"  "Four 2mA" "Four 3mA" "Four 4mA"]';
verbal.condition2 = ["Three 2mA" "Three 2mA" "Three 2mA" "Three 2mA" "Three 3mA" "Three 3mA" "Three 3mA" "Three 3mA" "Three 4mA" "Three 4mA" "Three 4mA" "Three 4mA" ]';
verbal.motion_wins1 = total_motion_combo_stats_org(:,1);
verbal.motion_wins2 = total_motion_combo_stats_org(:,2); 

verbal.tingling_wins1 = total_tingle_combo_stats_org(:,1); 
verbal.tingling_wins2 = total_tingle_combo_stats_org(:,2); 

verbal.vis_wins1 = total_vis_combo_stats_org(:,1); %[ total_forhead_shoulder(3,1) total_shoulder_neck(3,1) total_neck_forhead(3,1) ]';
verbal.vis_wins2 = total_vis_combo_stats_org(:,2); %[ total_forhead_shoulder(3,2) total_shoulder_neck(3,2) total_neck_forhead(3,2) ]';

verbal.metallic_wins1 = total_metal_combo_stats_org(:,1);%[ total_forhead_shoulder(4,1) total_shoulder_neck(4,1) total_neck_forhead(4,1) ]';
verbal.metallic_wins2 = total_metal_combo_stats_org(:,2);%[ total_forhead_shoulder(4,2) total_shoulder_neck(4,2) total_neck_forhead(4,2) ]';


cd(file_path)
writetable(verbal, "verbal.csv");
cd(code_path)

%% congruency between sway and verbal reports
congruent = table;
for sub = 1:numsub
        congruent.SID(sub) = sub;
        congruent.correct(sub) = sum(sway_verbal_congruent(:,sub))/(length(sway_verbal_congruent));
end

cd(file_path)
writetable(congruent, "congruent.csv");
cd(code_path)


%% power_interest stats 
control_current = 1; 
interest_current = 3; 
control_profile = 2;
interest_profile = 1;
condition_interest = ["3_electrode_0_1mA" "3_electrode_2mA" "3_electrode_3mA" ... 
    "3_electrode_4mA" "4_electrode_0_1mA"  "4_electrode_1mA"  ... 
    "4_electrode_2mA" "4_electrode_3mA" "4_electrode_4mA"];
% current_interest = [0.1 2 3 4 0.1 1 2 3 4];
current_interest = [0.1 1 1.5 2 0.1 1 2 3 4];

profile_freq = [ 0.5 ];
index = 0;
index2 = 0;
freq_power_anova = table;
freq_psd_anova = table;
freq_interest = [ 0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.5 0.6 0.75 0.8 0.9 1 1.1 1.2 1.25];

for profile = interest_profile % in this case there was only the 0.5 Hz profile/waveform
    for condition = 1:length(condition_interest) % counting the number of replicates using replicate order as an index
        replicate_order = 0;
        current_mA = current_interest(condition);
       
    for trial = 1:length(Label_IMU.all_trials_sort) 
        if contains(Label_IMU.all_trials_sort{1,trial}{1},condition_interest(condition))
            if contains(Label_IMU.all_trials_sort{1,trial}{1},num2str(subnum(1)))
                replicate_order = replicate_order+1;
            end
        else 
            continue
        end
        
        config = Label_IMU.all_config_sort(:,trial);
        config(config ==0) = config(1); % one trial is missing data, but config gets used as a indexing variable which can't be zero
        
        for dir = 1:2
            for freq = 1:length(freq_interest)
                if profile_freq(profile) ~= freq_interest(freq) % only care about the frequencies that math the GVS freq
                    continue
                end

                
                index = index +1;            
                
                power_eval(:,index) = changem(squeeze(power_interest_log_sort(trial,:,dir,freq)), nan);
                % power_eval(:,index) = changem(squeeze(power_values_sort(trial,:,dir)), nan);
                
                % save data into table
                num_subs = height(power_eval);

                % I don't remember why I did the indexing the way I did but
                % it works so I don't want to change it
                freq_power_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = power_eval(:,index);
                 
                freq_power_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "exp";

                freq_power_anova.order((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = replicate_order;

                freq_power_anova.config((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) =Config(config);

                freq_power_anova.mA((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) =current_mA;

                freq_power_anova.dir((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = imu_dir(dir);

                freq_power_anova.freq_interest((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2-num_subs) ) = freq_interest(freq);

                freq_power_anova.sub((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 1:num_subs;


                index2 = index2+1;
                Label_IMU.power_stats(index2) = strjoin([ "trial" num2str(trial) imu_dir(dir) Config(max(config))]);
                power_eval_mat(:,index2) =  power_eval(:,index);

            end
        end
    end
    end
end

freq_power_anova( any(ismissing(freq_power_anova),2), :) = [];
power_eval_save = power_eval(~isnan(power_eval));

cd(file_path)
writetable(freq_power_anova, "freq_power_anova.csv");
cd(code_path)


%% my psd calcs at 0.5Hz (log)
index = 0;
for dir = 1:2
% 
% 
        shoulder_0_1mA_psd= [psd_interest_sort(1:2, :,dir,1); NaN(8,10)]; % 
        shoulder_2mA_psd= [psd_interest_sort(3:10, :,dir,1); NaN(2,10)];
        shoulder_3mA_psd= [psd_interest_sort(11:18, :,dir,1); NaN(2,10)];
        shoulder_4mA_psd= psd_interest_sort(19:28, :,dir,1);
    
        temples_0_1mA_psd= [psd_interest_sort(29:30, :,dir,1); NaN(8,10)]; % 
        temples_1mA_psd= [psd_interest_sort(31:36, :,dir,1); NaN(4,10)];
        temples_2mA_psd= [psd_interest_sort(37:42, :,dir,1); NaN(4,10)];
        temples_3mA_psd= [psd_interest_sort(43:48, :,dir,1); NaN(4,10)];
        temples_4mA_psd= [psd_interest_sort(49:56, :,dir,1); NaN(2,10)];

        mean_shoulder_0_1mA_psd = mean(shoulder_0_1mA_psd, 'omitnan');
        mean_shoulder_2mA_psd = mean(shoulder_2mA_psd, 'omitnan');
        mean_shoulder_3mA_psd = mean(shoulder_3mA_psd, 'omitnan');
        mean_shoulder_4mA_psd = mean(shoulder_4mA_psd, 'omitnan');

        mean_temples_0_1mA_psd = mean(temples_0_1mA_psd, 'omitnan');
        mean_temples_1mA_psd = mean(temples_1mA_psd, 'omitnan');
        mean_temples_2mA_psd = mean(temples_2mA_psd, 'omitnan');
        mean_temples_3mA_psd = mean(temples_3mA_psd, 'omitnan');
        mean_temples_4mA_psd = mean(temples_4mA_psd, 'omitnan');
        
        median_shoulder_0_1mA_psd = median(shoulder_0_1mA_psd, 'omitnan');
        median_shoulder_2mA_psd = median(shoulder_2mA_psd, 'omitnan');
        median_shoulder_3mA_psd = median(shoulder_3mA_psd, 'omitnan');
        median_shoulder_4mA_psd = median(shoulder_4mA_psd, 'omitnan');

        median_temples_0_1mA_psd = median(temples_0_1mA_psd, 'omitnan');
        median_temples_1mA_psd = median(temples_1mA_psd, 'omitnan');
        median_temples_2mA_psd = median(temples_2mA_psd, 'omitnan');
        median_temples_3mA_psd = median(temples_3mA_psd, 'omitnan');
        median_temples_4mA_psd = median(temples_4mA_psd, 'omitnan');
% 
%      max_forehead_freq_psd = max(forehead_freq_psd);
%     max_shoulder_freq_psd = max(shoulder_freq_psd);
%     max_neck_freq_psd = max(neck_freq_psd);
% 
    num_subs = length(median_shoulder_0_1mA_psd);
% 
    for condition = 1:length(condition_interest) % counting the number of replicates using replicate order as an index
        replicate_order = 0;
        current_mA = current_interest(condition);
        index = index +1; 

        switch condition
            case 1
                freq_psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_shoulder_0_1mA_psd;
                config = 1;
            case 2 
                freq_psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_shoulder_2mA_psd;
                config = 1;
            case 3
                freq_psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_shoulder_3mA_psd;
                config = 1;
            case 4
                freq_psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_shoulder_4mA_psd;
                config = 1;
            case 5 
                freq_psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_temples_0_1mA_psd;
                config = 2;
            case 6 
                freq_psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_temples_1mA_psd;
                config = 2;
            case 7 
                freq_psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_temples_2mA_psd;
                config = 2;
            case 8
                freq_psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_temples_3mA_psd;
                config = 2;
            case 9 
                freq_psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_temples_4mA_psd;
                config = 2; 
        end

        freq_psd_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "exp";

        freq_psd_anova.config((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) =Config(config);

        freq_psd_anova.mA((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) =current_mA;

        freq_psd_anova.dir((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = imu_dir(dir);

        freq_psd_anova.freq_interest((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 0.5;

        freq_psd_anova.sub((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 1:num_subs;

    end
end

freq_psd_anova( any(ismissing(freq_psd_anova),2), :) = [];
cd(file_path)
writetable(freq_psd_anova, "freq_psd_anova.csv");
cd(code_path)