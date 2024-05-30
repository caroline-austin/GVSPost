%% Script 2 for Manual Control Nulling Testing
% This script takes the .mat files from script 1 and plots it for
% visualization 

close all; clear; clc; 

%% setup
subnum = [ 3004:3004];  % Subject List 1011:1022
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part 


code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory it should be the Data folder for the experiment (on Sharepoint)
plots_path = [file_path '/Plots']; % specify where plots are saved
% gvs_path = [file_path '/GVSProfiles']; %specify where to grab default GVS profiles from
% tts_path = [file_path '/TTSProfiles']; %specify where to grab baseline TTS profiles from

cd([code_path '/..']); 
[filenames]=file_path_info2(code_path, file_path); % get subfolder and file names from file folder

%% plot for each subject

for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    subject_path = [file_path '\' subject_str];


% get info on the .mat files (output files from previous script) for the current subject
    cd([code_path '/..']);
    [subject_filenames]=file_path_info2(code_path,subject_path ); % get files from file folder
    num_sub_files = length(subject_filenames);
    cd([code_path '/..']);
    mat_filenames = get_filetype(subject_filenames, 'mat');
    num_files = length(mat_filenames);

    figure;
    trial= [];
    subplot(4,1,1)
    % for each of the output files read it in and plot it
    for i = 1:num_files
       current_mat_file = char(mat_filenames(i));
       if ~ contains(current_mat_file, 'Dist') 
           continue
       end
       
       %
       cd(subject_path);
       TTS_data = load(current_mat_file); 
       cd(code_path);

       if contains(current_mat_file, 'no')
            continue %make separate plot?
       end

       if (contains(current_mat_file, '12') || contains(current_mat_file, '15')) && length(TTS_data.tilt_actual) > 6004
           
           TTS_data.tilt_force = TTS_data.tilt_force(1:6004); 
           TTS_data.tilt_actual =  TTS_data.tilt_actual(1:6004); 
           TTS_data.joystick_actual = TTS_data.joystick_actual(1:6004);
           TTS_data.GVS_actual_mV = TTS_data.GVS_actual_mV(1:6004);
       end

       rms_save(sub,i) = rms(TTS_data.tilt_actual);
       mae_save(sub,i) = rms(TTS_data.joystick_actual);

       if contains(current_mat_file, '2_0') || contains(current_mat_file, '2_1') || contains(current_mat_file, '2_2')
           TTS_data.tilt_force = TTS_data.tilt_force*-1; 
           TTS_data.tilt_actual =  TTS_data.tilt_actual*-1; 
           TTS_data.joystick_actual = TTS_data.joystick_actual*-1;
           TTS_data.GVS_actual_mV = TTS_data.GVS_actual_mV*-1;
       elseif contains(current_mat_file, '3_0') || contains(current_mat_file, '3_1') || contains(current_mat_file, '3_2')  || contains(current_mat_file, '3_3')
            TTS_data.tilt_force = flip(TTS_data.tilt_force); 
           TTS_data.tilt_actual =  flip(TTS_data.tilt_actual); 
           TTS_data.joystick_actual = flip(TTS_data.joystick_actual);
           TTS_data.GVS_actual_mV = flip(TTS_data.GVS_actual_mV);
       elseif contains(current_mat_file, '4_0') || contains(current_mat_file, '4_1') || contains(current_mat_file, '4_2')
           TTS_data.tilt_force = flip(TTS_data.tilt_force*-1); 
           TTS_data.tilt_actual =  flip(TTS_data.tilt_actual*-1); 
           TTS_data.joystick_actual = flip(TTS_data.joystick_actual*-1);
           TTS_data.GVS_actual_mV = flip(TTS_data.GVS_actual_mV*-1);
       end
       
       subplot(4,1,1)
       plot(TTS_data.tilt_force)
       hold on;
       title("disturbance profile")
       subplot(4,1,2)
       plot(TTS_data.tilt_actual)
       title("actual motion")
       hold on;
       subplot(4,1,3)
       plot(TTS_data.joystick_actual);
       title("joy stick")
       hold on;
       subplot(4,1,4)
       plot(TTS_data.GVS_actual_mV);
       title("GVS")
       hold on;
       index = length(trial)+1;
       trial{index} = string([current_mat_file]);
       text = char(trial{index});

       Label.trial(index)= string(text(7:12));
       % if (contains(current_mat_file, '12d') || contains(current_mat_file, '15d'))
       %      Label.trial(index)= string(text(21:26));
       % else
       % 
       % end
       
       


    end

    sgtitle(subject_str)
    legend(trial)
end

%%
figure; 
plot(mae_save')
%%
figure
bar(rms_save')
xticks([1:24])
xticklabels(["" (Label.trial)])