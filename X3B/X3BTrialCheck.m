%% Script 3 for X3B Functional Mobility Testing
% this script takes the data from script 2 and plots it for visual
% verification that the correct GVS was applied. 

close all; 
clear all; 
clc; 

%% setup
subnum = [ 3094:3094];  % Subject List 1011:1022
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

plot_check = [""];

%% find data to plot
GVS_fs=125;
TTS_fs = 50;
cd(gvs_path)
Offset = readmatrix('MacDougall_2mA_max4mA_100HzSamplePos.csv');
Offset = resample(Offset, GVS_fs,100)*2.5/4;
cd(code_path)

%% 

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


    % start with Romberg
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
                plot((Ch1)); hold on; 
                plot(resample(data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){sub, trial}.CH1Current, GVS_fs,GIST_fs)/1000)
                legend(["Ch1 est", "Ch1 act"])
                subplot(2,1,2)
                plot((Ch2)); hold on;
                plot(resample(data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){sub, trial}.CH2Current,GVS_fs, GIST_fs)/1000)
                legend(["Ch2 est", "Ch2 act"])
                % legend(["Ch1 est", "Ch2 est", "Ch1 act", "Ch 2act"])
                title([ROM_fields{phys_cond} GVS_fields{gvs_cond} ])
            end
        end
    end

        disp("Please Review these plots for correctness and then press any key to continue");
    pause;
    close all

    % % either in above loop or separate loop - make plot that 
    % % for each condition (physical and GVS) make subplot to compare actual
    % % and anticipated GVS

    % FMT
    GVS_fields = fieldnames(data.FMT.GIST);



    for gvs_cond = 1:length(GVS_fields)
        [~,num_trials] = size(data.FMT.GIST.(GVS_fields{gvs_cond}));
        for trial = 1:num_trials

            [Ch1, Ch2, Ch3] = GIST_GVS(data.FMT.GIST.(GVS_fields{gvs_cond}){sub, trial}, GVS_fields{gvs_cond}, -Offset);


                if contains( GVS_fields{gvs_cond}, 'DCSD')
                    GIST_fs = 125;
                else 
                    GIST_fs = 375;
                end
            figure;
            subplot(2,1,1)
            plot(Ch1); hold on; 
            plot(resample(data.FMT.GIST.(GVS_fields{gvs_cond}){sub, trial}.CH1Current, GVS_fs,GIST_fs)/1000)
            legend(["Ch1 est", "Ch1 act"])
            subplot(2,1,2)
            plot(Ch2); hold on;
            plot(resample(data.FMT.GIST.(GVS_fields{gvs_cond}){sub, trial}.CH2Current, GVS_fs, GIST_fs)/1000)
            legend(["Ch2 est", "Ch2 act"])
            % legend(["Ch1 est", "Ch2 est", "Ch1 act", "Ch 2act"])
            title([GVS_fields{gvs_cond} ])
        end
    end

        disp("Please Review these plots for correctness and then press any key to continue");
    pause;
    close all
   
    % Tandem
    TDM_fields = fieldnames(data.TDM.GIST);


    for phys_cond = 1:length(TDM_fields)
        GVS_fields = fieldnames(data.TDM.GIST.(TDM_fields{phys_cond}));
        for gvs_cond = 1:length(GVS_fields)
            [~,num_trials] = size(data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}));
            for trial = 1:num_trials

                [Ch1, Ch2, Ch3] = GIST_GVS(data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){sub, trial}, GVS_fields{gvs_cond}, Offset);


                    if contains( GVS_fields{gvs_cond}, 'DCSD')
                        GIST_fs = 125;
                    else 
                        GIST_fs = 375;
                    end
                figure;
                subplot(2,1,1)
                plot((Ch1)); hold on; 
                plot(resample(data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){sub, trial}.CH1Current, GVS_fs,GIST_fs)/1000)
                legend(["Ch1 est", "Ch1 act"])
                subplot(2,1,2)
                plot((Ch2)); hold on;
                plot(resample(data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){sub, trial}.CH2Current,GVS_fs, GIST_fs)/1000)
                legend(["Ch2 est", "Ch2 act"])
                % legend(["Ch1 est", "Ch2 est", "Ch1 act", "Ch 2act"])
                title([TDM_fields{phys_cond} GVS_fields{gvs_cond} ])
            end
        end
    end
    disp("Please Review these plots for correctness and then press any key to continue");
    pause;
    close all
    % TTS
    GVS_fields = fieldnames(data.TTS.GIST);

    for gvs_cond = 1:length(GVS_fields)
        [~,num_trials] = size(data.TTS.GIST.(GVS_fields{gvs_cond}));
        
        for trial = 1:num_trials

            [trial_length,~] = size(data.TTS.GIST.(GVS_fields{gvs_cond}){sub, trial});
            if trial_length <1
                continue
            end


            if contains( GVS_fields{gvs_cond}, 'DCSD')
                GIST_fs = 125;
            else 
                GIST_fs = 375;
            end

            [Ch1, Ch2, Ch3] = GIST_GVS(data.TTS.GIST.(GVS_fields{gvs_cond}){sub, trial}, GVS_fields{gvs_cond}, Offset);
           
            figure;
            subplot(2,1,1)
            plot(Ch1); hold on; 
            plot(resample(data.TTS.GIST.(GVS_fields{gvs_cond}){sub, trial}.CH1Current, GVS_fs,GIST_fs)/1000)
            
            legend(["Ch1 est", "Ch1 act"])
            subplot(2,1,2)
            plot(resample(data.TTS.TTS.(GVS_fields{gvs_cond}){sub, trial}.Var10, GVS_fs,TTS_fs)/1000)
            legend(["TTS recording"])
            % legend(["Ch1 est", "Ch2 est", "Ch1 act", "Ch 2act"])
            title([GVS_fields{gvs_cond} ])
        end
    end
        disp("Please Review these plots for correctness and then press any key to continue");
    pause;
    close all

