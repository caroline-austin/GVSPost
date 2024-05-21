%script 2
% prep the workspace
close all; 
clear all; 
clc; 

%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

subnum = [1011:1022, 1066:1068];  % Subject List 
subskip = [1006 1007 1008 1009 1010 1011 1012 1013 1015 1019 1067 40006];  %DNF'd subjects or subjects that didn't complete this part
numsub = length(subnum);

used_sub = 0; % initialize variable that keeps track of the subjects' data that is analyzed in this step
for sub = 1:numsub %interate through all of the specified subjects
    %put subject number into quick and usable format for the interation
    subject = subnum(sub); 
    subject_str = num2str(subject);

    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    %keep track of subject data order
    used_sub = used_sub +1;
    subject_label(used_sub)= subject;

    %load the file with subject data
    cd([file_path, '/' , subject_str]);
    load(['A' subject_str '.mat'])
    cd(code_path);

%initialize current amplitude information to be used later
Label.CurrentAmp = [0, 0.1 , 0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 2.0, 4.0];
% MaxCurrent = cell2mat(MaxCurrent);
% MinCurrent = cell2mat(MinCurrent);

%change data type of other variables of interest that are cells
EndImpedance = cell2mat(EndImpedance);
if isempty(EndImpedance)
    EndImpedance = 0;
end
TTSImpedance = cell2mat(TTSImpedance);
if isempty(TTSImpedance)
    TTSImpedance = 0;
end
StartImpedance = cell2mat(StartImpedance);
if isempty(StartImpedance)
    StartImpedance = 0;
end
        
 %% Rating Scale Data Extraction
 rating_scale = ["none"; "slight"; "moderate"; "severe"]; %responses to check for
 %condense data into specific "maps" which record responses based on
 %current level, response, electrode configuration, and profile
 %these variables are specifically the intensity rating
 % suffix 1 is from part 1 of the experiment
 Tingle_map = TextMatchMap(SideEffects1,TrialInfo1,rating_scale, 1);
 Metallic_map = TextMatchMap(SideEffects1,TrialInfo1,rating_scale, 2);
 VisFlash_map = TextMatchMap(SideEffects1,TrialInfo1,rating_scale, 3);
 MotionRating_map = TextMatchMap(MotionSense1,TrialInfo1,rating_scale, 1);
 ObservedRating_map = TextMatchMap(Observed1,TrialInfo1,rating_scale, 1);
 Label.Rating_map = ["Current"; "Rating"; "Config"];

% 
% %take map variables and reduce it so that they only contain the responses
% %from the high (max), low (min), and sham (0.1) trials - the actual current values 
% % vary between subjects for high and low
% Tingle_mapReduced = ReduceMapMultiple(Tingle_map,MinCurrent,MaxCurrent,Label);
% Metallic_mapReduced = ReduceMapMultiple(Metallic_map,MinCurrent,MaxCurrent,Label);
% VisFlash_mapReduced = ReduceMapMultiple(VisFlash_map,MinCurrent,MaxCurrent,Label);
% MotionRating_mapReduced = ReduceMapMultiple(MotionRating_map,MinCurrent,MaxCurrent,Label);
% ObservedRating_mapReduced = ReduceMapMultiple(ObservedRating_map,MinCurrent,MaxCurrent,Label);


%% Save file
    cd([file_path, '/' , subject_str]); %move to directory where file will be saved
    %add all variables that we want to save to a list must include space
    %between variable names 
    vars_2_save =  ['Label Tingle_map Metallic_map' ... 
        ' VisFlash_map MotionRating_map ObservedRating_map' ... 
        ' '...
        ' EndImpedance StartImpedance']; 
    eval(['  save ' ['A', subject_str,'Extract.mat '] vars_2_save ' vars_2_save']); %save file     
    cd(code_path) %return to code directory
    %clear saved variables to prevent them from affecting next subjects' data
    eval (['clear ' vars_2_save]) 

end % loop around to the next subject

function [Output_map] = TextMatchMap(Input,TrialInfo,Text2Chk,Column)
%TextMatchMap cycles through a column of data looking for text that matches
%the text specified in Text2Chk and then records it in an array where the
%location it is stored in the array provides information about what the 
% response was and the conditions underwhich this response was obtained to
% back the information back out you will need the index label

response_types = length(Text2Chk);

%these are the hardcoded locations of the data in the TrialInfo variable
%and also the initilization of the storage index used/reset later on in the
%code. ideally I could modify this function to pass in a label variable that
%could check for which column each variable of interest is in, but this
%will work for now
current_col = 3;
current_index = 0;
% config_col = 2; 
config_index = 1;
% profile_col = 5;
profile_index = 1;
%initialize checking variables
match = 0;
check = 1;

% pre-allocate map with: 10 current levels, x response types, 
% 1 configurations, 1 profiles
% ideally/eventually these numbers should be pulled maybe from TrialInfo
Output_map = zeros(10,response_types,1,1);

for j= 1:response_types %cycle through for each string you want to check
    %find the location of any responses that match the specified response
    match_loc = find(contains(Input(:,Column), Text2Chk(j)));
    for i =1: length(Input(:,Column)) %cycle through all row in the data column to find all the matches
        match = ~ isempty(find(match_loc == i,1)); %check if this row is a match
        if match
            check = check +1; % for debugging purposes
            %pull trial info (variables) we want to index/store by
            Current = TrialInfo(i, current_col);
%             Config = TrialInfo(i, config_col);
%             Profile = TrialInfo(i, profile_col);

            %assign storage index value for each of our variables of
            %interest that we want to index by
           
  
            switch string(Current)
                case '0'
                    current_index = 1;
                case '0.1'
                    current_index = 2;
                case '0.25'
                    current_index = 3;
                case '0.5'
                    current_index = 4;
                case '0.75'
                    current_index = 5;
                case '1'
                    current_index = 6;
                case '1.25'
                    current_index = 7;
                case '1.5'
                    current_index = 8;
                case '2'
                    current_index = 9;
                case '4'
                    current_index = 10;
                otherwise
                    current_index = 0;
            end
    
        end

        %error checking
        if current_index == 0 || profile_index == 0 || config_index == 0
            continue
        end
    
        %record the matched value in the proper map location
        if match % the way this is currently coded doesn't account for reducing multiple reports to a single report 
%             Output_map(current_index, j,config_index,profile_index) = 1;%... 
                Output_map(current_index,j, config_index,profile_index)=  Output_map(current_index, j,config_index,profile_index) +1;
        end
        match = 0;

    end

end

end 

