% Main Script
clc;clear;close all;

% Aggregate Data
<<<<<<< Updated upstream
TTS_GVS_Aggregate_Final
save("DynamicData.mat") % Save Aggregate Data to .mat
=======
TTS_GVS_GainAdjust_Final
TTS_GVS_Aggregate_Final

% Save Aggregate Data to .mat
DataName = "DynamicDataGain.mat";
save("./data/"+DataName) 

%% Load
Var = load("./data/"+DataName);
>>>>>>> Stashed changes

% Plot Data
PlotGroupPerceptions('Angle')
PlotGroupPerceptions('Semi')
PlotGroupPerceptions('Velocity')

<<<<<<< Updated upstream
PlotGroupGainScatter('Angle')
PlotGroupGainScatter('Semi')
PlotGroupGainScatter('Velocity')

% Compute Metrics (store in csv)
MetricCompute_Gain("AngleGain")
MetricCompute_Gain("CurrentGain")
=======
% for i = 1:12
%     PlotIndPerceptions(Var,i)
% end
PlotNoGVSGroupPerceptions(Var)

% % Compute Metrics (store in .csv)
% MetricCompute_Gain("AngleGain",Var)
% MetricCompute_Gain("CurrentGain",Var)

%% Plots for Paper
% Figure 1
Var = load("./data/"+DataName);
Figure1b(Var)
>>>>>>> Stashed changes
