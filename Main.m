% Main Script
clc;clear;close all;
DataName = "DynamicData.mat";

% Aggregate Data
TTS_GVS_GainAdjust_Aaron
TTS_GVS_Aggregate_Final
save(DataName) % Save Aggregate Data to .mat
Var = load(DataName);

% Plot Data
PlotGroupPerceptions('Angle',Var)
PlotGroupPerceptions('Semi',Var)
PlotGroupPerceptions('Velocity',Var)

PlotIndPerceptions(Var)
PlotNoGVSGroupPerceptions(Var)

% Compute Metrics (store in .csv)
MetricCompute_Gain("AngleGain")
MetricCompute_Gain("CurrentGain")