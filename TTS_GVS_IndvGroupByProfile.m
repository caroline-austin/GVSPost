%% Script 2 for Dynamic GVS +Tilt
% this script takes the individual matlab files generated in the previous
% script and combines the data into a single matlab file with variables
% made up of multiple trials(each trial is a separate column), but grouped
% by the physical motion profile that the trial is associated with. The
% trial each column is associated with is stored in the Label structure.
% The results of this file are unadjusted, but are able to be used as inputs 
% in any of the 3,4,5 scripts
close all; 
clear all; 
clc; 

%% set up
subnum = 1015:1015;  % Subject List 
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory (Data)
plots_path = [file_path '\Plots']; % specify where plots are saved
[filenames]=file_path_info2(code_path, file_path); % get file names from file folder
   
% combine individual trials for each subject
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    %directory with individual subject files (this naming convention is
    %predefined)
%     subject_path = [file_path, '\PS' , subject_str];
    subject_path = [file_path, '\' , subject_str];

    % load overall file(has info about all trials from the "master"
    % excel document)
    cd(subject_path);
    load(['S', subject_str, '.mat ']);
    cd(code_path);

    %get info about indiviual trial files
    [subject_filenames]=file_path_info2(code_path,subject_path ); % get files from file folder
    num_files = length(subject_filenames);
    mat_filenames = get_filetype(subject_filenames, 'mat');
    num_mat_files = length(mat_filenames);

   %initialize/allocate the variables we plan to consolidate the trial
   %variables into
   GVS_4A = [];
   tilt_4A = [];
   shot_4A = [];
   GVS_4B = [];
   tilt_4B = [];
   shot_4B = [];
   GVS_5A = [];
   tilt_5A = [];
   shot_5A = [];
   GVS_5B = [];
   tilt_5B = [];
   shot_5B = [];
   GVS_6A = [];
   tilt_6A = [];
   shot_6A = [];
   GVS_6B = [];
   tilt_6B = [];
   shot_6B = [];
   
    %iterate through all trial files to store them into the grouped
    %variables
    for file = 1:num_mat_files
        current_file = char(mat_filenames(file));
       %skip files that aren't the trial files 
       if length(current_file)<25
           continue
       end

       %get info about and load trial file
       check_profile_name = current_file(7:8); %reduce by one when transitioning to regular subjects
       trial_number = current_file(end-5:end-4);
%        current_val = current_file();
%        proportional = current_file();
       cd(subject_path);
       load(current_file);
       cd(code_path); 

        %store trial files based on the motion profile. the code should
        %automatically sort things alpha-numerically, but the label is also
        %created to identify data
        switch check_profile_name

            case '4A'

                [GVS_4A, Label] = AddOnData3(GVS_4A,GVS_command(2:end), ... 
                    -GVS_actual_mV,-GVS_actual_filt, Label, 'GVS_4A', ... 
                    '_GVS_command', '_GVS_actual_mV', '_GVS_actual_filt', ... 
                    current_file);

                [tilt_4A, Label] = AddOnData3(tilt_4A,tilt_command, ... 
                    tilt_actual,tilt_velocity, Label, 'tilt_4A', ... 
                    '_tilt_command', '_tilt_actual', '_tilt_velocity', ... 
                    current_file);
                [shot_4A, Label] = AddOnData1(shot_4A,shot_actual,  ... 
                    Label, 'shot_4A', 'shot_actual', current_file);
              
            case '4B'
               [GVS_4B, Label] = AddOnData3(GVS_4B,GVS_command, ... 
                    -GVS_actual_mV,-GVS_actual_filt, Label, 'GVS_4B', ... 
                    '_GVS_command', '_GVS_actual_mV', '_GVS_actual_filt', ... 
                    current_file);

                [tilt_4B, Label] = AddOnData3(tilt_4B,tilt_command, ... 
                    tilt_actual,tilt_velocity, Label, 'tilt_4B', ... 
                    '_tilt_command', '_tilt_actual', '_tilt_velocity', ... 
                    current_file);
                [shot_4B, Label] = AddOnData1(shot_4B,shot_actual,  ... 
                    Label, 'shot_4B', 'shot_actual', current_file);

            case '5A'

                [GVS_5A, Label] = AddOnData3(GVS_5A,GVS_command(2:end), ... 
                    -GVS_actual_mV,-GVS_actual_filt, Label, 'GVS_5A', ... 
                    '_GVS_command', '_GVS_actual_mV', '_GVS_actual_filt', ... 
                    current_file);

                [tilt_5A, Label] = AddOnData3(tilt_5A,tilt_command, ... 
                    tilt_actual,tilt_velocity, Label, 'tilt_5A', ... 
                    '_tilt_command', '_tilt_actual', '_tilt_velocity', ... 
                    current_file);
                [shot_5A, Label] = AddOnData1(shot_5A,shot_actual,  ... 
                    Label, 'shot_5A', 'shot_actual', current_file);

            case '5B'

                [GVS_5B, Label] = AddOnData3(GVS_5B,GVS_command, ... 
                    -GVS_actual_mV,-GVS_actual_filt, Label, 'GVS_5B', ... 
                    '_GVS_command', '_GVS_actual_mV', '_GVS_actual_filt', ... 
                    current_file);

                [tilt_5B, Label] = AddOnData3(tilt_5B,tilt_command, ... 
                    tilt_actual,tilt_velocity, Label, 'tilt_5B', ... 
                    '_tilt_command', '_tilt_actual', '_tilt_velocity', ... 
                    current_file);
                [shot_5B, Label] = AddOnData1(shot_5B,shot_actual,  ... 
                    Label, 'shot_5B', 'shot_actual', current_file);

            case '6A'

                [GVS_6A, Label] = AddOnData3(GVS_6A,GVS_command, ... 
                    -GVS_actual_mV,-GVS_actual_filt, Label, 'GVS_6A', ... 
                    '_GVS_command', '_GVS_actual_mV', '_GVS_actual_filt', ... 
                    current_file);

                [tilt_6A, Label] = AddOnData3(tilt_6A,tilt_command, ... 
                    tilt_actual,tilt_velocity, Label, 'tilt_6A', ... 
                    '_tilt_command', '_tilt_actual', '_tilt_velocity', ... 
                    current_file);
                [shot_6A, Label] = AddOnData1(shot_6A,shot_actual,  ... 
                    Label, 'shot_6A', 'shot_actual', current_file);

            case '6B'

                [GVS_6B, Label] = AddOnData3(GVS_6B,GVS_command, ... 
                    -GVS_actual_mV,-GVS_actual_filt, Label, 'GVS_6B', ... 
                    '_GVS_command', '_GVS_actual_mV', '_GVS_actual_filt', ... 
                    current_file);

                [tilt_6B, Label] = AddOnData3(tilt_6B,tilt_command, ... 
                    tilt_actual,tilt_velocity, Label, 'tilt_6B', ... 
                    '_tilt_command', '_tilt_actual', '_tilt_velocity', ... 
                    current_file);
                [shot_6B, Label] = AddOnData1(shot_6B,shot_actual,  ... 
                    Label, 'shot_6B', 'shot_actual', current_file);
        end
    end
    %set up time vector for plotting later on
    time = (time- time(1))/1000;  

%% save files
   cd(subject_path);
   vars_2_save = ['Label Trial_Info time trial_end shot_4A tilt_4A GVS_4A  ' ...
       ' shot_5A tilt_5A GVS_5A shot_6A tilt_6A GVS_6A shot_4B tilt_4B GVS_4B  ' ...
       'shot_5B tilt_5B GVS_5B shot_6B tilt_6B GVS_6B'];
   %change filename for saving -> remove PS and possibly swap out "Group"
   %for Extract or Sort
   eval(['  save ' ['S', subject_str, 'Group.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])
   close all;

end
function [out_var, Label] = AddOnData3(out_var,data1,data2,data3, Label, ...
    out_var_name, name1, name2, name3,current_file)
    %determine existing variable size
    [~,out_var_col]=size(out_var);
    %append data onto existing variable
    out_var(:,out_var_col+1) = data1; 
    out_var(:,out_var_col+2) = data2; 
    out_var(:,out_var_col+3) = data3; 

    %append corresponding labels
    eval(char(["Label." out_var_name "(out_var_col+1,:) = string([ " + ...
        "current_file(10:end-4)  name1]);"]));
    eval(char(["Label." out_var_name "(out_var_col+2,:) = string([ " + ...
        "current_file(10:end-4)  name2]);"]));
    eval(char(["Label." out_var_name "(out_var_col+3,:) = string([ " + ...
        "current_file(10:end-4)  name3]);"]));

end

function [out_var, Label] = AddOnData1(out_var,data1, Label, out_var_name, ...
    name1, current_file)
    %determine existing variable size
    [~,out_var_col]=size(out_var);
    %append data onto existing variable
    out_var(:,out_var_col+1) = data1; 
    %append corresponding labels
    eval(char(["Label." out_var_name "(out_var_col+1,:) = string([ " + ...
        "current_file(10:end-4)  name1]);"]));

end