end

%%




function [Ch1, Ch2, Ch3] = GIST_GVS(imu_data, GVS_type,Offset)
    GVS_fs=125;
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
    z_vel = resample(imu_data.ZVelocity,GVS_fs,GIST_fs); % store roll tilt velocity 
    pitch = resample(imu_data.Pitch,GVS_fs,GIST_fs); % store pitch tilt
    x_vel = resample(imu_data.XVelocity,GVS_fs,GIST_fs); % store pitch tilt velocity 
    yaw = resample(imu_data.Yaw,GVS_fs,GIST_fs); % store yaw 
    y_vel = resample(imu_data.YVelocity,GVS_fs,GIST_fs); % store yaw velocity 

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
        K1 = [999 0 0 0 0 -999]/1000; % roll, pitch, yaw, x_vel, y_vel, z_vel   -> note that -K1 here is because GIST sign convention is flipped (ie negative mo
        K2 = [0 999 0 999 0 0]/1000; % roll, pitch, yaw, x_vel, y_vel, z_vel
        K3 = [0 999 0 999 0 0]/1000; % roll, pitch, yaw, x_vel, y_vel, z_vel
        Offset = 0;
    elseif contains(GVS_type, 'DCSD')
        K1 = [999 0 0 0 0 0]/999; % roll, pitch, yaw, x_vel, y_vel, z_vel   
        K2 = [0 999 0 0 0 0]/999; % roll, pitch, yaw, x_vel, y_vel, z_vel
        K3 = [0 999 0 0 0 0]/999; % roll, pitch, yaw, x_vel, y_vel, z_vel

        % K1 = [0 0 0 0 0 0]; % roll, pitch, yaw, x_vel, y_vel, z_vel   
        % K2 = [0 0 0 0 0 0]; % roll, pitch, yaw, x_vel, y_vel, z_vel
        % K3 = [0 0 0 0 0 0]; % roll, pitch, yaw, x_vel, y_vel, z_vel
        if len_data <len_Offset
            Offset = Offset(1:len_data);
        elseif len_data > len_Offset
            Offset = [Offset; Offset(1:(len_data-len_Offset))];
        end
    end

    Ch1 = ((roll*K1(1) +pitch*K1(2) +yaw*K1(3))*max_mA/max_ang + (x_vel *K1(4) + y_vel *K1(5) + z_vel*K1(6)) *max_mA/max_vel );
    Ch2 = ((roll*K2(1) +pitch*K2(2) +yaw*K2(3))*max_mA/max_ang + (x_vel *K2(4) + y_vel *K2(5) + z_vel*K2(6)) *max_mA/max_vel );
    Ch3 = ((roll*K3(1) +pitch*K3(2) +yaw*K3(3))*max_mA/max_ang + (x_vel *K3(4) + y_vel *K3(5) + z_vel*K3(6)) *max_mA/max_vel );

    Ch1(Ch1>max_mA) = max_mA;
    Ch2(Ch2>max_mA) = max_mA;
    Ch3(Ch3>max_mA) = max_mA;

    Ch1(Ch1<-max_mA) = -max_mA;
    Ch2(Ch2<-max_mA) = -max_mA;
    Ch3(Ch3<-max_mA) = -max_mA;

    Ch1 = Ch1 +Offset/1000;
    Ch2 = Ch2 +Offset/1000;
    Ch3 = Ch3 +Offset/1000;

    % if contains(GVS_type, 'DCON')
    %     Ch1 = abs(Ch1);
    %     Ch2 = abs(Ch2);
    %     Ch3 = abs(Ch3);
    % end



end

