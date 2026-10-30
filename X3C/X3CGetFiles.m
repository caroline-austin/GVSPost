%% Script 1 for X3C Fuctional Mobility and Manual Control Nulling Testing
% This script reads in information from both the master spreadsheet for the
% experiment and the individual GIST, OPAL, Wii Balance Board, and TTS files. 
% It loads the files in timestamp order (compares the filenames to the 
% expected name info specified in the master spreadsheet for the TTS files)
% and then combines the data from the different files appropriately and
% saves it all into a single matlab file for each trial with a standardized
% naming scheme 

close all; clear; clc; 
warning('off', 'MATLAB:table:ModifiedAndSavedVarnames');

%% setup
subnum = [ 3100];  % Subject List 1011:1022; 3091:3092
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part 


code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory it should be the Data folder for the experiment (on Sharepoint)
plots_path = [file_path '/Plots']; % specify where plots are saved
% gvs_path = [file_path '/GVSProfiles']; %specify where to grab default GVS profiles from
% tts_path = [file_path '/TTSProfiles']; %specify where to grab baseline TTS profiles from
sternumPath = '/Sensors/24095/';
headPath = '/Sensors/22154/';
lumbarPath = '/Sensors/22157/';
rfootPath = '/Sensors/22512/';
lfootPath = '/Sensors/22296/';

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

    % Fuctional Mobility info
    Trial_Info_FMT = readcell('FunctionalMobilityTesting.xlsx','Sheet', ... % ManualControlTrials.xlsx
        ['S' subject_str],'Range','A3:I16'); % may need to increase beyond 35, but make sure those rows have zeros
    emptyCells = cellfun(@ismissing, Trial_Info_FMT(:,1));
    Trial_Info_FMT(emptyCells,1) = {NaN};
    Trial_Num_FMT = cell2mat(Trial_Info_FMT(:,1));
    Label.DataColumnsFMT = readcell('FunctionalMobilityTesting.xlsx','Sheet',... 
        ['S' subject_str], 'Range','A2:I2');

    % Tandem walk info
    Trial_Info_TDM = readcell('FunctionalMobilityTesting.xlsx','Sheet', ... % ManualControlTrials.xlsx
        ['S' subject_str],'Range','K3:S16'); % may need to increase beyond 35, but make sure those rows have zeros
    emptyCells = cellfun(@ismissing, Trial_Info_TDM(:,1));
    Trial_Info_TDM(emptyCells,1) = {NaN};
    Trial_Num_TDM = cell2mat(Trial_Info_TDM(:,1));
    Label.DataColumnsTDM = readcell('FunctionalMobilityTesting.xlsx','Sheet',... 
        ['S' subject_str], 'Range','K2:S2');

    % Romberg info
    Trial_Info_ROM = readcell('FunctionalMobilityTesting.xlsx','Sheet', ... % ManualControlTrials.xlsx
        ['S' subject_str],'Range','A23:L40'); % may need to increase beyond 35, but make sure those rows have zeros
    emptyCells = cellfun(@ismissing, Trial_Info_ROM(:,1));
    Trial_Info_ROM(emptyCells,1) = {NaN};
    Trial_Num_ROM = cell2mat(Trial_Info_ROM(:,1));
    Label.DataColumnsROM = readcell('FunctionalMobilityTesting.xlsx','Sheet',... 
        ['S' subject_str], 'Range','A22:L22');

    % TTS info
    Trial_Info_TTS = readcell('FunctionalMobilityTesting.xlsx','Sheet', ... % ManualControlTrials.xlsx
        ['S' subject_str],'Range','N28:T39'); % may need to increase beyond 35, but make sure those rows have zeros
    emptyCells = cellfun(@ismissing, Trial_Info_TTS(:,1));
    Trial_Info_TTS(emptyCells,1) = {NaN};
    Trial_Num_TTS = cell2mat(Trial_Info_TTS(:,1));
    Label.DataColumnsTTS = readcell('FunctionalMobilityTesting.xlsx','Sheet',... 
        ['S' subject_str], 'Range','N22:T22');
