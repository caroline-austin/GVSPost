%% Script 1 for Manual Control Nulling Testing
% This script reads in information from both the master spreadsheet for the
% experiment and the individual TTS and GVS? files. It compares the
% filenames to the expected name info specified in the master spreadsheet
% and then combines the data from the different files appropriately and
% saves it all into a single matlab file for each trial with a standardized
% naming scheme 

close all; clear; clc; 

%% setup
subnum = [ 3001:3003];  % Subject List 1011:1022
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part 


code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory it should be the Data folder for the experiment (on Sharepoint)
plots_path = [file_path '/Plots']; % specify where plots are saved
% gvs_path = [file_path '/GVSProfiles']; %specify where to grab default GVS profiles from
% tts_path = [file_path '/TTSProfiles']; %specify where to grab baseline TTS profiles from

cd([code_path '/..']); 
[filenames]=file_path_info2(code_path, file_path); % get subfolder and file names from file folder

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
    Trial_Info = readcell('PilotTestTrials.xlsx','Sheet', ... % ManualControlTrials.xlsx
        ['S' subject_str],'Range','A2:H30'); % may need to increase beyond 30, but make sure those rows have zeros
    Trial_Num = cell2mat(Trial_Info(:,1));
    Label.DataColumns = readcell('PilotTestTrials.xlsx','Sheet',... 
        ['S' subject_str], 'Range','A1:H1');
    
    % get info on the csv files (TTS output files) for the current subject
    cd([code_path '/..']);
    [subject_filenames]=file_path_info2(code_path,subject_path ); % get files from file folder
    num_sub_files = length(subject_filenames);
    cd([code_path '/..']);
    csv_filenames = get_filetype(subject_filenames, 'csv');
    num_csv_files = length(csv_filenames);

    % for each of the TTS output files extract the recorded data, add in the
    % intended GVS and TTS data, and then save as a matlab file 
    for i = 1:num_csv_files
       current_csv_file = char(csv_filenames(i));
       if ~ contains(current_csv_file, 'Dist') 
           continue
       end
       % start by pulling out the important identifying info and use it to
       % create the filename for saving
       % currently using the info from the master spread sheet to do this 
       
       % pull the trial number from the TTS output file
       trial_loc = find(current_csv_file == ' ', 1,"last"); % there should be a space right before the trial number
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
           trial_number = ['0', strrep(trial_number, '.', '')];
       end

       % % figure out the filename of the GVS profile that was run
       % GVS_profile_name = char(strjoin([ string(Trial_Info(row,4)), ...
       %     "_", string(Trial_Info(row,5)), "mA_prop", string(Trial_Info(row,6))]));
        
       % %figure out what the current was proportional to (7,7.5,8) and store
       % %in a string to use later for file naming
       % if contains(GVS_profile_name, '.')
       %      decimal_loc = find(GVS_profile_name(:) == '.');
       % 
       %      proportion= strrep(strjoin([string(GVS_profile_name(decimal_loc-1)) ...
       %          '_' GVS_profile_name(decimal_loc+1) '0']),' ', '');
       %  else
       %      proportion = [GVS_profile_name(end) '_00'];
       %  end
       % 
       % GVS_profile_name = strrep([strrep(char(GVS_profile_name), '.', '_') '.mat'], ' ', '');
       % 
       % figure out name of the TTS profile that was run (this is 
       % based on the master spread sheet, not the csv filename)
       TTS_profile = char(string(Trial_Info(row,4)));%this might change if additional GVS columns are added
       TTS_profile_name = ['Esther_MC_', TTS_profile ];

       %check actual v. perscribed physical motion profile
       if ~ contains(current_csv_file, TTS_profile)
            disp(["For trial ", trial_number, "the TTS csv profile does " + ...
                "not match the listed master spread sheet profile "])
       end

       % %use N or P instead of +/- for the current amplitude
       %  if contains(GVS_profile_name, '-')
       %      polarity = 'N';
       %      current_amp = string(abs(str2num(string(Trial_Info(row,5)))));
       %  else
       %      polarity = 'P';
       %      current_amp = string(Trial_Info(row,5));
       %  end
        
       %generate filename 
       filesave_name = strrep(strjoin([ "S" subject_str '_' TTS_profile '_'... % add in GVS info here
           trial_number]), ' ', '');
       % %load GVS profile commanded by sparky
       % cd(gvs_path)
       % Commanded_GVS= load(GVS_profile_name);
       % cd (code_path);
       % GVS_command1 = (Commanded_GVS.Profile(1,2:end));
       % GVS_command = (cellfun(@str2num,(GVS_command1))')/100;
       % % load the profile stored on the TTS
       % cd(tts_path)
       % Commanded_TTS= load([TTS_profile_name, '.txt']);
       % cd (code_path);
       % tilt_velocity = (Commanded_TTS(2:end,7))/200;

       %load the TTS output csv file and store appropriate data with
       %unit conversions
       cd(subject_path);
       TTS_data = readtable(current_csv_file); 
       cd(code_path);
       time = table2array(TTS_data(1:end-1,1));
       plot_time = (time -time(1))/1000;
       tilt_force = table2array(TTS_data(1:end-1,2))/200; %deg; % the disturbance profile without joystick input
       tilt_command = table2array(TTS_data(1:end-1,3))/200; %deg %the net command of disturbance + joystick
       tilt_actual = table2array(TTS_data(1:end-1,5))/200; %deg % the net output moiton of disturbance + joystick
       joystick_actual = table2array(TTS_data(1:end-1,7))/1000; %deg %the joystick input
       % GVS_actual_mV= table2array(TTS_data(1:end-1,10))/1000; %mV (not mA) % the GVS signal recorded by the TTS 
       % mustBeNonsparse(GVS_actual_mV);
       % mustBeFinite(GVS_actual_mV);
       % GVS_actual_filt = lowpass(GVS_actual_mV,1,50); %filter raw GVS data
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
       vars_2_save = ['TTS_data tilt_force tilt_command  tilt_actual joystick_actual' ...
           ' time plot_time  trial_end' ...
           ' '];%tilt_velocity GVS_actual_mV GVS_actual_filt
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

