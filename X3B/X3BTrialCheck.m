%% Script 3 for X3B Functional Mobility Testing
% this script takes the data from script 2 and plots it for visual
% verification that the correct GVS was applied. 

close all; 
clear all; 
clc; 

%% setup
subnum = [ 3091:3091];  % Subject List 1011:1022
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part 


code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory it should be the Data folder for the experiment (on Sharepoint)
plots_path = [file_path '/Plots']; % specify where plots are saved
gvs_path = [file_path '/GVSProfiles']; %specify where to grab default GVS profiles from
% tts_path = [file_path '/TTSProfiles']; %specify where to grab baseline TTS profiles from

cd([code_path '/..']); 
[filenames]=file_path_info2(code_path, file_path); % get subfolder and file names from file folder

% plot((ROM_Wii_trial(:,1)- ROM_Wii_trial(1,1))/1000,ROM_Wii_trial(:,2:8) )

%% find data to plot

cd(gvs_path)
Offset = readmatrix('MacDougall_2mA_max4mA_100HzSamplePos.csv');
Offset = resample(Offset, 50,100)*2.5/4;
cd(code_path)

for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    subject_path = [file_path '\' subject_str];
    % load overall file(has info about all trials from the "master"
    % excel document)
    cd(subject_path);
        load(['S', subject_str, 'Extract.mat ']);
    cd(code_path);

    ROM_fields = fieldnames(data.ROM.GIST);


    for phys_cond = 1:length(ROM_fields)
        GVS_fields = fieldnames(data.ROM.GIST.(ROM_fields{phys_cond}));
        for gvs_cond = 1:length(GVS_fields)
            [~,num_trials] = size(data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}));
            for trial = 1:num_trials

                [Ch1, Ch2, Ch3] = GIST_GVS(data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){sub, trial}, GVS_fields{gvs_cond}, Offset);


                    if contains( GVS_fields{gvs_cond}, 'DCSD')
                        GIST_fs = 125;
                    else 
                        GIST_fs = 375;
                    end
                figure;
                subplot(2,1,1)
                plot(Ch1); hold on; 
                plot(resample(data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){sub, trial}.CH1Current, 50,GIST_fs)/1000)
                legend(["Ch1 est", "Ch1 act"])
                subplot(2,1,2)
                plot(Ch2); hold on;
                plot(resample(data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){sub, trial}.CH2Current, 50, GIST_fs)/1000)
                legend(["Ch2 est", "Ch2 act"])
                % legend(["Ch1 est", "Ch2 est", "Ch1 act", "Ch 2act"])
                title([ROM_fields{phys_cond} GVS_fields{gvs_cond} ])
            end
        end
    end

    % either in above loop or separate loop - make plot that 
    % for each condition (physical and GVS) make subplot to compare actual
    % and anticipated GVS

    

end
%%




