% Main Script
clc;clear;close all;

%%
% PreProcess
	% TTS_GVS_Files_Final.m
	% TTS_GVS_IndvGroupByProfile_Final.m
	% TTS_GVS_Trial_Check_Final.m
	% TTS_GVS_IndvPlotBiasAdjust_Final.m
	% TTS_GVS_IndvPlotTimeAdjust_Final.m

% Aggregate Data
TTS_GVS_GainAdjust_Final
TTS_GVS_Aggregate_Final
%%
% Save Aggregate Data to .mat
DataName = "DynamicDataGainPitch.mat";
save("../data/"+DataName) 

%% Load
Var = load("../data/"+DataName);

% Plot Data
X2DPlotGroupPerceptions('Angle',Var)
% PlotGroupPerceptions('Semi',Var)
% PlotGroupPerceptions('Velocity',Var)

% for i = 1:12
%     PlotIndPerceptions(Var,i)
% end
% PlotNoGVSGroupPerceptions(Var)

% % Compute Metrics (store in .csv)
% MetricCompute_Gain("AngleGain",Var)
% MetricCompute_Gain("CurrentGain",Var)

%% Plots for Paper
% Figure 1
Var = load("./data/"+DataName);
Figure1b(Var)