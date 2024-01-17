%%Timothy Behrer
%% HouseKeeping
clc; clear; close all;
%% Main Script


%% FMT
FMT_Data = analyzeFMT('ExcelData_Cut_ALL.mat',0,0);

% first add a subject column to the data
subj = cat(1, ones(6,1), ones(6,1)*2, ones(6,1)*3, ones(6,1)*4, ones(6,1)*5, ...
    ones(6,1)*6, ones(6,1)*7, ones(6,1)*8, ones(6,1)*9, ones(6,1)*10, ones(6,1)*11);
FMT_Data = [FMT_Data,subj];
% Check Normality
%%Create difference array
% diffArray = cat(1,diff(FMT_Data(1:6,1)),diff(FMT_Data(7:12,1)),diff(FMT_Data(13:18,1)),diff(FMT_Data(19:24,1)),diff(FMT_Data(25:30,1)),diff(FMT_Data(31:36,1)),...
%     diff(FMT_Data(37:42,1)),diff(FMT_Data(43:48,1)),diff(FMT_Data(49:54,1)),diff(FMT_Data(55:60,1)),diff(FMT_Data(61:66,1)));
diffArray = cat(1,(FMT_Data(1:6,1)- mean(FMT_Data(1:6,1))),(FMT_Data(7:12,1)- mean(FMT_Data(7:12,1))),(FMT_Data(13:18,1)- mean(FMT_Data(13:18,1))),(FMT_Data(19:24,1)-mean(FMT_Data(19:24,1))),(FMT_Data(25:30,1)- mean(FMT_Data(25:30,1))),(FMT_Data(31:36,1)-mean(FMT_Data(31:36,1))),...
    (FMT_Data(37:42,1)-mean(FMT_Data(37:42,1))),(FMT_Data(43:48,1)-mean(FMT_Data(43:48,1))),(FMT_Data(49:54,1)-mean(FMT_Data(49:54,1))),(FMT_Data(55:60,1)-mean(FMT_Data(55:60,1))),(FMT_Data(61:66,1)-mean(FMT_Data(61:66,1))));
[H, pValue, W] = swtest(diffArray,0.05)
figure();
qqplot(diffArray);title('QQ Plot for FMT Raw Time')
% diffArray = cat(1,diff(FMT_Data(1:6,2)),diff(FMT_Data(7:12,2)),diff(FMT_Data(13:18,2)),diff(FMT_Data(19:24,2)),diff(FMT_Data(25:30,2)),diff(FMT_Data(31:36,2)),...
    % diff(FMT_Data(37:42,2)),diff(FMT_Data(43:48,2)),diff(FMT_Data(49:54,2)),diff(FMT_Data(55:60,2)),diff(FMT_Data(61:66,2)));
diffArray = cat(1,(FMT_Data(1:6,2)- mean(FMT_Data(1:6,2))),(FMT_Data(7:12,2)- mean(FMT_Data(7:12,2))),(FMT_Data(13:18,2)- mean(FMT_Data(13:18,2))),(FMT_Data(19:24,2)-mean(FMT_Data(19:24,2))),(FMT_Data(25:30,2)- mean(FMT_Data(25:30,2))),(FMT_Data(31:36,2)-mean(FMT_Data(31:36,2))),...
    (FMT_Data(37:42,2)-mean(FMT_Data(37:42,2))),(FMT_Data(43:48,2)-mean(FMT_Data(43:48,2))),(FMT_Data(49:54,2)-mean(FMT_Data(49:54,2))),(FMT_Data(55:60,2)-mean(FMT_Data(55:60,2))),(FMT_Data(61:66,2)-mean(FMT_Data(61:66,2))));
[H, pValue, W] = swtest(diffArray,0.05)
figure();
qqplot(diffArray);title('QQ Plot for FMT Errors Time')
% diffArray = cat(1,diff(FMT_Data(1:6,3)),diff(FMT_Data(7:12,3)),diff(FMT_Data(13:18,3)),diff(FMT_Data(19:24,3)),diff(FMT_Data(25:30,3)),diff(FMT_Data(31:36,3)),...
%     diff(FMT_Data(37:42,3)),diff(FMT_Data(43:48,3)),diff(FMT_Data(49:54,3)),diff(FMT_Data(55:60,3)),diff(FMT_Data(61:66,3)));
diffArray = cat(1,(FMT_Data(1:6,3)- mean(FMT_Data(1:6,3))),(FMT_Data(7:12,3)- mean(FMT_Data(7:12,3))),(FMT_Data(13:18,3)- mean(FMT_Data(13:18,3))),(FMT_Data(19:24,3)-mean(FMT_Data(19:24,3))),(FMT_Data(25:30,3)- mean(FMT_Data(25:30,3))),(FMT_Data(31:36,3)-mean(FMT_Data(31:36,3))),...
    (FMT_Data(37:42,3)-mean(FMT_Data(37:42,3))),(FMT_Data(43:48,3)-mean(FMT_Data(43:48,3))),(FMT_Data(49:54,3)-mean(FMT_Data(49:54,3))),(FMT_Data(55:60,3)-mean(FMT_Data(55:60,3))),(FMT_Data(61:66,3)-mean(FMT_Data(61:66,3))));

[H, pValue, W] = swtest(diffArray,0.05)
figure();
qqplot(diffArray);title('QQ Plot for FMT Net Time')
% then convert the data into an array
FMT_Data_tbl = array2table(FMT_Data);
FMT_Data_tbl.Properties.VariableNames = {'RawTime', 'Errors', 'CorrectedTime', 'GVS', 'Order', 'Subj'};
% make indep. var's categorical 
FMT_Data_tbl.GVS = categorical(FMT_Data_tbl.GVS);
FMT_Data_tbl.Order = categorical(FMT_Data_tbl.Order);
FMT_Data_tbl.Subj = categorical(FMT_Data_tbl.Subj);

% create linear mixed effect model with dependent ~ independent (1|Var) =
% random effects (so our within subjects) 
%%Raw Time ANOVA
lme_model = fitlme(FMT_Data_tbl,'RawTime ~ GVS + Order + (1|Subj)','FitMethod','REML','DummyVarCoding','effects'); % can also add GVS*Order, but the effect is not significant, so should probably exclude
FMT_RT_AN = anova(lme_model) % left the ; off so that it prints the results to the command window
int_model = fitlme(FMT_Data_tbl, 'RawTime ~ GVS + Order + GVS:Order + (1|Subj)', 'FitMethod', 'REML', 'DummyVarCoding', 'effects'); %  test whether there is a significant interaction effect between 'GVS' and 'Order'.
% Refit the model without the non-significant terms
lme_simplified = fitlme(FMT_Data_tbl, 'RawTime ~ Order + (1|Subj)', 'FitMethod', 'REML', 'DummyVarCoding', 'effects');

