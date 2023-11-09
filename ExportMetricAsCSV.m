clear all
close all
code_path = pwd;
[file_name,file_path] = uigetfile; %user selects file directory
cd(file_path)
load(file_name)
cd(code_path)
%%
<<<<<<< HEAD
var_name = "peak_save_all"; % have to know aggregate variable name (check before hand)
=======
var_name = "peak_save_all"; % have to know aggregate variable name (check before hand)- peak,over, slope,mae
>>>>>>> 3c9f5df82171729658afe9b3900d0dabf471df88
eval("var = " + var_name + ";");
row_index = 0; 
for couple = 1:width(var)
    for sub = 1:length(var)
        row_index = row_index+1;
        var_anova(row_index,1) = sub;
        var_anova(row_index,2) = couple;
        var_anova(row_index,3) = var(sub,couple);
        if couple <4
<<<<<<< HEAD
                var_anova(row_index, 4) = 'N'; 
        elseif couple >4
                var_anova(row_index, 4) = 'P'; 
        else
                var_anova(row_index, 4) = 'X';
=======
                var_anova(row_index, 4) = -1; 
        elseif couple >4
                var_anova(row_index, 4) = 1; 
        else
                var_anova(row_index, 4) = 0;
>>>>>>> 3c9f5df82171729658afe9b3900d0dabf471df88
        end
    end
end
var_anova = array2table(var_anova,'VariableNames',{'SID', 'CouplingScheme', 'Var', 'CouplingDirection'});
% eval("writetable(" + var_name + ", '" + file_name(1:end-4) + ".csv');");
cd(file_path)
eval("writetable(var_anova, '" + file_name(1:end-4) + ".csv');");
cd(code_path)

%%
motion_list = ["4"; "4"; "5"; "5";"6"; "6"];
<<<<<<< HEAD
direction_list = ["A"; "B"; "A"; "B";"A"; "B"];
for motion = 1:length(motion_list)
    eval("var = peak_save_" + motion_list(motion) + direction_list(motion) + ";"); % have to know aggregate variable name (check before hand)
%     eval("var = " + var_name_full + ";");
    row_index = 0; 
=======
motion_num = [4; 4; 5; 5;6; 6];
direction_list = ["A"; "B"; "A"; "B";"A"; "B"];
direction_num = [1; 2; 1; 2;1; 2];
row_index = 0;
for motion = 1:length(motion_list)
    eval("var = peak_save_" + motion_list(motion) + direction_list(motion) + ";"); % have to know aggregate variable name (check before hand)
%     eval("var = " + var_name_full + ";");
>>>>>>> 3c9f5df82171729658afe9b3900d0dabf471df88
    for couple = 1:width(var)
        for sub = 1:length(var)
            row_index = row_index+1;
            var_anova_full(row_index,1) = sub;
            var_anova_full(row_index,2) = couple;
            var_anova_full(row_index,3) = var(sub,couple);
<<<<<<< HEAD
            var_anova_full(row_index,5) = motion_list(motion);
            var_anova_full(row_index,6) = direction_list(motion);
            if couple <4
                var_anova_full(row_index, 4) = 'N'; 
            elseif couple >4
                var_anova_full(row_index, 4) = 'P'; 
            else
                var_anova_full(row_index, 4) = 'X';
=======
            var_anova_full(row_index,5) = motion_num(motion);
            var_anova_full(row_index,6) = direction_num(motion);
             if couple <4
                    var_anova_full(row_index, 4) = -1; 
            elseif couple >4
                    var_anova_full(row_index, 4) = 1; 
            else
                    var_anova_full(row_index, 4) = 0;
>>>>>>> 3c9f5df82171729658afe9b3900d0dabf471df88
            end
        end
    end
end
var_anova_full = array2table(var_anova_full,'VariableNames',{'SID', 'CouplingScheme', 'Var', 'CouplingDirection', 'MotionProfile', 'MotionDirection'});
% eval("writetable(" + var_name + ", '" + file_name(1:end-4) + ".csv');");
cd(file_path)
eval("writetable(var_anova_full, '" + file_name(1:end-4) + "Full.csv');");
cd(code_path)