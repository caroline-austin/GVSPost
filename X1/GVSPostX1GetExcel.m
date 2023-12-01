% Script 1
close all; 
clear all; 
clc; 

%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory % select data folder
plots_path = [file_path '\Plots']; % specify where plots are saved
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

subnum = 1011:1022;  % Subject List 
numsub = length(subnum);
subskip = [1011 1012 1013 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end

    cd(file_path)    

    Label.TrialInfo = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','P1:T1');
    Label.SideEffects = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','U1:W1');
    Label.MotionSense = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','X1:AB1');
    Label.Observed = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','AC1:AF1');

    TrialInfo1 = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','P2:T13');
    SideEffects1 = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','U2:W13');
    MotionSense1 = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','X2:AB13');
    Observed1 = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','AC2:AF13');

    TrialInfo1(cellfun(@(x) any(ismissing(x)), TrialInfo1)) = {''};
    SideEffects1(cellfun(@(x) any(ismissing(x)), SideEffects1)) = {''};
    MotionSense1(cellfun(@(x) any(ismissing(x)), MotionSense1)) = {''};
    Observed1(cellfun(@(x) any(ismissing(x)), Observed1)) = {''};

    EndImpedance = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','AJ4:AJ4');
    TTSImpedance = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','AJ3:AJ3');
    StartImpedance = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','AJ2:AJ2');

    EndImpedance(cellfun(@(x) any(ismissing(x)), EndImpedance)) = {''};
    TTSImpedance(cellfun(@(x) any(ismissing(x)), TTSImpedance)) = {''};
    StartImpedance(cellfun(@(x) any(ismissing(x)), StartImpedance)) = {''};
    cd(code_path);

    if ismac || isunix
        cd([file_path, '/' , subject_str]);
    elseif ispc
        cd([file_path, '\' , subject_str]);
    end

    vars_2_save = ['Label TrialInfo1 SideEffects1 MotionSense1 Observed1 ' ...
        ' EndImpedance  TTSImpedance StartImpedance ']; %MaxCurrent MinCurrent TrialInfo2 SideEffects2 MotionSense2 Observed2
    eval(['  save ' ['A', subject_str,'.mat '] vars_2_save ' vars_2_save']);      
    cd(code_path)
    eval (['clear ' vars_2_save])
end


