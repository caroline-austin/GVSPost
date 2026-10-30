clear all ;close all; clc

name = strcat('test','.csv');

% Edit inputs
% (s) duration of signal (does not include padding, 
% or ramp up/down for sinusoid)
Duration = 12; 

% (Hz) sampling frequency, the GIST auto samples at 100Hz, TTS samples at 50Hz
fs = 100; 

% (mA) peak current, can't exceed 5mA 
PmA = 4;

% (Hz) only for sinusoidal profiles, set the frequency of 
% the sine wave for the profile
Sin_freq = 0.25; 


%% build GVS profile
dt = 1/fs;
t = [0:dt:Duration]; 
GVS_signal = sin(t*Sin_freq*(2*pi));

figure; 
plot(t,GVS_signal);
xlabel("time (s)")
ylabel("current (mA)")
ylim([-5 5])

profile= round(GVS_signal*1000)';
writematrix(profile,name);