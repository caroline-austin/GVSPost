%% Script 6 for Dynamic GVS +Tilt
% this script averages together the data from all specified subjects, if a
% trial does not exist for a subject it is not averaged in. 
% the script can take input from scripts 2 and 4 and output should be used
% for scripts 7
%
%Be sure to change the datatype to match which adjustments should be made
%to the data, as well as the subnum array!

% note that I think the negative angle coupling is actually the amplifying
% and the positive angle coupling is actually the attenuating

%close all; 
clear; 
clc; 

%% set up
subnum = [  2049, 2051 ,2053:2057, 2061:2062 2078:2090];  % Subject List 2049, 2051 ,2053:2057, 2061:2062 2078:2090
numsub = length(subnum);
subskip = [2058 2059 2060 2069:2077 2083 2085 2070 2072 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part
match_list = [ "N_4_00mA_8_00"; "N_5_00mA_0_00"; "0_00mA"; "0_00mA"; "P_4_00mA_8_00"; "P_5_00mA_0_00"];
datatype = 'BiasTimeGain';      % options are '', 'Bias', 'BiasTime', 'BiasTimeGain'

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
if ismac || isunix
    plots_path = [file_path '/Plots']; % specify where plots are saved
    gvs_path = [file_path '/GVSProfiles'];
elseif ispc
    plots_path = [file_path '\Plots']; % specify where plots are saved
    gvs_path = [file_path '\GVSProfiles'];
end


cd(code_path);
cd ..
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

%initalize all shot variables  
if contains(datatype, 'Time')
    timeSeriesLength = 1427;    %1427 is the length of the time-adjusted time series
else
    timeSeriesLength = 1527;    %1527 is the length of the non-adjusted time series 
end

%preallocate
% all data for a given trial averaged together
All_shot_4A = zeros(timeSeriesLength,length(match_list));
All_shot_4B = All_shot_4A;
All_shot_5A = All_shot_4A;
All_shot_5B = All_shot_4A;
All_shot_6A = All_shot_4A;
All_shot_6B = All_shot_4A;
% number of trials averaged into All_shot
num_trials_4A = zeros(1, length(match_list));
num_trials_4B = num_trials_4A;
num_trials_5A = num_trials_4A;
num_trials_5B = num_trials_4A;
num_trials_6A = num_trials_4A;
num_trials_6B = num_trials_4A;
% all trials across all subjects saved as individual vectors in the same
% array
shot_save_4A = NaN(timeSeriesLength,numsub,length(match_list));
shot_save_4B = shot_save_4A;
shot_save_5A= shot_save_4A;
shot_save_5B = shot_save_4A;
shot_save_6A = shot_save_4A;
shot_save_6B = shot_save_4A;

%add in the data for each subject while keeping track of how many trials
%are averaged in
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end   

    %load subject file
    if ismac || isunix
        subject_path = [file_path, '/' , subject_str];
        cd(subject_path);
        load(['S', subject_str, 'Extract' datatype '.mat']);
        cd(code_path);
    elseif ispc
        subject_path = [file_path, '\' , subject_str];
        cd(subject_path);
        load(['S', subject_str, 'Extract' datatype '.mat ']);
        cd(code_path);
    end


    % add the current subject's data into the aggregate variable
    %and increment the number of trials averaged into each trial type based on
    %the trial data available for the current subject
    check_4A = 0;
    check_4B = 0;
    check_5A = 0;
    check_5B = 0;
    check_6A = 0;
    check_6B = 0;

    for i = 1:length(Label.shot_4A)
        for j = 1:length(match_list)
            if contains(Label.shot_4A(i), match_list(j))
                if j ==3 
                    check_4A = check_4A+1;
                end
                if j ==3 && check_4A >1 % force 2nd of the GVS conditions to get paired with 2nd in matchlist
                    continue
                end
                %add data in to get averaged
                All_shot_4A(:,j) = All_shot_4A(:,j)+shot_4A(:,i);
                % count the file
                num_trials_4A(j) = num_trials_4A(j)+1;
                shot_save_4A(:,sub,j) = shot_4A(:,i);
                break
            end
        end
    end
    for i = 1:length(Label.shot_4B)
        for j = 1:length(match_list)
            if contains(Label.shot_4B(i), match_list(j))
                if j ==3
                    check_4B = check_4B+1;
                end
                if j ==3 && check_4B >1
                    continue
                end
                All_shot_4B(:,j) = All_shot_4B(:,j)+shot_4B(:,i);
                num_trials_4B(j) = num_trials_4B(j)+1;
                shot_save_4B(:,sub,j) = shot_4B(:,i);
                break
            end
        end
    end
    for i = 1:length(Label.shot_5A)
        for j = 1:length(match_list)
            if contains(Label.shot_5A(i), match_list(j))
                if j ==3
                    check_5A = check_5A+1;
                end
                if j ==3 && check_5A >1
                    continue
                end
                All_shot_5A(:,j) = All_shot_5A(:,j)+shot_5A(:,i);
                num_trials_5A(j) = num_trials_5A(j)+1;  
                shot_save_5A(:,sub,j) = shot_5A(:,i);
                break
            end
        end
    end
    for i = 1:length(Label.shot_5B)
        for j = 1:length(match_list)
            if contains(Label.shot_5B(i), match_list(j))
                if j ==3
                    check_5B = check_5B+1;
                end
                if j ==3 && check_5B >1
                    continue
                end
                All_shot_5B(:,j) = All_shot_5B(:,j)+shot_5B(:,i);
                num_trials_5B(j) = num_trials_5B(j)+1;
                
                shot_save_5B(:,sub,j) = shot_5B(:,i);
                break
            end
        end
    end
    for i = 1:length(Label.shot_6A)
        for j = 1:length(match_list)
            if contains(Label.shot_6A(i), match_list(j))
                if j ==3
                    check_6A = check_6A+1;
                end
                if j ==3 && check_6A >1
                    continue
                end
                All_shot_6A(:,j) = All_shot_6A(:,j)+shot_6A(:,i);
                num_trials_6A(j) = num_trials_6A(j)+1;
                shot_save_6A(:,sub,j) = shot_6A(:,i);
                break
            end
        end
    end
    for i = 1:length(Label.shot_6B)
        for j = 1:length(match_list)
            if contains(Label.shot_6B(i), match_list(j))
                if j ==3
                    check_6B = check_6B+1;
                end
                if j ==3 && check_6B >1
                    continue
                end
                All_shot_6B(:,j) = All_shot_6B(:,j)+shot_6B(:,i);
                num_trials_6B(j) = num_trials_6B(j)+1;
                shot_save_6B(:,sub,j) = shot_6B(:,i);
                break
            end
        end
    end

    shot_diff_4A(:,sub,:) = shot_save_4A(:,sub,:)- ((shot_save_4A(:,sub,3)+ fillmissing(shot_save_4A(:,sub,4), 'constant', 0))/2);
    shot_diff_4B(:,sub,:) = shot_save_4B(:,sub,:)- ((shot_save_4B(:,sub,3)+ fillmissing(shot_save_4B(:,sub,4), 'constant', 0))/2);
    shot_diff_5A(:,sub,:) = shot_save_5A(:,sub,:)- ((shot_save_5A(:,sub,3)+ fillmissing(shot_save_5A(:,sub,4), 'constant', 0))/2);
    shot_diff_5B(:,sub,:) = shot_save_5B(:,sub,:)- ((shot_save_5B(:,sub,3)+ fillmissing(shot_save_5B(:,sub,4), 'constant', 0))/2);
    shot_diff_6A(:,sub,:) = shot_save_6A(:,sub,:)- ((shot_save_6A(:,sub,3)+ fillmissing(shot_save_6A(:,sub,4), 'constant', 0))/2);
    shot_diff_6B(:,sub,:) = shot_save_6B(:,sub,:)- ((shot_save_6B(:,sub,3)+ fillmissing(shot_save_6B(:,sub,4), 'constant', 0))/2);

    
%% GVS variables

    for i = 1:length(Label.GVS_4A) %1:24
        for j = 1:length(match_list)  %1:7
            if contains(Label.GVS_4A(i), match_list(j)) && contains(Label.GVS_4A(i), 'command')
                All_GVS_4A(:,j) = GVS_4A(:,i);
            end
        end
    end
    for i = 1:length(Label.GVS_4B) %1:24
        for j = 1:length(match_list)  %1:7
            if contains(Label.GVS_4B(i), match_list(j)) && contains(Label.GVS_4B(i), 'command')
                All_GVS_4B(:,j) = GVS_4B(:,i);
            end
        end
    end
    for i = 1:length(Label.GVS_5A) %1:24
        for j = 1:length(match_list)  %1:7
            if contains(Label.GVS_5A(i), match_list(j)) && contains(Label.GVS_5A(i), 'command')
                All_GVS_5A(:,j) = GVS_5A(:,i);
            end
        end
    end
    for i = 1:length(Label.GVS_5B) %1:24
        for j = 1:length(match_list)  %1:7
            if contains(Label.GVS_5B(i), match_list(j)) && contains(Label.GVS_5B(i), 'command')
                All_GVS_5B(:,j) = GVS_5B(:,i);
            end
        end
    end
    for i = 1:length(Label.GVS_6A) %1:24
        for j = 1:length(match_list)  %1:7
            if contains(Label.GVS_6A(i), match_list(j)) && contains(Label.GVS_6A(i), 'command')
                All_GVS_6A(:,j) = GVS_6A(:,i);
            end
        end
    end
    for i = 1:length(Label.GVS_6B) %1:24
        for j = 1:length(match_list)  %1:7
            if contains(Label.GVS_6B(i), match_list(j)) && contains(Label.GVS_6B(i), 'command')
                All_GVS_6B(:,j) = GVS_6B(:,i);
            end
        end
    end



end
%% calc diff from baseline series 

%4
All_shot_diff_4A = squeeze(sum(fillmissing(shot_diff_4A, 'constant', 0),2));
All_shot_diff_4B = squeeze(sum(fillmissing(shot_diff_4B, 'constant', 0),2));
All_shot_diff_4 = All_shot_diff_4A- All_shot_diff_4B;
num_trials_4= num_trials_4A + num_trials_4B;

All_shot_diff_4A = All_shot_diff_4A./num_trials_4A;
STD_shot_diff_4A(:,:,:) = squeeze(std(shot_save_4A(:,:,:),[],2, 'omitnan'));
SEM_shot_diff_4A = STD_shot_diff_4A./sqrt(num_trials_4A);

All_shot_diff_4B = All_shot_diff_4B./num_trials_4B;
STD_shot_diff_4B(:,:,:) = squeeze(std(shot_save_4B(:,:,:),[],2, 'omitnan'));
SEM_shot_diff_4B = STD_shot_diff_4B./sqrt(num_trials_4B);

All_shot_diff_4 = All_shot_diff_4./num_trials_4;
STD_shot_diff_4 = sqrt( ...
    ((num_trials_4A-1).*STD_shot_diff_4A.^2 + (num_trials_4B-1).*STD_shot_diff_4B.^2 ...
    + num_trials_4A .* (All_shot_diff_4A - All_shot_diff_4).^2 + num_trials_4B .* (All_shot_diff_4B - All_shot_diff_4).^2 ) ...
    ./(num_trials_4A+num_trials_4B -1));
SEM_shot_diff_4 = STD_shot_diff_4./sqrt(num_trials_4);
%5
All_shot_diff_5A = squeeze(sum(fillmissing(shot_diff_5A, 'constant', 0),2));
All_shot_diff_5B = squeeze(sum(fillmissing(shot_diff_5B, 'constant', 0),2));
All_shot_diff_5 = All_shot_diff_5A- All_shot_diff_5B;
num_trials_5= num_trials_5A + num_trials_5B;

All_shot_diff_5A = All_shot_diff_5A./num_trials_5A;
STD_shot_diff_5A(:,:,:) = squeeze(std(shot_save_5A(:,:,:),[],2, 'omitnan'));
SEM_shot_diff_5A = STD_shot_diff_5A./sqrt(num_trials_5A);

All_shot_diff_5B = All_shot_diff_5B./num_trials_5B;
STD_shot_diff_5B(:,:,:) = squeeze(std(shot_save_5B(:,:,:),[],2, 'omitnan'));
SEM_shot_diff_5B = STD_shot_diff_5B./sqrt(num_trials_5B);

All_shot_diff_5 = All_shot_diff_5./num_trials_5;
STD_shot_diff_5 = sqrt( ...
    ((num_trials_5A-1).*STD_shot_diff_5A.^2 + (num_trials_5B-1).*STD_shot_diff_5B.^2 ...
    + num_trials_5A .* (All_shot_diff_5A - All_shot_diff_5).^2 + num_trials_5B .* (All_shot_diff_5B - All_shot_diff_5).^2 ) ...
    ./(num_trials_5A+num_trials_5B -1));
SEM_shot_diff_5 = STD_shot_diff_5./sqrt(num_trials_5);

%6
All_shot_diff_6A = squeeze(sum(fillmissing(shot_diff_6A, 'constant', 0),2));
All_shot_diff_6B = squeeze(sum(fillmissing(shot_diff_6B, 'constant', 0),2));
All_shot_diff_6 = All_shot_diff_6A- All_shot_diff_6B;
num_trials_6= num_trials_6A + num_trials_6B;

All_shot_diff_6A = All_shot_diff_6A./num_trials_6A;
STD_shot_diff_6A(:,:,:) = squeeze(std(shot_save_6A(:,:,:),[],2, 'omitnan'));
SEM_shot_diff_6A = STD_shot_diff_6A./sqrt(num_trials_6A);

All_shot_diff_6B = All_shot_diff_6B./num_trials_6B;
STD_shot_diff_6B(:,:,:) = squeeze(std(shot_save_6B(:,:,:),[],2, 'omitnan'));
SEM_shot_diff_6B = STD_shot_diff_6B./sqrt(num_trials_6B);

All_shot_diff_6 = All_shot_diff_6./num_trials_6;
STD_shot_diff_6 = sqrt( ...
    ((num_trials_6A-1).*STD_shot_diff_6A.^2 + (num_trials_6B-1).*STD_shot_diff_6B.^2 ...
    + num_trials_6A .* (All_shot_diff_6A - All_shot_diff_6).^2 + num_trials_6B .* (All_shot_diff_6B - All_shot_diff_6).^2 ) ...
    ./(num_trials_6A+num_trials_6B -1));
SEM_shot_diff_6 = STD_shot_diff_6./sqrt(num_trials_6);

%%
% Taking std of all subjects at each point in time:
% std(data to include, any speicial weighting, dimensions to calculate the std over)
STD_shot_save_4A(:,:,[1 2 4 5]) = std(shot_save_4A(:,:,[1 2 5 6]),[],2, 'omitnan');
STD_shot_save_4A(:,:,3) = std(shot_save_4A(:,:,[3 4]),[],[2 3], 'omitnan');
STD_shot_save_4A = reshape(STD_shot_save_4A,timeSeriesLength,5);

STD_shot_save_4B(:,:,[1 2 4 5]) = std(shot_save_4B(:,:,[1 2 5 6]),[],2, 'omitnan');
STD_shot_save_4B(:,:,3) = std(shot_save_4B(:,:,[3 4]),[],[2 3], 'omitnan');
STD_shot_save_4B = reshape(STD_shot_save_4B,timeSeriesLength,5);

STD_shot_save_5A(:,:,[1 2 4 5]) = std(shot_save_5A(:,:,[1 2 5 6]),[],2, 'omitnan');
STD_shot_save_5A(:,:,3) = std(shot_save_5A(:,:,[3 4]),[],[2 3], 'omitnan');
STD_shot_save_5A = reshape(STD_shot_save_5A,timeSeriesLength,5);

STD_shot_save_5B(:,:,[1 2 4 5]) = std(shot_save_5B(:,:,[1 2 5 6]),[],2, 'omitnan');
STD_shot_save_5B(:,:,3) = std(shot_save_5B(:,:,[3 4]),[],[2 3], 'omitnan');
STD_shot_save_5B = reshape(STD_shot_save_5B,timeSeriesLength,5);

STD_shot_save_6A(:,:,[1 2 4 5]) = std(shot_save_6A(:,:,[1 2 5 6]),[],2, 'omitnan');
STD_shot_save_6A(:,:,3) = std(shot_save_6A(:,:,[3 4]),[],[2 3], 'omitnan');
STD_shot_save_6A = reshape(STD_shot_save_6A,timeSeriesLength,5);

STD_shot_save_6B(:,:,[1 2 4 5]) = std(shot_save_6B(:,:,[1 2 5 6]),[],2, 'omitnan');
STD_shot_save_6B(:,:,3) = std(shot_save_6B(:,:,[3 4]),[],[2 3], 'omitnan');
STD_shot_save_6B = reshape(STD_shot_save_6B,timeSeriesLength,5);


%%
% combine the 3 and 4 columns which both have the NoGVS conditions 
All_shot_4A = [All_shot_4A(:,1) All_shot_4A(:,2) All_shot_4A(:,3)+ All_shot_4A(:,4)  All_shot_4A(:,5) All_shot_4A(:,6)];
num_trials_4A= [num_trials_4A(1) num_trials_4A(2) num_trials_4A(3)+num_trials_4A(4) num_trials_4A(5) num_trials_4A(6)];

All_shot_4B = [All_shot_4B(:,1) All_shot_4B(:,2) All_shot_4B(:,3)+ All_shot_4B(:,4)  All_shot_4B(:,5) All_shot_4B(:,6)];
num_trials_4B= [num_trials_4B(1) num_trials_4B(2) num_trials_4B(3)+num_trials_4B(4) num_trials_4B(5) num_trials_4B(6)];

All_shot_4 = All_shot_4A- All_shot_4B;
num_trials_4= num_trials_4A + num_trials_4B;

All_shot_5A = [All_shot_5A(:,1) All_shot_5A(:,2) All_shot_5A(:,3)+ All_shot_5A(:,4)  All_shot_5A(:,5) All_shot_5A(:,6)];
num_trials_5A= [num_trials_5A(1) num_trials_5A(2) num_trials_5A(3)+num_trials_5A(4) num_trials_5A(5) num_trials_5A(6)];

All_shot_5B = [All_shot_5B(:,1) All_shot_5B(:,2) All_shot_5B(:,3)+ All_shot_5B(:,4)  All_shot_5B(:,5) All_shot_5B(:,6)];
num_trials_5B= [num_trials_5B(1) num_trials_5B(2) num_trials_5B(3)+num_trials_5B(4) num_trials_5B(5) num_trials_5B(6)];

All_shot_5 = All_shot_5A- All_shot_5B;
num_trials_5= num_trials_5A + num_trials_5B;

All_shot_6A = [All_shot_6A(:,1) All_shot_6A(:,2) All_shot_6A(:,3)+ All_shot_6A(:,4)  All_shot_6A(:,5) All_shot_6A(:,6)];
num_trials_6A= [num_trials_6A(1) num_trials_6A(2) num_trials_6A(3)+num_trials_6A(4) num_trials_6A(5) num_trials_6A(6)];

All_shot_6B = [All_shot_6B(:,1) All_shot_6B(:,2) All_shot_6B(:,3)+ All_shot_6B(:,4)  All_shot_6B(:,5) All_shot_6B(:,6)];
num_trials_6B= [num_trials_6B(1) num_trials_6B(2) num_trials_6B(3)+num_trials_6B(4) num_trials_6B(5) num_trials_6B(6)];

All_shot_6 = All_shot_6A- All_shot_6B;
num_trials_6= num_trials_6A + num_trials_6B;


%divide the aggregate report by the number of trials added into it to get
%the average report across subjects 
All_shot_4A = All_shot_4A./num_trials_4A;
All_shot_4B = All_shot_4B./num_trials_4B;
All_shot_5A = All_shot_5A./num_trials_5A;
All_shot_5B = All_shot_5B./num_trials_5B;
All_shot_6A = All_shot_6A./num_trials_6A;
All_shot_6B = All_shot_6B./num_trials_6B;

All_shot_4 = All_shot_4./num_trials_4;
All_shot_5 = All_shot_5./num_trials_5;
All_shot_6 = All_shot_6./num_trials_6;

%%
% caclulate SEM for each motion profile coupling scheme combo
SEM_shot_save_4A = STD_shot_save_4A./sqrt(num_trials_4A);
SEM_shot_save_4B = STD_shot_save_4B./sqrt(num_trials_4B);
SEM_shot_save_5A = STD_shot_save_5A./sqrt(num_trials_5A);
SEM_shot_save_5B = STD_shot_save_5B./sqrt(num_trials_5B);
SEM_shot_save_6A = STD_shot_save_6A./sqrt(num_trials_6A);
SEM_shot_save_6B = STD_shot_save_6B./sqrt(num_trials_6B);

% calculate std and SEM for the 4,5,6
STD_shot_save_4 = sqrt( ...
    ((num_trials_4A-1).*STD_shot_save_4A.^2 + (num_trials_4B-1).*STD_shot_save_4B.^2 ...
    + num_trials_4A .* (All_shot_4A - All_shot_4).^2 + num_trials_4B .* (All_shot_4B - All_shot_4).^2 ) ...
    ./(num_trials_4A+num_trials_4B -1));

STD_shot_save_5 = sqrt( ...
    ((num_trials_5A-1).*STD_shot_save_5A.^2 + (num_trials_5B-1).*STD_shot_save_5B.^2 ...
    + num_trials_5A .* (All_shot_5A - All_shot_5).^2 + num_trials_5B .* (All_shot_5B - All_shot_5).^2 ) ...
    ./(num_trials_5A+num_trials_5B -1));

STD_shot_save_6 = sqrt( ...
    ((num_trials_6A-1).*STD_shot_save_6A.^2 + (num_trials_6B-1).*STD_shot_save_6B.^2 ...
    + num_trials_6A .* (All_shot_6A - All_shot_6).^2 + num_trials_6B .* (All_shot_6B - All_shot_6).^2 ) ...
    ./(num_trials_6A+num_trials_6B -1));

SEM_shot_save_4 = STD_shot_save_4./sqrt(num_trials_4);
SEM_shot_save_5 = STD_shot_save_5./sqrt(num_trials_5);
SEM_shot_save_6 = STD_shot_save_6./sqrt(num_trials_6);

match_list = [ "N_4_00mA_8_00"; "N_5_00mA_0_00"; "0_00mA"; "P_4_00mA_8_00"; "P_5_00mA_0_00"];
%update the label
Label.shot_4A = match_list;
Label.shot_4B = match_list;
Label.shot_5A = match_list;
Label.shot_5B = match_list;
Label.shot_6A = match_list;
Label.shot_6B = match_list;

%% save files
   cd(file_path);
   vars_2_save = ['Label Trial_Info trial_end time All_shot_4A tilt_4A GVS_4A ' ... 
       'All_shot_5A tilt_5A GVS_5A All_shot_6A tilt_6A GVS_6A ' ...
       'All_shot_4B tilt_4B GVS_4B  All_shot_5B tilt_5B GVS_5B All_shot_6B tilt_6B GVS_6B ' ...
       'All_GVS_4A All_GVS_4B All_GVS_5A All_GVS_5B All_GVS_6A All_GVS_6B ' ...
       'SEM_shot_save_4A SEM_shot_save_4B SEM_shot_save_5A SEM_shot_save_5B ' ...
       'SEM_shot_save_6A SEM_shot_save_6B All_shot_4 All_shot_5 All_shot_6 ' ...
       'SEM_shot_save_4 SEM_shot_save_5 SEM_shot_save_6 ' ...
       'shot_save_4A shot_save_4B shot_save_5A shot_save_5B shot_save_6A ' ...
       'shot_save_6B shot_diff_4A shot_diff_4B shot_diff_5A shot_diff_5B ' ... 
       'shot_diff_6A shot_diff_6B ' ...
       'SEM_shot_diff_4A SEM_shot_diff_4B SEM_shot_diff_5A SEM_shot_diff_5B ' ...
       'SEM_shot_diff_6A SEM_shot_diff_6B SEM_shot_diff_4 SEM_shot_diff_5 SEM_shot_diff_6 ' ... 
       'All_shot_diff_4A All_shot_diff_4B  All_shot_diff_5A  All_shot_diff_5B '...
       'All_shot_diff_6A All_shot_diff_6B All_shot_diff_4 All_shot_diff_5  All_shot_diff_6 '];
   eval(['  save ' ['S' 'All' datatype '.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   %eval (['clear ' vars_2_save])