%%%Post-HOC Correlation
% Compare the two models
compare(lme_simplified, lme_model)
%%%%%%%This shows that the simplified model better describes the data set
compare(lme_simplified,int_model)
%%%%%%%This shows that the simplified model better describes the data set

% Define custom contrasts for pairwise comparisons for 'Order'
contrasts = eye(6) - circshift(eye(6), [0, 1]);
% Perform custom contrasts
contrast_results = coefTest(lme_simplified, contrasts);
disp(contrast_results)
%%Indicates that there are significant differences between the levels of
%%order

%%%Final anova
FMT_RT_AN_simp = anova(lme_model) % left the ; off so that it prints the results to the command window

% H = [0,0,0,1,0,0,0,0;
%     0,0,0,0,1,0,0,0;
%     0,0,0,0,0,1,0,0;
%     0,0,0,0,0,0,1,0;
%     0,0,0,0,0,0,0,1;];
% [pVal,F,DF1,DF2] = coefTest(lme,H)
% H = [0,1,0,0,0,0,0,0;
%     0,0,1,0,0,0,0,0;
%     0,0,0,1,0,0,0,0;
%     0,0,0,0,1,0,0,0;
%     0,0,0,0,0,1,0,0;
%     0,0,0,0,0,0,1,0;
%     0,0,0,0,0,0,0,1;];
% [pVal,F,DF1,DF2] = coefTest(lme,H)
% H = [0,1,0,0,0,0,0,0;
%     0,0,1,0,0,0,0,0;];
% [pVal,F,DF1,DF2] = coefTest(lme,H)

%%%%%Not Normal!%%%%%%%%
% lme = fitlme(FMT_Data_tbl,'Errors ~ GVS + Order + (1|Subj)','FitMethod','REML','DummyVarCoding','effects'); % can also add GVS*Order, but the effect is not significant, so should probably exclude
% FMT_ER_AN = anova(lme) % left the ; off so that it prints the results to the command window
% H = [0,1,0,0,0,0,0,0;
%     0,0,1,0,0,0,0,0;
%     0,0,0,1,0,0,0,0;
%     0,0,0,0,1,0,0,0;
%     0,0,0,0,0,1,0,0;
%     0,0,0,0,0,0,1,0;
%     0,0,0,0,0,0,0,1;];
% [pVal,F,DF1,DF2] = coefTest(lme,H)
%%Net Time ANOVA
lme_model = fitlme(FMT_Data_tbl,'CorrectedTime ~ GVS + Order + (1|Subj)','FitMethod','REML','DummyVarCoding','effects'); % can also add GVS*Order, but the effect is not significant, so should probably exclude
FMT_NT_AN = anova(lme_model) % left the ; off so that it prints the results to the command window
int_model = fitlme(FMT_Data_tbl, 'CorrectedTime ~ GVS + Order + GVS:Order + (1|Subj)', 'FitMethod', 'REML', 'DummyVarCoding', 'effects'); %  test whether there is a significant interaction effect between 'GVS' and 'Order'.
% Refit the model without the non-significant terms
lme_simplified = fitlme(FMT_Data_tbl, 'CorrectedTime ~ Order + (1|Subj)', 'FitMethod', 'REML', 'DummyVarCoding', 'effects');

%%%Post-HOC Correlation
% Compare the two models
compare(lme_simplified,lme_model)
%%%%%%%This shows that the simplified model better describes the data set
compare(lme_simplified,int_model)
%%%%%%%This shows that the model with interaction effects better describes the data set
%%%Final anova
FMT_NT_AN_SIMP = anova(lme_simplified) % left the ; off so that it prints the results to the command window
FMT_NT_AN_INT = anova(int_model)

% Define custom contrasts for pairwise comparisons for 'Order'
contrasts = eye(6) - circshift(eye(6), [0, 1]);
% Perform custom contrasts
contrast_results = coefTest(lme_simplified, contrasts);
disp(contrast_results)
%%Indicates that there are significant differences between the levels of
%%order



% H = [0,1,0,0,0,0,0,0;
%     0,0,1,0,0,0,0,0;
%     0,0,0,1,0,0,0,0;
%     0,0,0,0,1,0,0,0;
%     0,0,0,0,0,1,0,0;
%     0,0,0,0,0,0,1,0;
%     0,0,0,0,0,0,0,1;];
% [pVal,F,DF1,DF2] = coefTest(lme,H)


% anova_RT = anovan(FMT_Data(:,1),{num2str(FMT_Data(:,4)),num2str(FMT_Data(:,5))},'model','interaction','varnames',{'GVS Admin','Trial Order'});
% anova_ER = anovan(FMT_Data(:,2),{num2str(FMT_Data(:,4)),num2str(FMT_Data(:,5))},'model','interaction','varnames',{'GVS Admin','Trial Order'});
% anova_NT = anovan(FMT_Data(:,3),{num2str(FMT_Data(:,4)),num2str(FMT_Data(:,5))},'model','interaction','varnames',{'GVS Admin','Trial Order'});
%% Romberg

% first add a subject column to the data
subj = cat(1, ones(24,1), ones(24,1)*2, ones(24,1)*3, ones(24,1)*4, ones(24,1)*5, ...
    ones(24,1)*6, ones(24,1)*7, ones(24,1)*8, ones(24,1)*9, ones(24,1)*10, ones(24,1)*11);
Rom_Data = [Rom_Data,subj];
% Check normality
%%Create difference array
n = 24;
diffArray = cat(1,(Rom_Data(1:n,1)- mean(Rom_Data(1:n,1))), ...
    (Rom_Data(n*1+1:n*2,1)- mean(Rom_Data(n*1+1:n*2,1))),(Rom_Data(n*2+1:n*3,1)- mean(Rom_Data(n*2+1:n*3,1))), ...
    (Rom_Data(n*3+1:n*4,1)-mean(Rom_Data(n*3+1:n*4,1))),(Rom_Data(n*4+1:n*5,1)- mean(Rom_Data(n*4+1:n*5,1))), ...
    (Rom_Data(n*5+1:n*6,1)-mean(Rom_Data(n*5+1:n*6,1))),...
    (Rom_Data(n*6+1:n*7,1)-mean(Rom_Data(n*6+1:n*7,1))),(Rom_Data(n*7+1:n*8,1)-mean(Rom_Data(n*7+1:n*8,1))), ...
    (Rom_Data(n*8+1:n*9,1)-mean(Rom_Data(n*8+1:n*9,1))),(Rom_Data(n*9+1:n*10,1)-mean(Rom_Data(n*9+1:n*10,1))), ...
    (Rom_Data(n*10+1:n*11,1)-mean(Rom_Data(n*10+1:n*11,1))));

