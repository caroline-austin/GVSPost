close all; 
clear all; 
clc; 
% code section 1 for TTS dynamic tilt + GVS stuff

Color_ListA = ["black"; "green";"green";"green"; "cyan";"cyan";"cyan"; ... 
    "blue";"blue";"blue";"red"; "red";"red";"red";"red";"red";"green";... 
    "green";"green"; "cyan";"cyan";"cyan";"blue";"blue";"blue"];
Color_ListB = ["black"; "green";"green";"green"; "cyan";"cyan";"cyan"; ... 
    "blue";"blue";"blue";"red"; "red";"red";"green";... 
    "green";"green"; "cyan";"cyan";"cyan";"blue";"blue";"blue"];
%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots\Check']; % specify where plots are saved
gvs_path = [file_path '\GVSProfiles'];
tts_path = [file_path '\TTSProfiles'];
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

subnum = 1002:1002;  % Subject List 
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

    cd(subject_path);
    load(['PS', subject_str, 'Group.mat ']);
    cd(code_path);
    
    figure;
    subplot(3,3,1);
    [row,col]=size(GVS_4A);
    for i = 2:col
        index = floor((i-1)/3+1);
        
        plot(GVS_4A(:,1), 'color', Color_ListA(1));
        plot(GVS_4A(:,i), 'color', Color_ListA(i));
        hold on;
        subplot(3,3,index);
    end
   figure;
    subplot(3,3,1);
        [row,col]=size(GVS_5A);
    for i = 2:col
        index = floor((i-1)/3+1);
        
        plot(GVS_5A(:,1), 'color', Color_ListA(1));
        plot(GVS_5A(:,i), 'color', Color_ListA(i));
        hold on;
        subplot(3,3,index);
    end
   figure;
    subplot(3,3,1);
            [row,col]=size(GVS_6A);
    for i = 2:col
        index = floor((i-1)/3+1);
        
        plot(GVS_6A(:,1), 'color', Color_ListA(1));
        plot(GVS_6A(:,i), 'color', Color_ListA(i));
        hold on;
        subplot(3,3,index);
    end

        figure;
    subplot(3,3,1);
    [row,col]=size(GVS_4B);
    for i = 2:col
        index = floor((i-1)/3+1);
        
        plot(GVS_4B(:,1), 'color', Color_ListB(1));
        plot(GVS_4B(:,i), 'color', Color_ListB(i));
        hold on;
        subplot(3,3,index);
    end
   figure;
    subplot(3,3,1);
        [row,col]=size(GVS_5B);
    for i = 2:col
        index = floor((i-1)/3+1);
        
        plot(GVS_5B(:,1), 'color', Color_ListB(1));
        plot(GVS_5B(:,i), 'color', Color_ListB(i));
        hold on;
        subplot(3,3,index);
    end
   figure;
    subplot(3,3,1);
            [row,col]=size(GVS_6B);
    for i = 2:col
        index = floor((i-1)/3+1);
        
        plot(GVS_6B(:,1), 'color', Color_ListB(1));
        plot(GVS_6B(:,i), 'color', Color_ListB(i));
        hold on;
        subplot(3,3,index);
    end

end
