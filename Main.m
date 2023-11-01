% Main Script
clc;clear;close all;

%%
% PreProcess
% Aggregate Data
TTS_GVS_GainAdjust_Final
TTS_GVS_Aggregate_Final

% Save Aggregate Data to .mat
DataName = "DynamicDataGain.mat";
save("./data/"+DataName) 

%% Load
Var = load("./data/"+DataName);

% Plot Data
PlotGroupPerceptions('Angle',Var)
PlotGroupPerceptions('Semi',Var)
PlotGroupPerceptions('Velocity',Var)

for i = 1:12
    PlotIndPerceptions(Var,i)
end
PlotNoGVSGroupPerceptions(Var)

% % Compute Metrics (store in .csv)
% MetricCompute_Gain("AngleGain",Var)
% MetricCompute_Gain("CurrentGain",Var)

%% Plots for Paper
% Figure 1
Var = load(DataName);
Figure1b(Var)