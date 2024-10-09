%% GVSPost X2A Script 2 : Organize and Extract Info from the Data
% Caroline Austin 
% Created ?/?/2023? Last Modified:10/9/24
% this script handles the verbal reports data from X2A - this includes 
% verbal rating of none slight/noticeable moderate severe for motion
% sensations and side effects as well as qualitative descriptions of
% motion. This script sorts and tallies up the reports of certain key words
% by the trial conditions they are asscoiated with (map variables) then
% saves them into a .mat file

%% house keeping
%prep the workspace
close all; 
clear all; 
clc; 

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

subnum = 2001:2010;  % Subject List 
numsub = length(subnum); % calculate how many subjects are specified in line above
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

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
Label.CurrentAmp = [0.1 , 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0];
MaxCurrent = cell2mat(MaxCurrent);
MinCurrent = cell2mat(MinCurrent);

%change data type of other variables of interest that are cells
EndImpedance = cell2mat(EndImpedance);
if isempty(EndImpedance)
    EndImpedance = zeros(10,1);
end
StartImpedance = cell2mat(StartImpedance);
        
 %% Rating Scale Data Extraction
 rating_scale = ["none"; "noticeable"; "moderate"; "severe"]; %responses to check for
 %condense data into specific "maps" which record responses based on
 %current level, response, electrode configuration, and profile
 %these variables are specifically the intensity rating
 % suffix 1 is from part 1 of the experiment
 Tingle_map1 = TextMatchMap(SideEffects1,TrialInfo1,rating_scale, 1);
 Metallic_map1 = TextMatchMap(SideEffects1,TrialInfo1,rating_scale, 2);
 VisFlash_map1 = TextMatchMap(SideEffects1,TrialInfo1,rating_scale, 3);
 MotionRating_map1 = TextMatchMap(MotionSense1,TrialInfo1,rating_scale, 1);
 ObservedRating_map1 = TextMatchMap(Observed1,TrialInfo1,rating_scale, 1);

 % suffix 2 is from part 2 of the experiment
 Tingle_map2 = TextMatchMap(SideEffects2,TrialInfo2,rating_scale, 1);
 Metallic_map2 = TextMatchMap(SideEffects2,TrialInfo2,rating_scale, 2);
 VisFlash_map2 = TextMatchMap(SideEffects2,TrialInfo2,rating_scale, 3);
 MotionRating_map2 = TextMatchMap(MotionSense2,TrialInfo2,rating_scale, 1);
 ObservedRating_map2 = TextMatchMap(Observed2,TrialInfo2,rating_scale, 1);
 Label.Rating_map = ["Current"; "Rating"; "Config"];
%combine responses from part 1 and 2 into a single array
Tingle_map=RemoveExtraReports(Tingle_map1+Tingle_map2);
Metallic_map=RemoveExtraReports(Metallic_map1+Metallic_map2);
VisFlash_map=RemoveExtraReports(VisFlash_map1+VisFlash_map2);
MotionRating_map=RemoveExtraReports(MotionRating_map1+MotionRating_map2);
ObservedRating_map=RemoveExtraReports(ObservedRating_map1+ObservedRating_map2);


