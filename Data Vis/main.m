%%Timothy Behrer
%% HouseKeeping
clc; clear; close all;
%% Main Script


%% FMT
FMT_Data = analyzeFMT('ExcelData_Cut_ALL.mat',0,0);

% this was for my attempt at using ranova and needing to reformat the data
% FMT_Data_RM_RT = NaN(11,18);
% for ii = 1:length(FMT_Data)
%     current_sub = ceil(ii/6);
%     if FMT_Data(ii,4) == 0
%         combo = FMT_Data(ii,5);
%     elseif FMT_Data(ii,4) == 500
%          combo = FMT_Data(ii,5)+6;
%     elseif FMT_Data(ii,4) == 999
%         combo = FMT_Data(ii,5)+12;
%     end
% 
%     FMT_Data_RM_RT(current_sub,combo) = FMT_Data(ii,1);
% 
%     % FMT_DATA_RM = table(FMT_Data((6*ii - 5):(6*ii),:)',...
%         % 'VariableNames',{'Raw Time'});
% end

% first add a subject column to the data
subj = cat(1, ones(6,1), ones(6,1)*2, ones(6,1)*3, ones(6,1)*4, ones(6,1)*5, ...
    ones(6,1)*6, ones(6,1)*7, ones(6,1)*8, ones(6,1)*9, ones(6,1)*10, ones(6,1)*11);
FMT_Data = [FMT_Data,subj];
% then convert the data into an array
FMT_Data_tbl = array2table(FMT_Data);
FMT_Data_tbl.Properties.VariableNames = {'RawTime', 'Errors', 'CorrectedTime', 'GVS', 'Order', 'Subj'};
% make indep. var's categorical 
FMT_Data_tbl.GVS = categorical(FMT_Data_tbl.GVS);
FMT_Data_tbl.Order = categorical(FMT_Data_tbl.Order);
FMT_Data_tbl.Subj = categorical(FMT_Data_tbl.Subj);

% create linear mixed effect model with dependent ~ independent (1|Var) =
% random effects (so our within subjects) 
lme = fitlme(FMT_Data_tbl,'RawTime ~ GVS + Order + (1|Subj)','FitMethod','REML','DummyVarCoding','effects'); % can also add GVS*Order, but the effect is not significant, so should probably exclude
FMT_RT_AN = anova(lme) % left the ; off so that it prints the results to the command window
lme = fitlme(FMT_Data_tbl,'Errors ~ GVS + Order + (1|Subj)','FitMethod','REML','DummyVarCoding','effects'); % can also add GVS*Order, but the effect is not significant, so should probably exclude
FMT_ER_AN = anova(lme) % left the ; off so that it prints the results to the command window
lme = fitlme(FMT_Data_tbl,'CorrectedTime ~ GVS + Order + (1|Subj)','FitMethod','REML','DummyVarCoding','effects'); % can also add GVS*Order, but the effect is not significant, so should probably exclude
FMT_NT_AN = anova(lme) % left the ; off so that it prints the results to the command window

% %this was me checking single effects models but they are set up pretty
% %much the same way
% lme = fitlme(FMT_Data_tbl,'RawTime ~ GVS  + (1|Subj)','FitMethod','REML','DummyVarCoding','effects');
% FMT_RT_AN2 = anova(lme)
% lme = fitlme(FMT_Data_tbl,'RawTime ~  Order +  (1|Subj)','FitMethod','REML','DummyVarCoding','effects');
% FMT_RT_AN3 = anova(lme)

% % this was my attempt at using ranova but I think it didn't work because
% we don't have all the OrderXGVS combos (ie. not enough data)
% dv = array2table(FMT_Data_RM_RT);
% dv.Properties.VariableNames = {'A1_000', 'A2_000', 'A3_000', 'A4_000', 'A5_000', 'A6_000', 'A1_500', 'A2_500', 'A3_500', 'A4_500', 'A5_500', 'A6_500', 'A1_999', 'A2_999', 'A3_999', 'A4_999', 'A5_999', 'A6_999' };
% % create the within-subjects design
% withinDesign = table([1 2 3 4 5 6 1 2 3 4 5 6 1 2 3 4 5 6]',[1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3]','VariableNames',{'Order','GVS'});
% withinDesign.Order = categorical(withinDesign.Order);
% withinDesign.GVS = categorical(withinDesign.GVS);
% 
% rm = fitrm(dv, "A1_000-A6_999 ~ 1", 'WithinDesign', withinDesign);
% AT = ranova(rm,'WithinModel', 'Order*GVS')

