%% Script 2 for X3B Functional Mobility
% This script takes the .mat files from script 1 and combines all the data
% from each of the separte tests and trials into a single matlab file with
% variables that contain all the trials for a given data type/condition

close all; clear; clc; 

%% setup
subnum = [ 3091:3094];  % Subject List 1011:1022 , 3091:3092
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part 


code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory it should be the Data folder for the experiment (on Sharepoint)
plots_path = [file_path '/Plots']; % specify where plots are saved
% gvs_path = [file_path '/GVSProfiles']; %specify where to grab default GVS profiles from
% tts_path = [file_path '/TTSProfiles']; %specify where to grab baseline TTS profiles from

cd([code_path '/..']); 
[filenames]=file_path_info2(code_path, file_path); % get subfolder and file names from file folder

% plot((ROM_Wii_trial(:,1)- ROM_Wii_trial(1,1))/1000,ROM_Wii_trial(:,2:8) )

%% find data to save into a single matlab file
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
        load(['S', subject_str, '.mat ']);
    cd(code_path);

    % set up pathing for the 4 tests
    ROM_path = [subject_path '\Romberg'] ;
    TDM_path = [subject_path '\Tandem'] ;
    FMT_path = [subject_path '\FMT'] ;
    TTS_path = [subject_path '\TTS'] ;

    % start by aggreagating/sorting the Romberg files
    cd([code_path '/..']); 
    [ROM_filenames]=file_path_info2(code_path, ROM_path); % get file names from Romberg folder
    cd(code_path);

    cd([code_path '/..']); 
    ROM_mat_filenames = get_filetype(ROM_filenames, 'mat');
    num_ROM_mat_files = length(ROM_mat_filenames);
    data.ROM.Num_Trials = num_ROM_mat_files;
    previous_file = 'z';

    for file = 1:num_ROM_mat_files

       current_file = char(ROM_mat_filenames(file));
       %skip files that aren't the trial files 
       % if ~contains(current_file,'mA')  %length(current_file)<25
       %     continue
       % end

              %get info about and load trial file
      test_type = current_file(1:3);
      eyes_type = current_file(5:6);
      surface_type = current_file(8:9);
      tilt_type = current_file(11:13);
      GVS_type = current_file(15:21);
      trial_number = current_file(end-5:end-4);

       cd(ROM_path);
       load(current_file);
       cd(code_path); 



       if  contains(current_file, previous_file)

         trial_index = trial_index+1;
       else
           trial_index = 1;
       end

       data.(test_type).GIST.([eyes_type '_' surface_type '_' tilt_type]).(GVS_type){sub,trial_index} = ROM_GIST_data;
       data.(test_type).Pass.([eyes_type '_' surface_type '_' tilt_type]).(GVS_type){sub,trial_index} = ROM_pass;
       data.(test_type).Wii.([eyes_type '_' surface_type '_' tilt_type]).(GVS_type){sub,trial_index} = ROM_Wii_trial;
       data.(test_type).Trial_Num.([eyes_type '_' surface_type '_' tilt_type]).(GVS_type){sub,trial_index} = trial_number;

       previous_file = [eyes_type '_' surface_type '_' tilt_type '_' GVS_type];
       
    end


    %  aggreagating/sorting the FMT files
    cd([code_path '/..']); 
    [FMT_filenames]=file_path_info2(code_path, FMT_path); % get file names from Romberg folder
    cd(code_path);

    cd([code_path '/..']); 
    FMT_mat_filenames = get_filetype(FMT_filenames, 'mat');
    num_FMT_mat_files = length(FMT_mat_filenames);
    data.FMT.Num_Trials = num_FMT_mat_files;
    previous_file = 'z';

    for file = 1:num_FMT_mat_files

       current_file = char(FMT_mat_filenames(file));
       %skip files that aren't the trial files 
       % if ~contains(current_file,'mA')  %length(current_file)<25
       %     continue
       % end

              %get info about and load trial file
      test_type = current_file(1:3);
      GVS_type = current_file(5:11);
      trial_number = current_file(end-5:end-4);

       cd(FMT_path);
       load(current_file);
       cd(code_path); 

       if  contains(current_file, previous_file)

         trial_index = trial_index+1;
       else
           trial_index = 1;
       end

       data.(test_type).GIST.(GVS_type){sub,trial_index} = FMT_GIST_data;
       data.(test_type).raw_time.(GVS_type){sub,trial_index} = FMT_raw_time;
       data.(test_type).errors.(GVS_type){sub,trial_index} = FMT_errors;
       data.(test_type).adj_time.(GVS_type){sub,trial_index} = FMT_adj_time;
       data.(test_type).Trial_Num.(GVS_type){sub,trial_index} = trial_number;

       previous_file = [ GVS_type];
       
    end

     %  aggreagating/sorting the Tandem files
    cd([code_path '/..']); 
    [TDM_filenames]=file_path_info2(code_path, TDM_path); % get file names from Tandem folder
    cd(code_path);

    cd([code_path '/..']); 
    TDM_mat_filenames = get_filetype(TDM_filenames, 'mat');
    num_TDM_mat_files = length(TDM_mat_filenames);
    data.TDM.Num_Trials = num_TDM_mat_files;
    previous_file = 'z';

    for file = 1:num_TDM_mat_files

       current_file = char(TDM_mat_filenames(file));
       %skip files that aren't the trial files 
       % if ~contains(current_file,'mA')  %length(current_file)<25
       %     continue
       % end

              %get info about and load trial file
      test_type = current_file(1:3);
      eyes_type = current_file(5:6);
      GVS_type = current_file(8:14);
      trial_number = current_file(end-5:end-4);

       cd(TDM_path);
       load(current_file);
       cd(code_path); 

       if  contains(current_file, previous_file)

         trial_index = trial_index+1;
       else
           trial_index = 1;
       end

       data.(test_type).GIST.(eyes_type).(GVS_type){sub,trial_index} = TDM_GIST_data;
       data.(test_type).raw_time.(eyes_type).(GVS_type){sub,trial_index} = TDM_correct_steps;
       data.(test_type).Trial_Num.(eyes_type).(GVS_type){sub,trial_index} = trial_number;

       previous_file = [ eyes_type '_' GVS_type];
       
    end


       %  aggreagating/sorting the TTS files
    cd([code_path '/..']); 
    [TTS_filenames]=file_path_info2(code_path, TTS_path); % get file names from Romberg folder
    cd(code_path);

    cd([code_path '/..']); 
    TTS_mat_filenames = get_filetype(TTS_filenames, 'mat');
    num_TTS_mat_files = length(TTS_mat_filenames);
    data.TTS.Num_Trials = num_TTS_mat_files;
    previous_file = 'z';
    trial_index = 0;

    for file = 1:num_TTS_mat_files

       current_file = char(TTS_mat_filenames(file));
       %skip files that aren't the trial files 
       % if ~contains(current_file,'mA')  %length(current_file)<25
       %     continue
       % end

              %get info about and load trial file
      test_type = current_file(1:3);
      profile = current_file(5:9);
      GVS_type = current_file(11:17);
      trial_number = current_file(end-5:end-4);

       cd(TTS_path);
       load(current_file);
       cd(code_path); 

       if  contains(current_file, previous_file)

       else
           trial_index = trial_index+1;
       end

       data.(test_type).GIST.(GVS_type){sub,trial_index} = TTS_GIST_data;
       data.(test_type).TTS.(GVS_type){sub,trial_index} = TTS_MC_data;
       data.(test_type).profile.(GVS_type){sub,trial_index} = TTS_profile;
       data.(test_type).Trial_Num.(GVS_type){sub,trial_index} = trial_number;

       previous_file = [ profile];
       
    end

    if numsub == 1
        cd(subject_path);
        eval(['  save ' ['S', subject_str, 'Extract.mat '] ' Label Trial_Info data ']); %add impedance, MS, GVS susceptibility
        cd(code_path) 
    else
        cd(file_path);
        eval(['  save ' ['SAll.mat '] ' Label Trial_Info data ']); %add impedance, MS, GVS susceptibility
        cd(code_path) 

    end



end