%take map variables and reduce it so that they only contain the responses
%from the high (max), low (min), and sham (0.1) trials - the actual current values 
% vary between subjects for high and low
Tingle_mapReduced = ReduceMapMultiple(Tingle_map,MinCurrent,MaxCurrent,Label);
Metallic_mapReduced = ReduceMapMultiple(Metallic_map,MinCurrent,MaxCurrent,Label);
VisFlash_mapReduced = ReduceMapMultiple(VisFlash_map,MinCurrent,MaxCurrent,Label);
MotionRating_mapReduced = ReduceMapMultiple(MotionRating_map,MinCurrent,MaxCurrent,Label);
ObservedRating_mapReduced = ReduceMapMultiple(ObservedRating_map,MinCurrent,MaxCurrent,Label);


    %% Motion Desciptions Data Extraction
    % condense data into specific "maps" which record responses based on
    %current level, response, electrode configuration, and profile
    %these variables are more open ended, subjects can have multiple key
    %word repsonses for each trial 
    % suffix 1 denotes part 1 suffix 2 denotes part 2     
     Motion_map1 = TextMatchMap(MotionSense1,TrialInfo1,["roll"; "pitch"; "yaw"], 3);
     Motion_map2 = TextMatchMap(MotionSense2,TrialInfo2,["roll"; "pitch"; "yaw"], 3);
     Motion_map = Motion_map1+Motion_map2; % combined into a single variable
     Label.Motion_map = ["Current"; "Direction"; "Config";"Profile"];%labels are for the 4 dimensions of the array
     %take map variables and reduce it so that they only contain the responses
     %from the high (max), low (min), and sham (0.1) trials - the actual current values 
     % vary between subjects for high and low
     Motion_mapReduced = ReduceMapMultiple(Motion_map,MinCurrent,MaxCurrent,Label);

     Timing_map1 = TextMatchMap(MotionSense1,TrialInfo1,["rhyt"; "cont"; "inter"], 4);
     Timing_map2 = TextMatchMap(MotionSense2,TrialInfo2,["rhyt"; "cont"; "inter"], 4);
     Timing_map = Timing_map1+Timing_map2;
     Label.Timing_map = ["Current"; "Timing"; "Config";"Profile"];
     Timing_mapReduced = ReduceMapMultiple(Timing_map,MinCurrent,MaxCurrent,Label);

     Type_map1 = TextMatchMap(MotionSense1,TrialInfo1,["tilt"; "trans"; "general"], 2);
     Type_map2 = TextMatchMap(MotionSense2,TrialInfo2,["tilt"; "trans"; "general"], 2);
     Type_map = Type_map1+Type_map2;
     Label.Type_map = ["Current"; "Type"; "Config";"Profile"];
     Type_mapReduced = ReduceMapMultiple(Type_map,MinCurrent,MaxCurrent,Label);

%% Save file
    cd([file_path, '/' , subject_str]); %move to directory where file will be saved
    %add all variables that we want to save to a list must include space
    %between variable names 
    vars_2_save =  ['Label Motion_map Tingle_map Metallic_map' ... 
        ' VisFlash_map MotionRating_map ObservedRating_map' ... 
        ' Timing_map Type_map Tingle_mapReduced Motion_mapReduced '...
        'Metallic_mapReduced VisFlash_mapReduced MotionRating_mapReduced ' ...
        'ObservedRating_mapReduced Type_mapReduced Timing_mapReduced '...
        ' EndImpedance StartImpedance MaxCurrent MinCurrent ']; 
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
current_col = 5;
current_index = 0;
config_col = 4; 
config_index = 0;
profile_col = 7;
profile_index = 0;
%initialize checking variables
match = 0;
check = 1;

% pre-allocate map with: 9 current levels, x response types, 
% 3 configurations, 5 profiles
% ideally/eventually these numbers should be pulled maybe from TrialInfo
Output_map = zeros(9,response_types,3,5);

