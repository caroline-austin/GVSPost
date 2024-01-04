%% load data
clear all
close all
code_path = pwd;
[file_name,file_path] = uigetfile; %user selects file most are in measures or the main data folder
cd(file_path)
load(file_name)
cd(code_path)

var_name = "peak_save_all"; % have to know aggregate variable name (check before hand)- peak,over, slope,mae
eval("var = " + var_name + ";");

%% format data

% row_index = 0; 
% for couple = 1:width(var)
%     for sub = 1:length(var)
%         row_index = row_index+1;
%         var_anova(row_index,1) = sub;
%         var_anova(row_index,2) = couple;
%         var_anova(row_index,3) = var(sub,couple);
%         if couple <4
%                 var_anova(row_index, 4) = -1; 
%         elseif couple >4
%                 var_anova(row_index, 4) = 1; 
%         else
%                 var_anova(row_index, 4) = 0;
%         end
%     end
% end
% % var_anova = array2table(var_anova,'VariableNames',{'SID', 'CouplingScheme', 'Var', 'CouplingDirection'});
% var = [var [1;2;3;4;5;6;7;2;1;2;1;2]];
% var_anova = array2table(var,'VariableNames',{'A', 'B', 'C', 'D', 'E', 'F', 'G', 'Ind'});

% %%
% motion_list = ["4"; "4"; "5"; "5";"6"; "6"];
% motion_num = [4; 4; 5; 5;6; 6];
% direction_list = ["A"; "B"; "A"; "B";"A"; "B"];
% direction_num = [1; 2; 1; 2;1; 2];
% row_index = 0;
% for motion = 1:length(motion_list)
%     eval("var = peak_save_" + motion_list(motion) + direction_list(motion) + ";"); % have to know aggregate variable name (check before hand)
% %     eval("var = " + var_name_full + ";");
%     for couple = 1:width(var)
%         for sub = 1:length(var)
%             row_index = row_index+1;
%             var_anova_full(row_index,1) = sub;
%             var_anova_full(row_index,2) = couple;
%             var_anova_full(row_index,3) = var(sub,couple);
%             var_anova_full(row_index,5) = motion_num(motion);
%             var_anova_full(row_index,6) = direction_num(motion);
%              if couple <4
%                     var_anova_full(row_index, 4) = -1; 
%             elseif couple >4
%                     var_anova_full(row_index, 4) = 1; 
%             else
%                     var_anova_full(row_index, 4) = 0;
%             end
%         end
%     end
% end
% % var_anova_full = array2table(var_anova_full,'VariableNames',{'SID', 'CouplingScheme', 'Var', 'CouplingDirection', 'MotionProfile', 'MotionDirection'});
% % % eval("writetable(" + var_name + ", '" + file_name(1:end-4) + ".csv');");
% % cd(file_path)
% % eval("writetable(var_anova_full, '" + file_name(1:end-4) + "Full.csv');");
% % cd(code_path)
% withinDesign = table([1 2 3 4 5 6 7]','VariableNames',{'CouplingScheme'});
% % withinDesign.CouplingScheme = var_anova_full.CouplingScheme;
% withinDesign.CouplingScheme = categorical(withinDesign.CouplingScheme);
% 
% % var_anova_full = var_anova_full{:,3:end};
% % var_anova_full = array2table(var_anova_full,'VariableNames',{ 'Var', 'CouplingDirection', 'MotionProfile', 'MotionDirection'});
% %% run anova
% rm = fitrm(var_anova,'A - G ~  Ind','WithinDesign',withinDesign);
% AT = ranova(rm, 'WithinModel', 'CouplingScheme');
% % output a conventional ANOVA table from ranova output
% disp(anovaTable(AT, 'DV'));

%% run post hoc tests
[h14,p14,ci14,stats14] = ttest(var(:,1),var(:,4));
[h24,p24,ci24,stats24] = ttest(var(:,2),var(:,4));
[h34,p34,ci34,stats34] = ttest(var(:,3),var(:,4));
[h54,p54,ci54,stats54] = ttest(var(:,5),var(:,4));
[h64,p64,ci64,stats64] = ttest(var(:,6),var(:,4));
[h74,p74,ci74,stats74] = ttest(var(:,7),var(:,4));

[h15,p15,ci15,stats15] = ttest(var(:,1),var(:,5));
[h26,p26,ci26,stats26] = ttest(var(:,2),var(:,6));
[h37,p37,ci37,stats37] = ttest(var(:,3),var(:,7));


%%

% % load your data into data table
% load(websave('data', 'https://www.mathworks.com/matlabcentral/answers/uploaded_files/1305605/data.mat'))
% data.Properties.VariableNames = {'Stress', 'Performance', 'Reward', 'Penalty'};
% % setup and do the three-way ANOVA
% withinDesign = table([1 2]','VariableNames',{'Feedback'});
% withinDesign.Feedback = categorical(withinDesign.Feedback);
% rm = fitrm(data,'Reward-Penalty ~ Stress*Performance','WithinDesign',withinDesign);
% AT = ranova(rm, 'WithinModel', 'Feedback');
% % output a conventional ANOVA table from ranova output
% disp(anovaTable(AT, 'DV'));

% %%
% % -------------------------------------------------------------------------
% % function to create a conventional ANOVA table from the overly-complicated
% % anova table created by the ranova function
% function [s] = anovaTable(AT, dvName)
% c = table2cell(AT);
% % remove erroneous entries in F and p columns
% for i=1:size(c,1)
%     if c{i,4} == 1
%         c(i,4) = {''};
%     end
%     if c{i,5} == .5
%         c(i,5) = {''};
%     end
% end
% % use conventional labels in Effect column
% effect = AT.Properties.RowNames;
% for i=1:length(effect)
%     tmp = effect{i};
%     tmp = erase(tmp, '(Intercept):');
%     tmp = strrep(tmp, 'Error', 'Participant');
%     effect(i) = {tmp};
% end
% % determine the required width of the table
% fieldWidth1 = max(cellfun('length', effect)); % width of Effect column
% fieldWidth2 = 57; % width for df, SS, MS, F, and p columns
% barDouble = repmat('=', 1, fieldWidth1 + fieldWidth2);
% barSingle = repmat('-', 1, fieldWidth1 + fieldWidth2);
% % re-organize the data
% c = c(2:end,[2 1 3 4 5]);
% c = [num2cell(repmat(fieldWidth1, size(c,1), 1)), effect(2:end), c]';
% % create the ANOVA table
% s = sprintf('ANOVA table for %s\n', dvName);
% s = [s sprintf('%s\n', barDouble)];
% s = [s sprintf('%-*s %4s %11s %14s %9s %9s\n', fieldWidth1, 'Effect', 'df', 'SS', 'MS', 'F', 'p')];
% s = [s sprintf('%s\n', barSingle)];
% s = [s sprintf('%-*s %4d %14.5f %14.5f %10.3f %10.4f\n', c{:})];
% s = [s sprintf('%s\n', barDouble)];
% end