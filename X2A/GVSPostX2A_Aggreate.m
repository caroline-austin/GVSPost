%% GVSPost X2A Script 3 : Combine Data/Info Across subjects
% Caroline Austin 
% Created ?/?/2023? Last Modified:10/9/24
% this script handles the verbal reports data from X2A - this includes 
% verbal rating of none slight/noticeable moderate severe for motion
% sensations and side effects as well as qualitative descriptions of
% motion. This script combines the tallied reports from across subjects


%% house keeping
close all; 
clear all; 
clc; 

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

subnum = 1014:1022;  % Subject List 2001:2010
numsub = length(subnum);
subskip = [1011 1012 1013 1015 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

used_sub = 0;
All_vars2save = [''];
for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    used_sub = used_sub +1;
    subject_label(used_sub)= subject;
    Label.Subject(used_sub)= subject;
    cd([file_path, '/' , subject_str]);
    load(['A' subject_str 'Extract.mat'])
    cd(code_path);

% probably only want to save the certain variables of interest not all of
% the data (ie vars_interest should be a subset of vars_2_save)
% but this code should have the proper logic 

vars_interest = split(vars_2_save);
for vars = 1:length(vars_interest)
    current_var = char(vars_interest(vars));
    if strcmp(current_var, "Label") || isempty(current_var)
        All_vars2save =  horzcat( [All_vars2save ' Label']);
        continue
    end

%     eval(['All_' current_var '(used_sub*row-row+1:used_sub*row, :) = ' current_var ' ;'])


        if contains(current_var, 'map') %contains(current_var, 'Motion_map') || contains(current_var, 'Timing_map') || contains(current_var, 'Type_map')
                eval(['[row, col, depth, d4] = size(' current_var ');'])
            if subject == subnum(1)% this is probably not the best way to do this, but will probably work for now
%                 test = zeros(row, col, depth);
                eval(['All_' current_var ' = zeros( row , col , depth, d4);']);
                dummy_name = ['All_' current_var];
                All_vars2save =  horzcat( [All_vars2save ' ' dummy_name]);
            end
            eval(['All_' current_var ' = ' current_var '+' 'All_' current_var ' ;'])
%         elseif contains(current_var, 'map') 
%                 eval(['[row, col, depth] = size(' current_var ');'])
%             if subject == subnum(1)% this is probably not the best way to do this, but will probably work for now
% %                 test = zeros(row, col, depth);
%                 eval(['All_' current_var ' = zeros( row , col , depth );']);
%                 dummy_name = ['All_' current_var];
%                 All_vars2save =  horzcat( [All_vars2save ' ' dummy_name]);
%             end
%             eval(['All_' current_var ' = ' current_var '+' 'All_' current_var ' ;'])

        else 
            %will worry about not reporting variable later 
            eval(['[row, col] = size(' current_var ');'])
             if subject == subnum(1)% this is probably not the best way to do this, but will probably work for now
%                 test = zeros(row, col, depth);
                eval(['All_' current_var ' = zeros(row, col );']);
                dummy_name = ['All_' current_var];
                All_vars2save =  horzcat( [All_vars2save ' ' dummy_name]);
                
             end
%             eval(['All_' current_var '(used_sub*row-row+1:used_sub*row, :) = ' current_var ' ;'])
                eval(['All_' current_var '(:, used_sub) = ' current_var ' ;'])
                
             
        end

end

end

% insert any data aggregating code ( or can be saved for the plot script)

All_vars2save = horzcat( [All_vars2save ' subject_label']);
    cd([file_path]);
%     %vars_interest probably doesn't need to get reset here
%     vars_interest = 'Label TrialInfo SideEffects MotionSense Observed EndImpedance StartImpedance MaxCurrent MinCurrent';
    eval(['  save  All_X2A.mat ' All_vars2save ' All_vars2save']);      
    cd(code_path)
    eval (['clear ' All_vars2save])