for j= 1:response_types %cycle through for each string you want to check
    %find the location of any responses that match the specified response
    match_loc = find(contains(Input(:,Column), Text2Chk(j)));
    for i =1: length(Input(:,Column)) %cycle through all row in the data column to find all the matches
        match = ~ isempty(find(match_loc == i,1)); %check if this row is a match
        if match
            check = check +1; % for debugging purposes
            %pull trial info (variables) we want to index/store by
            Current = TrialInfo(i, current_col);
            Config = TrialInfo(i, config_col);
            Profile = TrialInfo(i, profile_col);

            %assign storage index value for each of our variables of
            %interest that we want to index by
            switch string(Config)
                case 'Binaural'
                    config_index = 1;
                case 'Cevette'
                    config_index = 2;
                case 'Aoyama'
                    config_index = 3;
                otherwise
                    config_index = 0; 
            end
            
            switch string(Current)
                case '0.1'
                    current_index = 1;
                case '0.5'
                    current_index = 2;
                case '1'
                    current_index = 3;
                case '1.5'
                    current_index = 4;
                case '2'
                    current_index = 5;
                case '2.5'
                    current_index = 6;
                case '3'
                    current_index = 7;
                case '3.5'
                    current_index = 8;
                case '4'
                    current_index = 9;
                otherwise
                    current_index = 0;
            end
    
           switch string(Profile)
               case 'front'
                    profile_index = 1;
                case 'right'
                    profile_index = 1;
               case 'back'
                    profile_index = 2;
               case 'left'
                    profile_index = 2;
                case '0.25'
                    profile_index = 3;
                case '0.5'
                    profile_index = 4;
                case '1'
                    profile_index = 5;
                otherwise
                    profile_index = 0;
            end
        end

        %error checking
        if current_index == 0 || profile_index == 0 || config_index == 0
            continue
        end
    
        %record the matched value in the proper map location
        if match % the way this is currently coded doesn't account for reducing multiple reports to a single report 
            Output_map(current_index, j,config_index,profile_index) = 1;%... 
                %Output_map(current_index,j, config_index,profile_index) +1;
        end
        match = 0;

    end

end

end 

% for debugging both subject 2 and 3 are missing some of their reports;
% subject 3 is missing for the 3 and 4 electrode configuration of profile 1

%need to fix Min and max current are ordered Bi, Ay, Cv instead of Bi, Cv,
%Ay (which is what everything else in the code is ordered) - need to fix
%this

function [Reduced_map] = ReduceMapMultiple(Rating_map,MinCurrent,MaxCurrent,Label)
%this function takes a previously generated map and reduces it so that the
%values recorded are only for the sham(0.1), low (min), and high(max)
%current amplitude conditions. 
% dim1 is current, dim2 is variable of interest,dim 3 electrode configuration,is dim 4 is profile

%get size of the original map and pre-allocate the reduced map
[dim1, dim2, dim3, dim4] = size(Rating_map);
Reduced_map = zeros(3,dim2,dim3,dim4);

for outer = 1: dim4 %cycle through the different profiles
    for inner = 1:dim3 %cycle through the different electrode configurations
        %find locations where a response is recorded 
        [row,col] = find(Rating_map(:,:,inner,outer));

        num_trials = length(row); %number of responses
        %initialize checking variables
        check_low = 0;
        check_min = 0;
        check_max = 0;
        for k = 1:num_trials %cycle through all identified responses
            if Label.CurrentAmp(row(k)) == 0.1 %for sham condition
                Reduced_map(1,:, inner, outer) = Rating_map(row(k),:, inner, outer);
                check_low = 1;
            elseif Label.CurrentAmp(row(k)) == MinCurrent(inner) %for low current condition
                Reduced_map(2,:, inner, outer) = Rating_map(row(k),:, inner, outer);
                check_min = 1;
            elseif Label.CurrentAmp(row(k)) == MaxCurrent(inner) %for high current conditions 
                Reduced_map(3,:, inner, outer) = Rating_map(row(k),:, inner, outer);
                check_max = 1;
                %below is meant to handle a couple of trials where the
                %current provided in a part 2 trial was less than the
                %predetermined max while still meant to represent the max
                %report
            elseif Label.CurrentAmp(row(k)) <= MaxCurrent(inner) && Label.CurrentAmp(row(k)) >= MinCurrent(inner) && outer ~= 4 %not 0.5hz profile
                Reduced_map(3,:, inner, outer) = Rating_map(row(k),:, inner, outer);
                check_max = 1;
            end
        end

    end
end

end

function Rating_map = RemoveExtraReports(Rating_map)
%overwrite lower value of multiple reports
 [dim1, dim2,dim3, dim4] = size(Rating_map);
 for current = 1: dim1
     for config = 1:dim3
         for profile = 1:dim4
            if sum(Rating_map(current,:,config,profile))>1
                report_loc = find(Rating_map(current,:,config,profile));
                %right now only have cases of 1 extra different report, but
                %if multiple could make a loop              
                Rating_map(current,report_loc(1),config,profile) = 0;
            end

         end
     end
 end
end