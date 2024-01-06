%% Script 1 for Dynamic GVS +Tilt
% Either function reads in and combines data from the "master spread sheet"
% (DynamicGVSPlusTilt) in the Data folder, the GVS Profile files that
% Sparky runs, the TTS input files, and TTS output files. The combined data
% is then saved with a uniform naming scheme for each trial with one
% additional file containing non-shot related data  from the master spread
% sheet
%
%This script determines the operating system that the user is on so that
%the directory locations are in the correct format
close all; clear; clc; 
warning off;

%% setup
subnum = 1011:1022;  % Subject List 
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part 
% 1015 is included here for completeness but excluded later

%% Operating System Check
if ismac || isunix % Runs the Mac or Linux operating system code
    TTS_GVS_Files_MACLINUX(subnum,numsub,subskip);
elseif ispc % Runs the Windows operating system code
    TTS_GVS_Files_WINDOWS(subnum,numsub,subskip);
end