%%
 % get info on Romberg files 
    cd([code_path '/..']);
    ROM_path = [subject_path '\Romberg'] ;
    ROM_GIST_path = [subject_path '\Romberg\GIST'] ;
    ROM_Wii_path = [subject_path '\Romberg\Wii'] ;
    ROM_OPALr_path = [subject_path '\Romberg\OPALraw'] ;
    ROM_OPALs_path = [subject_path '\Romberg\OPALSummary'] ;
    [ROM_GIST_filenames]=file_path_info2(code_path,ROM_GIST_path ); % get files from file folder
    cd([code_path '/..']);
    [ROM_Wii_filenames]=file_path_info2(code_path,ROM_Wii_path ); % get files from file folder
    cd([code_path '/..']);
    [ROM_OPALr_filenames]=file_path_info2(code_path,ROM_OPALr_path ); % get files from file folder
    cd([code_path '/..']);
    [ROM_OPALs_filenames]=file_path_info2(code_path,ROM_OPALs_path ); % get files from file folder
    num_ROM_GIST_files = length(ROM_GIST_filenames);
    num_ROM_Wii_files = length(ROM_Wii_filenames);
    num_ROM_OPALr_files = length(ROM_OPALr_filenames);
    num_ROM_OPALs_files = length(ROM_OPALs_filenames);


    % for each romberg GIST file (trial) grab associated Wii Force Plate
    % data and condition info for naming then save as a matlab file. 
    Wii_file_index = 0;
    Wii_trial_index = 1;
    num_Wii_trials = 0;
    ROM_trial_index = 0;
    
    for i = 1:num_ROM_GIST_files
        current_file_GIST = char(ROM_GIST_filenames(i));
        current_file_OPALr = char(ROM_OPALr_filenames(i));
        current_file_OPALs = char(ROM_OPALs_filenames(i));
       if ~ contains(current_file_GIST, 'csv') 
           continue
       end
       ROM_trial_index = ROM_trial_index +1;
        cd(ROM_GIST_path);
        ROM_GIST_data = readtable(current_file_GIST); 
        cd(code_path);
        
        cd(ROM_OPALs_path);
        ROM_OPALs_data = readtable(current_file_OPALs,'Range','A13:E46');
        cd(code_path);

       cd(ROM_OPALr_path);
       ROM_OPALr_data = table();
       timeMuSec = h5read(current_file_OPALr, [headPath 'Time']);
       timeSec = double(timeMuSec - timeMuSec(1)) / 1e6; % Normalize to seconds starting at 0
       ROM_OPALr_data.Time = timeSec;
       headAccelData = h5read(current_file_OPALr, [headPath, 'Accelerometer']);
       headGyroData = h5read(current_file_OPALr, [headPath, 'Gyroscope']);
       ROM_OPALr_data.headXAcc =  headAccelData(1,:)';
       ROM_OPALr_data.headYAcc = headAccelData(2,:)';
       ROM_OPALr_data.headZAcc = headAccelData(3,:)';
       ROM_OPALr_data.headXVel = headGyroData(1,:)';
       ROM_OPALr_data.headYVel = headGyroData(2,:)';
       ROM_OPALr_data.headZVel = headGyroData(3,:)';

       sternumAccelData = h5read(current_file_OPALr, [sternumPath, 'Accelerometer']);
       sternumGyroData = h5read(current_file_OPALr, [sternumPath, 'Gyroscope']);
       ROM_OPALr_data.sternumXAcc =  sternumAccelData(1,:)';
       ROM_OPALr_data.sternumYAcc = sternumAccelData(2,:)';
       ROM_OPALr_data.sternumZAcc = sternumAccelData(3,:)';
       ROM_OPALr_data.sternumXVel = sternumGyroData(1,:)';
       ROM_OPALr_data.sternumYVel = sternumGyroData(2,:)';
       ROM_OPALr_data.sternumZVel = sternumGyroData(3,:)';

       lumbarAccelData = h5read(current_file_OPALr, [lumbarPath, 'Accelerometer']);
       lumbarGyroData = h5read(current_file_OPALr, [lumbarPath, 'Gyroscope']);
       ROM_OPALr_data.lumbarXAcc =  lumbarAccelData(1,:)';
       ROM_OPALr_data.lumbarYAcc = lumbarAccelData(2,:)';
       ROM_OPALr_data.lumbarZAcc = lumbarAccelData(3,:)';
       ROM_OPALr_data.lumbarXVel = lumbarGyroData(1,:)';
       ROM_OPALr_data.lumbarYVel = lumbarGyroData(2,:)';
       ROM_OPALr_data.lumbarZVel = lumbarGyroData(3,:)';

       rfootAccelData = h5read(current_file_OPALr, [rfootPath, 'Accelerometer']);
       rfootGyroData = h5read(current_file_OPALr, [rfootPath, 'Gyroscope']);
       ROM_OPALr_data.rfootXAcc =  rfootAccelData(1,:)';
       ROM_OPALr_data.rfootYAcc = rfootAccelData(2,:)';
       ROM_OPALr_data.rfootZAcc = rfootAccelData(3,:)';
       ROM_OPALr_data.rfootXVel = rfootGyroData(1,:)';
       ROM_OPALr_data.rfootYVel = rfootGyroData(2,:)';
       ROM_OPALr_data.rfootZVel = rfootGyroData(3,:)';

       lfootAccelData = h5read(current_file_OPALr, [lfootPath, 'Accelerometer']);
       lfootGyroData = h5read(current_file_OPALr, [lfootPath, 'Gyroscope']);
       ROM_OPALr_data.lfootXAcc =  lfootAccelData(1,:)';
       ROM_OPALr_data.lfootYAcc = lfootAccelData(2,:)';
       ROM_OPALr_data.lfootZAcc = lfootAccelData(3,:)';
       ROM_OPALr_data.lfootXVel = lfootGyroData(1,:)';
       ROM_OPALr_data.lfootYVel = lfootGyroData(2,:)';
       ROM_OPALr_data.lfootZVel = lfootGyroData(3,:)';
       cd(code_path);

        if Wii_trial_index > num_Wii_trials
            Wii_file_index = Wii_file_index +1;
            cd(ROM_Wii_path);
            ROM_Wii_data = readtable(char(ROM_Wii_filenames(Wii_file_index)));
            cd(code_path);

            timesteps = 0;
            for j = 2:length(ROM_Wii_data.Var1)
                timesteps(j) = ROM_Wii_data.Var1(j) - ROM_Wii_data.Var1(j-1);    
            end

            trial_start_loc = [1 find(timesteps > 500)];
            num_Wii_trials = length(trial_start_loc);
            trial_start_loc = [trial_start_loc length(ROM_Wii_data.Var1)];
            Wii_trial_index = 1;

            if num_Wii_trials ~= 6
                
                display(strjoin(["Incorrect number of Wii trials in Block " ...
                    num2str(Wii_file_index) "for subj " num2str(subject) ...
                    "there are " num2str(num_Wii_trials) "trials"]))
                display(trial_start_loc)

            end

        end

        ROM_Wii_trial = ROM_Wii_data{trial_start_loc(Wii_trial_index):(trial_start_loc(Wii_trial_index+1)-1) ,:};


        % get Trial Info from excel sheet % no longer processing the warm
        % up files with the rest of the data
        % if Wii_file_index == 1
        %     ROM_trial_row_index = Wii_trial_index;
        %     ROM_trial_col_index = 7;


        if num_ROM_Wii_files >2 % for blocking 
            ROM_trial_row_index = 6+(Wii_file_index-1)*2+  (ceil(Wii_trial_index/3));
            ROM_trial_col_index = 7+ rem((Wii_trial_index+2),3);

        else % for the single giant file
            ROM_trial_row_index = 6+(ceil(Wii_trial_index/3));%- rem((Wii_trial_index+1),2);
            ROM_trial_col_index = 7+ rem((Wii_trial_index+2),3);

        end

        if subject == 3099 && Wii_file_index>3
            ROM_trial_row_index = 6+(Wii_file_index-1)*2+  (ceil(Wii_trial_index/3))-1;
            ROM_trial_col_index = 7+ rem((Wii_trial_index+2),3);      
        end

        ROM_trial_info = Trial_Info_ROM(ROM_trial_row_index, :) ;
        ROM_pass = ROM_trial_info{ROM_trial_col_index};

        % may need to update so that check individual trials not conditions
        if ROM_trial_info{1} ==0 || isnan(ROM_trial_info{1})
            continue
        end

        if contains(ROM_trial_info{3}, 'SD')
            GIST_fs = 125;
        elseif ROM_GIST_data.Time(end) < ROM_pass*375
            GIST_fs = 125;
        else
            GIST_fs = 375;
        end

        ROM_GIST_data.TimeAdj = ROM_GIST_data.Time/GIST_fs;

        

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

            case 'SD Wave'
                ROM_trial_name = [ROM_trial_name '_SDWVGVS'];

            case 'DC Wave'
                ROM_trial_name = [ROM_trial_name '_DCWVGVS'];
        end

        if ROM_trial_index <10
            ROM_trial_name = [ROM_trial_name '_0' num2str(ROM_trial_index)];
        else
            ROM_trial_name = [ROM_trial_name '_' num2str(ROM_trial_index)];
        end

        cd(ROM_path);
       vars_2_save = ['ROM_GIST_data  ROM_OPALr_data ROM_OPALs_data ROM_Wii_trial ROM_trial_info ROM_pass' ...
           ];
       eval(['  save ' [char(ROM_trial_name), '.mat '] vars_2_save ' vars_2_save']);      
       cd(code_path)
       eval (['clear ' vars_2_save])

        Wii_trial_index = Wii_trial_index+1;
    end

