% This script reads in TTS output files from Skylar's vi

close all; 
clear all; 
clc; 

%%

%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
cd ..
[filenames]=file_path_info2(code_path, file_path); % get files from file folder
cd(code_path);

%get info on matlab (GVS) and csv (TTS) files
num_files = length(filenames);
cd ..
csv_filenames = get_filetype(filenames, 'csv');
% xcel_filenames = get_filetype(filenames, '.xlsx');
cd(code_path);
num_csv_files = length(csv_filenames);
cd(file_path)
TrialKey= readtable("TrialKey.xlsx");
cd(code_path)

%% 
% match the GVS (mat) and TTS (csv) files based on a common string in the
% filenames if they match then proceed with making comparison plots 
for i = 1:num_csv_files   
    current_csv_file = char(csv_filenames(i));
    csv_num = str2num(current_csv_file(20:21)); %19:20 11:12
    for j = 1:height(TrialKey)
        
        if csv_num == (TrialKey.TTSTrial(j))
            
            Trial_name = strjoin(["Prof" TrialKey.TTSProfile(j) ", GVS" ...
                TrialKey.MaxGVS(j) ", Angle" TrialKey.MaxAngle(j) ", Velocity" ...
                TrialKey.MaxVelocity(j) ", Decay" TrialKey.UserDecay(j) ...
                ", Ch1" TrialKey.Ch1(j) ", Ch 2" TrialKey.Ch2(j)  ", Ch3" TrialKey.Ch3(j) TrialKey.Ch3_1(j)]); % TrialKey.Ch2_1(j) ", Ch3" TrialKey.Ch3(j)

            cd(file_path)
            TTS_output = readtable(current_csv_file); %, 'VariableNamingRule','preserve');
            cd(code_path)

            figure; 
            sgtitle(Trial_name)
            subplot(2,1,1)
            plot(TTS_output.ms(1:end-2)/1000, TTS_output.TiltFeedback(1:end-2));
            hold on;
            plot(TTS_output.ms(1:end-2)/1000, TTS_output.GVS1MV(1:end-2));
            plot(TTS_output.ms(1:end-2)/1000, TTS_output.GVS2MV(1:end-2));
            plot(TTS_output.ms(1:end-2)/1000, TTS_output.GVS3MV(1:end-2));
            legend ("Tilt Angle", "Ch 3",  "Ch2", "Ch1")
            xlabel("time (s)");
            ylabel("Angle (deg) and GVS (mV) ")
             
            subplot(2,1,2)
            plot(TTS_output.ms(1:end-2)/1000, TTS_output.AngVel(1:end-2)); hold on;
            plot(TTS_output.ms(1:end-2)/1000, TTS_output.GVS1MV(1:end-2));
            plot(TTS_output.ms(1:end-2)/1000, TTS_output.GVS2MV(1:end-2));
            plot(TTS_output.ms(1:end-2)/1000, TTS_output.GVS3MV(1:end-2));
            legend ("Tilt Velocity", "Ch 3",  "Ch2", "Ch1")
            xlabel("time (s)");
            ylabel("Velocity (deg/s) and GVS (mV) ")

            % disp("press any key to continue")
            % pause
        else
            continue
        end

    end

    

   
end