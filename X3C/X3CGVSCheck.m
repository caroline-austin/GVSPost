%% Script 3 for X3C Functional Mobility Testing
% this script takes the data from script 2 and plots it for visual
% verification that the correct GVS was applied. 

close all; 
clear all; 
clc; 

%% setup
subnum = [ 3099];  % Subject List 1011:1022
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part 

include = [" "];%FMT TDM TTS"];

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory it should be the Data folder for the experiment (on Sharepoint)
plots_path = [file_path '/Plots']; % specify where plots are saved
gvs_path = [file_path '/GVSProfiles']; %specify where to grab default GVS profiles from
% tts_path = [file_path '/TTSProfiles']; %specify where to grab baseline TTS profiles from

cd([code_path '/..']); 
[filenames]=file_path_info2(code_path, file_path); % get subfolder and file names from file folder


GIST_fs = 375;
SDWave_fs=125;
TTS_fs = 50;
SDWave = zeros(3*60*100,1);

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


    if contains(include, 'ROM')
 %% start with Romberg
    ROM_fields = fieldnames(data.ROM.GIST);

    for phys_cond = 1:length(ROM_fields)
        GVS_fields = fieldnames(data.ROM.GIST.(ROM_fields{phys_cond}));
        for gvs_cond = 1:length(GVS_fields)
            [~,num_trials] = size(data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}));
            for trial = 1:num_trials

                % if contains(GVS_fields{gvs_cond}, 'SDWVGVS')
                %     GIST_fs = 125;
                % elseif data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1,trial}.Time(end) < data.ROM.Pass.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1,trial}*375
                %     GIST_fs = 125;
                % else
                %     GIST_fs = 375;
                % end
                time = data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.TimeAdj;%/GIST_fs;
                [Ch1, Ch2, Ch3, currentR, currentL] = GIST_GVS_Est(data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}, GVS_fields{gvs_cond}, SDWave);

                figure;
                subplot(2,1,1)
                plot(time,(Ch1)); hold on; 
                plot(time,(data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.CH1Current)/1000)
                legend(["Ch1 est", "Ch1 act"])
                subplot(2,1,2)
                plot(time,(Ch2)); hold on;
                plot(time,(data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.CH2Current)/1000)
                legend(["Ch2 est", "Ch2 act"])
                % legend(["Ch1 est", "Ch2 est", "Ch1 act", "Ch 2act"])
                sgtitle([ROM_fields{phys_cond} GVS_fields{gvs_cond} ])
            end
        end
    end

        disp("Please Review these plots for correctness and then press any key to continue");
    pause;
    close all
    end

if contains(include,'FMT')
 %% FMT
    GVS_fields = fieldnames(data.FMT.GIST);



    for gvs_cond = 1:length(GVS_fields)
        [~,num_trials] = size(data.FMT.GIST.(GVS_fields{gvs_cond}));
        for trial = 1:num_trials

            % if contains(GVS_fields{gvs_cond}, 'SDWVGVS')
            %     GIST_fs = 125;
            % elseif data.FMT.GIST.(GVS_fields{gvs_cond}){1, trial}.Time(end) < data.FMT.Pass.(GVS_fields{gvs_cond}){1,trial}*375
            %     GIST_fs = 125;
            % else
            %     GIST_fs = 375;
            % end
            trial_num = data.FMT.Trial_Num.(GVS_fields{gvs_cond}){1, trial};
            time = data.FMT.GIST.(GVS_fields{gvs_cond}){1, trial}.TimeAdj;%/GIST_fs;
            [Ch1, Ch2, Ch3] = GIST_GVS_Est(data.FMT.GIST.(GVS_fields{gvs_cond}){1, trial}, GVS_fields{gvs_cond}, SDWave);

            figure;
            subplot(3,1,1)
            plot(time,Ch1); hold on; 
            plot(time,(data.FMT.GIST.(GVS_fields{gvs_cond}){1, trial}.CH1Current)/1000)
            legend(["Ch1 est", "Ch1 act"])
            subplot(3,1,2)
            plot(time,Ch2); hold on;
            plot(time,(data.FMT.GIST.(GVS_fields{gvs_cond}){1, trial}.CH2Current)/1000)
            legend(["Ch2 est", "Ch2 act"])
            subplot(3,1,3)
            plot(time,Ch3); hold on;
            plot(time,(data.FMT.GIST.(GVS_fields{gvs_cond}){1, trial}.CH3Current)/1000)
            legend(["Ch3 est", "Ch3 act"])
            % legend(["Ch1 est", "Ch2 est", "Ch1 act", "Ch 2act"])
            sgtitle(['FMT ' num2str(trial_num) ' ' GVS_fields{gvs_cond} ])
        end
    end

        disp("Please Review these plots for correctness and then press any key to continue");
    pause;
    close all
end

