%% Script 3 for X3C Functional Mobility Testing
% this script takes the data from script 2 and plots it for visual
% verification that the data was sorted correctly

close all; 
clear all; 
clc; 

%% setup
subnum = [ 3100];  % Subject List 1011:1022
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
                GIST_time = data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.TimeAdj;%/GIST_fs;
                GIST_roll = data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.Roll;
                GIST_pitch = data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.Pitch;
                GIST_yaw = data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.Yaw;
                GIST_xvel = data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.XVelocity;
                GIST_yvel = data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.YVelocity;
                GIST_zvel = data.ROM.GIST.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.ZVelocity;

                Wii_time = (data.ROM.Wii.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}(:,1)- data.ROM.Wii.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}(1,1))/1000;
                Wii_x = data.ROM.Wii.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}(:,6);
                Wii_y = data.ROM.Wii.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}(:,7);

                OPAL_time = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.Time;

                OPAL_headXacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.headXAcc;
                OPAL_headYacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.headYAcc;
                OPAL_headZacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.headZAcc;
                OPAL_headXvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.headXVel;
                OPAL_headYvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.headYVel;
                OPAL_headZvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.headZVel;

                OPAL_sternumXacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.sternumXAcc;
                OPAL_sternumYacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.sternumYAcc;
                OPAL_sternumZacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.sternumZAcc;
                OPAL_sternumXvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.sternumXVel;
                OPAL_sternumYvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.sternumYVel;
                OPAL_sternumZvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.sternumZVel;

                OPAL_lumbarXacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lumbarXAcc;
                OPAL_lumbarYacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lumbarYAcc;
                OPAL_lumbarZacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lumbarZAcc;
                OPAL_lumbarXvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lumbarXVel;
                OPAL_lumbarYvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lumbarYVel;
                OPAL_lumbarZvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lumbarZVel;

                OPAL_rfootXacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.rfootXAcc;
                OPAL_rfootYacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.rfootYAcc;
                OPAL_rfootZacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.rfootZAcc;
                OPAL_rfootXvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.rfootXVel;
                OPAL_rfootYvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.rfootYVel;
                OPAL_rfootZvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.rfootZVel;

                OPAL_lfootXacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lfootXAcc;
                OPAL_lfootYacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lfootYAcc;
                OPAL_lfootZacc = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lfootZAcc;
                OPAL_lfootXvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lfootXVel;
                OPAL_lfootYvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lfootYVel;
                OPAL_lfootZvel = data.ROM.OPALr.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lfootZVel;
                
                %Wii
                figure;
                subplot(2,1,1)
                plot(Wii_time,Wii_x);
                hold on;
                plot(Wii_time,Wii_y);
                legend(["x" "y"])

                subplot(2,1,2);
                plot(Wii_x,Wii_y);


                % head movement
                figure; 
                % GIST angle
                subplot(4,1,1)
                plot(GIST_time, GIST_roll); hold on; 
                plot(GIST_time, GIST_pitch);
                plot(GIST_time, GIST_yaw);
                legend(["roll" "pitch" "yaw"])
                title("GIST Angles")

                % GIST velocity
                subplot(4,1,2)
                plot(GIST_time, GIST_xvel); hold on; 
                plot(GIST_time, GIST_yvel);
                plot(GIST_time, GIST_zvel);
                legend(["xvel" "yvel" "zvel"])
                title("GIST Velocity")
                
                % OPAL head velocity
                subplot(4,1,3)
                plot(OPAL_time, OPAL_headXvel); hold on; 
                plot(OPAL_time, OPAL_headYvel);
                plot(OPAL_time, OPAL_headZvel);
                legend(["xvel" "yvel" "zvel"])
                title("OPAL Velocity")

                %OPAL Acc
                subplot(4,1,4)
                plot(OPAL_time, OPAL_headXacc); hold on; 
                plot(OPAL_time, OPAL_headYacc);
                plot(OPAL_time, OPAL_headZacc);
                legend(["xacc" "yacc" "zacc"])
                title("OPAL Acc")
                sgtitle([ROM_fields{phys_cond} GVS_fields{gvs_cond} ' Head IMU'])

                % other IMUs
                % OPAL head velocity
                figure;
                subplot(8,1,1)
                plot(OPAL_time, OPAL_sternumXvel); hold on; 
                plot(OPAL_time, OPAL_sternumYvel);
                plot(OPAL_time, OPAL_sternumZvel);
                legend(["xvel" "yvel" "zvel"])
                title("Sternum Velocity")

                %OPAL Acc
                subplot(8,1,2)
                plot(OPAL_time, OPAL_sternumXacc); hold on; 
                plot(OPAL_time, OPAL_sternumYacc);
                plot(OPAL_time, OPAL_sternumZacc);
                legend(["xacc" "yacc" "zacc"])
                title("Sternum Acc")

                % OPAL lumbar velocity
                subplot(8,1,3)
                plot(OPAL_time, OPAL_lumbarXvel); hold on; 
                plot(OPAL_time, OPAL_lumbarYvel);
                plot(OPAL_time, OPAL_lumbarZvel);
                legend(["xvel" "yvel" "zvel"])
                title("Lumbar Velocity")

                %OPAL Acc
                subplot(8,1,4)
                plot(OPAL_time, OPAL_lumbarXacc); hold on; 
                plot(OPAL_time, OPAL_lumbarYacc);
                plot(OPAL_time, OPAL_lumbarZacc);
                legend(["xacc" "yacc" "zacc"])
                title("Lumbar Acc")

                % OPAL rfoot velocity
                subplot(8,1,5)
                plot(OPAL_time, OPAL_rfootXvel); hold on; 
                plot(OPAL_time, OPAL_rfootYvel);
                plot(OPAL_time, OPAL_rfootZvel);
                legend(["xvel" "yvel" "zvel"])
                title("Rfoot Velocity")

                %OPAL Acc
                subplot(8,1,6)
                plot(OPAL_time, OPAL_rfootXacc); hold on; 
                plot(OPAL_time, OPAL_rfootYacc);
                plot(OPAL_time, OPAL_rfootZacc);
                legend(["xacc" "yacc" "zacc"])
                title("RfootAcc")

                % OPAL lfoot velocity
                subplot(8,1,7)
                plot(OPAL_time, OPAL_lfootXvel); hold on; 
                plot(OPAL_time, OPAL_lfootYvel);
                plot(OPAL_time, OPAL_lfootZvel);
                legend(["xvel" "yvel" "zvel"])
                title("Lfoot Velocity")

                %OPAL Acc
                subplot(8,1,8)
                plot(OPAL_time, OPAL_lfootXacc); hold on; 
                plot(OPAL_time, OPAL_lfootYacc);
                plot(OPAL_time, OPAL_lfootZacc);
                legend(["xacc" "yacc" "zacc"])
                title("Lfoot Acc")

                sgtitle([ROM_fields{phys_cond} GVS_fields{gvs_cond} ' IMU'])
            end
            disp("Please Review these plots for correctness and then press any key to continue");
        pause;
        close all
        end
        
    end

    %     disp("Please Review these plots for correctness and then press any key to continue");
    % pause;
    % close all
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
            GIST_time = data.FMT.GIST.(GVS_fields{gvs_cond}){1, trial}.TimeAdj;%/GIST_fs;

            GIST_roll = data.FMT.GIST.(GVS_fields{gvs_cond}){1, trial}.Roll;
            GIST_pitch = data.FMT.GIST.(GVS_fields{gvs_cond}){1, trial}.Pitch;
            GIST_yaw = data.FMT.GIST.(GVS_fields{gvs_cond}){1, trial}.Yaw;
            GIST_xvel = data.FMT.GIST.(GVS_fields{gvs_cond}){1, trial}.XVelocity;
            GIST_yvel = data.FMT.GIST.(GVS_fields{gvs_cond}){1, trial}.YVelocity;
            GIST_zvel = data.FMT.GIST.(GVS_fields{gvs_cond}){1, trial}.ZVelocity;


            OPAL_time = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.Time;

            OPAL_headXacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.headXAcc;
            OPAL_headYacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.headYAcc;
            OPAL_headZacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.headZAcc;
            OPAL_headXvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.headXVel;
            OPAL_headYvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.headYVel;
            OPAL_headZvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.headZVel;

            OPAL_sternumXacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.sternumXAcc;
            OPAL_sternumYacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.sternumYAcc;
            OPAL_sternumZacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.sternumZAcc;
            OPAL_sternumXvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.sternumXVel;
            OPAL_sternumYvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.sternumYVel;
            OPAL_sternumZvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.sternumZVel;

            OPAL_lumbarXacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.lumbarXAcc;
            OPAL_lumbarYacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.lumbarYAcc;
            OPAL_lumbarZacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.lumbarZAcc;
            OPAL_lumbarXvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.lumbarXVel;
            OPAL_lumbarYvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.lumbarYVel;
            OPAL_lumbarZvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.lumbarZVel;

            OPAL_rfootXacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.rfootXAcc;
            OPAL_rfootYacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.rfootYAcc;
            OPAL_rfootZacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.rfootZAcc;
            OPAL_rfootXvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.rfootXVel;
            OPAL_rfootYvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.rfootYVel;
            OPAL_rfootZvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.rfootZVel;

            OPAL_lfootXacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.lfootXAcc;
            OPAL_lfootYacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.lfootYAcc;
            OPAL_lfootZacc = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.lfootZAcc;
            OPAL_lfootXvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.lfootXVel;
            OPAL_lfootYvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.lfootYVel;
            OPAL_lfootZvel = data.FMT.OPALr.(GVS_fields{gvs_cond}){1, trial}.lfootZVel;
            

            % head movement
            figure;
            % GIST angle
            subplot(4,1,1)
            plot(GIST_time, GIST_roll); hold on; 
            plot(GIST_time, GIST_pitch);
            plot(GIST_time, GIST_yaw);
            legend(["roll" "pitch" "yaw"])
            title("GIST Angles")

            % GIST velocity
            subplot(4,1,2)
            plot(GIST_time, GIST_xvel); hold on; 
            plot(GIST_time, GIST_yvel);
            plot(GIST_time, GIST_zvel);
            legend(["xvel" "yvel" "zvel"])
            title("GIST Velocity")
            
            % OPAL head velocity
            subplot(4,1,3)
            plot(OPAL_time, OPAL_headXvel); hold on; 
            plot(OPAL_time, OPAL_headYvel);
            plot(OPAL_time, OPAL_headZvel);
            legend(["xvel" "yvel" "zvel"])
            title("OPAL Velocity")

            %OPAL Acc
            subplot(4,1,4)
            plot(OPAL_time, OPAL_headXacc); hold on; 
            plot(OPAL_time, OPAL_headYacc);
            plot(OPAL_time, OPAL_headZacc);
            legend(["xacc" "yacc" "zacc"])
            title("OPAL Acc")
            sgtitle([ GVS_fields{gvs_cond} ' Head IMU'])


            % other IMUs
            % OPAL head velocity
            figure;
            subplot(8,1,1)
            plot(OPAL_time, OPAL_sternumXvel); hold on; 
            plot(OPAL_time, OPAL_sternumYvel);
            plot(OPAL_time, OPAL_sternumZvel);
            legend(["xvel" "yvel" "zvel"])
            title("Sternum Velocity")

            %OPAL Acc
            subplot(8,1,2)
            plot(OPAL_time, OPAL_sternumXacc); hold on; 
            plot(OPAL_time, OPAL_sternumYacc);
            plot(OPAL_time, OPAL_sternumZacc);
            legend(["xacc" "yacc" "zacc"])
            title("Sternum Acc")

            % OPAL lumbar velocity
            subplot(8,1,3)
            plot(OPAL_time, OPAL_lumbarXvel); hold on; 
            plot(OPAL_time, OPAL_lumbarYvel);
            plot(OPAL_time, OPAL_lumbarZvel);
            legend(["xvel" "yvel" "zvel"])
            title("Lumbar Velocity")

            %OPAL Acc
            subplot(8,1,4)
            plot(OPAL_time, OPAL_lumbarXacc); hold on; 
            plot(OPAL_time, OPAL_lumbarYacc);
            plot(OPAL_time, OPAL_lumbarZacc);
            legend(["xacc" "yacc" "zacc"])
            title("Lumbar Acc")

            % OPAL rfoot velocity
            subplot(8,1,5)
            plot(OPAL_time, OPAL_rfootXvel); hold on; 
            plot(OPAL_time, OPAL_rfootYvel);
            plot(OPAL_time, OPAL_rfootZvel);
            legend(["xvel" "yvel" "zvel"])
            title("Rfoot Velocity")

            %OPAL Acc
            subplot(8,1,6)
            plot(OPAL_time, OPAL_rfootXacc); hold on; 
            plot(OPAL_time, OPAL_rfootYacc);
            plot(OPAL_time, OPAL_rfootZacc);
            legend(["xacc" "yacc" "zacc"])
            title("RfootAcc")

            % OPAL lfoot velocity
            subplot(8,1,7)
            plot(OPAL_time, OPAL_lfootXvel); hold on; 
            plot(OPAL_time, OPAL_lfootYvel);
            plot(OPAL_time, OPAL_lfootZvel);
            legend(["xvel" "yvel" "zvel"])
            title("Lfoot Velocity")

            %OPAL Acc
            subplot(8,1,8)
            plot(OPAL_time, OPAL_lfootXacc); hold on; 
            plot(OPAL_time, OPAL_lfootYacc);
            plot(OPAL_time, OPAL_lfootZacc);
            legend(["xacc" "yacc" "zacc"])
            title("Lfoot Acc")

            sgtitle([ GVS_fields{gvs_cond} ' IMU'])
        end
        disp("Please Review these plots for correctness and then press any key to continue");
    pause;
    close all
    end

    %     disp("Please Review these plots for correctness and then press any key to continue");
    % pause;
    % close all