% diffArray = cat(1,diff(Rom_Data(1:n,1)),diff(Rom_Data(n*1+1:n*2,1)),diff(Rom_Data(n*2+1:n*3,1)),diff(Rom_Data(n*3+1:n*4,1)),diff(Rom_Data(n*4+1:n*5,1)),diff(Rom_Data(n*5+1:n*6,1)),...
%     diff(Rom_Data(n*6+1:n*7,1)),diff(Rom_Data(n*7+1:n*8,1)),diff(Rom_Data(n*8+1:n*9,1)),diff(Rom_Data(n*9+1:n*10,1)),diff(Rom_Data(n*10+1:n*11,1)));
[H, pValue, W] = swtest(diffArray,0.05)
figure();
qqplot(diffArray);title('QQ Plot for Romberg Failure Time')

%%Begin Friedman Analysis
%%%Data Parsage
%%No Head Tilts
c = 0;
NHT_data = [Rom_Data(find(Rom_Data(1:n,2) == c,1,'first'):find(Rom_Data(1:n,2) == c,1,'last'),1)';
    Rom_Data((n*1)+find(Rom_Data(n*1+1:n*2,2) == c,1,'first'):(n*1)+find(Rom_Data(n*1+1:n*2,2) == c,1,'last'),1)';
    Rom_Data((n*2)+find(Rom_Data(n*2+1:n*3,2) == c,1,'first'):(n*2)+find(Rom_Data(n*2+1:n*3,2) == c,1,'last'),1)';
    Rom_Data((n*3)+find(Rom_Data(n*3+1:n*4,2) == c,1,'first'):(n*3)+find(Rom_Data(n*3+1:n*4,2) == c,1,'last'),1)';
    Rom_Data((n*4)+find(Rom_Data(n*4+1:n*5,2) == c,1,'first'):(n*4)+find(Rom_Data(n*4+1:n*5,2) == c,1,'last'),1)';
    Rom_Data((n*5)+find(Rom_Data(n*5+1:n*6,2) == c,1,'first'):(n*5)+find(Rom_Data(n*5+1:n*6,2) == c,1,'last'),1)';
    Rom_Data((n*6)+find(Rom_Data(n*6+1:n*7,2) == c,1,'first'):(n*6)+find(Rom_Data(n*6+1:n*7,2) == c,1,'last'),1)';
    Rom_Data((n*7)+find(Rom_Data(n*7+1:n*8,2) == c,1,'first'):(n*7)+find(Rom_Data(n*7+1:n*8,2) == c,1,'last'),1)';
    Rom_Data((n*8)+find(Rom_Data(n*8+1:n*9,2) == c,1,'first'):(n*8)+find(Rom_Data(n*8+1:n*9,2) == c,1,'last'),1)';
    Rom_Data((n*9)+find(Rom_Data(n*9+1:n*10,2) == c,1,'first'):(n*9)+find(Rom_Data(n*9+1:n*10,2) == c,1,'last'),1)';
    Rom_Data((n*10)+find(Rom_Data(n*10+1:n*11,2) == c,1,'first'):(n*10)+find(Rom_Data(n*10+1:n*11,2) == c,1,'last'),1)'];
[NHT_p, tbl, stats] = friedman(NHT_data);
% Use multcompare for post hoc tests
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% Display the results
tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])
% no significant relationships

%pool the data across all 4 trials because no significant diff
NHT_data_pooled = [NHT_data(:,[1 5 9]); NHT_data(:,[2 6 10]); NHT_data(:,[3 7 11]); NHT_data(:,[4 8 12])];
[NHT_p, tbl, stats] = friedman(NHT_data_pooled);
% Use multcompare for post hoc tests
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% Display the results
tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])
%no significant realtionships 

%%Head tilts
c = 1;
HT_data = [Rom_Data(find(Rom_Data(1:n,2) == c,1,'first'):find(Rom_Data(1:n,2) == c,1,'last'),1)';
    Rom_Data((n*1)+find(Rom_Data(n*1+1:n*2,2) == c,1,'first'):(n*1)+find(Rom_Data(n*1+1:n*2,2) == c,1,'last'),1)';
    Rom_Data((n*2)+find(Rom_Data(n*2+1:n*3,2) == c,1,'first'):(n*2)+find(Rom_Data(n*2+1:n*3,2) == c,1,'last'),1)';
    Rom_Data((n*3)+find(Rom_Data(n*3+1:n*4,2) == c,1,'first'):(n*3)+find(Rom_Data(n*3+1:n*4,2) == c,1,'last'),1)';
    Rom_Data((n*4)+find(Rom_Data(n*4+1:n*5,2) == c,1,'first'):(n*4)+find(Rom_Data(n*4+1:n*5,2) == c,1,'last'),1)';
    Rom_Data((n*5)+find(Rom_Data(n*5+1:n*6,2) == c,1,'first'):(n*5)+find(Rom_Data(n*5+1:n*6,2) == c,1,'last'),1)';
    Rom_Data((n*6)+find(Rom_Data(n*6+1:n*7,2) == c,1,'first'):(n*6)+find(Rom_Data(n*6+1:n*7,2) == c,1,'last'),1)';
    Rom_Data((n*7)+find(Rom_Data(n*7+1:n*8,2) == c,1,'first'):(n*7)+find(Rom_Data(n*7+1:n*8,2) == c,1,'last'),1)';
    Rom_Data((n*8)+find(Rom_Data(n*8+1:n*9,2) == c,1,'first'):(n*8)+find(Rom_Data(n*8+1:n*9,2) == c,1,'last'),1)';
    Rom_Data((n*9)+find(Rom_Data(n*9+1:n*10,2) == c,1,'first'):(n*9)+find(Rom_Data(n*9+1:n*10,2) == c,1,'last'),1)';
    Rom_Data((n*10)+find(Rom_Data(n*10+1:n*11,2) == c,1,'first'):(n*10)+find(Rom_Data(n*10+1:n*11,2) == c,1,'last'),1)'];

[HT_p, tbl, stats] = friedman(HT_data);
% Use multcompare for post hoc tests
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% Display the results
tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])
% only trial 9 is signf different than some of the ones less than 8 (this
% makes sense as 9 is the first 999 GVS trial where everyone fell so it
% should be considered different than most other conditions where fewer or
% no people fell

% because no differences between the same condition type can pool across
% condition 
HT_data_pooled = [HT_data(:,[1 5 9]); HT_data(:,[2 6 10]); HT_data(:,[3 7 11]); HT_data(:,[4 8 12])];
[HT_p, tbl, stats] = friedman(HT_data_pooled);
% Use multcompare for post hoc tests
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% Display the results
tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])
% 999 GVS is significantly different from No GVS and 500 GVS

