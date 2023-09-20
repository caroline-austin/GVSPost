clc; close; clear;

subnum = 1011:1021;  % Subject List 
numsub = length(subnum);
subskip = [1006 1007 1008 1009 1010 1013 40006];  %DNF'd subjects or subjects that didn't complete this part
match_list = ["N700"; "N750"; "N800"; "000mA";"P700"; "P750"; "P800"];
%match_list = 
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

[filenames]=file_path_info2(code_path, file_path); % get files from file folder

for sub = 1:11
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
        load(['S', subject_str, 'Group' datatype '.mat']);
        cd(code_path);
    elseif ispc
        subject_path = [file_path, '\' , subject_str];
        cd(subject_path);
        load(['S', subject_str, 'Group' datatype '.mat ']);
        cd(code_path);
    end

for i = 1:(length(tilt_6B) - 1)
    delta_x = time(i+1) - time(i);

    % shot y 4_A
    [delta_y_shot_4A_N7,delta_y_shot_4A_N7_2,delta_y_shot_4A_N75,delta_y_shot_4A_N75_2,delta_y_shot_4A_N8,delta_y_shot_4A_N8_2,delta_y_shot_4A_P0,...
        delta_y_shot_4A_P0_2,delta_y_shot_4A_P0_3,delta_y_shot_4A_P7,delta_y_shot_4A_P7_2,delta_y_shot_4A_P75,delta_y_shot_4A_P75_2,delta_y_shot_4A_P8,delta_y_shot_4A_P8_2] = lengthfinder('shot_4A',i,Label,shot_4A,time);

  
    [DN7_4A(i),DN7_4A_2(i),DN75_4A(i),DN75_4A_2(i),DN8_4A(i),DN8_4A_2(i),DP0_4A(i),DP02_4A(i),DP03_4A(i),DP7_4A(i),DP7_4A_2(i),...
    DP75_4A(i),DP75_4A_2(i),DP8_4A(i),DP8_4A_2(i)] = seg(delta_y_shot_4A_N7,delta_y_shot_4A_N7_2,delta_y_shot_4A_N75,delta_y_shot_4A_N75_2,delta_y_shot_4A_N8,delta_y_shot_4A_N8_2,delta_y_shot_4A_P0,...
        delta_y_shot_4A_P0_2,delta_y_shot_4A_P0_3,delta_y_shot_4A_P7,delta_y_shot_4A_P7_2,delta_y_shot_4A_P75,delta_y_shot_4A_P75_2,delta_y_shot_4A_P8,delta_y_shot_4A_P8_2,delta_x);


    % shot y 4_B
    [delta_y_shot_4B_N7,delta_y_shot_4B_N7_2,delta_y_shot_4B_N75,delta_y_shot_4B_N75_2,delta_y_shot_4B_N8,delta_y_shot_4B_N8_2,delta_y_shot_4B_P0,...
        delta_y_shot_4B_P0_2,delta_y_shot_4B_P0_3,delta_y_shot_4B_P7,delta_y_shot_4B_P7_2,delta_y_shot_4B_P75,delta_y_shot_4B_P75_2,delta_y_shot_4B_P8,delta_y_shot_4B_P8_2] = lengthfinder('shot_4B',i,Label,shot_4B,time);

    [DN7_4B(i),DN7_4B_2(i),DN75_4B(i),DN75_4B_2(i),DN8_4B(i),DN8_4B_2(i),DP0_4B(i),DP02_4B(i),DP03_4B(i),DP7_4B(i),DP7_4B_2(i),...
    DP75_4B(i),DP75_4B_2(i),DP8_4B(i),DP8_4B_2(i)] = seg(delta_y_shot_4B_N7,delta_y_shot_4B_N7_2,delta_y_shot_4B_N75,delta_y_shot_4B_N75_2,delta_y_shot_4B_N8,delta_y_shot_4B_N8_2,delta_y_shot_4B_P0,...
        delta_y_shot_4B_P0_2,delta_y_shot_4B_P0_3,delta_y_shot_4B_P7,delta_y_shot_4B_P7_2,delta_y_shot_4B_P75,delta_y_shot_4B_P75_2,delta_y_shot_4B_P8,delta_y_shot_4B_P8_2,delta_x);


    % shot y 5A
    [delta_y_shot_5A_N7,delta_y_shot_5A_N7_2,delta_y_shot_5A_N75,delta_y_shot_5A_N75_2,delta_y_shot_5A_N8,delta_y_shot_5A_N8_2,delta_y_shot_5A_P0,...
        delta_y_shot_5A_P0_2,delta_y_shot_5A_P0_3,delta_y_shot_5A_P7,delta_y_shot_5A_P7_2,delta_y_shot_5A_P75,delta_y_shot_5A_P75_2,delta_y_shot_5A_P8,delta_y_shot_5A_P8_2] = lengthfinder('shot_5A',i,Label,shot_5A,time);

    [DN7_5A(i),DN7_5A_2(i),DN75_5A(i),DN75_5A_2(i),DN8_5A(i),DN8_5A_2(i),DP0_5A(i),DP02_5A(i),DP03_5A(i),DP7_5A(i),DP7_5A_2(i),...
    DP75_5A(i),DP75_5A_2(i),DP8_5A(i),DP8_5A_2(i)] = seg(delta_y_shot_5A_N7,delta_y_shot_5A_N7_2,delta_y_shot_5A_N75,delta_y_shot_5A_N75_2,delta_y_shot_5A_N8,delta_y_shot_5A_N8_2,delta_y_shot_5A_P0,...
        delta_y_shot_5A_P0_2,delta_y_shot_5A_P0_3,delta_y_shot_5A_P7,delta_y_shot_5A_P7_2,delta_y_shot_5A_P75,delta_y_shot_5A_P75_2,delta_y_shot_5A_P8,delta_y_shot_5A_P8_2,delta_x);

    % shot y 5B
    [delta_y_shot_5B_N7,delta_y_shot_5B_N7_2,delta_y_shot_5B_N75,delta_y_shot_5B_N75_2,delta_y_shot_5B_N8,delta_y_shot_5B_N8_2,delta_y_shot_5B_P0,...
        delta_y_shot_5B_P0_2,delta_y_shot_5B_P0_3,delta_y_shot_5B_P7,delta_y_shot_5B_P7_2,delta_y_shot_5B_P75,delta_y_shot_5B_P75_2,delta_y_shot_5B_P8,delta_y_shot_5B_P8_2] = lengthfinder('shot_5B',i,Label,shot_5B,time);

   [DN7_5B(i),DN7_5B_2(i),DN75_5B(i),DN75_5B_2(i),DN8_5B(i),DN8_5B_2(i),DP0_5B(i),DP02_5B(i),DP03_5B(i),DP7_5B(i),DP7_5B_2(i),...
    DP75_5B(i),DP75_5B_2(i),DP8_5B(i),DP8_5B_2(i)] = seg(delta_y_shot_5B_N7,delta_y_shot_5B_N7_2,delta_y_shot_5B_N75,delta_y_shot_5B_N75_2,delta_y_shot_5B_N8,delta_y_shot_5B_N8_2,delta_y_shot_5B_P0,...
        delta_y_shot_5B_P0_2,delta_y_shot_5B_P0_3,delta_y_shot_5B_P7,delta_y_shot_5B_P7_2,delta_y_shot_5B_P75,delta_y_shot_5B_P75_2,delta_y_shot_5B_P8,delta_y_shot_5B_P8_2,delta_x); 

    % shot y 6A
    [delta_y_shot_6A_N7,delta_y_shot_6A_N7_2,delta_y_shot_6A_N75,delta_y_shot_6A_N75_2,delta_y_shot_6A_N8,delta_y_shot_6A_N8_2,delta_y_shot_6A_P0,...
        delta_y_shot_6A_P0_2,delta_y_shot_6A_P0_3,delta_y_shot_6A_P7,delta_y_shot_6A_P7_2,delta_y_shot_6A_P75,delta_y_shot_6A_P75_2,delta_y_shot_6A_P8,delta_y_shot_6A_P8_2] = lengthfinder('shot_6A',i,Label,shot_6A,time);

    [DN7_6A(i),DN7_6A_2(i),DN75_6A(i),DN75_6A_2(i),DN8_6A(i),DN8_6A_2(i),DP0_6A(i),DP02_6A(i),DP03_6A(i),DP7_6A(i),DP7_6A_2(i),...
    DP75_6A(i),DP75_6A_2(i),DP8_6A(i),DP8_6A_2(i)] = seg(delta_y_shot_6A_N7,delta_y_shot_6A_N7_2,delta_y_shot_6A_N75,delta_y_shot_6A_N75_2,delta_y_shot_6A_N8,delta_y_shot_6A_N8_2,delta_y_shot_6A_P0,...
        delta_y_shot_6A_P0_2,delta_y_shot_6A_P0_3,delta_y_shot_6A_P7,delta_y_shot_6A_P7_2,delta_y_shot_6A_P75,delta_y_shot_6A_P75_2,delta_y_shot_6A_P8,delta_y_shot_6A_P8_2,delta_x);

    % shot y 6B
    [delta_y_shot_6B_N7,delta_y_shot_6B_N7_2,delta_y_shot_6B_N75,delta_y_shot_6B_N75_2,delta_y_shot_6B_N8,delta_y_shot_6B_N8_2,delta_y_shot_6B_P0,...
        delta_y_shot_6B_P0_2,delta_y_shot_6B_P0_3,delta_y_shot_6B_P7,delta_y_shot_6B_P7_2,delta_y_shot_6B_P75,delta_y_shot_6B_P75_2,delta_y_shot_6B_P8,delta_y_shot_6B_P8_2] = lengthfinder('shot_6B',i,Label,shot_6B,time);

    [DN7_6B(i),DN7_6B_2(i),DN75_6B(i),DN75_6B_2(i),DN8_6B(i),DN8_6B_2(i),DP0_6B(i),DP02_6B(i),DP03_6B(i),DP7_6B(i),DP7_6B_2(i),...
    DP75_6B(i),DP75_6B_2(i),DP8_6B(i),DP8_6B_2(i)] = seg(delta_y_shot_6B_N7,delta_y_shot_6B_N7_2,delta_y_shot_6B_N75,delta_y_shot_6B_N75_2,delta_y_shot_6B_N8,delta_y_shot_6B_N8_2,delta_y_shot_6B_P0,...
        delta_y_shot_6B_P0_2,delta_y_shot_6B_P0_3,delta_y_shot_6B_P7,delta_y_shot_6B_P7_2,delta_y_shot_6B_P75,delta_y_shot_6B_P75_2,delta_y_shot_6B_P8,delta_y_shot_6B_P8_2,delta_x);




end

[rec_4A_N7,rec_4A_N7_2,rec_4A_N75,rec_4A_N75_2,rec_4A_N8,rec_4A_N8_2,rec_4A_P0,rec_4A_P02,...
    rec_4A_P03,rec_4A_P7,rec_4A_P7_2,rec_4A_P75,rec_4A_P75_2,rec_4A_P8,rec_4A_P8_2] = sumfunc(DN7_4A,DN7_4A_2,DN75_4A,DN75_4A_2,DN8_4A,DN8_4A_2,DP0_4A,DP02_4A,DP03_4A,DP7_4A,DP7_4A_2,...
    DP75_4A,DP75_4A_2,DP8_4A,DP8_4A_2);

[rec_4B_N7,rec_4B_N7_2,rec_4B_N75,rec_4B_N75_2,rec_4B_N8,rec_4B_N8_2,rec_4B_P0,rec_4B_P02,...
    rec_4B_P03,rec_4B_P7,rec_4B_P7_2,rec_4B_P75,rec_4B_P75_2,rec_4B_P8,rec_4B_P8_2] = sumfunc(DN7_4B,DN7_4B_2,DN75_4B,DN75_4B_2,DN8_4B,DN8_4B_2,DP0_4B,DP02_4B,DP03_4B,DP7_4B,DP7_4B_2,...
    DP75_4B,DP75_4B_2,DP8_4B,DP8_4B_2);

[rec_5A_N7,rec_5A_N7_2,rec_5A_N75,rec_5A_N75_2,rec_5A_N8,rec_5A_N8_2,rec_5A_P0,rec_5A_P02,...
    rec_5A_P03,rec_5A_P7,rec_5A_P7_2,rec_5A_P75,rec_5A_P75_2,rec_5A_P8,rec_5A_P8_2] = sumfunc(DN7_5A,DN7_5A_2,DN75_5A,DN75_5A_2,DN8_5A,DN8_5A_2,DP0_5A,DP02_5A,DP03_5A,DP7_5A,DP7_5A_2,...
    DP75_5A,DP75_5A_2,DP8_5A,DP8_5A_2);

[rec_5B_N7,rec_5B_N7_2,rec_5B_N75,rec_5B_N75_2,rec_5B_N8,rec_5B_N8_2,rec_5B_P0,rec_5B_P02,...
    rec_5B_P03,rec_5B_P7,rec_5B_P7_2,rec_5B_P75,rec_5B_P75_2,rec_5B_P8,rec_5B_P8_2] = sumfunc(DN7_5B,DN7_5B_2,DN75_5B,DN75_5B_2,DN8_5B,DN8_5B_2,DP0_5B,DP02_5B,DP03_5B,DP7_5B,DP7_5B_2,...
    DP75_5B,DP75_5B_2,DP8_5B,DP8_5B_2);

[rec_6A_N7,rec_6A_N7_2,rec_6A_N75,rec_6A_N75_2,rec_6A_N8,rec_6A_N8_2,rec_6A_P0,rec_6A_P02,...
    rec_6A_P03,rec_6A_P7,rec_6A_P7_2,rec_6A_P75,rec_6A_P75_2,rec_6A_P8,rec_6A_P8_2] = sumfunc(DN7_6A,DN7_6A_2,DN75_6A,DN75_6A_2,DN8_6A,DN8_6A_2,DP0_6A,DP02_6A,DP03_6A,DP7_6A,DP7_6A_2,...
    DP75_6A,DP75_6A_2,DP8_6A,DP8_6A_2);

[rec_6B_N7,rec_6B_N7_2,rec_6B_N75,rec_6B_N75_2,rec_6B_N8,rec_6B_N8_2,rec_6B_P0,rec_6B_P02,...
    rec_6B_P03,rec_6B_P7,rec_6B_P7_2,rec_6B_P75,rec_6B_P75_2,rec_6B_P8,rec_6B_P8_2] = sumfunc(DN7_6B,DN7_6B_2,DN75_6B,DN75_6B_2,DN8_6B,DN8_6B_2,DP0_6B,DP02_6B,DP03_6B,DP7_6B,DP7_6B_2,...
    DP75_6B,DP75_6B_2,DP8_6B,DP8_6B_2);

[REC_4A_N7(sub),REC_4A_N75(sub),REC_4A_N8(sub),REC_4A_P0(sub),REC_4A_P7(sub),REC_4A_P75(sub),REC_4A_P8(sub)] = avgrec(rec_4A_N7,rec_4A_N7_2,rec_4A_N75,rec_4A_N75_2,rec_4A_N8,rec_4A_N8_2,rec_4A_P0,rec_4A_P02,...
    rec_4A_P03,rec_4A_P7,rec_4A_P7_2,rec_4A_P75,rec_4A_P75_2,rec_4A_P8,rec_4A_P8_2);

[REC_4B_N7(sub),REC_4B_N75(sub),REC_4B_N8(sub),REC_4B_P0(sub),REC_4B_P7(sub),REC_4B_P75(sub),REC_4B_P8(sub)] = avgrec(rec_4B_N7,rec_4B_N7_2,rec_4B_N75,rec_4B_N75_2,rec_4B_N8,rec_4B_N8_2,rec_4B_P0,rec_4B_P02,...
    rec_4B_P03,rec_4B_P7,rec_4B_P7_2,rec_4B_P75,rec_4B_P75_2,rec_4B_P8,rec_4B_P8_2);

[REC_5A_N7(sub),REC_5A_N75(sub),REC_5A_N8(sub),REC_5A_P0(sub),REC_5A_P7(sub),REC_5A_P75(sub),REC_5A_P8(sub)] = avgrec(rec_5A_N7,rec_5A_N7_2,rec_5A_N75,rec_5A_N75_2,rec_5A_N8,rec_5A_N8_2,rec_5A_P0,rec_5A_P02,...
    rec_5A_P03,rec_5A_P7,rec_5A_P7_2,rec_5A_P75,rec_5A_P75_2,rec_5A_P8,rec_5A_P8_2);

[REC_5B_N7(sub),REC_5B_N75(sub),REC_5B_N8(sub),REC_5B_P0(sub),REC_5B_P7(sub),REC_5B_P75(sub),REC_5B_P8(sub)] = avgrec(rec_5B_N7,rec_5B_N7_2,rec_5B_N75,rec_5B_N75_2,rec_5B_N8,rec_5B_N8_2,rec_5B_P0,rec_5B_P02,...
    rec_5B_P03,rec_5B_P7,rec_5B_P7_2,rec_5B_P75,rec_5B_P75_2,rec_5B_P8,rec_5B_P8_2);

[REC_6A_N7(sub),REC_6A_N75(sub),REC_6A_N8(sub),REC_6A_P0(sub),REC_6A_P7(sub),REC_6A_P75(sub),REC_6A_P8(sub)] = avgrec(rec_6A_N7,rec_6A_N7_2,rec_6A_N75,rec_6A_N75_2,rec_6A_N8,rec_6A_N8_2,rec_6A_P0,rec_6A_P02,...
    rec_6A_P03,rec_6A_P7,rec_6A_P7_2,rec_6A_P75,rec_6A_P75_2,rec_6A_P8,rec_6A_P8_2);

[REC_6B_N7(sub),REC_6B_N75(sub),REC_6B_N8(sub),REC_6B_P0(sub),REC_6B_P7(sub),REC_6B_P75(sub),REC_6B_P8(sub)] = avgrec(rec_6B_N7,rec_6B_N7_2,rec_6B_N75,rec_6B_N75_2,rec_6B_N8,rec_6B_N8_2,rec_6B_P0,rec_6B_P02,...
    rec_6B_P03,rec_6B_P7,rec_6B_P7_2,rec_6B_P75,rec_6B_P75_2,rec_6B_P8,rec_6B_P8_2);

end

REC_TOT_4A = [REC_4A_N7;REC_4A_N75;REC_4A_N8;REC_4A_P0;REC_4A_P7;REC_4A_P75;REC_4A_P8]; 
REC_TOT_4A_avg = mean(REC_TOT_4A,2);

REC_TOT_4B = [REC_4B_N7;REC_4B_N75;REC_4B_N8;REC_4B_P0;REC_4B_P7;REC_4B_P75;REC_4B_P8]; 
REC_TOT_4B_avg = mean(REC_TOT_4B,2);

REC_TOT_5A = [REC_5A_N7;REC_5A_N75;REC_5A_N8;REC_5A_P0;REC_5A_P7;REC_5A_P75;REC_5A_P8]; 
REC_TOT_5A_avg = mean(REC_TOT_5A,2);

REC_TOT_5B = [REC_5B_N7;REC_5B_N75;REC_5B_N8;REC_5B_P0;REC_5B_P7;REC_5B_P75;REC_5B_P8]; 
REC_TOT_5B_avg = mean(REC_TOT_5B,2);

REC_TOT_6A = [REC_6A_N7;REC_6A_N75;REC_6A_N8;REC_6A_P0;REC_6A_P7;REC_6A_P75;REC_6A_P8]; 
REC_TOT_6A_avg = mean(REC_TOT_6A,2);

REC_TOT_6B = [REC_6B_N7;REC_6B_N75;REC_6B_N8;REC_6B_P0;REC_6B_P7;REC_6B_P75;REC_6B_P8]; 
REC_TOT_6B_avg = mean(REC_TOT_6B,2);

%% Plotting
for sub = 1:11
    figure();
    subnum = num2str(sub);
    sgtitle(['Subject ',subnum])
    subplot(6,1,1)
    bar([REC_4A_N7(sub),REC_4A_N75(sub),REC_4A_N8(sub),REC_4A_P0(sub),REC_4A_P7(sub),REC_4A_P75(sub),REC_4A_P8(sub)])
    set(gca,'xticklabel',match_list)
    subplot(6,1,2)
    bar([REC_4B_N7(sub),REC_4B_N75(sub),REC_4B_N8(sub),REC_4B_P0(sub),REC_4B_P7(sub),REC_4B_P75(sub),REC_4B_P8(sub)])
    set(gca,'xticklabel',match_list)
    subplot(6,1,3)
    bar([REC_5A_N7(sub),REC_5A_N75(sub),REC_5A_N8(sub),REC_5A_P0(sub),REC_5A_P7(sub),REC_5A_P75(sub),REC_5A_P8(sub)])
    set(gca,'xticklabel',match_list)
    subplot(6,1,4)
    bar([REC_5B_N7(sub),REC_5B_N75(sub),REC_5B_N8(sub),REC_5B_P0(sub),REC_5B_P7(sub),REC_5B_P75(sub),REC_5B_P8(sub)])
    set(gca,'xticklabel',match_list)
    subplot(6,1,5)
    bar([REC_6A_N7(sub),REC_6A_N75(sub),REC_6A_N8(sub),REC_6A_P0(sub),REC_6A_P7(sub),REC_6A_P75(sub),REC_6A_P8(sub)])
    set(gca,'xticklabel',match_list)
    subplot(6,1,6)
    bar([REC_6B_N7(sub),REC_6B_N75(sub),REC_6B_N8(sub),REC_6B_P0(sub),REC_6B_P7(sub),REC_6B_P75(sub),REC_6B_P8(sub)])
    set(gca,'xticklabel',match_list)
end

figure();
sgtitle('Subject Average')
subplot(6,1,1)
bar(REC_TOT_4A_avg)
set(gca,'xticklabel',match_list)
subplot(6,1,2)
bar(REC_TOT_4B_avg)
set(gca,'xticklabel',match_list)
subplot(6,1,3)
bar(REC_TOT_5A_avg)
set(gca,'xticklabel',match_list)
subplot(6,1,4)
bar(REC_TOT_5B_avg)
set(gca,'xticklabel',match_list)
subplot(6,1,5)
bar(REC_TOT_6A_avg)
set(gca,'xticklabel',match_list)
subplot(6,1,6)
bar(REC_TOT_6B_avg)
set(gca,'xticklabel',match_list)
%% Functions

function [REC_4A_N7,REC_4A_N75,REC_4A_N8,REC_4A_P0,REC_4A_P7,REC_4A_P75,REC_4A_P8] = avgrec(rec_4A_N7,rec_4A_N7_2,rec_4A_N75,rec_4A_N75_2,rec_4A_N8,rec_4A_N8_2,rec_4A_P0,rec_4A_P02,...
    rec_4A_P03,rec_4A_P7,rec_4A_P7_2,rec_4A_P75,rec_4A_P75_2,rec_4A_P8,rec_4A_P8_2)
if (rec_4A_N7_2 == 0) || (rec_4A_N7 == 0)
    REC_4A_N7 = (rec_4A_N7 + rec_4A_N7_2);
else
    REC_4A_N7 = (rec_4A_N7 + rec_4A_N7_2)/2;
end

if (rec_4A_N75_2 == 0) || (rec_4A_N75 == 0)
    REC_4A_N75 = (rec_4A_N75 + rec_4A_N75_2);
else
    REC_4A_N75 = (rec_4A_N75 + rec_4A_N75_2)/2;
end

if (rec_4A_N8_2 == 0) || (rec_4A_N8 == 0)
    REC_4A_N8 = (rec_4A_N8 + rec_4A_N8_2);
else
    REC_4A_N8 = (rec_4A_N8 + rec_4A_N8_2)/2;
end

if (rec_4A_P7_2 == 0) || (rec_4A_P7 == 0)
    REC_4A_P7 = (rec_4A_P7 + rec_4A_P7_2);
else
    REC_4A_P7 = (rec_4A_P7 + rec_4A_P7_2)/2;
end

if (rec_4A_P75_2 == 0) || (rec_4A_P75 == 0)
    REC_4A_P75 = (rec_4A_P75 + rec_4A_P75_2);
else
    REC_4A_P75 = (rec_4A_P75 + rec_4A_P75_2)/2;
end

if (rec_4A_P8_2 == 0) || (rec_4A_P8 == 0)
    REC_4A_P8 = (rec_4A_P8 + rec_4A_P8_2);
else
    REC_4A_P8 = (rec_4A_P8 + rec_4A_P8_2)/2;
end

if (rec_4A_P0 == 0) && (rec_4A_P02 == 0)
    REC_4A_P0 = (rec_4A_P03);
elseif (rec_4A_P02 == 0)&&(rec_4A_P03 == 0)
    REC_4A_P0 = (rec_4A_P0);
elseif (rec_4A_P0==0)&&(rec_4A_P03 == 0)
    REC_4A_P0 = (rec_4A_P02);
elseif (rec_4A_P0 == 0)||(rec_4A_P02 == 0) || (rec_4A_P03 == 0)
    REC_4A_P0 = (rec_4A_P0+rec_4A_P02+rec_4A_P03)/2;
else
    REC_4A_P0 = (rec_4A_P0+rec_4A_P02+rec_4A_P03)/3;
end

end

function [rec_4A_N7,rec_4A_N7_2,rec_4A_N75,rec_4A_N75_2,rec_4A_N8,rec_4A_N8_2,rec_4A_P0,rec_4A_P02,...
    rec_4A_P03,rec_4A_P7,rec_4A_P7_2,rec_4A_P75,rec_4A_P75_2,rec_4A_P8,rec_4A_P8_2] = sumfunc(DN7,DN7_2,DN75,DN75_2,DN8,DN8_2,DP0,DP02,DP03,DP7,DP7_2,...
    DP75,DP75_2,DP8,DP8_2)

rec_4A_N7 = sum(DN7); rec_4A_N75 = sum(DN75); rec_4A_N8 = sum(DN8); rec_4A_P0 = sum(DP0);
rec_4A_P02 = sum(DP02); rec_4A_P7 = sum(DP7); rec_4A_P75 = sum(DP75); rec_4A_P8 = sum(DP8);

rec_4A_N7_2 = sum(DN7_2); rec_4A_N75_2 = sum(DN75_2); rec_4A_N8_2 = sum(DN8_2);
rec_4A_P03 = sum(DP03); rec_4A_P7_2 = sum(DP7_2); rec_4A_P75_2 = sum(DP75_2); rec_4A_P8_2 = sum(DP8_2);
end

function [DN7_4A,DN7_4A_2,DN75_4A,DN75_4A_2,DN8_4A,DN8_4A_2,DP0_4A,DP02_4A,DP03_4A,DP7_4A,DP7_4A_2,...
    DP75_4A,DP75_4A_2,DP8_4A,DP8_4A_2] = seg(N7,N72,N75,N752,N8,N82,P0,P02,P03,P7,P72,P75,P752,P8,P82,delta_x)
    if N72 == 0
        DN7_4A = sqrt((delta_x^2) + (N7^2));
        DN7_4A_2 = 0;
    else
        DN7_4A = sqrt((delta_x^2) + (N7^2));
        DN7_4A_2 = sqrt((delta_x^2) + (N72^2));
    end



    if N752 == 0
        DN75_4A = sqrt((delta_x^2) + (N75^2));
        DN75_4A_2 = 0;
    else
        DN75_4A = sqrt((delta_x^2) + (N75^2));
        DN75_4A_2 = sqrt((delta_x^2) + (N752^2));
    end

    if N82 == 0
        DN8_4A = sqrt((delta_x^2) + (N8^2));
        DN8_4A_2 = 0;
    else
        DN8_4A = sqrt((delta_x^2) + (N8^2));
        DN8_4A_2 = sqrt((delta_x^2) + (N82^2));
    end

    if P02 == 0 && P03 == 0
        DP0_4A = sqrt((delta_x^2) + (P0^2));
        DP02_4A = 0;
        DP03_4A = 0;
    elseif P03 == 0
        DP0_4A = sqrt((delta_x^2) + (P0^2));
        DP02_4A = sqrt((delta_x^2) + (P02^2));
        DP03_4A = 0;
    else
        DP0_4A = sqrt((delta_x^2) + (P0^2));
        DP02_4A = sqrt((delta_x^2) + (P02^2));
        DP03_4A = sqrt((delta_x^2) + (P03^2));
    end

    if P72 == 0
        DP7_4A = sqrt((delta_x^2) + (P7^2));
        DP7_4A_2 = 0;
    else
        DP7_4A = sqrt((delta_x^2) + (P7^2));
        DP7_4A_2 = sqrt((delta_x^2) + (P72^2));
    end

    if P752 == 0
        DP75_4A = sqrt((delta_x^2) + (P75^2));
        DP75_4A_2 = 0;
    else
        DP75_4A = sqrt((delta_x^2) + (P75^2));
        DP75_4A_2 = sqrt((delta_x^2) + (P752^2));
    end

    if P82 == 0
        DP8_4A = sqrt((delta_x^2) + (P8^2));
        DP8_4A_2 = 0;
    else
        DP8_4A = sqrt((delta_x^2) + (P8^2));
        DP8_4A_2 = sqrt((delta_x^2) + (P82^2));
    end


end


function [delta_y_shot_N7,delta_y_shot_N7_2,delta_y_shot_N75,delta_y_shot_N75_2,delta_y_shot_N8,delta_y_shot_N8_2,delta_y_shot_P0,...
    delta_y_shot_P0_2,delta_y_shot_P0_3,delta_y_shot_P7,delta_y_shot_P7_2,delta_y_shot_P75,delta_y_shot_P75_2,delta_y_shot_P8,delta_y_shot_P8_2] = lengthfinder(shot_val,i,Label,sv,~)

cont_shot_N7_00 = contains(Label.(shot_val),'N_4_00mA_7_00');
cont_shot_N7_50 = contains(Label.(shot_val),'N_4_00mA_7_50');
cont_shot_N8_00 = contains(Label.(shot_val),'N_4_00mA_8_00');
cont_shot_P0_00 = contains(Label.(shot_val),'P_0_00mA_0_00');
cont_shot_P7_00 = contains(Label.(shot_val),'P_4_00mA_7_00');
cont_shot_P7_50 = contains(Label.(shot_val),'P_4_00mA_7_50');
cont_shot_P8_00 = contains(Label.(shot_val),'P_4_00mA_8_00');

find7 = find(cont_shot_N7_00 == 1);
if length(find(cont_shot_N7_00 == 1)) == 1
    delta_y_shot_N7 = sv(i+1,cont_shot_N7_00) - sv(i,cont_shot_N7_00);
    delta_y_shot_N7_2 = 0;
elseif length(find(cont_shot_N7_00 == 1)) == 2
    delta_y_shot_N7 = sv(i+1,find7(1)) - sv(i,find7(1));
    delta_y_shot_N7_2 = sv(i+1,find7(2)) - sv(i,find7(2));
elseif any(cont_shot_N7_00) == 0
    delta_y_shot_N7 = 0;
    delta_y_shot_N7_2 = 0;
end

find75 = find(cont_shot_N7_50 == 1);
if length(find(cont_shot_N7_50 == 1)) == 1
    delta_y_shot_N75 = sv(i+1,cont_shot_N7_50) - sv(i,cont_shot_N7_50);
    delta_y_shot_N75_2 = 0;
elseif length(find(cont_shot_N7_50 == 1)) == 2
    delta_y_shot_N75 = sv(i+1,find75(1)) - sv(i,find75(1));
    delta_y_shot_N75_2 = sv(i+1,find75(2)) - sv(i,find75(2));
elseif any(cont_shot_N7_50) == 0
    delta_y_shot_N75 = 0;
    delta_y_shot_N75_2 = 0;
end

find8 = find(cont_shot_N8_00 == 1);
if length(find(cont_shot_N8_00 == 1)) == 1
    delta_y_shot_N8 = sv(i+1,cont_shot_N8_00) - sv(i,cont_shot_N8_00);
    delta_y_shot_N8_2 = 0;
elseif length(find(cont_shot_N8_00 == 1)) == 2
    delta_y_shot_N8 = sv(i+1,find8(1)) - sv(i,find8(1));
    delta_y_shot_N8_2 = sv(i+1,find8(2)) - sv(i,find8(2));
elseif any(cont_shot_N8_00) == 0
    delta_y_shot_N8 = 0;
    delta_y_shot_N8_2 = 0;
end

find_zeros = find(cont_shot_P0_00 == 1);
if length(find(cont_shot_P0_00 == 1)) == 1
    delta_y_shot_P0 = sv(i+1,cont_shot_P0_00) - sv(i,cont_shot_P0_00);
    delta_y_shot_P0_2 = 0;
    delta_y_shot_P0_3 = 0;
elseif length(find(cont_shot_P0_00 == 1)) == 2
    delta_y_shot_P0 = sv(i+1,find_zeros(1)) - sv(i,find_zeros(1));
    delta_y_shot_P0_2 = sv(i+1,find_zeros(2)) - sv(i,find_zeros(2));
    delta_y_shot_P0_3 = 0;
elseif length(find(cont_shot_P0_00 == 1)) == 3
    delta_y_shot_P0 = sv(i+1,find_zeros(1)) - sv(i,find_zeros(1));
    delta_y_shot_P0_2 = sv(i+1,find_zeros(2)) - sv(i,find_zeros(2));
    delta_y_shot_P0_3 = sv(i+1,find_zeros(3)) - sv(i,find_zeros(3));
elseif any(cont_shot_P0_00) == 0
    delta_y_shot_P0 = 0;
    delta_y_shot_P0_2 = 0;
    delta_y_shot_P0_3 = 0;
end

findP7 = find(cont_shot_P7_00 == 1);
if length(find(cont_shot_P7_00 == 1)) == 1
    delta_y_shot_P7 = sv(i+1,cont_shot_P7_00) - sv(i,cont_shot_P7_00);
    delta_y_shot_P7_2 = 0;
elseif length(find(cont_shot_P7_00 == 1)) == 2
    delta_y_shot_P7 = sv(i+1,findP7(1)) - sv(i,findP7(1));
    delta_y_shot_P7_2 = sv(i+1,findP7(2)) - sv(i,findP7(2));
elseif any(cont_shot_P7_00) == 0
    delta_y_shot_P7 = 0;
    delta_y_shot_P7_2 = 0;
end

findP75 = find(cont_shot_P7_50 == 1);
if length(find(cont_shot_P7_50 == 1)) == 1
    delta_y_shot_P75 = sv(i+1,cont_shot_P7_50) - sv(i,cont_shot_P7_50);
    delta_y_shot_P75_2 = 0;
elseif length(find(cont_shot_P7_50 == 1)) == 2
    delta_y_shot_P75 = sv(i+1,findP75(1)) - sv(i,findP75(1));
    delta_y_shot_P75_2 = sv(i+1,findP75(2)) - sv(i,findP75(2));
elseif any(cont_shot_P7_50) == 0
    delta_y_shot_P75 = 0;
    delta_y_shot_P75_2 = 0;
end

findP8 = find(cont_shot_P8_00 == 1);
if length(find(cont_shot_P8_00 == 1)) == 1
    delta_y_shot_P8 = sv(i+1,cont_shot_P8_00) - sv(i,cont_shot_P8_00);
    delta_y_shot_P8_2 = 0;
elseif length(find(cont_shot_P8_00 == 1)) == 2
    delta_y_shot_P8 = sv(i+1,findP8(1)) - sv(i,findP8(1));
    delta_y_shot_P8_2 = sv(i+1,findP8(2)) - sv(i,findP8(2));
elseif any(cont_shot_P8_00) == 0
    delta_y_shot_P8 = 0;
    delta_y_shot_P8_2 = 0;
end

end