end

if contains(include, 'TDM')
    %% Tandem
    TDM_fields = fieldnames(data.TDM.GIST);


    for phys_cond = 1:length(TDM_fields)
        GVS_fields = fieldnames(data.TDM.GIST.(TDM_fields{phys_cond}));
        for gvs_cond = 1:length(GVS_fields)
            [~,num_trials] = size(data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}));
            for trial = 1:num_trials

                trial_num = data.TDM.Trial_Num.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial};
                GIST_time = data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.TimeAdj;%/GIST_fs;

                GIST_roll = data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.Roll;
                GIST_pitch = data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.Pitch;
                GIST_yaw = data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.Yaw;
                GIST_xvel = data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.XVelocity;
                GIST_yvel = data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.YVelocity;
                GIST_zvel = data.TDM.GIST.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.ZVelocity;

                OPAL_time = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.Time;

                OPAL_headXacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.headXAcc;
                OPAL_headYacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.headYAcc;
                OPAL_headZacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.headZAcc;
                OPAL_headXvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.headXVel;
                OPAL_headYvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.headYVel;
                OPAL_headZvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.headZVel;

                OPAL_sternumXacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.sternumXAcc;
                OPAL_sternumYacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.sternumYAcc;
                OPAL_sternumZacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.sternumZAcc;
                OPAL_sternumXvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.sternumXVel;
                OPAL_sternumYvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.sternumYVel;
                OPAL_sternumZvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.sternumZVel;

                OPAL_lumbarXacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lumbarXAcc;
                OPAL_lumbarYacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lumbarYAcc;
                OPAL_lumbarZacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lumbarZAcc;
                OPAL_lumbarXvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lumbarXVel;
                OPAL_lumbarYvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lumbarYVel;
                OPAL_lumbarZvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lumbarZVel;

                OPAL_rfootXacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.rfootXAcc;
                OPAL_rfootYacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.rfootYAcc;
                OPAL_rfootZacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.rfootZAcc;
                OPAL_rfootXvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.rfootXVel;
                OPAL_rfootYvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.rfootYVel;
                OPAL_rfootZvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.rfootZVel;

                OPAL_lfootXacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lfootXAcc;
                OPAL_lfootYacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lfootYAcc;
                OPAL_lfootZacc = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lfootZAcc;
                OPAL_lfootXvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lfootXVel;
                OPAL_lfootYvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lfootYVel;
                OPAL_lfootZvel = data.TDM.OPALr.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){1, trial}.lfootZVel;
                

                % head movement
                figure;
                % GIST angle
                subplot(4,1,1)
                plot(GIST_time, GIST_roll); hold on; 
                plot(GIST_time, GIST_pitch);
                plot(GIST_time, GIST_yaw);
                legend(["roll" "pitch" "yaw"])
                title("GIST Angles")

                % GIST velocity
                subplot(4,1,2)
                plot(GIST_time, GIST_xvel); hold on; 
                plot(GIST_time, GIST_yvel);
                plot(GIST_time, GIST_zvel);
                legend(["xvel" "yvel" "zvel"])
                title("GIST Velocity")
                
                % OPAL head velocity
                subplot(4,1,3)
                plot(OPAL_time, OPAL_headXvel); hold on; 
                plot(OPAL_time, OPAL_headYvel);
                plot(OPAL_time, OPAL_headZvel);
                legend(["xvel" "yvel" "zvel"])
                title("OPAL Velocity")

                %OPAL Acc
                subplot(4,1,4)
                plot(OPAL_time, OPAL_headXacc); hold on; 
                plot(OPAL_time, OPAL_headYacc);
                plot(OPAL_time, OPAL_headZacc);
                legend(["xacc" "yacc" "zacc"])
                title("OPAL Acc")
                sgtitle([TDM_fields{phys_cond} GVS_fields{gvs_cond} ' Head IMU'])

                sgtitle([TDM_fields{phys_cond} GVS_fields{gvs_cond} ' Wii'])

                % other IMUs
                % OPAL head velocity
                figure;
                subplot(8,1,1)
                plot(OPAL_time, OPAL_sternumXvel); hold on; 
                plot(OPAL_time, OPAL_sternumYvel);
                plot(OPAL_time, OPAL_sternumZvel);
                legend(["xvel" "yvel" "zvel"])
                title("Sternum Velocity")

                %OPAL Acc
                subplot(8,1,2)
                plot(OPAL_time, OPAL_sternumXacc); hold on; 
                plot(OPAL_time, OPAL_sternumYacc);
                plot(OPAL_time, OPAL_sternumZacc);
                legend(["xacc" "yacc" "zacc"])
                title("Sternum Acc")

                % OPAL lumbar velocity
                subplot(8,1,3)
                plot(OPAL_time, OPAL_lumbarXvel); hold on; 
                plot(OPAL_time, OPAL_lumbarYvel);
                plot(OPAL_time, OPAL_lumbarZvel);
                legend(["xvel" "yvel" "zvel"])
                title("Lumbar Velocity")

                %OPAL Acc
                subplot(8,1,4)
                plot(OPAL_time, OPAL_lumbarXacc); hold on; 
                plot(OPAL_time, OPAL_lumbarYacc);
                plot(OPAL_time, OPAL_lumbarZacc);
                legend(["xacc" "yacc" "zacc"])
                title("Lumbar Acc")

                % OPAL rfoot velocity
                subplot(8,1,5)
                plot(OPAL_time, OPAL_rfootXvel); hold on; 
                plot(OPAL_time, OPAL_rfootYvel);
                plot(OPAL_time, OPAL_rfootZvel);
                legend(["xvel" "yvel" "zvel"])
                title("Rfoot Velocity")

                %OPAL Acc
                subplot(8,1,6)
                plot(OPAL_time, OPAL_rfootXacc); hold on; 
                plot(OPAL_time, OPAL_rfootYacc);
                plot(OPAL_time, OPAL_rfootZacc);
                legend(["xacc" "yacc" "zacc"])
                title("RfootAcc")

                % OPAL lfoot velocity
                subplot(8,1,7)
                plot(OPAL_time, OPAL_lfootXvel); hold on; 
                plot(OPAL_time, OPAL_lfootYvel);
                plot(OPAL_time, OPAL_lfootZvel);
                legend(["xvel" "yvel" "zvel"])
                title("Lfoot Velocity")

                %OPAL Acc
                subplot(8,1,8)
                plot(OPAL_time, OPAL_lfootXacc); hold on; 
                plot(OPAL_time, OPAL_lfootYacc);
                plot(OPAL_time, OPAL_lfootZacc);
                legend(["xacc" "yacc" "zacc"])
                title("Lfoot Acc")

                sgtitle([TDM_fields{phys_cond} GVS_fields{gvs_cond} ' IMU'])
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
            GIST_time = data.TTS.GIST.(GVS_fields{gvs_cond}){1, trial}.TimeAdj;%/GIST_fs;
           GIST_roll = data.TTS.GIST.(GVS_fields{gvs_cond}){1, trial}.Roll;
            GIST_pitch = data.TTS.GIST.(GVS_fields{gvs_cond}){1, trial}.Pitch;
            GIST_yaw = data.TTS.GIST.(GVS_fields{gvs_cond}){1, trial}.Yaw;
            GIST_xvel = data.TTS.GIST.(GVS_fields{gvs_cond}){1, trial}.XVelocity;
            GIST_yvel = data.TTS.GIST.(GVS_fields{gvs_cond}){1, trial}.YVelocity;
            GIST_zvel = data.TTS.GIST.(GVS_fields{gvs_cond}){1, trial}.ZVelocity;


            TTS_time = (data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var1- data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var1(1))/1000;
            TTS_motion = (data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var5)/200;
            TTS_rms = rms(TTS_motion);
            TTS_profile = (data.TTS.TTS.(GVS_fields{gvs_cond}){1, trial}.Var2)/200;
            prof_rms = rms(TTS_profile);

            % head movement
            figure;
            % GIST angle
            subplot(3,1,1)
            plot(GIST_time, GIST_roll); hold on; 
            plot(GIST_time, GIST_pitch);
            plot(GIST_time, GIST_yaw);
            legend(["roll" "pitch" "yaw"])
            title("GIST Angles")

            % GIST velocity
            subplot(3,1,2)
            plot(GIST_time, GIST_xvel); hold on; 
            plot(GIST_time, GIST_yvel);
            plot(GIST_time, GIST_zvel);
            legend(["xvel" "yvel" "zvel"])
            title("GIST Velocity")

            % TTS motion
            subplot(3,1,3)
            plot(TTS_time, TTS_motion); hold on; 
            plot(TTS_time, TTS_profile); 
            legend(["actual tilt" "dist prof"])
            title("TTS motion")
            
            sgtitle([GVS_fields{gvs_cond} 'RMS = ' num2str(TTS_rms) '(baseline = ' num2str(prof_rms) ')'])

        end
    end
        disp("Please Review these plots for correctness and then press any key to continue");
    pause;
    close all
end

end
