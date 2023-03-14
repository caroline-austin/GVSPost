close all; 
clear all; 
clc; 

%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

subnum = 2001:2010;  % Subject List 
numsub = length(subnum);
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

used_sub = 0;
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    used_sub = used_sub +1;
    subject_label(used_sub)= subject;

    cd([file_path, '/' , subject_str]);
    load(['A' subject_str '.mat'])
    cd(code_path);
%
Label.CurrentAmp = [0.1 , 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0];
MaxCurrent = cell2mat(MaxCurrent);
MinCurrent = cell2mat(MinCurrent);

        % insert code here
 %% Rating Scale Data Extraction
 rating_scale = ["none"; "noticeable"; "moderate"; "severe"];
 Tingle_map1 = TextMatchMap(SideEffects1,TrialInfo1,rating_scale, 1);
 Metallic_map1 = TextMatchMap(SideEffects1,TrialInfo1,rating_scale, 2);
 VisFlash_map1 = TextMatchMap(SideEffects1,TrialInfo1,rating_scale, 3);
 MotionRating_map1 = TextMatchMap(MotionSense1,TrialInfo1,rating_scale, 1);
 ObservedRating_map1 = TextMatchMap(Observed1,TrialInfo1,rating_scale, 1);

 Tingle_map2 = TextMatchMap(SideEffects2,TrialInfo2,rating_scale, 1);
 Metallic_map2 = TextMatchMap(SideEffects2,TrialInfo2,rating_scale, 2);
 VisFlash_map2 = TextMatchMap(SideEffects2,TrialInfo2,rating_scale, 3);
 MotionRating_map2 = TextMatchMap(MotionSense2,TrialInfo2,rating_scale, 1);
 ObservedRating_map2 = TextMatchMap(Observed2,TrialInfo2,rating_scale, 1);
 Label.Rating_map = ["Current"; "Rating"; "Config"];

Tingle_map=Tingle_map1+Tingle_map2;
Metallic_map=Metallic_map1+Metallic_map2;
VisFlash_map=VisFlash_map1+VisFlash_map2;
MotionRating_map=MotionRating_map1+MotionRating_map2;
ObservedRating_map=ObservedRating_map1+ObservedRating_map2;

Tingle_mapReduced = ReduceMapMultiple(Tingle_map,MinCurrent,MaxCurrent,Label);
Metallic_mapReduced = ReduceMapMultiple(Metallic_map,MinCurrent,MaxCurrent,Label);
VisFlash_mapReduced = ReduceMapMultiple(VisFlash_map,MinCurrent,MaxCurrent,Label);
MotionRating_mapReduced = ReduceMapMultiple(MotionRating_map,MinCurrent,MaxCurrent,Label);
ObservedRating_mapReduced = ReduceMapMultiple(ObservedRating_map,MinCurrent,MaxCurrent,Label);


    %% Motion Desciptions Data Extraction
     Motion_map1 = TextMatchMap(MotionSense1,TrialInfo1,["roll"; "pitch"; "yaw"], 3);
     Motion_map2 = TextMatchMap(MotionSense2,TrialInfo2,["roll"; "pitch"; "yaw"], 3);
     Motion_map = Motion_map1+Motion_map2;
     Label.Motion_map = ["Current"; "Direction"; "Config";"Profile"];
     Motion_mapReduced = ReduceMapMultiple(Motion_map,MinCurrent,MaxCurrent,Label);

     Timing_map1 = TextMatchMap(MotionSense1,TrialInfo1,["rhyt"; "cont"; "inter"], 4);
     Timing_map2 = TextMatchMap(MotionSense2,TrialInfo2,["rhyt"; "cont"; "inter"], 4);
     Timing_map = Timing_map1+Timing_map2;
     Label.Timing_map = ["Current"; "Timing"; "Config";"Profile"];
     Timing_mapReduced = ReduceMapMultiple(Motion_map,MinCurrent,MaxCurrent,Label);

     Type_map1 = TextMatchMap(MotionSense1,TrialInfo1,["tilt"; "trans"; "general"], 2);
     Type_map2 = TextMatchMap(MotionSense2,TrialInfo2,["tilt"; "trans"; "general"], 2);
     Type_map = Type_map1+Type_map2;
     Label.Type_map = ["Current"; "Type"; "Config";"Profile"];
     Type_mapReduced = ReduceMapMultiple(Motion_map,MinCurrent,MaxCurrent,Label);

     test_variable = 2;