%%%%Parametric - NOT VALID %%%%%%%%%%%%%%%%
% % then convert the data into an array
ROM_Data_tbl = array2table(Rom_Data);
ROM_Data_tbl.Properties.VariableNames = {'FailTime', 'headTilt', 'GVS', 'Order', 'Subj'};
% % make indep. var's categorical 
% ROM_Data_tbl.headTilt = categorical(ROM_Data_tbl.headTilt);
% ROM_Data_tbl.GVS = categorical(ROM_Data_tbl.GVS);
% ROM_Data_tbl.Order = categorical(ROM_Data_tbl.Order);
% ROM_Data_tbl.Subj = categorical(ROM_Data_tbl.Subj);
% % create linear mixed effect model with dependent ~ independent (1|Var) =
% % random effects (so our within subjects) 
% lme = fitlme(ROM_Data_tbl,'FailTime ~ headTilt + GVS*headTilt + Order + (1|Subj)','FitMethod','REML','DummyVarCoding','effects'); % can also add GVS*Order, but the effect is not significant, so should probably exclude
% ROM_FT_AN = anova(lme) % left the ; off so that it prints the results to the command window
% H = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0;
%     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
% [pVal,F,DF1,DF2] = coefTest(lme,H)
% H = [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
%     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0;
%     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
% [pVal,F,DF1,DF2] = coefTest(lme,H)
% H = [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
%     0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;
%     0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
% [pVal,F,DF1,DF2] = coefTest(lme,H)
% % anova_FT = anovan(Rom_Data(:,1),{num2str(Rom_Data(:,2)),num2str(Rom_Data(:,3)),num2str(Rom_Data(:,4))},'model','interaction','varnames',{'Head Tilt','GVS Admin','Trial Order'});


%% Tandem
Tan_Data = analyzeTandem('ExcelData_Cut_ALL.mat',0);
% first add a subject column to the data
subj = cat(1, ones(12,1), ones(12,1)*2, ones(12,1)*3, ones(12,1)*4, ones(12,1)*5, ...
    ones(12,1)*6, ones(12,1)*7, ones(12,1)*8, ones(12,1)*9, ones(12,1)*10, ones(12,1)*11);
Tan_Data = [Tan_Data,subj];
% Check Normality
%%Create difference array
n = 12;
diffArray = cat(1,(Tan_Data(1:n,1)- mean(Tan_Data(1:n,1))), ...
    (Tan_Data(n*1+1:n*2,1)- mean(Tan_Data(n*1+1:n*2,1))),(Tan_Data(n*2+1:n*3,1)- mean(Tan_Data(n*2+1:n*3,1))), ...
    (Tan_Data(n*3+1:n*4,1)-mean(Tan_Data(n*3+1:n*4,1))),(Tan_Data(n*4+1:n*5,1)- mean(Tan_Data(n*4+1:n*5,1))), ...
    (Tan_Data(n*5+1:n*6,1)-mean(Tan_Data(n*5+1:n*6,1))),...
    (Tan_Data(n*6+1:n*7,1)-mean(Tan_Data(n*6+1:n*7,1))),(Tan_Data(n*7+1:n*8,1)-mean(Tan_Data(n*7+1:n*8,1))), ...
    (Tan_Data(n*8+1:n*9,1)-mean(Tan_Data(n*8+1:n*9,1))),(Tan_Data(n*9+1:n*10,1)-mean(Tan_Data(n*9+1:n*10,1))), ...
    (Tan_Data(n*10+1:n*11,1)-mean(Tan_Data(n*10+1:n*11,1))));
% diffArray = cat(1,diff(Tan_Data(1:n,1)),diff(Tan_Data(n*1+1:n*2,1)),diff(Tan_Data(n*2+1:n*3,1)),diff(Tan_Data(n*3+1:n*4,1)),diff(Tan_Data(n*4+1:n*5,1)),diff(Tan_Data(n*5+1:n*6,1)),...
%     diff(Tan_Data(n*6+1:n*7,1)),diff(Tan_Data(n*7+1:n*8,1)),diff(Tan_Data(n*8+1:n*9,1)),diff(Tan_Data(n*9+1:n*10,1)),diff(Tan_Data(n*10+1:n*11,1)));
[H, pValue, W] = swtest(diffArray,0.05)
figure();
qqplot(diffArray);title('QQ Plot for Tandem Completion Time')
%%Create difference array
n = 12;
diffArray = cat(1,(Tan_Data(1:n,2)- mean(Tan_Data(1:n,2))), ...
    (Tan_Data(n*1+1:n*2,2)- mean(Tan_Data(n*1+1:n*2,2))),(Tan_Data(n*2+1:n*3,2)- mean(Tan_Data(n*2+1:n*3,2))), ...
    (Tan_Data(n*3+1:n*4,2)-mean(Tan_Data(n*3+1:n*4,2))),(Tan_Data(n*4+1:n*5,2)- mean(Tan_Data(n*4+1:n*5,2))), ...
    (Tan_Data(n*5+1:n*6,2)-mean(Tan_Data(n*5+1:n*6,2))),...
    (Tan_Data(n*6+1:n*7,2)-mean(Tan_Data(n*6+1:n*7,2))),(Tan_Data(n*7+1:n*8,2)-mean(Tan_Data(n*7+1:n*8,2))), ...
    (Tan_Data(n*8+1:n*9,2)-mean(Tan_Data(n*8+1:n*9,2))),(Tan_Data(n*9+1:n*10,2)-mean(Tan_Data(n*9+1:n*10,2))), ...
    (Tan_Data(n*10+1:n*11,2)-mean(Tan_Data(n*10+1:n*11,2))));
% diffArray = cat(1,diff(Tan_Data(1:n,2)),diff(Tan_Data(n*1+1:n*2,2)),diff(Tan_Data(n*2+1:n*3,2)),diff(Tan_Data(n*3+1:n*4,2)),diff(Tan_Data(n*4+1:n*5,2)),diff(Tan_Data(n*5+1:n*6,2)),...
%     diff(Tan_Data(n*6+1:n*7,2)),diff(Tan_Data(n*7+1:n*8,2)),diff(Tan_Data(n*8+1:n*9,2)),diff(Tan_Data(n*9+1:n*10,2)),diff(Tan_Data(n*10+1:n*11,2)));
[H, pValue, W] = swtest(diffArray,0.05)
figure();
qqplot(diffArray);title('QQ Plot for Tandem Good Steps')
Zone = abs(Tan_Data);
diffArray = cat(1,(Zone(1:n,7)- mean(Zone(1:n,7))), ...
    (Zone(n*1+1:n*2,7)- mean(Zone(n*1+1:n*2,7))),(Zone(n*2+1:n*3,7)- mean(Zone(n*2+1:n*3,7))), ...
    (Zone(n*3+1:n*4,7)-mean(Zone(n*3+1:n*4,7))),(Zone(n*4+1:n*5,7)- mean(Zone(n*4+1:n*5,7))), ...
    (Zone(n*5+1:n*6,7)-mean(Zone(n*5+1:n*6,7))),...
    (Zone(n*6+1:n*7,7)-mean(Zone(n*6+1:n*7,7))),(Zone(n*7+1:n*8,7)-mean(Zone(n*7+1:n*8,7))), ...
    (Zone(n*8+1:n*9,7)-mean(Zone(n*8+1:n*9,7))),(Zone(n*9+1:n*10,7)-mean(Zone(n*9+1:n*10,7))), ...
    (Zone(n*10+1:n*11,7)-mean(Zone(n*10+1:n*11,7))));
% diffArray = cat(1,diff(Tan_Data(1:n,2)),diff(Tan_Data(n*1+1:n*2,2)),diff(Tan_Data(n*2+1:n*3,2)),diff(Tan_Data(n*3+1:n*4,2)),diff(Tan_Data(n*4+1:n*5,2)),diff(Tan_Data(n*5+1:n*6,2)),...
%     diff(Tan_Data(n*6+1:n*7,2)),diff(Tan_Data(n*7+1:n*8,2)),diff(Tan_Data(n*8+1:n*9,2)),diff(Tan_Data(n*9+1:n*10,2)),diff(Tan_Data(n*10+1:n*11,2)));
[H, pValue, W] = swtest(diffArray,0.05)
figure();
qqplot(diffArray);title('QQ Plot for Tandem Zone')


%%Begin Friedman Analysis
%%%Data Parsage
%%No Head tilts Eyes open
c = 0; %Head Tilt Condition
b = 1; %Eyes Condition
NHT_EO_Data = [Tan_Data(find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'first'):find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'last'),1)';
    Tan_Data((n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'first'):(n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'last'),1)';
    Tan_Data((n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'first'):(n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'last'),1)';
    Tan_Data((n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'first'):(n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'last'),1)';
    Tan_Data((n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'first'):(n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'last'),1)';
    Tan_Data((n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'first'):(n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'last'),1)';
    Tan_Data((n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'first'):(n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'last'),1)';
    Tan_Data((n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'first'):(n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'last'),1)';
    Tan_Data((n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'first'):(n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'last'),1)';
    Tan_Data((n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'first'):(n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'last'),1)';
    Tan_Data((n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'first'):(n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'last'),1)'];
%%Remove NaN Rows
idx = isnan(NHT_EO_Data(:,1));
NHT_EO_Data(idx,:) = [];
idx = isnan(NHT_EO_Data(:,2));
NHT_EO_Data(idx,:) = [];
idx = isnan(NHT_EO_Data(:,3));
NHT_EO_Data(idx,:) = [];
%%Friedman Analysis
[NHT_EO_p, tbl, stats] = friedman(NHT_EO_Data);
% Use multcompare for post hoc tests
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% Display the results
tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])

