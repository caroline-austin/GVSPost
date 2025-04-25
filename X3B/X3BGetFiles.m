%% Script 1 for X3B Fuctional Mobility and Manual Control Nulling Testing
% This script reads in information from both the master spreadsheet for the
% experiment and the individual TTS and GVS? files. It compares the
% filenames to the expected name info specified in the master spreadsheet
% and then combines the data from the different files appropriately and
% saves it all into a single matlab file for each trial with a standardized
% naming scheme 

close all; clear; clc; 

%% setup
subnum = [ 3091:3091];  % Subject List 1011:1022
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

    % Tandem walk info
    Trial_Info_TDM = readcell('FunctionalMobilityTesting.xlsx','Sheet', ... % ManualControlTrials.xlsx
        ['S' subject_str],'Range','K28:S41'); % may need to increase beyond 35, but make sure those rows have zeros
    Trial_Num_TDM = cell2mat(Trial_Info_TDM(:,1));
    Label.DataColumnsTDM = readcell('FunctionalMobilityTesting.xlsx','Sheet',... 
        ['S' subject_str], 'Range','K27:S27');

    % Fuctional Mobility info
    Trial_Info_FMT = readcell('FunctionalMobilityTesting.xlsx','Sheet', ... % ManualControlTrials.xlsx
        ['S' subject_str],'Range','A28:I41'); % may need to increase beyond 35, but make sure those rows have zeros
    Trial_Num_FMT = cell2mat(Trial_Info_FMT(:,1));
    Label.DataColumnsFMT = readcell('FunctionalMobilityTesting.xlsx','Sheet',... 
        ['S' subject_str], 'Range','A27:I27');

    % Romberg info
    Trial_Info_ROM = readcell('FunctionalMobilityTesting.xlsx','Sheet', ... % ManualControlTrials.xlsx
        ['S' subject_str],'Range','A3:L23'); % may need to increase beyond 35, but make sure those rows have zeros
    Trial_Num_ROM = cell2mat(Trial_Info_ROM(:,1));
    Label.DataColumnsROM = readcell('FunctionalMobilityTesting.xlsx','Sheet',... 
        ['S' subject_str], 'Range','A2:L2');

    % TTS info
    Trial_Info_TTS = readcell('FunctionalMobilityTesting.xlsx','Sheet', ... % ManualControlTrials.xlsx
        ['S' subject_str],'Range','N3:T19'); % may need to increase beyond 35, but make sure those rows have zeros
    Trial_Num_TTS = cell2mat(Trial_Info_TTS(:,1));
    Label.DataColumnsTTS = readcell('FunctionalMobilityTesting.xlsx','Sheet',... 
        ['S' subject_str], 'Range','N2:T2');
