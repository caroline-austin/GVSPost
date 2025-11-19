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
Label_IMU = Label;
load(['AllVerbal.mat'])
cd(code_path);

imu_dir = ["roll" "pitch" "yaw" ];

%% Verbal report data export
group_verbal = table;
% verbal.condition1 = ["Neck" "Neck"  "Shoulder" ]';
% verbal.condition2 = ["Shoulder" "Forehead" "Forehead" ]';
group_verbal.condition1 = ["Forehead"   "Shoulder" "Neck" ]';
group_verbal.condition2 = ["Shoulder" "Neck" "Forehead"  ]';
group_verbal.motion_wins1 = [ total_forhead_shoulder(1,1) total_shoulder_neck(1,1) total_neck_forhead(1,1) ]';
group_verbal.motion_wins2 = [ total_forhead_shoulder(1,2) total_shoulder_neck(1,2) total_neck_forhead(1,2) ]';

group_verbal.tingling_wins1 = [ total_forhead_shoulder(2,1) total_shoulder_neck(2,1) total_neck_forhead(2,1) ]';
group_verbal.tingling_wins2 = [ total_forhead_shoulder(2,2) total_shoulder_neck(2,2) total_neck_forhead(2,2) ]';

group_verbal.vis_wins1 = [ total_forhead_shoulder(3,1) total_shoulder_neck(3,1) total_neck_forhead(3,1) ]';
group_verbal.vis_wins2 = [ total_forhead_shoulder(3,2) total_shoulder_neck(3,2) total_neck_forhead(3,2) ]';

group_verbal.metallic_wins1 = [ total_forhead_shoulder(4,1) total_shoulder_neck(4,1) total_neck_forhead(4,1) ]';
group_verbal.metallic_wins2 = [ total_forhead_shoulder(4,2) total_shoulder_neck(4,2) total_neck_forhead(4,2) ]';


cd(file_path)
writetable(group_verbal, "group_verbal.csv");
cd(code_path)

%% Verbal report data export
sub_verbal = table;

