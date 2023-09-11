% Main Script
clc;clear;close all;

% Aggregate Data
TTS_GVS_Aggregate_Final
save("DynamicData.mat") % Save Data to .mat

% Plot Data
PlotGroupPerceptions('Angle')
PlotGroupPerceptions('Semi')
PlotGroupPerceptions('Velocity')

PlotGroupGainScatter('Angle')
PlotGroupGainScatter('Semi')
PlotGroupGainScatter('Velocity')