%%Head tilts Eyes open
c = 1; %Head Tilt Condition
b = 1; %Eyes Condition
HT_EO_Data = [Tan_Data(find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'first'):find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'last'),1)';
    Tan_Data((n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'first'):(n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'last'),1)';
    Tan_Data((n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'first'):(n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'last'),1)';
    Tan_Data((n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'first'):(n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'last'),1)';
    Tan_Data((n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'first'):(n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'last'),1)';
    Tan_Data((n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'first'):(n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'last'),1)';
    Tan_Data((n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'first'):(n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'last'),1)';
    Tan_Data((n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'first'):(n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'last'),1)';
    Tan_Data((n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'first'):(n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'last'),1)';
    Tan_Data((n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'first'):(n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'last'),1)';
    Tan_Data((n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'first'):(n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'last'),1)'];
%%Remove NaN Rows
idx = isnan(HT_EO_Data(:,1));
HT_EO_Data(idx,:) = [];
idx = isnan(HT_EO_Data(:,2));
HT_EO_Data(idx,:) = [];
idx = isnan(HT_EO_Data(:,3));
HT_EO_Data(idx,:) = [];
%%Friedman Analysis
[HT_EO_p, tbl, stats] = friedman(HT_EO_Data);
% Use multcompare for post hoc tests
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% Display the results
tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])

%%No Head tilts Eyes Closed
c = 0; %Head Tilt Condition
b = 0; %Eyes Condition
NHT_EC_Data = [Tan_Data(find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'first'):find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'last'),1)';
    Tan_Data((n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'first'):(n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'last'),1)';
    Tan_Data((n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'first'):(n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'last'),1)';
    Tan_Data((n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'first'):(n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'last'),1)';
    Tan_Data((n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'first'):(n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'last'),1)';
    Tan_Data((n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'first'):(n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'last'),1)';
    Tan_Data((n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'first'):(n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'last'),1)';
    Tan_Data((n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'first'):(n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'last'),1)';
    Tan_Data((n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'first'):(n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'last'),1)';
    Tan_Data((n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'first'):(n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'last'),1)';
    Tan_Data((n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'first'):(n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'last'),1)'];

%%Remove NaN Rows
idx = isnan(NHT_EC_Data(:,1));
NHT_EC_Data(idx,:) = [];
idx = isnan(NHT_EC_Data(:,2));
NHT_EC_Data(idx,:) = [];
idx = isnan(NHT_EC_Data(:,3));
NHT_EC_Data(idx,:) = [];
%%Friedman Analysis
[NHT_EC_p, tbl, stats] = friedman(NHT_EC_Data);
% Use multcompare for post hoc tests
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% Display the results
tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])

%%Head tilts Eyes Closed
c = 1; %Head Tilt Condition
b = 0; %Eyes Condition
HT_EC_Data = [Tan_Data(find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'first'):find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'last'),1)';
    Tan_Data((n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'first'):(n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'last'),1)';
    Tan_Data((n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'first'):(n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'last'),1)';
    Tan_Data((n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'first'):(n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'last'),1)';
    Tan_Data((n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'first'):(n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'last'),1)';
    Tan_Data((n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'first'):(n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'last'),1)';
    Tan_Data((n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'first'):(n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'last'),1)';
    Tan_Data((n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'first'):(n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'last'),1)';
    Tan_Data((n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'first'):(n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'last'),1)';
    Tan_Data((n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'first'):(n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'last'),1)';
    Tan_Data((n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'first'):(n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'last'),1)'];
%%Remove NaN Rows
idx = isnan(HT_EC_Data(:,1));
HT_EC_Data(idx,:) = [];
idx = isnan(HT_EC_Data(:,2));
HT_EC_Data(idx,:) = [];
idx = isnan(HT_EC_Data(:,3));
HT_EC_Data(idx,:) = [];
%%Friedman Analysis
[HT_EC_p , tbl, stats] = friedman(HT_EC_Data);
% Use multcompare for post hoc tests
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% Display the results
tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])
% significant difference between no GVS and 999 GVS - approaching signif
% for 500 and 999 GVS
%% Number of Good Steps
%%No Head tilts Eyes open
c = 0; %Head Tilt Condition
b = 1; %Eyes Condition
NHT_EO_Data = [Tan_Data(find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'first'):find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'last'),1)';
    Tan_Data((n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'first'):(n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'last'),1)';
    Tan_Data((n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'first'):(n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'last'),1)';
    Tan_Data((n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'first'):(n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'last'),1)';
    Tan_Data((n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'first'):(n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'last'),1)';
    Tan_Data((n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'first'):(n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'last'),1)';
    Tan_Data((n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'first'):(n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'last'),1)';
    Tan_Data((n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'first'):(n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'last'),1)';
    Tan_Data((n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'first'):(n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'last'),1)';
    Tan_Data((n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'first'):(n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'last'),1)';
    Tan_Data((n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'first'):(n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'last'),2)'];
