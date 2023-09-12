%% Dynamic GVS X1A - Script 8a
% Locates the peaks and valleys of the GVS Current for each individual's
% trial, and saves the SHOT Perception at that point
%
% Edit the subject range and dataType for what is needed, then hit run and
% navigate to your Data folder that has been synced with the repository.
%
% Initial Code by Lanna K, sept 2023

% Housekeeping
clear; close all; clc;

%%%%% Edit Here: %%%%%%%%%%%%%%%%%%
% Which Subjects and files to find?
subnum = 1011:1022;  % Subject List 
numsub = length(subnum);
subskip = [1006 1007 1008 1009 1010 1013 1015 40006];  %DNF'd subjects or subjects that didn't complete this part
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];
datatype = 'BiasTimeGain';      % options are '', 'Bias', 'BiasTime', 'BiasTimeGain'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
profileNums = ["_4A" "_4B" "_5A" "_5B" "_6A" "_6B"];
shotStr = "shot";
gvsStr = "GVS";
tiltStr = "tilt";
count = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Where to look for them?
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
% OS Specific Details
if ismac || isunix
    plots_path = [file_path '/Plots']; % specify where plots are saved
    gvs_path = [file_path '/GVSProfiles'];
elseif ispc
    plots_path = [file_path '\Plots']; % specify where plots are saved
    gvs_path = [file_path '\GVSProfiles'];
end
[filenames]=file_path_info2(code_path, file_path); % get files from file folder


% Loop through the subjects
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end   

    %load subject files
    if ismac || isunix
        subject_path = [file_path, '/' , subject_str];
        cd(subject_path);
        load(['S', subject_str, 'Group' datatype '.mat']);
        cd(code_path);
    elseif ispc
        subject_path = [file_path, '\' , subject_str];
        cd(subject_path);
        load(['S', subject_str, 'Group' datatype '.mat ']);
        cd(code_path);
    end

    for i = 1:numel(profileNums)
        % Which Profile are we looking at?
        gvsTrial = strcat(gvsStr,profileNums(i));
        shotTrial = strcat(shotStr,profileNums(i));
        % Which Columns contain filtered data?
        gvsList = contains(Label.(gvsTrial),"command");
        
        % Loop through each of the recorded GVS trials for that motion profile
        for j = 1:length(Label.(gvsTrial))
            
            % Skip the non-filtered GVS columns
            if gvsList(j) == 0
                continue
            end
            count = count + 1;

            for k = 1:length(match_list)    
                % Compare filename against each option in the matchlist
                if contains(Label.(gvsTrial)(j), match_list(k))
                    % Pull the GVS file that matches
                    gvsFile = eval(gvsTrial);

                    % Find the local min and max indices
                    gvsMax = islocalmax(gvsFile(:,j),'MinProminence',0.1,'MinSeparation',100);
                    gvsMaxIndices = find(gvsMax);
                    gvsMin = islocalmin(gvsFile(:,j),'MinProminence',0.1,'MinSeparation',100);
                    gvsMinIndices = find(gvsMin);
                    gvsAllIndices = union(gvsMinIndices,gvsMaxIndices);% Combine the two arrays
                    
                    % Plot to check
                    %figure; plot(gvsFile(:,j)); hold on; plot(gvsMax); plot(gvsMin);

                    % Save the Shot values at those points
                    shotData = eval(shotTrial);
                    shotAtGVSPeaks(sub).(shotTrial).(Label.(shotTrial)(count)) = shotData(gvsAllIndices,count);
                    
                end
            end
        end
count = 0;
    end
end
