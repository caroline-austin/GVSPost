%% Script for Individual Pathlength
% This script takes the desired subject and computes the difference between
% the comanded TTS pathlength and the average pathlength ...

%% DOUBLE CHECK I AM USING THE ADJUSTED DATA!!!
clc; clear; close all;

%% set up
% This is just using the same process as Caroline's file selection:
subnum = 1015:1015;  % Subject List 
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

Color_List = [ "black";"green";"cyan"; "blue";"red";"green"; "cyan";"blue"];
match_list = ["N_4_00mA_7_00"; "N_4_00mA_7_50"; "N_4_00mA_8_00"; "0_00mA";"P_4_00mA_7_00"; "P_4_00mA_7_50"; "P_4_00mA_8_00"];
datatype = 'BiasTime'; % Use GroupBias ???

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '/Plots']; % specify where plots are saved
[filenames]=file_path_info2(code_path, file_path); % get files from file folder


for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);

    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end

    %set up file/plot save locations
    subject_path = [file_path, '/' , subject_str];
    subject_plot_path = [plots_path '/' subject_str];
    mkdir(subject_plot_path);

    cd(subject_path); % change directory to subject #
    load(['S', subject_str, 'Group', datatype, '.mat']); 

    cd(code_path); % saving the current directory

    A_LOC_shot = cell(3,3); B_LOC_shot = cell(3,3);
    A_LOC_tilt = cell(3,3); B_LOC_tilt = cell(3,3);
    A_LOC_gvs = cell(3,3); B_LOC_gvs = cell(3,3);
    for i  = 1:3 % rows
        for j = 1:3 % collumns
            % SHOT locations 
            strA_shot = {Label.shot_4A,Label.shot_5A,Label.shot_6A};
            strB_shot = {Label.shot_4B,Label.shot_5B,Label.shot_6B};
 
            PNZ = ["P";"N";"P_0"]; % respectively: positive, negative, and zero
            A_LOC_shot{i,j} = find(contains(strA_shot{i}(:,1),PNZ(j))); 
            B_LOC_shot{i,j} = find(contains(strB_shot{i}(:,1),PNZ(j)));

            % TILT locations
            strA_tilt = {Label.tilt_4A,Label.tilt_5A,Label.tilt_6A};
            strB_tilt = {Label.tilt_4B,Label.tilt_5B,Label.tilt_6B};
 
            A_LOC_tilt{i,j} = find(contains(strA_tilt{i}(:,1),PNZ(j))); 
            B_LOC_tilt{i,j} = find(contains(strB_tilt{i}(:,1),PNZ(j)));

            % GVS locations
            strA_gvs = {Label.GVS_4A,Label.GVS_5A,Label.GVS_6A};
            strB_gvs = {Label.GVS_4B,Label.GVS_5B,Label.GVS_6B};
 
            A_LOC_gvs{i,j} = find(contains(strA_gvs{i}(:,1),PNZ(j))); 
            B_LOC_gvs{i,j} = find(contains(strB_gvs{i}(:,1),PNZ(j)));

            if i == 1
    
                % Path Length (4A)
                command_4A = tilt_4A(:,A_LOC_tilt{1,j});
                command_4A_avg = mean(command_4A,2);
                command_4A_avg_dist = command_4A_avg(2:end) - command_4A_avg(1:end-1);
    
                recorded_4A = shot_4A(:,A_LOC_shot{1,j});
                recorded_4A_avg = mean(recorded_4A,2);
                recorded_4A_avg_dist = recorded_4A_avg(2:end) - recorded_4A_avg(1:end-1);
    
                waypoints_command = [linspace(1,length(command_4A_avg),length(command_4A_avg))',command_4A_avg];
                waypoints_recorded = [linspace(1,length(recorded_4A_avg),length(recorded_4A_avg))',recorded_4A_avg]; 
    
                pt_dist_command = sqrt(waypoints_command(2:end,1).^2 + command_4A_avg_dist.^2);
                pathlength_4A_command_pos = sum(pt_dist_command);
    
                pt_dist_recorded = sqrt(waypoints_recorded(2:end,1).^2 + recorded_4A_avg_dist.^2);
                pathlength_4A_recorded_pos = sum(pt_dist_recorded);
            
                diff_4A(j) = pathlength_4A_recorded_pos - pathlength_4A_command_pos;
    
                % Path Length (4B)
                command_4B = tilt_4B(:,B_LOC_tilt{1,j});
                command_4B_avg = mean(command_4B,2);
                command_4B_avg_dist = command_4B_avg(2:end) - command_4B_avg(1:end-1);
    
                recorded_4B = shot_4B(:,B_LOC_shot{1,j});
                recorded_4B_avg = mean(recorded_4B,2);
                recorded_4B_avg_dist = recorded_4B_avg(2:end) - recorded_4B_avg(1:end-1);
    
                waypoints_commandB = [linspace(1,length(command_4B_avg),length(command_4B_avg))',command_4B_avg];
                waypoints_recordedB = [linspace(1,length(recorded_4B_avg),length(recorded_4B_avg))',recorded_4B_avg]; 
    
                pt_dist_commandB = sqrt(waypoints_commandB(2:end,1).^2 + command_4B_avg_dist.^2);
                pathlength_4B_command_pos = sum(pt_dist_commandB);
    
                pt_dist_recordedB = sqrt(waypoints_recordedB(2:end,1).^2 + recorded_4B_avg_dist.^2);
                pathlength_4B_recorded_pos = sum(pt_dist_recordedB);
            
                diff_4B(j) = pathlength_4B_recorded_pos - pathlength_4B_command_pos;
            elseif i == 2
                % Path Length (5A)
                command_5A = tilt_5A(:,A_LOC_tilt{2,j});
                command_5A_avg = mean(command_5A,2);
                command_5A_avg_dist = command_5A_avg(2:end) - command_5A_avg(1:end-1);
    
                recorded_5A = shot_5A(:,A_LOC_shot{2,j});
                recorded_5A_avg = mean(recorded_5A,2);
                recorded_5A_avg_dist = recorded_5A_avg(2:end) - recorded_5A_avg(1:end-1);
    
                waypoints_command5 = [linspace(1,length(command_5A_avg),length(command_5A_avg))',command_5A_avg];
                waypoints_recorded5 = [linspace(1,length(recorded_5A_avg),length(recorded_5A_avg))',recorded_5A_avg]; 
    
                pt_dist_command5 = sqrt(waypoints_command5(2:end,1).^2 + command_5A_avg_dist.^2);
                pathlength_5A_command_pos = sum(pt_dist_command5);
    
                pt_dist_recorded5 = sqrt(waypoints_recorded5(2:end,1).^2 + recorded_5A_avg_dist.^2);
                pathlength_5A_recorded_pos = sum(pt_dist_recorded5);
            
                diff_5A(j) = pathlength_5A_recorded_pos - pathlength_5A_command_pos;
    
                % Path Length (5B)
                command_5B = tilt_5B(:,B_LOC_tilt{2,j});
                command_5B_avg = mean(command_5B,2);
                command_5B_avg_dist = command_5B_avg(2:end) - command_5B_avg(1:end-1);
    
                recorded_5B = shot_5B(:,B_LOC_shot{2,j});
                recorded_5B_avg = mean(recorded_5B,2);
                recorded_5B_avg_dist = recorded_5B_avg(2:end) - recorded_5B_avg(1:end-1);
    
                waypoints_commandB5 = [linspace(1,length(command_5B_avg),length(command_5B_avg))',command_5B_avg];
                waypoints_recordedB5 = [linspace(1,length(recorded_5B_avg),length(recorded_5B_avg))',recorded_5B_avg]; 
    
                pt_dist_commandB5 = sqrt(waypoints_commandB5(2:end,1).^2 + command_5B_avg_dist.^2);
                pathlength_5B_command_pos = sum(pt_dist_commandB5);
    
                pt_dist_recordedB5 = sqrt(waypoints_recordedB5(2:end,1).^2 + recorded_5B_avg_dist.^2);
                pathlength_5B_recorded_pos = sum(pt_dist_recordedB5);
            
                diff_5B(j) = pathlength_5B_recorded_pos - pathlength_5B_command_pos;
            elseif i == 3
                % Path Length (6A)
                command_6A = tilt_6A(:,A_LOC_tilt{3,j});
                command_6A_avg = mean(command_6A,2);
                command_6A_avg_dist = command_6A_avg(2:end) - command_6A_avg(1:end-1);
    
                recorded_6A = shot_6A(:,A_LOC_shot{3,j});
                recorded_6A_avg = mean(recorded_6A,2);
                recorded_6A_avg_dist = recorded_6A_avg(2:end) - recorded_6A_avg(1:end-1);
    
                waypoints_command6 = [linspace(1,length(command_6A_avg),length(command_6A_avg))',command_6A_avg];
                waypoints_recorded6 = [linspace(1,length(recorded_6A_avg),length(recorded_6A_avg))',recorded_6A_avg]; 
    
                pt_dist_command6 = sqrt(waypoints_command6(2:end,1).^2 + command_6A_avg_dist.^2);
                pathlength_6A_command_pos = sum(pt_dist_command6);
    
                pt_dist_recorded6 = sqrt(waypoints_recorded6(2:end,1).^2 + recorded_6A_avg_dist.^2);
                pathlength_6A_recorded_pos = sum(pt_dist_recorded6);
            
                diff_6A(j) = pathlength_6A_recorded_pos - pathlength_6A_command_pos;
    
                % Path Length (6B)
                command_6B = tilt_6B(:,B_LOC_tilt{3,j});
                command_6B_avg = mean(command_6B,2);
                command_6B_avg_dist = command_6B_avg(2:end) - command_6B_avg(1:end-1);
    
                recorded_6B = shot_6B(:,B_LOC_shot{3,j});
                recorded_6B_avg = mean(recorded_6B,2);
                recorded_6B_avg_dist = recorded_6B_avg(2:end) - recorded_6B_avg(1:end-1);
    
                waypoints_commandB6 = [linspace(1,length(command_6B_avg),length(command_6B_avg))',command_6B_avg];
                waypoints_recordedB6 = [linspace(1,length(recorded_6B_avg),length(recorded_6B_avg))',recorded_6B_avg]; 
    
                pt_dist_commandB6 = sqrt(waypoints_commandB6(2:end,1).^2 + command_6B_avg_dist.^2);
                pathlength_6B_command_pos = sum(pt_dist_commandB6);
    
                pt_dist_recordedB6 = sqrt(waypoints_recordedB6(2:end,1).^2 + recorded_6B_avg_dist.^2);
                pathlength_6B_recorded_pos = sum(pt_dist_recordedB6);
            
                diff_6B(j) = pathlength_6B_recorded_pos - pathlength_6B_command_pos;

            end
     
        end
    end


diff_mat = [diff_4A;diff_4B;diff_5A;diff_5B;diff_6A;diff_6B];
Label_diff = categorical({'4A' '4B' '5A' '5B' '6A' '6B'});

figure();
grid on;
bar(Label_diff,diff_mat);
legend('Positive','Negative','Zero');



    


end