%%
 % get info on Romberg files 
    cd([code_path '/..']);
    ROM_path = [subject_path '\Romberg'] ;
    ROM_GIST_path = [subject_path '\Romberg\GIST'] ;
    ROM_Wii_path = [subject_path '\Romberg\Wii'] ;
    [ROM_GIST_filenames]=file_path_info2(code_path,ROM_GIST_path ); % get files from file folder
    cd([code_path '/..']);
    [ROM_Wii_filenames]=file_path_info2(code_path,ROM_Wii_path ); % get files from file folder
    num_ROM_GIST_files = length(ROM_GIST_filenames);
    num_ROM_Wii_files = length(ROM_Wii_filenames);

    % for each romberg GIST file (trial) grab associated Wii Force Plate
    % data and condition info for naming then save as a matlab file. 
    Wii_file_index = 0;
    Wii_trial_index = 1;
    num_Wii_trials = 0;
    ROM_trial_index = 0;
    for i = 1:num_ROM_GIST_files
        current_file = char(ROM_GIST_filenames(i));
       if ~ contains(current_file, 'csv') 
           continue
       end
       ROM_trial_index = ROM_trial_index +1;
        cd(ROM_GIST_path);
        ROM_GIST_data = readtable(current_file); 
        cd(code_path);
        

        if Wii_trial_index > num_Wii_trials
            Wii_file_index = Wii_file_index +1;
            cd(ROM_Wii_path);
            ROM_Wii_data = readtable(char(ROM_Wii_filenames(Wii_file_index)));
            cd(code_path);
            
            for j = 2:length(ROM_Wii_data.Var1)
                timesteps(j) = ROM_Wii_data.Var1(j) - ROM_Wii_data.Var1(j-1);    
            end

            trial_start_loc = [1 find(timesteps > 100)];
            num_Wii_trials = length(trial_start_loc);
            trial_start_loc = [trial_start_loc length(ROM_Wii_data.Var1)];
            Wii_trial_index = 1;

        end

        ROM_Wii_trial = ROM_Wii_data{trial_start_loc(Wii_trial_index):(trial_start_loc(Wii_trial_index+1)-1) ,:};
        

        % get Trial Info from excel sheet
        if Wii_file_index == 1
            ROM_trial_row_index = Wii_trial_index;
            ROM_trial_col_index = 7;
            
        elseif num_ROM_Wii_files >2 % for blocking 
            ROM_trial_row_index = 6*(Wii_trial_index-1)+ 1+ rem((Wii_trial_index+1),2);
            ROM_trial_col_index = 7+ rem((Wii_trial_index+1),2);

        else % for the single giant file
            ROM_trial_row_index = 6+(ceil(Wii_trial_index/2));%- rem((Wii_trial_index+1),2);
            ROM_trial_col_index = 7+ rem((Wii_trial_index+1),2);
            
        end

        ROM_trial_info = Trial_Info_ROM(ROM_trial_row_index, :) ;
        ROM_pass = ROM_trial_info{ROM_trial_col_index};
        
        ROM_trial_name = 'ROM';
        % put together trial_name
        switch ROM_trial_info{4}
            case {'open' , 'Open'}
                ROM_trial_name = [ROM_trial_name '_EO'];

            case {'closed' , 'Closed'}
                ROM_trial_name = [ROM_trial_name '_EC'];
        end

        switch ROM_trial_info{6}
            case 'hard'
                ROM_trial_name = [ROM_trial_name '_HS'];
            case 'foam'
                ROM_trial_name = [ROM_trial_name '_FS'];
        end

        switch ROM_trial_info{5}
            case 'none'
                ROM_trial_name = [ROM_trial_name '_NHT'];

            case {'pitch', 'Pitch'}
                ROM_trial_name = [ROM_trial_name '_PHT'];

            case {'roll', 'Roll'}
                ROM_trial_name = [ROM_trial_name '_RHT'];
        end



        switch ROM_trial_info{3}
            case 'Sham'
                ROM_trial_name = [ROM_trial_name '_SHAMGVS'];

            case 'DC Offset'
                ROM_trial_name = [ROM_trial_name '_DCSDGVS'];

            case 'DC Wave'
                ROM_trial_name = [ROM_trial_name '_DCONGVS'];
        end

        if ROM_trial_index <10
            ROM_trial_name = [ROM_trial_name '_0' num2str(ROM_trial_index)];
        else
            ROM_trial_name = [ROM_trial_name '_' num2str(ROM_trial_index)];
        end

        cd(ROM_path);
       vars_2_save = ['ROM_GIST_data ROM_Wii_trial ROM_trial_info ROM_pass' ...
           ];
       eval(['  save ' [char(ROM_trial_name), '.mat '] vars_2_save ' vars_2_save']);      
       cd(code_path)
       eval (['clear ' vars_2_save])

        Wii_trial_index = Wii_trial_index+1;
    end


    % % get info on the csv files (TTS output files) for the current subject
    % cd([code_path '/..']);
    % TTS_path = [subject_path '\TTS'] ;
    % [subject_filenames]=file_path_info2(code_path,TTS_path ); % get files from file folder
    % num_sub_files = length(subject_filenames);
    % cd([code_path '/..']);
    % csv_filenames = get_filetype(subject_filenames, 'csv');
    % num_csv_files = length(csv_filenames);
    % 
    % % for each of the TTS output files extract the recorded data, add in the
    % % intended GVS and TTS data, and then save as a matlab file 
    % for i = 1:num_csv_files
    %    current_csv_file = char(csv_filenames(i));
    %    if ~ contains(current_csv_file, 'Dist') 
    %        continue
    %    end
    %    % start by pulling out the important identifying info and use it to
    %    % create the filename for saving
    %    % currently using the info from the master spread sheet to do this 
    % 
    %    % pull the trial number from the TTS output file
    %    trial_loc = find(current_csv_file == ' ', 1,"last"); % there should be a space right before the trial number
    %    trial_number = current_csv_file(trial_loc+1:trial_loc+2);
    %    %find the matching trial number from the master spreadsheet
    %    row = find(Trial_Num_TTS == str2num(trial_number),1);
    %    % if there is not a matching number in the master spreadsheet skip
    %    % (could be a practice trial or a trial that was thrown out)
    %    if isempty(row)
    %        continue;
    %    end
    %    % just in case we forget to start at trial 11 make it a 2 digit
    %    % number
    %    if str2num(trial_number)<10
    %        trial_number = ['0', strrep(trial_number, '.', '')];
    %    end
    % 
    %    % % figure out the filename of the GVS profile that was run
    %    GVS_profile_name = char(strjoin([ string(Trial_Info_TTS(row,3))]));
    % 
    %    % %figure out what the current was proportional to (7,7.5,8) and store
    %    % %in a string to use later for file naming
    %    % if contains(GVS_profile_name, '.')
    %    %      decimal_loc = find(GVS_profile_name(:) == '.');
    %    % 
    %    %      proportion= strrep(strjoin([string(GVS_profile_name(decimal_loc-1)) ...
    %    %          '_' GVS_profile_name(decimal_loc+1) '0']),' ', '');
    %    %  else
    %    %      proportion = [GVS_profile_name(end) '_00'];
    %    %  end
    %    % 
    %    GVS_profile_name = strrep([strrep(char(GVS_profile_name), '.', '_') ], ' ', '');
    %    % 
    %    % figure out name of the TTS profile that was run (this is 
    %    % based on the master spread sheet, not the csv filename)
    %    TTS_profile = char(string(Trial_Info_TTS(row,4)));%this might change if additional GVS columns are added
    %    TTS_profile_name = ['Esther_MC_', TTS_profile ];
    % 
    %    %check actual v. perscribed physical motion profile
    %    if ~ contains(current_csv_file, TTS_profile)
    %         disp(["For trial ", trial_number, "the TTS csv profile does " + ...
    %             "not match the listed master spread sheet profile "])
    %    end
    % 
    %    % %use N or P instead of +/- for the current amplitude
    %    %  if contains(GVS_profile_name, '-')
    %    %      polarity = 'N';
    %    %      current_amp = string(abs(str2num(string(Trial_Info(row,5)))));
    %    %  else
    %    %      polarity = 'P';
    %    %      current_amp = string(Trial_Info(row,5));
    %    %  end
    % 
    %    %generate filename 
    %    filesave_name = strrep(strjoin([ "S" subject_str '_' GVS_profile_name '_' TTS_profile ... % add in GVS info here
    %          '_' trial_number]), ' ', '');
    %    % %load GVS profile commanded by sparky
    %    % cd(gvs_path)
    %    % Commanded_GVS= load(GVS_profile_name);
    %    % cd (code_path);
    %    % GVS_command1 = (Commanded_GVS.Profile(1,2:end));
    %    % GVS_command = (cellfun(@str2num,(GVS_command1))')/100;
    %    % % load the profile stored on the TTS
    %    % cd(tts_path)
    %    % Commanded_TTS= load([TTS_profile_name, '.txt']);
    %    % cd (code_path);
    %    % tilt_velocity = (Commanded_TTS(2:end,7))/200;
    % 
    %    %load the TTS output csv file and store appropriate data with
    %    %unit conversions
    %    cd(subject_path);
    %    TTS_data = readtable(current_csv_file); 
    %    cd(code_path);
    %    time = table2array(TTS_data(1:end-1,1));
    %    plot_time = (time -time(1))/1000;
    %    tilt_force = table2array(TTS_data(1:end-1,2))/200; %deg; % the disturbance profile without joystick input
    %    tilt_command = table2array(TTS_data(1:end-1,3))/200; %deg %the net command of disturbance + joystick
    %    tilt_actual = table2array(TTS_data(1:end-1,5))/200; %deg % the net output moiton of disturbance + joystick
    %    joystick_actual = table2array(TTS_data(1:end-1,7))/1000; %deg %the joystick input
    %    GVS_actual_mV= table2array(TTS_data(1:end-1,10))/1000; %mV (not mA) % the GVS signal recorded by the TTS 
    %    mustBeNonsparse(GVS_actual_mV);
    %    mustBeFinite(GVS_actual_mV);
    %    GVS_actual_filt = lowpass(GVS_actual_mV,1,50); %filter raw GVS data
    %    trial_end = find(time,1, 'last');
    % 
    %    % Find where there are the random 0s because data was not sent and use
    %    % linear interpolation to fill them in with representative values
    %     ind = [];
    %     for j = 2:length(tilt_command)-1
    %         if tilt_command(j) == 0 && (tilt_command(j-1) ~= 0)
    %             % there is a random zero, so replace with linear interpolating
    %             ind = [ind j];
    %             tilt_command(j) = interp1([time(j-1) time(j+1)], [tilt_command(j-1) tilt_command(j+1)], time(j));
    %         end
    %     end
    % 
    %     %save the individual trial data into a matlab file and clear
    %     %variables
    %    cd(subject_path);
    %    vars_2_save = ['TTS_data tilt_force tilt_command  tilt_actual joystick_actual' ...
    %        ' time plot_time  trial_end GVS_actual_mV GVS_actual_filt' ...
    %        ' '];%tilt_velocity 
    %    eval(['  save ' [char(filesave_name), '.mat '] vars_2_save ' vars_2_save']);      
    %    cd(code_path)
    %    eval (['clear ' vars_2_save])
    % 
    % end
    %save the master sheet info into a single file
    Trial_Info.ROM = Trial_Info_ROM;
    Trial_Info.TDM = Trial_Info_TDM;
    Trial_Info.TTS = Trial_Info_TTS;
    Trial_Info.FMT = Trial_Info_FMT;

    cd(subject_path);
    eval(['  save ' ['S', subject_str, '.mat '] ' Label Trial_Info ']); %add impedance, MS, GVS susceptibility
    cd(code_path) 
% clear Label Trial_Info
end