NHT_EO_Data = [Tan_Data([1 2 3],2)'; Tan_Data([13 14 15],2)'; Tan_Data([25 26 27],2)'; ...
    Tan_Data([37 38 39],2)'; Tan_Data([49 50 51],2)'; Tan_Data([61 62 63],2)'; ...
    Tan_Data([73 74 75],2)'; Tan_Data([85 86 87],2)'; ...
    Tan_Data([97 98 99],2)'; Tan_Data([109 110 111],2)';Tan_Data([121 122 123],2)'];
%%Remove NaN Rows
idx = isnan(NHT_EO_Data(:,1));
NHT_EO_Data(idx,:) = [];
idx = isnan(NHT_EO_Data(:,2));
NHT_EO_Data(idx,:) = [];
idx = isnan(NHT_EO_Data(:,3));
NHT_EO_Data(idx,:) = [];
%%Friedman Analysis
[NHT_EO_p, tbl, stats] = friedman(NHT_EO_Data);
% Use multcompare for post hoc tests
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% Display the results
tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])
% No significant diff

%%Head tilts Eyes open
c = 1; %Head Tilt Condition
b = 1; %Eyes Condition
HT_EO_Data = [Tan_Data(find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'first'):find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'last'),1)';
    Tan_Data((n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'first'):(n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'last'),1)';
    Tan_Data((n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'first'):(n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'last'),1)';
    Tan_Data((n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'first'):(n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'last'),1)';
    Tan_Data((n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'first'):(n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'last'),1)';
    Tan_Data((n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'first'):(n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'last'),1)';
    Tan_Data((n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'first'):(n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'last'),1)';
    Tan_Data((n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'first'):(n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'last'),1)';
    Tan_Data((n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'first'):(n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'last'),1)';
    Tan_Data((n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'first'):(n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'last'),1)';
    Tan_Data((n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'first'):(n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'last'),2)'];
HT_EO_Data = [Tan_Data([4:6],2)'; Tan_Data([16:18],2)'; Tan_Data([28:30],2)'; ...
    Tan_Data([40:42],2)'; Tan_Data([52:54],2)'; Tan_Data([64:66],2)'; ...
    Tan_Data([76:78],2)'; Tan_Data([88:90],2)'; ...
    Tan_Data([100:102],2)'; Tan_Data([112:114],2)';Tan_Data([124:126],2)'];

%%Remove NaN Rows
idx = isnan(HT_EO_Data(:,1));
HT_EO_Data(idx,:) = [];
idx = isnan(HT_EO_Data(:,2));
HT_EO_Data(idx,:) = [];
idx = isnan(HT_EO_Data(:,3));
HT_EO_Data(idx,:) = [];
%%Friedman Analysis
[HT_EO_p, tbl, stats] = friedman(HT_EO_Data);
% Use multcompare for post hoc tests - not sure if this is valid if not
% normally distributed
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% need to use wilcoxon signed rank test instead - correction factor
% calculated manually based on the number of comparisons
% 3 corrections so multipy p by 3
bonf_corr = 3;
p_TDM_HT_EO_0_500 = signrank(HT_EO_Data(:,1),HT_EO_Data(:,2))*3;
p_TDM_HT_EO_0_999 = signrank(HT_EO_Data(:,1),HT_EO_Data(:,3))*3;
p_TDM_HT_EO_500_999 = signrank(HT_EO_Data(:,2),HT_EO_Data(:,3))*3;

% Display the results
tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])
%significant difference between 500 GVS and 999 GVS

%%No Head tilts Eyes Closed
c = 0; %Head Tilt Condition
b = 0; %Eyes Condition
NHT_EC_Data = [Tan_Data(find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'first'):find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'last'),1)';
    Tan_Data((n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'first'):(n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'last'),1)';
    Tan_Data((n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'first'):(n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'last'),1)';
    Tan_Data((n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'first'):(n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'last'),1)';
    Tan_Data((n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'first'):(n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'last'),1)';
    Tan_Data((n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'first'):(n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'last'),1)';
    Tan_Data((n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'first'):(n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'last'),1)';
    Tan_Data((n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'first'):(n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'last'),1)';
    Tan_Data((n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'first'):(n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'last'),1)';
    Tan_Data((n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'first'):(n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'last'),1)';
    Tan_Data((n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'first'):(n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'last'),2)'];
NHT_EC_Data = [Tan_Data([7:9],2)'; Tan_Data([19:21],2)'; Tan_Data([31:33],2)'; ...
    Tan_Data([43:45],2)'; Tan_Data([55:57],2)'; Tan_Data([67:69],2)'; ...
    Tan_Data([79:81],2)'; Tan_Data([91:93],2)'; ...
    Tan_Data([103:105],2)'; Tan_Data([115:117],2)';Tan_Data([127:129],2)'];
%%Remove NaN Rows
idx = isnan(NHT_EC_Data(:,1));
NHT_EC_Data(idx,:) = [];
idx = isnan(NHT_EC_Data(:,2));
NHT_EC_Data(idx,:) = [];
idx = isnan(NHT_EC_Data(:,3));
NHT_EC_Data(idx,:) = [];
%%Friedman Analysis
[NHT_EC_p, tbl, stats] = friedman(NHT_EC_Data);
% % Use multcompare for post hoc tests -
% [c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% use manually corrected Wilcoxn signed rank tests
bonf_corr = 3;
p_TDM_NHT_EC_0_500 = signrank(NHT_EC_Data(:,1),HT_EO_Data(:,2))*3;
p_TDM_NHT_EC_0_999 = signrank(NHT_EC_Data(:,1),HT_EO_Data(:,3))*3;
p_TDM_NHT_EC_500_999 = signrank(NHT_EC_Data(:,2),HT_EO_Data(:,3))*3;
% Display the results
% tbl = array2table(c,"VariableNames", ...
    % ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])
%no significance

%%Head tilts Eyes Closed
c = 1; %Head Tilt Condition
b = 0; %Eyes Condition
HT_EC_Data = [Tan_Data(find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'first'):find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'last'),1)';
    Tan_Data((n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'first'):(n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'last'),1)';
    Tan_Data((n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'first'):(n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'last'),1)';
    Tan_Data((n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'first'):(n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'last'),1)';
    Tan_Data((n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'first'):(n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'last'),1)';
    Tan_Data((n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'first'):(n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'last'),1)';
    Tan_Data((n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'first'):(n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'last'),1)';
    Tan_Data((n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'first'):(n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'last'),1)';
    Tan_Data((n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'first'):(n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'last'),1)';
    Tan_Data((n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'first'):(n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'last'),1)';
    Tan_Data((n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'first'):(n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'last'),2)'];