function [Ch1, Ch2, Ch3] = GIST_GVS(imu_data, GVS_type,Offset)
    GVS_fs=50;
    if contains(GVS_type, 'DCSD')
        GIST_fs = 125;
    else 
        GIST_fs = 375;
    end
    max_mA = 2.5;
    max_ang = 10;
    max_vel = 20;
    
    Var_names = imu_data.Properties.VariableNames;
    roll = resample(imu_data.Roll,GVS_fs,GIST_fs); % store roll tilt
    pitch = resample(imu_data.ZVelocity,GVS_fs,GIST_fs); % store roll tilt velocity 
    yaw = resample(imu_data.Pitch,GVS_fs,GIST_fs); % store pitch tilt
    x_vel = resample(imu_data.XVelocity,GVS_fs,GIST_fs); % store pitch tilt velocity 
    y_vel = resample(imu_data.Yaw,GVS_fs,GIST_fs); % store yaw 
    z_vel = resample(imu_data.YVelocity,GVS_fs,GIST_fs); % store yaw velocity 

    len_data= length(roll);
    len_Offset = length(Offset);

    if len_data <len_Offset
        Offset = Offset(1:len_data);
    end
   

    if contains(GVS_type, 'SHAM')
        K1 = [0 0 0 0 0 0]; % roll, pitch, yaw, x_vel, y_vel, z_vel   
        K2 = [0 0 0 0 0 0]; % roll, pitch, yaw, x_vel, y_vel, z_vel
        K3 = [0 0 0 0 0 0]; % roll, pitch, yaw, x_vel, y_vel, z_vel
        Offset = 0;
    elseif contains(GVS_type, 'DCON')
        K1 = [-999 0 0 0 0 999]/999; % roll, pitch, yaw, x_vel, y_vel, z_vel   -> note that -K1 here is because GIST sign convention is flipped (ie negative mo
        K2 = [0 -999 0 -999 0 0]/999; % roll, pitch, yaw, x_vel, y_vel, z_vel
        K3 = [0 -999 0 -999 0 0]/999; % roll, pitch, yaw, x_vel, y_vel, z_vel
        Offset = 0;
    elseif contains(GVS_type, 'DCSD')
        K1 = [-999 0 0 0 0 0]/999; % roll, pitch, yaw, x_vel, y_vel, z_vel   
        K2 = [0 -999 0 0 0 0]/999; % roll, pitch, yaw, x_vel, y_vel, z_vel
        K3 = [0 -999 0 0 0 0]/999; % roll, pitch, yaw, x_vel, y_vel, z_vel

        % K1 = [0 0 0 0 0 0]; % roll, pitch, yaw, x_vel, y_vel, z_vel   
        % K2 = [0 0 0 0 0 0]; % roll, pitch, yaw, x_vel, y_vel, z_vel
        % K3 = [0 0 0 0 0 0]; % roll, pitch, yaw, x_vel, y_vel, z_vel
        if len_data <len_Offset
        Offset = Offset(1:len_data);
        end
    end

    Ch1 = ((roll*K1(1) +pitch*K1(2) +yaw*K1(3))*max_mA/max_ang + (x_vel *K1(4) + y_vel *K1(5) + z_vel *K1(6)) *max_mA/max_vel +Offset/1000);
    Ch2 = ((roll*K2(1) +pitch*K2(2) +yaw*K2(3))*max_mA/max_ang + (x_vel *K2(4) + y_vel *K2(5) + z_vel *K2(6)) *max_mA/max_vel+Offset/1000);
    Ch3 = ((roll*K3(1) +pitch*K3(2) +yaw*K3(3))*max_mA/max_ang + (x_vel *K3(4) + y_vel *K3(5) + z_vel *K3(6)) *max_mA/max_vel+Offset/1000);

    Ch1(Ch1>max_mA) = max_mA;
    Ch2(Ch2>max_mA) = max_mA;
    Ch3(Ch3>max_mA) = max_mA;

    Ch1(Ch1<-max_mA) = -max_mA;
    Ch2(Ch2<-max_mA) = -max_mA;
    Ch3(Ch3<-max_mA) = -max_mA;

    if contains(GVS_type, 'DCON')
        Ch1 = abs(Ch1);
        Ch2 = abs(Ch2);
        Ch3 = abs(Ch3);
    end



end





% %% Edit Inputs Here
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% %Info for saving the Files
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% % set the folder that you want to save the files to
% % file_path = '/home/gvslinux/Documents/ChairGVS/Profiles/TTS/DynamicTilt/Ang_50_Vel_50/SumOfSin6B';
% % file_path = 'C:\Users\caroa\OneDrive - UCB-O365\Research\Testing\GVSProfiles\TTSPitchTilt';
% % file_path = 'C:\Users\caroa\OneDrive - UCB-O365\Research\Testing\GVSProfiles\GVSwaveformOptimization';
% file_path = 'C:\Users\caroa\OneDrive - UCB-O365\Research\Testing\GVSProfiles\GVSwaveformOptimization\X04182025';
% %'/home/gvslinux/Documents/ChairGVS/Profiles/TTS/DynamicTilt';
% % uncomment the mkdir line if the folder does not already exist
% mkdir(file_path) 
% 
% % a good naming convention is 
% % MontageName_Current_mA_Duration_s_Profile_Type_freq/dir 
% % can also add polarity and/or fs to end if applicable
% % I might make code that automatically names the profile based on the input
% % information
% % Filename = 'Bilateral_0_10mA_12s_left_bipolar_50Hz'; % the name you would like to file to be saved as 
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% % Parameters to modify for all/any profile
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% 
% % number of electrodes in the montage (must be at least 2 and no more than 5)
% % 2 = bilateral 3 = Cevette, 4 = Aoyama
% Num_Electrode = 2; 
% 
% % 7 = tilt velocity; 8 = tilt angle ; 
% % between 7 and 8 = scaled contribution (closer to 7 is more velocity
% % weighted, closer to 8 is more angle weighted)
% Proportional = 8;
% 
% PmA = [2.5 ]; %[- 4 0 4];
% 
% % C = [-0.5, -0.25, 0., 0.25 0.5];
% 
% % For reconstruction of GIST profiles set GIST =1, for original profiles
% % designed for sparky set = 0;
% GIST_IMU = 1;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Profile Type Modifiers
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % set this as 1 for sinusoidal and noise; 
% % for DC profiles use 1 for left/backward and 2 for right/forward -
% % right/forward I think is default positve coupling with the GIST because
% % angle and velocity have opposite sign conventions on the GIST
% Current_Direction = 2; 
% 
% % Provide some time with zero motion at the beginniTTSsaveng and end, if desired
% % this adds time to the duration
% zpad=0;           % sec at beginning runs padded with zeros
% zpad_after = 0;     % sec at the end of runs padded with zeros
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % if Num_Electrode = 4 or 5
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Specifies the number of cathodes ( 1 or 2) 
% % only for configurations with 4 or 5 electrodes
% % set as 2 for Aoyama config
% Electrode_Config = 2; 
% 
% % 1 = Sinusoidal, 2 = Noise, 3 = DC
% % for this code set as 2 if you want a power spectral density plot and any
% % other number otherwise
% Profile_Type = 1; 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % if GIST_IMU = 1; 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % General 
% 
% % Default waveform for coupling is "DC" , "DC+SD" is DC plus a custom
% % waveform (code should prompt for the additional custom waveform)
% Waveform = "DC";
% mA_max = 2.5; % maximum current for coupling
% % doesn't apply for the DC, but I think this is the sampling freq for the 
% % custom waveform
% freq = 0.5; 
% SD_period = 0; % in seconds (this might actually be for the custom waveform)
% 
% % angle and velocity at which the maximum current is realized
% max_angle = 10; % set to 10 for optimal roll coupling
% max_vel = 20; % set to 6 for optimal roll coupling % set to 15, 20, or 30 for comfort coupling
% 
% % Zvelocity = roll velocity, X velocity = pitch velocity, Y velocity = yaw
% % velocity
% 
% % Channel 1
% Ch1 = 1;
% K1 = 999; % set as -999 for optimal roll coupling % Note for actual GIST + current for leftward tilt (- current for rightward tilt) 
% Couple_1 = "Roll";
% Threshold_1 = 0;
% K2 = -999; % set at 999 for optimal roll coupling
% Couple_2 = "ZVelocity";
% Threshold_2 = 0;
% % Channel 2
% Ch2 = 1;
% K3 = 999;
% Couple_3 = "Pitch";
% Threshold_3 = 0;
% K4 = -999; % GIST positive current for pitch forward
% Couple_4 = "XVelocity";
% Threshold_4 = 0;
% % Channel 3
% Ch3 = 1;
% K5 = 999;
% Couple_5 = "Pitch";
% Threshold_5 = 0;
% K6 = -999;
% Couple_6 = "XVelocity";
% Threshold_6 = 0;
% %%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Select the GIST file
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cd ../..
% [input_filearg,input_path] = uigetfile('*.csv');
% fprintf([input_filearg '\n']);
% 
% cd(input_path) %make sure the profile you want to run is in this folder
% GIST_file = readtable(input_filearg);  
% cd(code_path);
% %% 
% Var_names = GIST_file.Properties.VariableNames;
% GIST_param(:,8) = resample(GIST_file.Roll,50,375); % store roll tilt
% GIST_param(:,7) = resample(GIST_file.ZVelocity,50,375); % store roll tilt velocity 
% GIST_param(:,6) = resample(GIST_file.Pitch,50,375); % store pitch tilt
% GIST_param(:,5) = resample(GIST_file.XVelocity,50,375); % store pitch tilt velocity 
% GIST_param(:,4) = resample(GIST_file.Yaw,50,375); % store yaw 
% GIST_param(:,3) = resample(GIST_file.YVelocity,50,375); % store yaw velocity 
% 
% %%
% for iter = 1:length(PmA)
% 
% % GVS_Signal = (GIST_file(:,8)*C(iter))';
% if GIST_IMU == 0
% if ismember(Proportional, [1 2 3 4 5 6 7 8])
% 
%     GVS_Signal = (GIST_param(:,Proportional))'; 
%     signal_max = max(abs(GVS_Signal));
%     scale = PmA(iter)/signal_max;
%     C = scale;
% 
% elseif Proportional < 8 && Proportional > 1
%        Type_1 = floor(Proportional);
%        Type_2 = ceil(Proportional);
% 
%        Weight_1 = Type_2 - Proportional;
%        Weight_2 = 1-Weight_1; 
% 
%        Signal_1 = (GIST_param(:,Type_1))'; 
%        Signal_2 = (GIST_param(:,Type_2))'; 
% 
%        signal_max1 = max(abs(Signal_1));
%        signal_max2 = max(abs(Signal_2));
% 
%        Signal_1 = Signal_1 / signal_max1;
%        Signal_2 = Signal_2 / signal_max2;
% 
%        GVS_Signal = Signal_1*Weight_1+Signal_2*Weight_2;
% 
%        signal_max = max(abs(GVS_Signal));
%        GVS_Signal = GVS_Signal/max(abs(GVS_Signal));
% 
%        scale = (PmA(iter));
% %        C = scale/(signal_max1*Weight_1+signal_max2*Weight_2);
%        C = scale/signal_max;
% 
% elseif Proportional <1 && Proportional>0
%     %special case where proportional to angle and abs(velocity)
% 
%        Type_2 = 8; % angle
%        Type_1 = 7; % velocity
% 
%        Weight_1 = 1-Proportional; 
%        Weight_2 = 1-Weight_1; 
% 
%        Signal_1 = abs((GIST_param(:,Type_1)))'; 
%        Signal_2 = (GIST_param(:,Type_2))'; 
% 
%        signal_max1 = max(abs(Signal_1));
%        signal_max2 = max(abs(Signal_2));
% 
%        Signal_1 = Signal_1 / signal_max1;
%        Signal_2 = Signal_2 / signal_max2;
% 
%        [loc] =find(Signal_2<0);
%        Signal_1(loc) = Signal_1(loc)*-1;
% 
%        GVS_Signal = Signal_1*Weight_1+Signal_2*Weight_2;
% 
%        signal_max = max(abs(GVS_Signal));
%        GVS_Signal = GVS_Signal/max(abs(GVS_Signal));
% 
%        scale = (PmA(iter));
% %        C = scale/(signal_max1*Weight_1+signal_max2*Weight_2);
%        C = scale/signal_max;
% 
% elseif Proportional >-1 && Proportional<0
%     %special case where proportional to velocity and abs(angle)
% 
%        Type_2 = 8; % angle
%        Type_1 = 7; % velocity
% 
%        Weight_1 = 1+Proportional; % equal weighting for now
%        Weight_2 = 1-Weight_1; 
% 
%        Signal_1 = (GIST_param(:,Type_1))'; 
%        Signal_2 = abs(GIST_param(:,Type_2))'; 
% 
%        signal_max1 = max(abs(Signal_1));
%        signal_max2 = max(abs(Signal_2));
% 
%        Signal_1 = Signal_1 / signal_max1;
%        Signal_2 = Signal_2 / signal_max2;
% 
%        [loc] =find(Signal_1<0);
%        Signal_2(loc) = Signal_2(loc)*-1;
% 
%        GVS_Signal = Signal_1*Weight_1+Signal_2*Weight_2;
% 
%        signal_max = max(abs(GVS_Signal));
%        GVS_Signal = GVS_Signal/max(abs(GVS_Signal));
% 
%        scale = (PmA(iter));
% %        C = scale/(signal_max1*Weight_1+signal_max2*Weight_2);
%        C = scale/signal_max;
% 
% elseif Proportional <-1
%       % special case where angle and velocity are coupled with opposite
%       % signs - default as velocity + and angle negative
%        Type_1 = floor(abs(Proportional));
%        Type_2 = ceil(abs(Proportional));
% 
%        Weight_1 = Type_2 - abs(Proportional);
%        Weight_2 = 1-Weight_1; 
% 
%        Signal_1 = (GIST_param(:,Type_1))'; 
%        Signal_2 = -1*(GIST_param(:,Type_2))'; 
% 
%        signal_max1 = max(abs(Signal_1));
%        signal_max2 = max(abs(Signal_2));
% 
%        % Signal_1 = Signal_1 / signal_max1;
%        % Signal_2 = Signal_2 / signal_max2;
% 
%        GVS_Signal = Signal_1*Weight_1+Signal_2*Weight_2;
% 
%        signal_max = max(abs(GVS_Signal));
%        GVS_Signal = GVS_Signal/max(abs(GVS_Signal));
% 
%        scale = (PmA(iter));
% %        C = scale/(signal_max1*Weight_1+signal_max2*Weight_2);
%        C = scale/signal_max;
% end 
% 
% GVS_Signal = GVS_Signal*(scale);
% 
% 
% elseif GIST_IMU == 1
%     % for now assuming only channel 1 is in use so only bilateral GVS (2
%     % electrodes)
% 
%     % channel 1
%     if Couple_1 == "Roll"
%         Signal_1 = (GIST_param(:,8))'; 
%         max_1 = max_angle;
%     elseif Couple_1 == "ZVelocity"
%         Signal_1 = -(GIST_param(:,7))'; 
%         max_1 = max_vel;
%     elseif Couple_1 == "Pitch"
%         Signal_1 = (GIST_param(:,6))'; 
%         max_1 = max_angle;
%     elseif Couple_1 == "XVelocity"
%         Signal_1 = -(GIST_param(:,5))'; 
%         max_1 = max_vel;
%     elseif Couple_1 == "Yaw"
%         Signal_1 = (GIST_param(:,4))'; 
%         max_1 = max_angle;
%     elseif Couple_1 == "YVelocity"
%         Signal_1 = -(GIST_param(:,3))'; 
%         max_1 = max_vel;
%     end
% 
%     if Couple_2 == "Roll"
%         Signal_2 = (GIST_param(:,8))'; 
%         max_2 = max_angle;
%     elseif Couple_2 == "ZVelocity"
%         Signal_2 = -(GIST_param(:,7))'; 
%         max_2 = max_vel;
%     elseif Couple_2 == "Pitch"
%         Signal_2 = (GIST_param(:,6))'; 
%         max_2 = max_angle;
%     elseif Couple_2 == "XVelocity"
%         Signal_2 = -(GIST_param(:,5))'; 
%         max_2 = max_vel;
%     elseif Couple_2 == "Yaw"
%         Signal_2 = (GIST_param(:,4))'; 
%         max_2 = max_angle;
%     elseif Couple_2 == "YVelocity"
%         Signal_2 = -(GIST_param(:,3))'; 
%         max_2 = max_vel;
%     end
% 
%     % channel 2
%     if Couple_3 == "Roll"
%         Signal_3 = (GIST_param(:,8))'; 
%         max_3 = max_angle;
%     elseif Couple_3 == "ZVelocity"
%         Signal_3 = -(GIST_param(:,7))'; 
%         max_3 = max_vel;
%     elseif Couple_3 == "Pitch"
%         Signal_3 = (GIST_param(:,6))'; 
%         max_3 = max_angle;
%     elseif Couple_3 == "XVelocity"
%         Signal_3 = -(GIST_param(:,5))'; 
%         max_3 = max_vel;
%     elseif Couple_3 == "Yaw"
%         Signal_3 = (GIST_param(:,4))'; 
%         max_3 = max_angle;
%     elseif Couple_3 == "YVelocity"
%         Signal_3 = -(GIST_param(:,3))'; 
%         max_3 = max_vel;
%     end
% 
%     if Couple_4 == "Roll"
%         Signal_4 = (GIST_param(:,8))'; 
%         max_4 = max_angle;
%     elseif Couple_4 == "ZVelocity"
%         Signal_4 = -(GIST_param(:,7))'; 
%         max_4 = max_vel;
%     elseif Couple_4 == "Pitch"
%         Signal_4 = (GIST_param(:,6))'; 
%         max_4 = max_angle;
%     elseif Couple_4 == "XVelocity"
%         Signal_4 = -(GIST_param(:,5))'; 
%         max_4 = max_vel;
%     elseif Couple_4 == "Yaw"
%         Signal_4 = (GIST_param(:,4))'; 
%         max_4 = max_angle;
%     elseif Couple_4 == "YVelocity"
%         Signal_4 = -(GIST_param(:,3))'; 
%         max_4 = max_vel;
%     end
% 
%      % channel 3
%     if Couple_5 == "Roll"
%         Signal_5 = (GIST_param(:,8))'; 
%         max_5 = max_angle;
%     elseif Couple_5 == "ZVelocity"
%         Signal_5 = -(GIST_param(:,7))'; 
%         max_5 = max_vel;
%     elseif Couple_5 == "Pitch"
%         Signal_5 = (GIST_param(:,6))'; 
%         max_5 = max_angle;
%     elseif Couple_5 == "XVelocity"
%         Signal_5 = -(GIST_param(:,5))'; 
%         max_5 = max_vel;
%     elseif Couple_5 == "Yaw"
%         Signal_5 = (GIST_param(:,4))'; 
%         max_5 = max_angle;
%     elseif Couple_5 == "YVelocity"
%         Signal_5 = -(GIST_param(:,3))'; 
%         max_5 = max_vel;
%     end
% 
%     if Couple_6 == "Roll"
%         Signal_6 = (GIST_param(:,8))'; 
%         max_6 = max_angle;
%     elseif Couple_6 == "ZVelocity"
%         Signal_6 = -(GIST_param(:,7))'; 
%         max_6 = max_vel;
%     elseif Couple_6 == "Pitch"
%         Signal_6 = (GIST_param(:,6))'; 
%         max_6 = max_angle;
%     elseif Couple_6 == "XVelocity"
%         Signal_6 = -(GIST_param(:,5))'; 
%         max_6 = max_vel;
%     elseif Couple_6 == "Yaw"
%         Signal_6 = (GIST_param(:,4))'; 
%         max_6 = max_angle;
%     elseif Couple_6 == "YVelocity"
%         Signal_6 = -(GIST_param(:,3))'; 
%         max_6 = max_vel;
%     end
% 
% 
%     GVS_Signal_1 = K1/999*(mA_max/max_1)*(Signal_1-Threshold_1) + K2/999*(mA_max/max_2)*(Signal_2-Threshold_2);
%     GVS_Signal_2 = K3/999*(mA_max/max_3)*(Signal_3-Threshold_3) + K4/999*(mA_max/max_4)*(Signal_4-Threshold_4);
%     GVS_Signal_3 = K5/999*(mA_max/max_5)*(Signal_5-Threshold_5) + K6/999*(mA_max/max_6)*(Signal_6-Threshold_6);
% 
% % if statements on how to program electrodes depending on which/how many
% % channels are on.
% 
% if Ch1>=1 && Ch2==0 && Ch3 ==0 % bilateral for Sparky
%     GVS_Signal = GVS_Signal_1;
%     Num_Electrode = 2;
%     GIST_electrodes = 2;
% 
% elseif Ch1==0 && Ch2>=1 && Ch3 ==0  % bilateral for Sparky
%     GVS_Signal = GVS_Signal_2;
%     Num_Electrode = 2;
%     GIST_electrodes = 2;
% 
% elseif Ch1==0 && Ch2==0 && Ch3 >=1  % bilateral for Sparky
%     GVS_Signal = GVS_Signal_3;
%     Num_Electrode = 2;
%     GIST_electrodes = 2;
% 
% elseif Ch1>=1 && Ch2>=1 && Ch3 ==0  % "aoyama" for Sparky
%     Num_Electrode = 4;
%     GIST_electrodes = 4;
%     GVS_Signal = GVS_Signal_1;
%     GVS_Signal_1 = GVS_Signal_1;
%     GVS_Signal_2 = GVS_Signal_2;
% 
% elseif Ch1>=1 && Ch2==0 && Ch3 >=1 % "aoyama" for Sparky
%     Num_Electrode = 4;
%     GIST_electrodes = 4;
%     GVS_Signal = GVS_Signal_1;
%     GVS_Signal_1 = GVS_Signal_1;
%     GVS_Signal_2 = GVS_Signal_3;
% 
% elseif Ch1==0 && Ch2>=1 && Ch3 >=1 % "aoyama" for Sparky
%     Num_Electrode = 4;
%     GIST_electrodes = 4;
%     GVS_Signal = GVS_Signal_2;
%     GVS_Signal_1 = GVS_Signal_2;
%     GVS_Signal_2 = GVS_Signal_3;
% 
% 
% elseif Ch1>= 1 && Ch2>=1 && Ch3>=1 % combine channels into "aoyama" for Sparky
%     Num_Electrode = 4;
%     GIST_electrodes = 6;
%     GVS_Signal = GVS_Signal_1;
% 
% end
% 
% 
%     GVS_Signal(GVS_Signal > mA_max) = mA_max;
%     GVS_Signal(GVS_Signal < -mA_max) = -mA_max;
% 
%     GVS_Signal_1(GVS_Signal_1 > mA_max) = mA_max;
%     GVS_Signal_1(GVS_Signal_1 < -mA_max) = -mA_max;
% 
%     GVS_Signal_2(GVS_Signal_2 > mA_max) = mA_max;
%     GVS_Signal_2(GVS_Signal_2 < -mA_max) = -mA_max;
% 
%     GVS_Signal_3(GVS_Signal_3 > mA_max) = mA_max;
%     GVS_Signal_3(GVS_Signal_3 < -mA_max) = -mA_max;
% 
% 
%     C = 0; % normally C is scale/maxGVS not sure why
% 
% end 
% 
% maxGVS = max(abs(GVS_Signal));
% 
% GVS_Signal = [ zeros(zpad*fs) GVS_Signal];
% dt =1/fs;
% T = length(GVS_Signal);
% t = (0:T-1)*dt;
% 
% Filename = strtrim(strjoin([input_filearg(1:end-4) "_" num2str(PmA(iter)) "mA_prop"  num2str(Proportional)])); %C(iter)
% if GIST_IMU == 1
%     % Filename = strtrim(strjoin([input_filearg(1:end-4) "_DC_" num2str(mA_max(iter)) ...
%     %     "mAmax_Ch1"  num2str(K1) Couple_1 num2str(K2) Couple_2 ...
%     %     "_Ch2"  num2str(K3) Couple_3 num2str(K4) Couple_4 ...
%     %     "_Ch3"  num2str(K5) Couple_5 num2str(K6) Couple_6 ...
%     %     "MaxAngle" num2str(max_angle) "MaxVel" num2str(max_vel)]));
%     Filename = strtrim(strjoin([input_filearg(1:end-4) "_DC_" num2str(mA_max(iter)) ...
%         "mAmax"]));
%     if Ch1 ==1
%         Filename = strtrim(strjoin([Filename "_Ch1"  num2str(K1) Couple_1 num2str(K2) Couple_2]));
%     end
%     if Ch2 == 1
%         Filename = strtrim(strjoin([Filename "_Ch2"  num2str(K3) Couple_3 num2str(K4) Couple_4]));
%     end
%     if Ch3 ==1
%         Filename = strtrim(strjoin([Filename "_Ch3"  num2str(K5) Couple_5 num2str(K6) Couple_6]));
%     end
% end
% Filename = strtrim(strjoin([Filename "_MaxAngle" num2str(max_angle) "MaxVel" num2str(max_vel)]));
% Filename = strrep(Filename, '.', '_');
% Filename = strrep(Filename, ' ', '');
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Other setup
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % PmA = max(abs(GVS_Signal));
% 
% if maxGVS>6 %can now go up to 6 mA instead of just 3mA
%     error('Error: Peak current cannot exceed 6 mA.')
% end
% if Num_Electrode<2 || Num_Electrode>5
%     error('Error: Number of electrodes cannot be <2 or >5.');
% end
% 
% 
% % 
% % dt=1/fs;  %%% seconds per sample.
% % t=(0:dt:Duration);  %%% time vector (in seconds).
% % T=length(t);
% % freq=0:fs/T:fs/2;
% % 
% % %% Run appropriate signal generator.
% % if Profile_Type==1
% %     [GVS_Signal]=Sinusoidal_Ramp(t,fs,PmA,Polarity_Type,Sin_freq);
% %     T = length(GVS_Signal);
% %     t = (0:T-1)*dt;
% % elseif Profile_Type==2
% %     GVS_Signal=Noise(fs,T,PmA,Polarity_Type);
% % elseif Profile_Type ==3 %DC
% %     GVS_Signal(1:T) = PmA;
% %     GVS_Signal(1:ramp_time*fs) = t(1:ramp_time*fs)*PmA/ramp_time;
% %     GVS_Signal((T-ramp_time*fs)+1:T) = t(ramp_time*fs:-1:1)*PmA/ramp_time;
% % end
% 
% % Power Spectral Density Analysis:
% %% GVS Signal
% xdft=fft(GVS_Signal);
% xdft=xdft(1:T/2+1);
% psdx=(1/(fs*T))*abs(xdft).^2;
% psdx(2:end-1)=2*psdx(2:end-1);
% 
% %% Create GVS signals for all electrodes.
% Electrode_1_Sig=GVS_Signal;
% if Num_Electrode==2
%     Electrode_2_Sig=GVS_Signal*(-1);
%     if Current_Direction ==2
%         Electrode_1_Sig=GVS_Signal*(-1);
%         Electrode_2_Sig=GVS_Signal;
%     end
%     Electrode_3_Sig=zeros(1,T);
%     Electrode_4_Sig=Electrode_3_Sig;
%     Electrode_5_Sig=Electrode_3_Sig;
% elseif Num_Electrode==3
%     if Current_Direction == 1
%         %electrodes 1&2 are cathodes 5 is the anode (backward)
%         Electrode_5_Sig = GVS_Signal;
%         Electrode_2_Sig=GVS_Signal*(-.5);
%         Electrode_1_Sig=Electrode_2_Sig;
%         Electrode_3_Sig=zeros(1,T); %Electrode_4_Sig;
%     elseif Current_Direction == 2
%         %electrodes 1&2 are anodes 5 is the cathode (forward)
%         Electrode_5_Sig = -GVS_Signal;
%         Electrode_2_Sig=GVS_Signal*(.5);
%         Electrode_1_Sig=Electrode_2_Sig;
%         Electrode_3_Sig=zeros(1,T); %Electrode_4_Sig;
%     else
%         Electrode_2_Sig=GVS_Signal*(-.5);
%         Electrode_3_Sig=Electrode_2_Sig;
%         Electrode_5_Sig=zeros(1,T); %Electrode_4_Sig;
%     end
%     Electrode_4_Sig=zeros(1,T);
% elseif Num_Electrode==5
%     if Electrode_Config==1
%         Electrode_2_Sig=GVS_Signal*(-.25);
%         Electrode_3_Sig=Electrode_2_Sig;
%         Electrode_4_Sig=Electrode_2_Sig;
%         Electrode_5_Sig=Electrode_2_Sig;
%     elseif Electrode_Config==2
%         Electrode_2_Sig=GVS_Signal;
%         Electrode_3_Sig=GVS_Signal*(-2/3);
%         Electrode_4_Sig=Electrode_3_Sig;
%         Electrode_5_Sig=Electrode_3_Sig;
%     end
% 
% elseif Num_Electrode==4 && GIST_IMU ==0
%     if Electrode_Config==1
%         Electrode_2_Sig=GVS_Signal*(-1/3);
%         Electrode_3_Sig=Electrode_2_Sig;
%         Electrode_4_Sig=Electrode_2_Sig;
%         Electrode_5_Sig=zeros(1,T);
%     elseif Electrode_Config==2
%         Electrode_5_Sig=zeros(1,T);% may need to switch this to match the length of the sinusoid - seems to be and 2 second difference?
%         if Current_Direction == 2
%             % electrodes 1&2 are cathodes(-) and 3&4 are anodes(+)
%             % (forward)- positive motion coupling
%             Electrode_1_Sig=GVS_Signal*(-1);
%             Electrode_2_Sig=Electrode_1_Sig;
%             Electrode_3_Sig=GVS_Signal;
%         else
%             % electrodes 1&2 are anodes (+) and 3&4 are cathodes (-) 
%             % (Backward) - negative motion coupling 
%             Electrode_2_Sig=GVS_Signal;
%             Electrode_3_Sig=GVS_Signal*(-1);
%         end
%         Electrode_4_Sig=Electrode_3_Sig;
%     end
% elseif Num_Electrode==4 && GIST_electrodes ==4
% 
%     % positive coupling we want the sign of the mastoid to be opposite of
%     % the motion- apparently not?
%     % 
%     Electrode_1_Sig= GVS_Signal_1; % left mastoid
%     Electrode_2_Sig= GVS_Signal_2;% right mastoid
% 
%     %
%     Electrode_3_Sig= -1*Electrode_1_Sig;% left distal
%     Electrode_4_Sig=-1*Electrode_2_Sig; % right distal
%     Electrode_5_Sig=zeros(1,T);
% 
% 
% elseif Num_Electrode==4 && GIST_electrodes ==6
%     % positive coupling we want the sign of the mastoid to be opposite of
%     % the motion
%     Electrode_1_Sig=(-1)*GVS_Signal_1+GVS_Signal_2 ; % left mastoid
%     Electrode_2_Sig=GVS_Signal_1 + GVS_Signal_3; % right mastoid
% 
% 
%     Electrode_3_Sig=-GVS_Signal_2; %left distal
%     Electrode_4_Sig=-GVS_Signal_3; % right distal
%     Electrode_5_Sig=zeros(1,T);
% 
% end
% 
% zpad_Zeros= zeros(zpad*fs,1);
% zpad_after_Zeros = zeros(zpad_after*fs,1);
% 
% %% Make electrode matrix, then round values to hundredths.
% ElectrodesM=[dt Electrode_1_Sig(2:end);    0  Electrode_2_Sig(2:end)  ;    0  Electrode_3_Sig(2:end)  ;    0  Electrode_4_Sig(2:end)  ;     0  Electrode_5_Sig(2:end)  ];
% ElectM100=ElectrodesM.*100; %% Multiply by 100 to remove the decimal.
% RoundElectM=round(ElectM100); %% Rounds to whole numbers.
% %%% Check that they all sum to zero. 
% SumElectrodes=sum(RoundElectM);
% j=find(SumElectrodes);
% if min(SumElectrodes(2:end))<-3 && max(SumElectrodes(2:end))>3
%     error('Error: Sum of electrodes at certain iterations is >30 uA. Check "j" values to see which iterations do not sum to zero.')
% end
% %%% Subtract additional currents (<30 uA) from Electrode 5.
% ModElect5=[0 (RoundElectM(5,2:end)-SumElectrodes(2:end))];
% NewElectM=[RoundElectM(1:4,:);ModElect5];
% %%% Check that they all sum to zero again.
% SumElectNew=sum(NewElectM(1:5,2:end));
% k=find(SumElectNew);
% if k~=0
%     error('Error: Electrodes did not sum to zero. Check "k" values.')
% end
% 
% %% Plot GVS signals.
% figure;
% subplot(2,3,1);
% title('Electrode 1 Signal (Blue)'); hold on;
% plot(t(1:end-1),(NewElectM(1,2:end)./100));
% xlabel('Time (seconds)');
% ylabel('Current (mA)');
% subplot(2,3,2);
% title('Electrode 2 Signal (White)'); hold on;
% plot(t(1:end-1),(NewElectM(2,2:end)./100));
% xlabel('Time (seconds)');
% ylabel('Current (mA)');
% subplot(2,3,3);
% title('Electrode 3 Signal (Green)'); hold on;
% plot(t(1:end-1),(NewElectM(3,2:end)./100));
% xlabel('Time (seconds)');
% ylabel('Current (mA)');
% subplot(2,3,4);
% title('Electrode 4 Signal (Yellow)'); hold on;
% plot(t(1:end-1),(NewElectM(4,2:end)./100));
% xlabel('Time (seconds)');
% ylabel('Current (mA)');
% subplot(2,3,5);
% title('Electrode 5 Signal (Black)'); hold on;
% plot(t(1:end-1),(NewElectM(5,2:end)./100));
% xlabel('Time (seconds)');
% ylabel('Current (mA)');
% subplot(2,3,6);
% dim = [.75 .1 .4 .3];
% str = strjoin(["C = " num2str(C)]);
% annotation('textbox',dim, 'String',str,'FitBoxToText','on');
% % legend(str)
% if Profile_Type == 2
% plot(freq,10*log10(psdx));
% grid on;
% title('GVS Signal Periodogram Using FFT');
% xlabel('Frequency (Hz)');
% ylabel('Power/Frequency (dB/Hz)');
% end
% %%
% cd(file_path);
% saveas(gcf, Filename);
% cd(code_path);
% 
% %% Create CSV file that removes decimals and adds +/- sign.
% X=num2str(NewElectM,'%+04g '); %% Create 5 character string with 3-digit number + symbol, then space after.
% %%% Create electrode matrix of 5 character values.
% Y(1,:)=strsplit(X(1,:)," ");
% Y(2,:)=strsplit(X(2,:)," ");
% Y(3,:)=strsplit(X(3,:)," ");
% Y(4,:)=strsplit(X(4,:)," ");
% Y(5,:)=strsplit(X(5,:)," ");
% Profile = Y;
% %% Write matlab file and save plot
% cd(file_path);
% save([char(Filename) '.mat'], 'Profile');
% cd(code_path);
% 
% clear GVS_Signal Signal_1 Signal_2
% end
% %writecell(Y,"CHAIR_GVS_Profile_.csv");
