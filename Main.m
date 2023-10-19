% Main Script
clc;clear;close all;

%% PreProcess
% Aggregate Data
TTS_GVS_GainAdjust_P2P
TTS_GVS_Aggregate_Final

% Save Aggregate Data to .mat
DataName = "DynamicDataGain.mat";
save(DataName) 

%% Load
Var = load(DataName);

% Plot Data
PlotGroupPerceptions('Angle',Var)
PlotGroupPerceptions('Semi',Var)
PlotGroupPerceptions('Velocity',Var)

PlotIndPerceptions(Var)
PlotNoGVSGroupPerceptions(Var)

% Compute Metrics (store in .csv)
MetricCompute_Gain("AngleGain",Var)
MetricCompute_Gain("CurrentGain",Var)