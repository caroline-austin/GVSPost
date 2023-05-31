%% Script 2 for Dynamic GVS +Tilt
% this script takes the individual matlab files generated in the previous
% script and combines the data into a single matlab file with variables
% made up of multiple trials(each trial is a separate column), but grouped
% by the physical motion profile that the trial is associated with. The
% trial each column is associated with is stored in the Label structure.
% The results of this file are unadjusted, but are able to be used as inputs 
% in any of the 3,4,5 scripts
close all; clear; clc; 

%% set up
subnum = 1015:1015;  % Subject List 
numsub = length(subnum);
subskip = [1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

%% Operating System Check
if ismac || isunix % Runs the Mac or Linux operating system code
    TTS_GVS_IndvGroupByProfile_MACLINUX(subnum,numsub,subskip);
elseif ispc % Runs the Windows operating system code
    TTS_GVS_IndvGroupByProfile_WINDOWS(subnum,numsub,subskip);
end