% %This is my attempt at using the anovan, but I don't think it works right
% %unless I make the order variable continuous which it is not
% subj = cat(1, ones(6,1), ones(6,1)*2, ones(6,1)*3, ones(6,1)*4, ones(6,1)*5, ones(6,1)*6, ones(6,1)*7, ones(6,1)*8, ones(6,1)*9, ones(6,1)*10, ones(6,1)*11);
% 
% anovan(FMT_Data(:,1),{num2str(FMT_Data(:,4)),subj},'model',1,'random',2,'varnames',{'GVS','Subj'});
% anovan(FMT_Data(:,1),{num2str(FMT_Data(:,5)),subj},'model',1,'random',2,'varnames',{'Order','Subj'});
% anovan(FMT_Data(:,1),{(FMT_Data(:,5)),(FMT_Data(:,4)),subj},'model','interaction','continuous',[1],'random',3,'varnames',{'Order','GVS','Subj'});

% anova_RT = anovan(FMT_Data(:,1),{num2str(FMT_Data(:,4)),num2str(FMT_Data(:,5))},'model','interaction','varnames',{'GVS Admin','Trial Order'});
% anova_ER = anovan(FMT_Data(:,2),{num2str(FMT_Data(:,4)),num2str(FMT_Data(:,5))},'model','interaction','varnames',{'GVS Admin','Trial Order'});
% anova_NT = anovan(FMT_Data(:,3),{num2str(FMT_Data(:,4)),num2str(FMT_Data(:,5))},'model','interaction','varnames',{'GVS Admin','Trial Order'});
%% Romberg
Rom_Data = analyzeRomberg('ExcelData_Cut_ALL.mat',0);
% first add a subject column to the data
subj = cat(1, ones(24,1), ones(24,1)*2, ones(24,1)*3, ones(24,1)*4, ones(24,1)*5, ...
    ones(24,1)*6, ones(24,1)*7, ones(24,1)*8, ones(24,1)*9, ones(24,1)*10, ones(24,1)*11);
Rom_Data = [Rom_Data,subj];
% then convert the data into an array
ROM_Data_tbl = array2table(Rom_Data);
ROM_Data_tbl.Properties.VariableNames = {'FailTime', 'headTilt', 'GVS', 'Order', 'Subj'};
% make indep. var's categorical 
ROM_Data_tbl.headTilt = categorical(ROM_Data_tbl.headTilt);
ROM_Data_tbl.GVS = categorical(ROM_Data_tbl.GVS);
ROM_Data_tbl.Order = categorical(ROM_Data_tbl.Order);
ROM_Data_tbl.Subj = categorical(ROM_Data_tbl.Subj);
% create linear mixed effect model with dependent ~ independent (1|Var) =
% random effects (so our within subjects) 
lme = fitlme(ROM_Data_tbl,'FailTime ~ headTilt + GVS*headTilt + Order + (1|Subj)','FitMethod','REML','DummyVarCoding','effects'); % can also add GVS*Order, but the effect is not significant, so should probably exclude
ROM_FT_AN = anova(lme) % left the ; off so that it prints the results to the command window

% anova_FT = anovan(Rom_Data(:,1),{num2str(Rom_Data(:,2)),num2str(Rom_Data(:,3)),num2str(Rom_Data(:,4))},'model','interaction','varnames',{'Head Tilt','GVS Admin','Trial Order'});


%% Tandem
Tan_Data = analyzeTandem('ExcelData_Cut_ALL.mat',0);
% first add a subject column to the data
subj = cat(1, ones(12,1), ones(12,1)*2, ones(12,1)*3, ones(12,1)*4, ones(12,1)*5, ...
    ones(12,1)*6, ones(12,1)*7, ones(12,1)*8, ones(12,1)*9, ones(12,1)*10, ones(12,1)*11);
Tan_Data = [Tan_Data,subj];
% then convert the data into an array
Tan_Data_tbl = array2table(Tan_Data);
Tan_Data_tbl.Properties.VariableNames = {'testTime', 'goodSteps','eyesOpen','headTilt', 'GVS', 'Order', 'Subj'};
% make indep. var's categorical 
Tan_Data_tbl.eyesOpen = categorical(Tan_Data_tbl.eyesOpen);
Tan_Data_tbl.headTilt = categorical(Tan_Data_tbl.headTilt);
Tan_Data_tbl.GVS = categorical(Tan_Data_tbl.GVS);
Tan_Data_tbl.Order = categorical(Tan_Data_tbl.Order);
Tan_Data_tbl.Subj = categorical(Tan_Data_tbl.Subj);
% create linear mixed effect model with dependent ~ independent (1|Var) =
% random effects (so our within subjects) 
lme = fitlme(Tan_Data_tbl,'testTime ~ headTilt + eyesOpen + GVS*headTilt*eyesOpen + Order + (1|Subj)','FitMethod','REML','DummyVarCoding','effects'); % can also add GVS*Order, but the effect is not significant, so should probably exclude
Tan_TT_AN = anova(lme) % left the ; off so that it prints the results to the command window
lme = fitlme(Tan_Data_tbl,'goodSteps ~ headTilt + eyesOpen + GVS*headTilt*eyesOpen + Order + (1|Subj)','FitMethod','REML','DummyVarCoding','effects'); % can also add GVS*Order, but the effect is not significant, so should probably exclude
Tan_GS_AN = anova(lme) % left the ; off so that it prints the results to the command window

