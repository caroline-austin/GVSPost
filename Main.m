% Main Script
clc;clear;close all;

% Aggregate Data
TTS_GVS_GainAdjust_Aaron
TTS_GVS_Aggregate_Final
save("DynamicData.mat") % Save Aggregate Data to .mat

% Plot Data
PlotGroupPerceptions('Angle')
PlotGroupPerceptions('Semi')
PlotGroupPerceptions('Velocity')
% 
% PlotGroupGainScatter('Angle')
% PlotGroupGainScatter('Semi')
% PlotGroupGainScatter('Velocity')

% Compute Metrics (store in .csv)
MetricCompute_Gain("AngleGain")
MetricCompute_Gain("CurrentGain")