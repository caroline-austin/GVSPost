% Main Script
clc;clear;close all;

% Aggregate Data
TTS_GVS_Aggregate_Final
save("DynamicData.mat") % Save Data to .mat

% Plot Data
PlotPerceptions('Angle')
PlotPerceptions('Semi')
PlotPerceptions('Velocity')