%% Save file
    cd([file_path, '/' , subject_str]);
    vars_2_save =  ['Label Motion_map Tingle_map Metallic_map' ... 
        ' VisFlash_map MotionRating_map ObservedRating_map' ... 
        ' Timing_map Type_map Tingle_mapReduced Motion_mapReduced '...
        'Metallic_mapReduced VisFlash_mapReduced MotionRating_mapReduced ' ...
        'ObservedRating_mapReduced Type_mapReduced Timing_mapReduced '...
        ' EndImpedance StartImpedance MaxCurrent MinCurrent ']; % need to create and save label variable for the maps
    eval(['  save ' ['A', subject_str,'Extract.mat '] vars_2_save ' vars_2_save']);      
    cd(code_path)
    eval (['clear ' vars_2_save])

end

function [Output_map] = TextMatchMap(Input,TrialInfo,Text2Chk,Column)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% Text = ["roll"; "pitch" ; "yaw"];
response_types = length(Text2Chk);
% Column = 3;

current_col = 5;
current_index = 0;
config_col = 4; 
config_index = 0;
profile_col = 7;
profile_index = 0;
match = 0;
check = 1;
% 9 current levels, x response types, 3 configurations, 5 profiles
% eventually these numbers should be pulled maybe from Trial info?
Output_map = zeros(9,response_types,3,5);

for j= 1:response_types
    match_loc = find(contains(Input(:,Column), Text2Chk(j)));
    for i =1: length(Input(:,Column))
        match = ~ isempty(find(match_loc == i,1)); 
        if match
            check = check +1;
            Current = TrialInfo(i, current_col);
            Config = TrialInfo(i, config_col);
            Profile = TrialInfo(i, profile_col);

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

        if current_index == 0 || profile_index == 0 || config_index == 0
            continue
        end
    
        if match % the way this is currently coded doesn't account for reducing multiple reports to a single report 
            Output_map(current_index, j,config_index,profile_index) = ... 
                Output_map(current_index,j, config_index,profile_index) +1;
        end
        match = 0;

    end

end

end 

function [Reduced_map] = ReduceMapMultiple(Rating_map,MinCurrent,MaxCurrent,Label)
% dim1 is current, dim2 is variable of interest,dim 3 configureation,is dim 4 is profile

[dim1, dim2, dim3, dim4] = size(Rating_map);
Reduced_map = zeros(3,dim2,dim3,dim4);

for outer = 1: dim4
    for inner = 1:dim3
        [row,col] = find(Rating_map(:,:,inner,outer));

        num_trials = length(row); 
        check_low = 0;
        check_min = 0;
        check_max = 0;
        for k = 1:num_trials
            if Label.CurrentAmp(row(k)) == 0.1 
                Reduced_map(1,:, inner, outer) = Rating_map(row(k),:, inner, outer);
                check_low = 1;
            elseif Label.CurrentAmp(row(k)) == MinCurrent(inner) 
                Reduced_map(2,:, inner, outer) = Rating_map(row(k),:, inner, outer);
                check_min = 1;
            elseif Label.CurrentAmp(row(k)) == MaxCurrent(inner) 
                Reduced_map(3,:, inner, outer) = Rating_map(row(k),:, inner, outer);
                check_max = 1;
            elseif Label.CurrentAmp(row(k)) <= MaxCurrent(inner) && Label.CurrentAmp(row(k)) >= MinCurrent(inner) && outer ~= 4 %not 0.5hz profile
                Reduced_map(3,:, inner, outer) = Rating_map(row(k),:, inner, outer);
                check_max = 1;
            end
        end

    end
end

end