sub_verbal.SID = repmat([1:10]',3,1);
sub_verbal.condition1 = [repmat("Forehead",numsub,1) ;  repmat("Shoulder",numsub,1); repmat("Neck",numsub,1) ];
sub_verbal.condition2 = [repmat("Shoulder",numsub,1) ;repmat("Neck",numsub,1); repmat("Forehead",numsub,1)  ];
sub_verbal.motion_wins1 = [ sub_forhead_shoulder(:,1,1); sub_shoulder_neck(:,1,1); sub_neck_forhead(:,1,1) ];
sub_verbal.motion_wins2 = [ sub_forhead_shoulder(:,2,1) ;sub_shoulder_neck(:,2,1) ;sub_neck_forhead(:,2,1) ];


sub_verbal.tingling_wins1 = [ sub_forhead_shoulder(:,1,2); sub_shoulder_neck(:,1,2); sub_neck_forhead(:,1,2) ];
sub_verbal.tingling_wins2 = [ sub_forhead_shoulder(:,2,2); sub_shoulder_neck(:,2,2) ;sub_neck_forhead(:,2,2) ];

sub_verbal.vis_wins1 = [ sub_forhead_shoulder(:,1,3); sub_shoulder_neck(:,1,3); sub_neck_forhead(:,1,3) ];
sub_verbal.vis_wins2 = [ sub_forhead_shoulder(:,2,3); sub_shoulder_neck(:,2,3); sub_neck_forhead(:,2,3) ];

sub_verbal.metallic_wins1 = [ sub_forhead_shoulder(:,1,4) ;sub_shoulder_neck(:,1,4); sub_neck_forhead(:,1,4) ];
sub_verbal.metallic_wins2 = [ sub_forhead_shoulder(:,2,4) ;sub_shoulder_neck(:,2,4) ;sub_neck_forhead(:,2,4) ];


cd(file_path)
writetable(sub_verbal, "sub_verbal.csv");
cd(code_path)

%% congruency between sway and verbal reports
congruent = table;
for sub = 1:numsub
        congruent.SID(sub) = sub;
        congruent.correct(sub) = sum(sway_verbal_congruent(1:12,sub))/(length(sway_verbal_congruent)-2);
end

cd(file_path)
writetable(congruent, "congruent.csv");
cd(code_path)


%% power_interest stats 
control_current = 1; 
interest_current = 3; 
control_profile = 2;
interest_profile = 1;
profile_freq = [ 0.5 ];
index = 0;
index2 = 0;
freq_power_anova = table;
mag_anova = table;
psd_anova = table;
freq_psd_anova = table;
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
        config = Label_IMU.all_config_sort(:,trial);

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
                Label_IMU.power_stats(index2) = strjoin([ "trial" num2str(trial) imu_dir(dir) Config(max(config))]);
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

%% mag interest stats
index = 0;
for dir = 1:2
    

    forehead_mag= mag_interest_sort(1:8, :,dir,1);
    shoulder_mag= mag_interest_sort(11:18, :,dir,1);
    neck_mag= mag_interest_sort(21:28, :,dir,1);
    mean_forehead_mag = mean(forehead_mag);
    mean_shoulder_mag = mean(shoulder_mag);
    mean_neck_mag = mean(neck_mag);
    median_forehead_mag = median(forehead_mag, 'omitnan');
    median_shoulder_mag = median(shoulder_mag, 'omitnan');
    median_neck_mag = median(neck_mag, 'omitnan');

     max_forehead_mag = max(forehead_mag);
    max_shoulder_mag = max(shoulder_mag);
    max_neck_mag = max(neck_mag);

    num_subs = length(max_forehead_mag);

    for config = 1:3
        index = index +1;  
        if config ==1
    
            mag_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_forehead_mag;
        elseif config ==2
            mag_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_shoulder_mag;
    
        elseif config ==3 
            mag_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_neck_mag;
    
        end
                     
        mag_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "exp";
    
        mag_anova.config((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) =Config(config);
    
        mag_anova.dir((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = imu_dir(dir);
    
        mag_anova.freq_interest((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 0.5;
    
        mag_anova.sub((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 1:num_subs;
    
    end
end

mag_anova( any(ismissing(mag_anova),2), :) = [];
cd(file_path)
writetable(mag_anova, "mag_anova.csv");
cd(code_path)

%%
%% my psd calcs at 0.5Hz (log)
index = 0;
for dir = 1:2
    

    forehead_freq_psd= psd_05_sort(1:8, :,dir,1);
    shoulder_freq_psd= psd_05_sort(11:18, :,dir,1);
    neck_freq_psd= psd_05_sort(21:28, :,dir,1);
    mean_forehead_freq_psd = mean(forehead_freq_psd);
    mean_shoulder_freq_psd = mean(shoulder_freq_psd);
    mean_neck_freq_psd = mean(neck_freq_psd);
    median_forehead_freq_psd = median(forehead_freq_psd, 'omitnan');
    median_shoulder_freq_psd = median(shoulder_freq_psd, 'omitnan');
    median_neck_freq_psd = median(neck_freq_psd, 'omitnan');

     max_forehead_freq_psd = max(forehead_freq_psd);
    max_shoulder_freq_psd = max(shoulder_freq_psd);
    max_neck_freq_psd = max(neck_freq_psd);

    num_subs = length(max_forehead_freq_psd);

    for config = 1:3
        index = index +1;  
        if config ==1
    
            freq_psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_forehead_freq_psd;
        elseif config ==2
            freq_psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_shoulder_freq_psd;
    
        elseif config ==3 
            freq_psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_neck_freq_psd;
    
        end
                     
        freq_psd_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "exp";
    
        freq_psd_anova.config((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) =Config(config);
    
        freq_psd_anova.dir((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = imu_dir(dir);
    
        freq_psd_anova.freq_interest((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 0.5;
    
        freq_psd_anova.sub((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 1:num_subs;
    
    end
end

freq_psd_anova( any(ismissing(freq_psd_anova),2), :) = [];
cd(file_path)
writetable(freq_psd_anova, "freq_psd_anova.csv");
cd(code_path)

%% torin's psd calcs at 0.5 hz (no log)
index = 0;
for dir = 1:2
    

    forehead_psd= psd_interest_sort(1:8, :,dir,1);
    shoulder_psd= psd_interest_sort(11:18, :,dir,1);
    neck_psd= psd_interest_sort(21:28, :,dir,1);
    mean_forehead_psd = mean(forehead_psd);
    mean_shoulder_psd = mean(shoulder_psd);
    mean_neck_psd = mean(neck_psd);
    median_forehead_psd = median(forehead_psd, 'omitnan');
    median_shoulder_psd = median(shoulder_psd, 'omitnan');
    median_neck_psd = median(neck_psd, 'omitnan');

     max_forehead_psd = max(forehead_psd);
    max_shoulder_psd = max(shoulder_psd);
    max_neck_psd = max(neck_psd);

    num_subs = length(max_forehead_psd);

    for config = 1:3
        index = index +1;  
        if config ==1
    
            psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_forehead_psd;
        elseif config ==2
            psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_shoulder_psd;
    
        elseif config ==3 
            psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = median_neck_psd;
    
        end
                     
        psd_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "exp";
    
        psd_anova.config((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) =Config(config);
    
        psd_anova.dir((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = imu_dir(dir);
    
        psd_anova.freq_interest((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 0.5;
    
        psd_anova.sub((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 1:num_subs;
    
    end
end

psd_anova( any(ismissing(psd_anova),2), :) = [];
cd(file_path)
writetable(psd_anova, "psd_anova.csv");
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


