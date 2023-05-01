close all; 
clear all; 
clc; 
% code section 4a for TTS dynamic tilt + GVS stuff
% (you don't need to run 3 for this one to work)

%% initialize 
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
yellow = [255 190 50]/255;
black =  [0 0 0];
Color_list = [blue; green; yellow; red; black; navy; purple; ];

Color_List = [ "black";"green";"cyan"; "blue";"red";"green"; "cyan";"blue"];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];

Color_listA = ['g'; 'c'; 'b'; 'r'; 'r'; 'g'; 'c'; 'b' ];
Color_listB = ['g'; 'c'; 'b'; 'r'; 'r';  'g'; 'c'; 'b'];
datatype = '';
%% set up pathing
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots\Measures']; % specify where plots are saved
gvs_path = [file_path '\GVSProfiles'];
tts_path = [file_path '\TTSProfiles'];
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

subnum = 1011:1011;  % Subject List 
numsub = length(subnum);
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

tot_num = 0;
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    tot_num = tot_num+1;   

%     subject_path = [file_path, '\PS' , subject_str];
    subject_path = [file_path, '\' , subject_str];

    cd(subject_path);
    load(['PS', subject_str, 'Group', datatype '.mat ']);
    cd(code_path);
   

%% RMS calculation and plots
    %calculate and plot rms normalized by the 0mA response
    % rms4A = rms(shot_4A(:,end-3)-shot_4A);
    % rms4B = rms(shot_4B(:,end-3)-shot_4B);
    % rms5A = rms(shot_5A(:,end-3)-shot_5A);
    % rms5B = rms(shot_5B(:,end-3)-shot_5B);
    % rms6A = rms(shot_6A(:,end-3)-shot_6A);
    % rms6B = rms(shot_6B(:,end-3)-shot_6B);
    
    rms4A = rms(shot_4A);
    rms4B = rms(shot_4B);
    rms5A = rms(shot_5A);
    rms5B = rms(shot_5B);
    rms6A = rms(shot_6A);
    rms6B = rms(shot_6B);
    
    rmsA = [ rms4A; rms5A; rms6A ];
    rmsB = [ rms4B; rms5B; rms6B ];
    
    %%
    figure;
    subplot(2,1,1)
    A=bar([1, 2, 3 ], rmsA');
    title ("A Profiles");
    xticklabels(["SumOfSin4", "SumOfSin5", "SumOfSin6"]);
    legend (["-4mA Vel", "-4 Ang & Vel", "-4 Ang", "0mA",  "0mA","+4mA Vel", "+4 Ang & Vel", "+4 Ang"], 'Location','north');
    for j = 1:length(rmsA)
        A(j).FaceColor = Color_listA(j,:);
    end
    
    hold on; 
    
    subplot(2,1,2)
    B=bar([1, 2, 3], rmsB'); 
    xticklabels(["SumOfSin4", "SumOfSin5", "SumOfSin6"]);
    title ("B Profiles");
    legend (["-4mA Vel", "-4 Ang & Vel", "-4 Ang", "0mA",  "+4mA Vel", "+4 Ang & Vel", "+4 Ang"],'Location','north');
    for j = 1:length(rmsB)
        B(j).FaceColor = Color_listB(j,:);
    end
    sgtitle(['RMS: Subject ' datatype subject_str]);

    cd(plots_path);
    saveas(gcf, [ 'RMS' datatype subject_str  ]); 
    cd(code_path);
    hold off;  
    
    %% variance calculations and plots
    %calculate and plot variance normalized by the 0mA response
    % var4A = var(shot_4A(:,end-3)-shot_4A);
    % var4B = var(shot_4B(:,end-3)-shot_4B);
    % var5A = var(shot_5A(:,end-3)-shot_5A);
    % var5B = var(shot_5B(:,end-3)-shot_5B);
    % var6A = var(shot_6A(:,end-3)-shot_6A);
    % var6B = var(shot_6B(:,end-3)-shot_6B);
    
    var4A = var(shot_4A);
    var4B = var(shot_4B);
    var5A = var(shot_5A);
    var5B = var(shot_5B);
    var6A = var(shot_6A);
    var6B = var(shot_6B);
    
    varA = [ var4A; var5A; var6A ];
    varB = [ var4B; var5B; var6B ];
    
    %%
    figure;
    subplot(2,1,1)
    A=bar([1, 2, 3], varA'); 
    title ("A Profiles");
    xticklabels(["SumOfSin4", "SumOfSin5", "SumOfSin6"]);
    legend ([ "-4mA Vel", "-4 Ang & Vel", "-4 Ang", "0mA",  "0mA","+4mA Vel", "+4 Ang & Vel", "+4 Ang"], 'Location','north');
    for j = 1:length(varA)
        A(j).FaceColor = Color_listA(j,:);
    end
    
    hold on; 
    
    subplot(2,1,2)
    B=bar([1, 2, 3], varB');%(:,2:end)
    xticklabels(["SumOfSin4", "SumOfSin5", "SumOfSin6"]);
    title ("B Profiles");
    legend ([ "-4mA Vel", "-4 Ang & Vel", "-4 Ang", "0mA",  "+4mA Vel", "+4 Ang & Vel", "+4 Ang"],'Location','north');
    for j = 1:length(varB)
        B(j).FaceColor = Color_listB(j,:);
    end
    sgtitle(['Variance: Subject ' datatype subject_str]);

    cd(plots_path);
    saveas(gcf, [ 'Variance' datatype subject_str  ]); 
    cd(code_path);
    hold off;  
end