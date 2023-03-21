close all; 
clear all; 
clc; 
% code section 1 for TTS stuff
%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
gvs_path = [file_path '\GVSProfiles'];
tts_path = [file_path '\TTSProfiles'];
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

subnum = 1003:1003;  % Subject List 
numsub = length(subnum);
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    subject_path = [file_path, '\PS' , subject_str];

    cd(file_path);
    Trial_Info = readcell('DynamicGVSPlusTilt.xlsx','Sheet', ...
        ['PS' subject_str],'Range','A2:H46'); % H30 for PS02, 46 for PS03
    Trial_Num = cell2mat(Trial_Info(:,1));
    Label.DataColumns = readcell('DynamicGVSPlusTilt.xlsx','Sheet',... 
        ['PS' subject_str], 'Range','A1:H1');

    cd(code_path);
    [subject_filenames]=file_path_info2(code_path,subject_path ); % get files from file folder
    num_sub_files = length(subject_filenames);
    csv_filenames = get_filetype(subject_filenames, 'csv');
    num_csv_files = length(csv_filenames);

%     cd(subject_path);

    for i = 1:num_csv_files
       current_csv_file = char(csv_filenames(i));
       if ~ contains(current_csv_file, 'A.') && ~ contains(current_csv_file, 'B.')
           continue
       end
       % match the GVS Profile to the TTS profile currently using trial
       % info to do this but eventually should have info in the trial name
       trial_loc = find(current_csv_file == ' ', 1); % this won't work if there's a space in the subject number
       trial_number = current_csv_file(trial_loc+1:trial_loc+2);

       row = find(Trial_Num == str2num(trial_number),1);
       if str2num(trial_number)<10
           trial_number = ['0', trial_number];
       end
       test = current_csv_file(end-23:end-14);
       part_1 = string(Trial_Info(row,4));
       GVS_profile_name = char(strjoin([ string(Trial_Info(row,4)), "_", string(Trial_Info(row,5)), "mA_prop", string(Trial_Info(row,6))])); %string(current_csv_file(end-22:end-13))
        
       if contains(GVS_profile_name, '.')
            decimal_loc = find(GVS_profile_name(:) == '.');

            proportion= strrep(strjoin([string(GVS_profile_name(decimal_loc-1)) '_' GVS_profile_name(decimal_loc+1) '0']),' ', '');
        else
            proportion = [GVS_profile_name(end) '_00'];
        end

       GVS_profile_name = strrep([strrep(char(GVS_profile_name), '.', '_') '.mat'], ' ', '');
       TTS_profile = GVS_profile_name(9:10);

       TTS_profile_name = ['SumOfSin', TTS_profile ];

        if contains(GVS_profile_name, '-')
            polarity = 'N';
            current_val = string(abs(str2num(string(Trial_Info(row,5)))));
        else
            polarity = 'P';
            current_val = string(Trial_Info(row,5));
        end
        

       filesave_name = strrep(strjoin(['PS' subject_str '_' TTS_profile ...
           '_' polarity '_' current_val '_00mA_' ...
           proportion '_' trial_number]), ' ', '');

       cd(gvs_path)
       Commanded_GVS= load(GVS_profile_name);
       cd (code_path);
       GVS_command1 = (Commanded_GVS.Profile(1,2:end));
       GVS_command = (cellfun(@str2num,(GVS_command1))')/100;

       cd(tts_path)
       Commanded_TTS= load([TTS_profile_name, '.txt']);
       cd (code_path);
       tilt_velocity = (Commanded_TTS(2:end,7))/200;
        
       close all % to limit the number of plots open at once
       % load the matching TTS file and store the appropriate data

       %load the TTS profile
       cd(subject_path);
       TTS_data = readtable(current_csv_file); 
       cd(code_path);
       time = table2array(TTS_data(1:end-1,1));
       plot_time = (time -time(1))/1000;
       tilt_command = table2array(TTS_data(1:end-1,2))/200;
       tilt_actual = table2array(TTS_data(1:end-1,4))/200;
       shot_actual = table2array(TTS_data(1:end-1,6))/1000;
       GVS_actual_mV= table2array(TTS_data(1:end-1,11))/1000;
       mustBeNonsparse(GVS_actual_mV);
       mustBeFinite(GVS_actual_mV);
       GVS_actual_filt = lowpass(GVS_actual_mV,1,50); %filter raw GVS data
       trial_end = find(time,1, 'last');

       cd(subject_path);
       vars_2_save = ['TTS_data tilt_command tilt_velocity tilt_actual' ...
           ' time plot_time GVS_actual_mV GVS_actual_filt trial_end' ...
           ' GVS_command shot_actual'];
       eval(['  save ' [char(filesave_name), '.mat '] vars_2_save ' vars_2_save']);      
       cd(code_path)
       eval (['clear ' vars_2_save])
    
    end
    cd(subject_path);
    eval(['  save ' ['PS', subject_str, '.mat '] ' Label Trial_Info ']); 
    cd(code_path) 
% clear Label Trial_Info
end