HT_EC_Data = [Tan_Data([10:12],2)'; Tan_Data([22:24],2)'; Tan_Data([34:36],2)'; ...
    Tan_Data([46:48],2)'; Tan_Data([58:60],2)'; Tan_Data([70:72],2)'; ...
    Tan_Data([82:84],2)'; Tan_Data([94:96],2)'; ...
    Tan_Data([106:108],2)'; Tan_Data([118:120],2)';Tan_Data([130:132],2)'];
%%Remove NaN Rows
idx = isnan(HT_EC_Data(:,1));
HT_EC_Data(idx,:) = [];
idx = isnan(HT_EC_Data(:,2));
HT_EC_Data(idx,:) = [];
idx = isnan(HT_EC_Data(:,3));
HT_EC_Data(idx,:) = [];
%%Friedman Analysis
[HT_EC_p , tbl, stats] = friedman(HT_EC_Data);
% % Use multcompare for post hoc tests
% [c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');

% use manually corrected Wilcoxn signed rank tests
bonf_corr = 3;
p_TDM_HT_EC_0_500 = signrank(HT_EC_Data(:,1),HT_EO_Data(:,2))*3;
p_TDM_HT_EC_0_999 = signrank(HT_EC_Data(:,1),HT_EO_Data(:,3))*3;
p_TDM_HT_EC_500_999 = signrank(HT_EC_Data(:,2),HT_EO_Data(:,3))*3;
% Display the results
% tbl = array2table(c,"VariableNames", ...
%     ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])
% significant difference between 500 GVS and 999 GVS, approaching signif
% for No GVS and 999 GVS


%% Zone
%%No Head tilts Eyes open
c = 0; %Head Tilt Condition
b = 1; %Eyes Condition
NHT_EO_Data = [Tan_Data(find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'first'):find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'last'),1)';
    Tan_Data((n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'first'):(n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'last'),1)';
    Tan_Data((n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'first'):(n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'last'),1)';
    Tan_Data((n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'first'):(n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'last'),1)';
    Tan_Data((n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'first'):(n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'last'),1)';
    Tan_Data((n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'first'):(n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'last'),1)';
    Tan_Data((n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'first'):(n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'last'),1)';
    Tan_Data((n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'first'):(n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'last'),1)';
    Tan_Data((n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'first'):(n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'last'),1)';
    Tan_Data((n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'first'):(n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'last'),1)';
    Tan_Data((n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'first'):(n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'last'),2)'];
NHT_EO_Data = [Zone([1 2 3],7)'; Zone([13 14 15],7)'; Zone([25 26 27],7)'; ...
    Zone([37 38 39],7)'; Zone([49 50 51],7)'; Zone([61 62 63],7)'; ...
    Zone([73 74 75],7)'; Zone([85 86 87],7)'; ...
    Zone([97 98 99],7)'; Zone([109 110 111],7)';Zone([121 122 123],7)'];
%%Remove NaN Rows
idx = isnan(NHT_EO_Data(:,1));
NHT_EO_Data(idx,:) = [];
idx = isnan(NHT_EO_Data(:,2));
NHT_EO_Data(idx,:) = [];
idx = isnan(NHT_EO_Data(:,3));
NHT_EO_Data(idx,:) = [];
%%Friedman Analysis
[NHT_EO_p, tbl, stats] = friedman(NHT_EO_Data);
% Use multcompare for post hoc tests
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% Display the results
tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])
% No significant diff

%%Head tilts Eyes open
c = 1; %Head Tilt Condition
b = 1; %Eyes Condition
HT_EO_Data = [Tan_Data(find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'first'):find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'last'),1)';
    Tan_Data((n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'first'):(n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'last'),1)';
    Tan_Data((n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'first'):(n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'last'),1)';
    Tan_Data((n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'first'):(n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'last'),1)';
    Tan_Data((n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'first'):(n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'last'),1)';
    Tan_Data((n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'first'):(n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'last'),1)';
    Tan_Data((n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'first'):(n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'last'),1)';
    Tan_Data((n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'first'):(n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'last'),1)';
    Tan_Data((n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'first'):(n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'last'),1)';
    Tan_Data((n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'first'):(n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'last'),1)';
    Tan_Data((n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'first'):(n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'last'),2)'];
HT_EO_Data = [Zone([4:6],7)'; Zone([16:18],7)'; Zone([28:30],7)'; ...
    Zone([40:42],7)'; Zone([52:54],7)'; Zone([64:66],7)'; ...
    Zone([76:78],7)'; Zone([88:90],7)'; ...
    Zone([100:102],7)'; Zone([112:114],7)';Zone([124:126],7)'];

%%Remove NaN Rows
idx = isnan(HT_EO_Data(:,1));
HT_EO_Data(idx,:) = [];
idx = isnan(HT_EO_Data(:,2));
HT_EO_Data(idx,:) = [];
idx = isnan(HT_EO_Data(:,3));
HT_EO_Data(idx,:) = [];
%%Friedman Analysis
[HT_EO_p, tbl, stats] = friedman(HT_EO_Data);
% Use multcompare for post hoc tests
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% Display the results
tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])
%no significance

%%No Head tilts Eyes Closed
c = 0; %Head Tilt Condition
b = 0; %Eyes Condition
NHT_EC_Data = [Tan_Data(find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'first'):find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'last'),1)';
    Tan_Data((n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'first'):(n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'last'),1)';
    Tan_Data((n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'first'):(n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'last'),1)';
    Tan_Data((n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'first'):(n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'last'),1)';
    Tan_Data((n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'first'):(n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'last'),1)';
    Tan_Data((n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'first'):(n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'last'),1)';
    Tan_Data((n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'first'):(n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'last'),1)';
    Tan_Data((n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'first'):(n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'last'),1)';
    Tan_Data((n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'first'):(n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'last'),1)';
    Tan_Data((n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'first'):(n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'last'),1)';
    Tan_Data((n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'first'):(n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'last'),2)'];
NHT_EC_Data = [Zone([7:9],7)'; Zone([19:21],7)'; Zone([31:33],7)'; ...
    Zone([43:45],7)'; Zone([55:57],7)'; Zone([67:69],7)'; ...
    Zone([79:81],7)'; Zone([91:93],7)'; ...
    Zone([103:105],7)'; Zone([115:117],7)';Zone([127:129],7)'];
%%Remove NaN Rows
idx = isnan(NHT_EC_Data(:,1));
NHT_EC_Data(idx,:) = [];
idx = isnan(NHT_EC_Data(:,2));
NHT_EC_Data(idx,:) = [];
idx = isnan(NHT_EC_Data(:,3));
NHT_EC_Data(idx,:) = [];
%%Friedman Analysis
[NHT_EC_p, tbl, stats] = friedman(NHT_EC_Data);
% Use multcompare for post hoc tests
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% Display the results
tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])
%no significance