if contains(include, 'TDM')
    %% Tandem
    TDM_fields = fieldnames(data.TDM.GIST);


    for phys_cond = 1:length(TDM_fields)
        GVS_fields = fieldnames(data.TDM.GIST.(TDM_fields{phys_cond}));
        for gvs_cond = 1:length(GVS_fields)
            [~,num_trials] = size(data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}));
            for trial = 1:num_trials

                % if gvs_cond >1
                %     continue
                % end

                trial_num = data.TDM.Trial_Num.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial};
                time = data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.TimeAdj;%/GIST_fs;
                [Ch1, Ch2, Ch3] = GIST_GVS_Est(data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}, GVS_fields{gvs_cond}, SDWave);

                figure;
                subplot(3,1,1)
                plot(time,(Ch1)); hold on; 
                plot(time,(data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.CH1Current)/1000)
                legend(["Ch1 est", "Ch1 act"])
                ylim([-2.5 2.5]);
                subplot(3,1,2)
                plot(time,(Ch2)); hold on;
                plot(time,(data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.CH2Current)/1000)
                legend(["Ch2 est", "Ch2 act"])
                ylim([-2.5 2.5]);
                subplot(3,1,3)
                plot(time,(Ch3)); hold on;
                plot(time,(data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.CH3Current)/1000)
                legend(["Ch3 est", "Ch3 act"])
                ylim([-2.5 2.5]);
                % legend(["Ch1 est", "Ch2 est", "Ch1 act", "Ch 2act"])
                sgtitle([ 'TDM ' num2str(trial_num) ' ' TDM_fields{phys_cond} ' ' GVS_fields{gvs_cond} ])

                % CH1_act = (data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.CH1Current)/1000;
                % CH2_act = (data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.CH2Current)/1000;
                % CH3_act = (data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.CH3Current)/1000;
                % 
                % CH1_volt = (data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.CH1Voltage)/1000;
                % CH2_volt = (data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.CH2Voltage)/1000;
                % CH3_volt = (data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.CH3Voltage)/1000;
                % 
                % figure;
                % plot(time, Ch1-CH1_act); hold on;
                % plot(time, Ch2-CH2_act);
                % plot(time, Ch3-CH3_act);
                % legend(["1" "2" "3"])
                % 
                % figure;
                % plot(time, (abs(CH1_act)+abs(CH2_act)+abs(CH3_act))); hold on;
                % plot(time, (abs(Ch1)+abs(Ch2)+abs(Ch3)));
                % legend(["act" "est"])
                % ylim([0 8]);

                % figure;
                % plot(time, CH1_volt); hold on;
                % plot(time, CH2_volt); hold on;
                % plot(time, CH3_volt); 
                % plot(time, (abs(CH1_volt)+abs(CH2_volt)+abs(CH3_volt)))
                % plot(time, ((CH1_volt)+(CH2_volt)+(CH3_volt)))
                % legend(["1" "2" "3" "abstot" "tpt"])

            end
        end
    end
    disp("Please Review these plots for correctness and then press any key to continue");
    pause;
    close all
end

if contains(include, 'TTS')
%% TTS
    GVS_fields = fieldnames(data.TTS.GIST);

    for gvs_cond = 1:length(GVS_fields)
        [~,num_trials] = size(data.TTS.GIST.(GVS_fields{gvs_cond}));

        for trial = 1:num_trials

            [trial_length,~] = size(data.TTS.GIST.(GVS_fields{gvs_cond}){1, trial});
            if trial_length <1
                continue
            end

            % if contains(GVS_fields{gvs_cond}, 'SDWVGVS')
            %     GIST_fs = 125;
            % elseif data.TTS.GIST.(GVS_fields{gvs_cond}){1, trial}.Time(end) < 120*375
            %     GIST_fs = 125;
            % else
            %     GIST_fs = 375;
            % end
            trial_num = data.TTS.Trial_Num.(GVS_fields{gvs_cond}){1, trial};
            time = data.TTS.GIST.(GVS_fields{gvs_cond}){1, trial}.TimeAdj;%/GIST_fs;
            [Ch1, Ch2, Ch3, currentR, currentL] = GIST_GVS_Est(data.TTS.GIST.(GVS_fields{gvs_cond}){1, trial}, GVS_fields{gvs_cond}, SDWave);
            
            if contains(GVS_fields{gvs_cond}, 'DCWVGVS')
                Ch1_TTS_est = (data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var5(2:end))/200 *-0.892*2.5/10 + diff(data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var5)/200*-0.995*2.5/20;
                Ch1_TTS_est( Ch1_TTS_est>2.5) = 2.5;   
                Ch1_TTS_est( Ch1_TTS_est<-2.5) = -2.5; 
            else 
                Ch1_TTS_est = zeros(length(data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var5(2:end)),1);
            end

            figure;
            subplot(3,1,1)
            plot(time,Ch1); hold on; 
            plot(time,(data.TTS.GIST.(GVS_fields{gvs_cond}){1, trial}.CH1Current)/1000)
            legend(["Ch1 est", "Ch1 act"])
            ylabel("Current (mA)")

            subplot(3,1,2)
            plot((data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var1(2:end)- data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var1(1))/1000, Ch1_TTS_est)
            hold on;
            plot((data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var1- data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var1(1))/1000,(data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var10)/1000)             
            legend(["TTS GVS est","TTS GVS recording"])
            % legend(["Ch1 est", "Ch2 est", "Ch1 act", "Ch 2act"])
            ylabel("Current (V and mA)")

            subplot(3,1,3)
            plot((data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var1- data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var1(1))/1000,(data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var5)/200)
            hold on
            plot(time,(data.TTS.GIST.(GVS_fields{gvs_cond}){1, trial}.Roll))
            legend(["TTS Roll recording", "GIST Roll recording"])
            xlabel("Time (s)")
            ylabel("tilt (deg)")
            sgtitle([ 'TTS ' num2str(trial_num) ' ' GVS_fields{gvs_cond} ])
        end
    end
        disp("Please Review these plots for correctness and then press any key to continue");
    pause;
    close all
end

end
