%% Script 1 for Dynamic GVS +Tilt
% this script reads in and combines data from the "master spread sheet"
% (DynamicGVSPlusTilt) in the Data folder, the GVS Profile files that
% Sparky runs, the TTS input files, and TTS output files. The combined data
% is then saved with a uniform naming scheme for each trial with one
% additional file containing non-shot related data  from the master spread
% sheet
close all; 
clear all; 
clc; 

%% setup
subnum = 1015:1015;  % Subject List 
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
gvs_path = [file_path '\GVSProfiles'];
tts_path = [file_path '\TTSProfiles'];
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

%% extract data to save as matlab files
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    subject_path = [file_path '\' subject_str];
%     subject_path = [file_path, '\PS' , subject_str]; % for pilot subjects

%pull info from the master testing spread sheet (what trials were supposed
%to be run, motion sickness information, impedances, GVS susceptibility) 
% Even though the document contains info from all subjects this pull from
% only the current subject's sheet
    cd(file_path);
    Trial_Info = readcell('DynamicGVSPlusTilt.xlsx','Sheet', ...
        ['S' subject_str],'Range','A2:H56'); % may need to increase beyond 56, but make sure those rows have zeros
    Trial_Num = cell2mat(Trial_Info(:,1));
    Label.DataColumns = readcell('DynamicGVSPlusTilt.xlsx','Sheet',... 
        ['S' subject_str], 'Range','A1:H1');
    %add line to pull the impedances
    %add line to pull motion sickness info
    %add line to pull GVS suceptibility reports

    % get info on the csv files (TTS output files) for the current subject
    cd(code_path);
    [subject_filenames]=file_path_info2(code_path,subject_path ); % get files from file folder
    num_sub_files = length(subject_filenames);
    csv_filenames = get_filetype(subject_filenames, 'csv');
    num_csv_files = length(csv_filenames);

    % for each of the TTS output files extract the recorded data, add in the
    % intended GVS and TTS data, and then save as a matlab file 
    for i = 1:num_csv_files
       current_csv_file = char(csv_filenames(i));
       if ~ contains(current_csv_file, 'A.') && ~ contains(current_csv_file, 'B.')
           continue
       end
       % start by pulling out the important identifying info and use it to
       % create the filename for saving
       % currently using the info from the master spread sheet to do this 
       
       % pull the trial number from the TTS output file
       trial_loc = find(current_csv_file == ' ', 1); % this won't work if there's a space in the subject name
       trial_number = current_csv_file(trial_loc+1:trial_loc+2);
       %find the matching trial number from the master spreadsheet
       row = find(Trial_Num == str2num(trial_number),1);
       % if there is not a matching number in the master spreadsheet skip
       % (could be a practice trial or a trial that was thrown out)
       if isempty(row)
           continue;
       end
       % just in case we forget to start at trial 11 make it a 2 digit
       % number
       if str2num(trial_number)<10
           trial_number = ['0', trial_number];
       end

       % figure out the filename of the GVS profile that was run
       GVS_profile_name = char(strjoin([ string(Trial_Info(row,4)), ...
           "_", string(Trial_Info(row,5)), "mA_prop", string(Trial_Info(row,6))]));
        
       %figure out what the current was proportional to (7,7.5,8) and store
       %in a string to use later for file naming
       if contains(GVS_profile_name, '.')
            decimal_loc = find(GVS_profile_name(:) == '.');

            proportion= strrep(strjoin([string(GVS_profile_name(decimal_loc-1)) ...
                '_' GVS_profile_name(decimal_loc+1) '0']),' ', '');
        else
            proportion = [GVS_profile_name(end) '_00'];
        end

       GVS_profile_name = strrep([strrep(char(GVS_profile_name), '.', '_') '.mat'], ' ', '');
        
       % figure out name of the TTS profile that was run (this is 
       % based on the master spread sheet, not the csv filename)
       TTS_profile = GVS_profile_name(9:10);
       TTS_profile_name = ['SumOfSin', TTS_profile ];

       %check actual v. perscribed physical motion profile
       if ~ contains(current_csv_file, TTS_profile)
            disp(["For trial ", trial_number, "the TTS csv profile does " + ...
                "not match the listed master spread sheet profile "])
       end

       %use N or P instead of +/- for the current amplitude
        if contains(GVS_profile_name, '-')
            polarity = 'N';
            current_amp = string(abs(str2num(string(Trial_Info(row,5)))));
        else
            polarity = 'P';
            current_amp = string(Trial_Info(row,5));
        end
        
       %generate filename 
       filesave_name = strrep(strjoin(['S' subject_str '_' TTS_profile ...
           '_' polarity '_' current_amp '_00mA_' ...
           proportion '_' trial_number]), ' ', '');
       %load GVS profile commanded by sparky
       cd(gvs_path)
       Commanded_GVS= load(GVS_profile_name);
       cd (code_path);
       GVS_command1 = (Commanded_GVS.Profile(1,2:end));
       GVS_command = (cellfun(@str2num,(GVS_command1))')/100;
       % load the profile stored on the TTS
       cd(tts_path)
       Commanded_TTS= load([TTS_profile_name, '.txt']);
       cd (code_path);
       tilt_velocity = (Commanded_TTS(2:end,7))/200;

       %load the TTS output csv file and store appropriate data with
       %unit conversions
       cd(subject_path);
       TTS_data = readtable(current_csv_file); 
       cd(code_path);
       time = table2array(TTS_data(1:end-1,1));
       plot_time = (time -time(1))/1000;
       tilt_command = table2array(TTS_data(1:end-1,2))/200; %deg
       tilt_actual = table2array(TTS_data(1:end-1,4))/200; %deg
       shot_actual = table2array(TTS_data(1:end-1,6))/1000; %deg
       GVS_actual_mV= table2array(TTS_data(1:end-1,11))/1000; %mV (not mA)
       mustBeNonsparse(GVS_actual_mV);
       mustBeFinite(GVS_actual_mV);
       GVS_actual_filt = lowpass(GVS_actual_mV,1,50); %filter raw GVS data
       trial_end = find(time,1, 'last');

       % Find where there are the random 0s because data was not sent and use
       % linear interpolation to fill them in with representative values
        ind = [];
        for j = 2:length(tilt_command)-1
            if tilt_command(j) == 0 && (tilt_command(j-1) ~= 0)
                % there is a random zero, so replace with linear interpolating
                ind = [ind j];
                tilt_command(j) = interp1([time(j-1) time(j+1)], [tilt_command(j-1) tilt_command(j+1)], time(j));
            end
        end

        %save the individual trial data into a matlab file and clear
        %variables
       cd(subject_path);
       vars_2_save = ['TTS_data tilt_command tilt_velocity tilt_actual' ...
           ' time plot_time GVS_actual_mV GVS_actual_filt trial_end' ...
           ' GVS_command shot_actual'];
       eval(['  save ' [char(filesave_name), '.mat '] vars_2_save ' vars_2_save']);      
       cd(code_path)
       eval (['clear ' vars_2_save])
    
    end
    %save the master sheet info into a single file
    cd(subject_path);
    eval(['  save ' ['S', subject_str, '.mat '] ' Label Trial_Info ']); %add impedance, MS, GVS susceptibility
    cd(code_path) 
% clear Label Trial_Info
end