%%
     % get info on FMT files 
     %%% come back and skip the warm up files
     
    cd([code_path '/..']);
    FMT_path = [subject_path '\FMT'] ;
    FMT_GIST_path = [subject_path '\FMT\GIST'] ;
    [FMT_GIST_filenames]=file_path_info2(code_path,FMT_GIST_path ); % get files from file folder
    num_FMT_GIST_files = length(FMT_GIST_filenames);
    cd([code_path '/..']);

    FMT_OPALr_path = [subject_path '\FMT\OPALraw'] ;
    [FMT_OPALr_filenames]=file_path_info2(code_path,FMT_OPALr_path ); % get files from file folder
    num_FMT_OPALr_files = length(FMT_OPALr_filenames);
    cd([code_path '/..']);

    FMT_OPALs_path = [subject_path '\FMT\OPALSummary'] ;
    [FMT_OPALs_filenames]=file_path_info2(code_path,FMT_OPALs_path ); % get files from file folder
    num_FMT_OPALs_files = length(FMT_OPALs_filenames);

    FMT_trial_index = 5; % skip the 5 warm up trials

    for i = 1:num_FMT_GIST_files
        current_file_GIST = char(FMT_GIST_filenames(i));
        current_file_OPALr = char(FMT_OPALr_filenames(i));
        current_file_OPALs = char(FMT_OPALs_filenames(i));
       if ~ contains(current_file_GIST, 'csv') 
           continue
       end

      % for each FMT GIST file (trial) grab data and condition info for 
    % naming then save as a matlab file. 
        FMT_trial_index = FMT_trial_index +1;

        cd(FMT_GIST_path);
        FMT_GIST_data = readtable(current_file_GIST); 
        cd(code_path);

        cd(FMT_OPALs_path);
        FMT_OPALs_data = readtable(current_file_OPALs,'Range','A13:E46');
        cd(code_path);

         cd(FMT_OPALr_path);
       FMT_OPALr_data = table();
       timeMuSec = h5read(current_file_OPALr, [headPath 'Time']);
       timeSec = double(timeMuSec - timeMuSec(1)) / 1e6; % Normalize to seconds starting at 0
       FMT_OPALr_data.Time = timeSec;
       headAccelData = h5read(current_file_OPALr, [headPath, 'Accelerometer']);
       headGyroData = h5read(current_file_OPALr, [headPath, 'Gyroscope']);
       FMT_OPALr_data.headXAcc =  headAccelData(1,:)';
       FMT_OPALr_data.headYAcc = headAccelData(2,:)';
       FMT_OPALr_data.headZAcc = headAccelData(3,:)';
       FMT_OPALr_data.headXVel = headGyroData(1,:)';
       FMT_OPALr_data.headYVel = headGyroData(2,:)';
       FMT_OPALr_data.headZVel = headGyroData(3,:)';

       sternumAccelData = h5read(current_file_OPALr, [sternumPath, 'Accelerometer']);
       sternumGyroData = h5read(current_file_OPALr, [sternumPath, 'Gyroscope']);
       FMT_OPALr_data.sternumXAcc =  sternumAccelData(1,:)';
       FMT_OPALr_data.sternumYAcc = sternumAccelData(2,:)';
       FMT_OPALr_data.sternumZAcc = sternumAccelData(3,:)';
       FMT_OPALr_data.sternumXVel = sternumGyroData(1,:)';
       FMT_OPALr_data.sternumYVel = sternumGyroData(2,:)';
       FMT_OPALr_data.sternumZVel = sternumGyroData(3,:)';

       lumbarAccelData = h5read(current_file_OPALr, [lumbarPath, 'Accelerometer']);
       lumbarGyroData = h5read(current_file_OPALr, [lumbarPath, 'Gyroscope']);
       FMT_OPALr_data.lumbarXAcc =  lumbarAccelData(1,:)';
       FMT_OPALr_data.lumbarYAcc = lumbarAccelData(2,:)';
       FMT_OPALr_data.lumbarZAcc = lumbarAccelData(3,:)';
       FMT_OPALr_data.lumbarXVel = lumbarGyroData(1,:)';
       FMT_OPALr_data.lumbarYVel = lumbarGyroData(2,:)';
       FMT_OPALr_data.lumbarZVel = lumbarGyroData(3,:)';

       rfootAccelData = h5read(current_file_OPALr, [rfootPath, 'Accelerometer']);
       rfootGyroData = h5read(current_file_OPALr, [rfootPath, 'Gyroscope']);
       FMT_OPALr_data.rfootXAcc =  rfootAccelData(1,:)';
       FMT_OPALr_data.rfootYAcc = rfootAccelData(2,:)';
       FMT_OPALr_data.rfootZAcc = rfootAccelData(3,:)';
       FMT_OPALr_data.rfootXVel = rfootGyroData(1,:)';
       FMT_OPALr_data.rfootYVel = rfootGyroData(2,:)';
       FMT_OPALr_data.rfootZVel = rfootGyroData(3,:)';

       lfootAccelData = h5read(current_file_OPALr, [lfootPath, 'Accelerometer']);
       lfootGyroData = h5read(current_file_OPALr, [lfootPath, 'Gyroscope']);
       FMT_OPALr_data.lfootXAcc =  lfootAccelData(1,:)';
       FMT_OPALr_data.lfootYAcc = lfootAccelData(2,:)';
       FMT_OPALr_data.lfootZAcc = lfootAccelData(3,:)';
       FMT_OPALr_data.lfootXVel = lfootGyroData(1,:)';
       FMT_OPALr_data.lfootYVel = lfootGyroData(2,:)';
       FMT_OPALr_data.lfootZVel = lfootGyroData(3,:)';
       cd(code_path);

        FMT_trial_info = Trial_Info_FMT(FMT_trial_index, :) ;
        trial_num = FMT_trial_info{1};
        % there will be between 3 and 5 training trials - check to see if
        % training trials 4 or 5 were completed, other wise skip over them
        if trial_num ==0 || isnan(trial_num)
            % FMT_trial_index = FMT_trial_index +1;
            % FMT_trial_info = Trial_Info_FMT(FMT_trial_index, :) ;
            % trial_num = FMT_trial_info{1};
            continue
        end

        FMT_raw_time = FMT_trial_info{4};
        FMT_errors = FMT_trial_info{5};
        FMT_adj_time = FMT_trial_info{6};

        if contains(FMT_trial_info{3}, 'SD')
            GIST_fs = 125;
        elseif FMT_GIST_data.Time(end) < FMT_raw_time*375
            GIST_fs = 125;
        else
            GIST_fs = 375;
        end

        FMT_GIST_data.TimeAdj = FMT_GIST_data.Time/GIST_fs;

        FMT_trial_name = 'FMT';
        % put together trial_name

        switch FMT_trial_info{3}
            case 'Sham'
                FMT_trial_name = [FMT_trial_name '_SHAMGVS'];

            case 'SD Wave'
                FMT_trial_name = [FMT_trial_name '_SDWVGVS'];

            case 'DC Wave'
                FMT_trial_name = [FMT_trial_name '_DCWVGVS'];
        end

        if FMT_trial_index <10
            FMT_trial_name = [FMT_trial_name '_0' num2str(FMT_trial_index)];
        else
            FMT_trial_name = [FMT_trial_name '_' num2str(FMT_trial_index)];
        end

        cd(FMT_path);
       vars_2_save = ['FMT_GIST_data FMT_OPALr_data FMT_OPALs_data FMT_trial_info FMT_raw_time FMT_errors FMT_adj_time' ...
           ];
       eval(['  save ' [char(FMT_trial_name), '.mat '] vars_2_save ' vars_2_save']);      
       cd(code_path)
       eval (['clear ' vars_2_save])
    end

 


    %%
     % get info on Tandem files 
    cd([code_path '/..']);
    TDM_path = [subject_path '\Tandem'] ;
    TDM_GIST_path = [subject_path '\Tandem\GIST'] ;
    [TDM_GIST_filenames]=file_path_info2(code_path,TDM_GIST_path ); % get files from file folder
    num_TDM_GIST_files = length(TDM_GIST_filenames);
        cd([code_path '/..']);

    TDM_OPALr_path = [subject_path '\Tandem\OPALraw'] ;
    [TDM_OPALr_filenames]=file_path_info2(code_path,TDM_OPALr_path ); % get files from file folder
    num_TDM_OPALr_files = length(TDM_OPALr_filenames);
    cd([code_path '/..']);

    TDM_OPALs_path = [subject_path '\Tandem\OPALSummary'] ;
    [TDM_OPALs_filenames]=file_path_info2(code_path,TDM_OPALs_path ); % get files from file folder
    num_TDM_OPALs_files = length(TDM_OPALs_filenames);

    TDM_trial_index = 2; % skip the warm up trials

    for i = 1:num_TDM_GIST_files
        current_file_GIST = char(TDM_GIST_filenames(i));
        current_file_OPALr = char(TDM_OPALr_filenames(i));
        current_file_OPALs = char(TDM_OPALs_filenames(i));
       if ~ contains(current_file_GIST, 'csv') 
           continue
       end
        TDM_trial_index = TDM_trial_index +1;

        cd(TDM_GIST_path);
        TDM_GIST_data = readtable(current_file_GIST); 
        cd(code_path);

                cd(TDM_OPALs_path);
        TDM_OPALs_data = readtable(current_file_OPALs,'Range','A13:E46');
        cd(code_path);

         cd(TDM_OPALr_path);
       TDM_OPALr_data = table();
       timeMuSec = h5read(current_file_OPALr, [headPath 'Time']);
       timeSec = double(timeMuSec - timeMuSec(1)) / 1e6; % Normalize to seconds starting at 0
       TDM_OPALr_data.Time = timeSec;
       headAccelData = h5read(current_file_OPALr, [headPath, 'Accelerometer']);
       headGyroData = h5read(current_file_OPALr, [headPath, 'Gyroscope']);
       TDM_OPALr_data.headXAcc =  headAccelData(1,:)';
       TDM_OPALr_data.headYAcc = headAccelData(2,:)';
       TDM_OPALr_data.headZAcc = headAccelData(3,:)';
       TDM_OPALr_data.headXVel = headGyroData(1,:)';
       TDM_OPALr_data.headYVel = headGyroData(2,:)';
       TDM_OPALr_data.headZVel = headGyroData(3,:)';

       sternumAccelData = h5read(current_file_OPALr, [sternumPath, 'Accelerometer']);
       sternumGyroData = h5read(current_file_OPALr, [sternumPath, 'Gyroscope']);
       TDM_OPALr_data.sternumXAcc =  sternumAccelData(1,:)';
       TDM_OPALr_data.sternumYAcc = sternumAccelData(2,:)';
       TDM_OPALr_data.sternumZAcc = sternumAccelData(3,:)';
       TDM_OPALr_data.sternumXVel = sternumGyroData(1,:)';
       TDM_OPALr_data.sternumYVel = sternumGyroData(2,:)';
       TDM_OPALr_data.sternumZVel = sternumGyroData(3,:)';

       lumbarAccelData = h5read(current_file_OPALr, [lumbarPath, 'Accelerometer']);
       lumbarGyroData = h5read(current_file_OPALr, [lumbarPath, 'Gyroscope']);
       TDM_OPALr_data.lumbarXAcc =  lumbarAccelData(1,:)';
       TDM_OPALr_data.lumbarYAcc = lumbarAccelData(2,:)';
       TDM_OPALr_data.lumbarZAcc = lumbarAccelData(3,:)';
       TDM_OPALr_data.lumbarXVel = lumbarGyroData(1,:)';
       TDM_OPALr_data.lumbarYVel = lumbarGyroData(2,:)';
       TDM_OPALr_data.lumbarZVel = lumbarGyroData(3,:)';

       rfootAccelData = h5read(current_file_OPALr, [rfootPath, 'Accelerometer']);
       rfootGyroData = h5read(current_file_OPALr, [rfootPath, 'Gyroscope']);
       TDM_OPALr_data.rfootXAcc =  rfootAccelData(1,:)';
       TDM_OPALr_data.rfootYAcc = rfootAccelData(2,:)';
       TDM_OPALr_data.rfootZAcc = rfootAccelData(3,:)';
       TDM_OPALr_data.rfootXVel = rfootGyroData(1,:)';
       TDM_OPALr_data.rfootYVel = rfootGyroData(2,:)';
       TDM_OPALr_data.rfootZVel = rfootGyroData(3,:)';

       lfootAccelData = h5read(current_file_OPALr, [lfootPath, 'Accelerometer']);
       lfootGyroData = h5read(current_file_OPALr, [lfootPath, 'Gyroscope']);
       TDM_OPALr_data.lfootXAcc =  lfootAccelData(1,:)';
       TDM_OPALr_data.lfootYAcc = lfootAccelData(2,:)';
       TDM_OPALr_data.lfootZAcc = lfootAccelData(3,:)';
       TDM_OPALr_data.lfootXVel = lfootGyroData(1,:)';
       TDM_OPALr_data.lfootYVel = lfootGyroData(2,:)';
       TDM_OPALr_data.lfootZVel = lfootGyroData(3,:)';
       cd(code_path);

        TDM_trial_info = Trial_Info_TDM(TDM_trial_index, :) ;

        if TDM_trial_info{1} ==0 || isnan(TDM_trial_info{1})

            continue
        end
        TDM_correct_steps = TDM_trial_info{5};

        if contains(TDM_trial_info{3}, 'SD')
            GIST_fs = 125;
        elseif (TDM_GIST_data.Time(end) < (timeSec(end)-2)*375) || (TDM_GIST_data.Time(end) < 12*375)
            GIST_fs = 125;
        else
            GIST_fs = 375;
        end

        TDM_GIST_data.TimeAdj = TDM_GIST_data.Time/GIST_fs;

        TDM_trial_name = 'TDM';
        % put together trial_name

        switch TDM_trial_info{4}
            case 'Open'
                TDM_trial_name = [TDM_trial_name '_EO'];

            case 'Closed'
                TDM_trial_name = [TDM_trial_name '_EC'];
        end

        switch TDM_trial_info{3}
            case 'Sham'
                TDM_trial_name = [TDM_trial_name '_SHAMGVS'];

            case 'SD Wave'
                TDM_trial_name = [TDM_trial_name '_SDWVGVS'];

            case 'DC Wave'
                TDM_trial_name = [TDM_trial_name '_DCWVGVS'];
        end

        if TDM_trial_index <10
            TDM_trial_name = [TDM_trial_name '_0' num2str(TDM_trial_index)];
        else
            TDM_trial_name = [TDM_trial_name '_' num2str(TDM_trial_index)];
        end

        cd(TDM_path);
       vars_2_save = ['TDM_GIST_data TDM_OPALr_data TDM_OPALs_data TDM_trial_info TDM_correct_steps ' ...
           ];
       eval(['  save ' [char(TDM_trial_name), '.mat '] vars_2_save ' vars_2_save']);      
       cd(code_path)
       eval (['clear ' vars_2_save])
    end

    %%
 % get info on TTS MC files 
    cd([code_path '/..']);
    TTS_path = [subject_path '\TTS'] ;
    TTS_GIST_path = [subject_path '\TTS\GIST'] ;
    TTS_MC_path = [subject_path '\TTS\TTS'] ;
    [TTS_GIST_filenames]=file_path_info2(code_path,TTS_GIST_path ); % get files from file folder
    cd([code_path '/..']);
    [TTS_MC_filenames]=file_path_info2(code_path,TTS_MC_path ); % get files from file folder
    num_TTS_GIST_files = length(TTS_GIST_filenames);
    num_TTS_MC_files = length(TTS_MC_filenames);

    % for each romberg GIST file (trial) grab associated TTS file
    % data and condition info for naming then save as a matlab file. 
    MC_file_index = 0;
    MC_trial_index = 1;
    num_MC_trials = 0;
    TTS_trial_index = 0;
    for i = 1:num_TTS_GIST_files
        current_file_GIST = char(TTS_GIST_filenames(i));
       if ~ contains(current_file_GIST, 'csv') 
           continue
       end
       TTS_trial_index = TTS_trial_index +1;
        cd(TTS_GIST_path);
        TTS_GIST_data = readtable(current_file_GIST); 
        cd(code_path);

        TTS_trial_info = Trial_Info_TTS(TTS_trial_index, :) ;
        if TTS_trial_info{1} ==0 || isnan(TTS_trial_info{1})
            continue
        end

        TTS_profile = TTS_trial_info{4};
        TTS_file_num = TTS_trial_info{1};

        idx = cellfun(@(x) contains(x, TTS_profile) && contains(x, [' ' num2str( TTS_file_num)]), TTS_MC_filenames);
        MC_file_index  = find(idx);

        % MC_file_index = find(all(contains(TTS_MC_filenames, TTS_profile) && contains(TTS_MC_filenames,TTS_trial_info{3})));
        % MC_file_index = MC_file_index +1;
        cd(TTS_MC_path);
            TTS_MC_data = readtable(char(TTS_MC_filenames(MC_file_index)));
        cd(code_path);

        if contains(TTS_trial_info{3}, 'SD')
            GIST_fs = 125;
        elseif (TTS_GIST_data.Time(end) < 120*375)
            GIST_fs = 125;
        else
            GIST_fs = 375;
        end

        TTS_GIST_data.TimeAdj = TTS_GIST_data.Time/GIST_fs;

        TTS_trial_name = 'TTS';
        % put together trial_name
        TTS_trial_name = [TTS_trial_name '_' TTS_trial_info{4}];


        switch TTS_trial_info{3}
            case 'Sham'
                TTS_trial_name = [TTS_trial_name '_SHAMGVS'];

            case 'SD Wave'
                TTS_trial_name = [TTS_trial_name '_SDWVGVS'];

            case 'DC Wave'
                TTS_trial_name = [TTS_trial_name '_DCWVGVS'];
        end

        if TTS_trial_index <10
            TTS_trial_name = [TTS_trial_name '_0' num2str(TTS_trial_index)];
        else
            TTS_trial_name = [TTS_trial_name '_' num2str(TTS_trial_index)];
        end

        cd(TTS_path);
       vars_2_save = ['TTS_GIST_data  TTS_MC_data TTS_trial_info TTS_profile ' ...
           ];
       eval(['  save ' [char(TTS_trial_name), '.mat '] vars_2_save ' vars_2_save']);      
       cd(code_path)
       eval (['clear ' vars_2_save])

        MC_trial_index = MC_trial_index+1;
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
    %%
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

