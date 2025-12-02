%% script 4
% Created by: Caroline Austin
% Modified by: Caroline Austin
% exports imu data to .csv for R analysis 
% 11/20/25

clear all; close all; clc;
code_path = pwd;

%% Experimental Methods Specifications
file_path = uigetdir; %user selects file directory './Subject Data/'; %I replaced this so the person can directly choose where to pull the data from

subnum = [2049, 2051,2053:2057, 2061:2062, 2078:2090];  % Subject List 2049, 2051,2053:2062
numsub = length(subnum);
subskip = [2058 2059 2060 2069:2077 2083 2085 2086 2070 2072 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

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

imu_dir = ["roll" "pitch" "yaw" ];


%% power_interest stats 
control_current = 1; 
interest_current = 3; 
control_profile = 2;
interest_profile = 1;
condition_interest = ["0_1mA_1Hz" "2mA_1Hz" "4mA_1Hz" ... 
    "0_1mA_0_5Hz"  "2mA_0_5Hz" "4mA_0_5Hz"];
% current_interest = [0.1 2 3 4 0.1 1 2 3 4];
current_interest = [0.1 2 4 0.1 2 4];

profile_freq = [ 0.5 ];
index = 0;
index2 = 0;
freq_power_anova = table;

freq_interest = [ 1 1 1 0.5 0.5 0.5];


%% magnitude of sway results 
mag_anova = table;
index = 0;
for dir = 1:2

    num_subs = length(mag_interest_sort);
% 
    for condition = 1:length(condition_interest) % counting the number of replicates using replicate order as an index
        replicate_order = 0;
        current_mA = current_interest(condition);
        index = index +1; 

        mag_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = mag_interest_sort(condition,:,dir);

        if condition == 1 || condition == 4 
            mag_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "control";
        else
            mag_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "exp";
        end
        mag_anova.mA((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) =current_mA;

        mag_anova.dir((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = imu_dir(dir);

        mag_anova.freq_interest((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = freq_interest(condition);%%%

        mag_anova.sub((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 1:num_subs;

    end
end

mag_anova( any(ismissing(mag_anova),2), :) = [];
cd(file_path)
writetable(mag_anova, "mag_anova.csv");
cd(code_path)


%% psd sway results 
psd_anova = table;
index = 0;
for dir = 1:2

    num_subs = length(psd_interest_sort);
% 
    for condition = 1:length(condition_interest) % counting the number of replicates using replicate order as an index
        replicate_order = 0;
        current_mA = current_interest(condition);
        index = index +1; 

        psd_anova.Var((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = psd_interest_sort(condition,:,dir);

        if condition == 1 || condition == 4 
            psd_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "control";
        else
            psd_anova.type((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = "exp";
        end
        psd_anova.mA((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) =current_mA;

        psd_anova.dir((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = imu_dir(dir);

        psd_anova.freq_interest((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = freq_interest(condition);%%%

        psd_anova.sub((index*num_subs*2 - num_subs*2 +1):(index*num_subs*2 -num_subs) ) = 1:num_subs;

    end
end

psd_anova( any(ismissing(psd_anova),2), :) = [];
cd(file_path)
writetable(psd_anova, "psd_anova.csv");
cd(code_path)