%%Head tilts Eyes Closed
c = 1; %Head Tilt Condition
b = 0; %Eyes Condition
HT_EC_Data = [Tan_Data(find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'first'):find((Tan_Data(1:n,4) == c & Tan_Data(1:n,3) == b),1,'last'),1)';
    Tan_Data((n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'first'):(n*1)+find((Tan_Data(n*1+1:n*2,4) == c & Tan_Data(n*1+1:n*2,3) == b),1,'last'),1)';
    Tan_Data((n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'first'):(n*2)+find((Tan_Data(n*2+1:n*3,4) == c & Tan_Data(n*2+1:n*3,3) == b),1,'last'),1)';
    Tan_Data((n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'first'):(n*3)+find((Tan_Data(n*3+1:n*4,4) == c & Tan_Data(n*3+1:n*4,3) == b),1,'last'),1)';
    Tan_Data((n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'first'):(n*4)+find((Tan_Data(n*4+1:n*5,4) == c & Tan_Data(n*4+1:n*5,3) == b),1,'last'),1)';
    Tan_Data((n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'first'):(n*5)+find((Tan_Data(n*5+1:n*6,4) == c & Tan_Data(n*5+1:n*6,3) == b),1,'last'),1)';
    Tan_Data((n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'first'):(n*6)+find((Tan_Data(n*6+1:n*7,4) == c & Tan_Data(n*6+1:n*7,3) == b),1,'last'),1)';
    Tan_Data((n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'first'):(n*7)+find((Tan_Data(n*7+1:n*8,4) == c & Tan_Data(n*7+1:n*8,3) == b),1,'last'),1)';
    Tan_Data((n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'first'):(n*8)+find((Tan_Data(n*8+1:n*9,4) == c & Tan_Data(n*8+1:n*9,3) == b),1,'last'),1)';
    Tan_Data((n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'first'):(n*9)+find((Tan_Data(n*9+1:n*10,4) == c & Tan_Data(n*9+1:n*10,3) == b),1,'last'),1)';
    Tan_Data((n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'first'):(n*10)+find((Tan_Data(n*10+1:n*11,4) == c & Tan_Data(n*10+1:n*11,3) == b),1,'last'),2)'];
HT_EC_Data = [Zone([10:12],7)'; Zone([22:24],7)'; Zone([34:36],7)'; ...
    Zone([46:48],7)'; Zone([58:60],7)'; Zone([70:72],7)'; ...
    Zone([82:84],7)'; Zone([94:96],7)'; ...
    Zone([106:108],7)'; Zone([118:120],7)';Zone([130:132],7)'];
%%Remove NaN Rows
idx = isnan(HT_EC_Data(:,1));
HT_EC_Data(idx,:) = [];
idx = isnan(HT_EC_Data(:,2));
HT_EC_Data(idx,:) = [];
idx = isnan(HT_EC_Data(:,3));
HT_EC_Data(idx,:) = [];
%%Friedman Analysis
[HT_EC_p , tbl, stats] = friedman(HT_EC_Data);
% Use multcompare for post hoc tests
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
% Display the results
tbl = array2table(c,"VariableNames", ...
    ["Group","Control Group","Lower Limit","Difference","Upper Limit","P-value"])
% no significance

%%
%%%%Parametric - NOT VALID FOR GOOD STEPS %%%%%%%%%%%%%%%%
% % then convert the data into an array
Tan_Data_tbl = array2table(Tan_Data);
Tan_Data_tbl.Properties.VariableNames = {'testTime', 'goodSteps','eyesOpen','headTilt', 'GVS', 'Order', 'Subj','zoneFinish'};
% make indep. var's categorical 
Tan_Data_tbl.eyesOpen = categorical(Tan_Data_tbl.eyesOpen);
Tan_Data_tbl.headTilt = categorical(Tan_Data_tbl.headTilt);
Tan_Data_tbl.GVS = categorical(Tan_Data_tbl.GVS);
Tan_Data_tbl.Order = categorical(Tan_Data_tbl.Order);
Tan_Data_tbl.Subj = categorical(Tan_Data_tbl.Subj);
% create linear mixed effect model with dependent ~ independent (1|Var) =
% random effects (so our within subjects) 
lme_model = fitlme(Tan_Data_tbl,'testTime ~ headTilt + eyesOpen + GVS*headTilt*eyesOpen + Order + (1|Subj)','FitMethod','REML','DummyVarCoding','effects'); % can also add GVS*Order, but the effect is not significant, so should probably exclude
Tan_TT_AN = anova(lme_model) % left the ; off so that it prints the results to the command window
ind_model = fitlme(Tan_Data_tbl, 'testTime ~ headTilt + eyesOpen + Order + GVS + (1|Subj)', 'FitMethod', 'REML', 'DummyVarCoding', 'effects');
Tan_TT_AN = anova(int_model) % left the ; off so that it prints the results to the command window
% Refit the model without the non-significant terms
lme_simplified = fitlme(Tan_Data_tbl, 'testTime ~ headTilt + eyesOpen + GVS*headTilt*eyesOpen + (1|Subj)', 'FitMethod', 'REML', 'DummyVarCoding', 'effects');
Tan_TT_AN = anova(lme_simplified) % left the ; off so that it prints the results to the command window
%%%Post-HOC Correlation
% Compare the two models
compare(lme_simplified,lme_model)
%%%%%%%This shows that the lme model better describes the data set
compare(lme_model,ind_model)
%%%%%%%This shows that the lme model better describes the data set
%%%Final anova
Tan_TT_AN = anova(lme_model) % left the ; off so that it prints the results to the command window


% Define custom contrasts for pairwise comparisons

% Define custom contrasts for pairwise comparisons

% Main effects for categorical variables
contrast1 = [0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % Compare eyesOpen_0 and headtilt_0
contrast2 = [0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % Compare eyesOpen_0 and GVS_0
contrast3 = [0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % Compare headtilt_0 and GVS_0
contrast4 = [0 1 0 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % Compare eyesOpen_0 and GVS_500
contrast5 = [0 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % Compare headtilt_0 and GVS_500
contrast6 = [0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % Compare GVS_0 and GVS_500


% Perform custom contrasts
contrast_results1 = coefTest(lme_model, contrast1);
contrast_results2 = coefTest(lme_model, contrast2);
contrast_results3 = coefTest(lme_model, contrast3);
contrast_results4 = coefTest(lme_model, contrast4);
contrast_results5 = coefTest(lme_model, contrast5);
contrast_results6 = coefTest(lme_model, contrast6);

% Display contrast results
disp(contrast_results1);
disp(contrast_results2);
disp(contrast_results3);
disp(contrast_results4);
disp(contrast_results5);
disp(contrast_results6);


