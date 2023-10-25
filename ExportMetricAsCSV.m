clear all
close all
code_path = pwd;
[file_name,file_path] = uigetfile; %user selects file directory
cd(file_path)
load(file_name)

var_name = "slope_save_all"; % for tilt-perception 
eval("var = " + var_name + ";");
row_index = 0; 
for i = 1:width(var)
    for j = 1:length(var)
        row_index = row_index+1;
        var_anova(row_index,1) = j;
        var_anova(row_index,2) = i;
        var_anova(row_index,3) = var(j,i);
    end
end
var_anova = array2table(var_anova,'VariableNames',{'SID', 'CouplingScheme', 'Var'});
% eval("writetable(" + var_name + ", '" + file_name(1:end-4) + ".csv');");
eval("writetable(var_anova, '" + file_name(1:end-4) + ".csv');");
cd(code_path)
