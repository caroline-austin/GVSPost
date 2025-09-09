%% GVSPost X2A Script 1 : Get the data
% Caroline Austin 
% Created ?/?/2023? Last Modified:10/9/24
% this script handles the verbal reports data from X2A - this includes 
% verbal rating of none slight/noticeable moderate severe for motion
% sensations and side effects as well as qualitative descriptions of
% motion. This script pulls the reports as well as trial info (montage,
% current amplitude, waveform freq. etc) and other exp info like impedance
% from the excel file and then stores the info into a .mat file
%% house keeping
close all; 
clear all; 
clc; 

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory % select data folder
plots_path = [file_path '\Plots']; % specify where plots are saved
cd ..
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder
cd(code_path)

subnum = 2001:2010;  % Subject List 
numsub = length(subnum);
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end

    if ismac || isunix
        cd([file_path, '/' , subject_str]);
    elseif ispc
        cd([file_path, '\' , subject_str]);
    end

    % get label information
    Label.TrialInfo = readcell(['A' subject_str '.xlsx'],'Range','A1:G1');
    Label.SideEffects = readcell(['A' subject_str '.xlsx'],'Range','H1:J1');
    Label.MotionSense = readcell(['A' subject_str '.xlsx'],'Range','K1:O1');
    Label.Observed = readcell(['A' subject_str '.xlsx'],'Range','P1:T1');
    Label.Impedance = readcell(['A' subject_str '.xlsx'],'Range','V1:V12');
    Label.Current = readcell(['A' subject_str '.xlsx'],'Range','Y3:Y5');

    % get data from part 1
    TrialInfo1 = readcell(['A' subject_str '.xlsx'],'Range','A3:G32');
    SideEffects1 = readcell(['A' subject_str '.xlsx'],'Range','H3:J32');
    MotionSense1 = readcell(['A' subject_str '.xlsx'],'Range','K3:O32');
    Observed1 = readcell(['A' subject_str '.xlsx'],'Range','P3:T32');

    TrialInfo1(cellfun(@(x) any(ismissing(x)), TrialInfo1)) = {''};
    SideEffects1(cellfun(@(x) any(ismissing(x)), SideEffects1)) = {''};
    MotionSense1(cellfun(@(x) any(ismissing(x)), MotionSense1)) = {''};
    Observed1(cellfun(@(x) any(ismissing(x)), Observed1)) = {''};

    % get data from part 2
    % the 76 may need to be reduced to 73 (because the first subject had 3
    % extra trials
    if subnum(sub) == 2001
        TrialInfo2 = readcell(['A' subject_str '.xlsx'],'Range','A44:G76');
        SideEffects2 = readcell(['A' subject_str '.xlsx'],'Range','H44:J76');
        MotionSense2 = readcell(['A' subject_str '.xlsx'],'Range','K44:O76');
        Observed2 = readcell(['A' subject_str '.xlsx'],'Range','P44:T76');
    else
        TrialInfo2 = readcell(['A' subject_str '.xlsx'],'Range','A44:G73');
        SideEffects2 = readcell(['A' subject_str '.xlsx'],'Range','H44:J73');
        MotionSense2 = readcell(['A' subject_str '.xlsx'],'Range','K44:O73');
        Observed2 = readcell(['A' subject_str '.xlsx'],'Range','P44:T73');
    end

    TrialInfo2(cellfun(@(x) any(ismissing(x)), TrialInfo2)) = {''};
    SideEffects2(cellfun(@(x) any(ismissing(x)), SideEffects2)) = {''};
    MotionSense2(cellfun(@(x) any(ismissing(x)), MotionSense2)) = {''};
    Observed2(cellfun(@(x) any(ismissing(x)), Observed2)) = {''};


    % swap aoyama DC+ and DC- report labels because the current profiles
    % used were backwards from the cevette labeling (note that the front
    % and back labels were applied based on the anticipated sway direction
    % from the Fitzpatrick and Day theory, but the experiment proved that
    % in reality sway response is in the opposite direction - so the
    % "front" label here is intended to be positive, but actually leads to
    % backwards sway
    for trial = 1:length(TrialInfo2)
        if contains(TrialInfo2{trial,4},'Aoyama') && contains(TrialInfo2{trial,6},'DC')
            if contains(TrialInfo2{trial,7},'front')
                TrialInfo2{trial,7} = 'back';
            elseif contains(TrialInfo2{trial,7},'back')
                TrialInfo2{trial,7} = 'front';
            end
        end
    end

    % get other subject information
    EndImpedance = readcell(['A' subject_str '.xlsx'],'Range','X3:X12');
    StartImpedance = readcell(['A' subject_str '.xlsx'],'Range','W3:W12');
    MaxCurrent = readcell(['A' subject_str '.xlsx'],'Range','Z3:Z5');
    MinCurrent = readcell(['A' subject_str '.xlsx'],'Range','AB3:AB5');

    EndImpedance(cellfun(@(x) any(ismissing(x)), EndImpedance)) = {''};
    StartImpedance(cellfun(@(x) any(ismissing(x)), StartImpedance)) = {''};
    MaxCurrent(cellfun(@(x) any(ismissing(x)),  MaxCurrent)) = {''};
    MinCurrent(cellfun(@(x) any(ismissing(x)), MinCurrent)) = {''};
    cd(code_path);

    % rearranging the order of min/max vues because
    %In the excel spreadsheet the min/max is order Bi, Ay, Cv but
    %everywhere else in this code it's Bi, Cv, Ay so this makes things more
    %streamlined later on
    MinCurrent = [MinCurrent(1), MinCurrent(3), MinCurrent(2)]';
    MaxCurrent = [MaxCurrent(1), MaxCurrent(3), MaxCurrent(2)]';

% insert code that will count the number of each type of response


    if ismac || isunix
        cd([file_path, '/' , subject_str]);
    elseif ispc
        cd([file_path, '\' , subject_str]);
    end

    % save data in .mat files
    vars_2_save = 'Label TrialInfo1 SideEffects1 MotionSense1 Observed1 TrialInfo2 SideEffects2 MotionSense2 Observed2 EndImpedance StartImpedance MaxCurrent MinCurrent';
    eval(['  save ' ['A', subject_str,'.mat '] vars_2_save ' vars_2_save']);      
    cd(code_path)
    eval (['clear ' vars_2_save])
end


