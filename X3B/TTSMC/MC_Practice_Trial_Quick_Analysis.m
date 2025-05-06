% clear; close all; clc %% Leave commented out if running TCP Connection!
code_path = pwd;
%% USER INPUT
multi_select=0;  % 0 for one file and 1 for multiple files.

file_format='txt'; % options: 'xlsx', 'xls','csv', or 'txt'

% [file, path] = uigetfile({'*.csv'; '*.xls'; '*.xlsx'; '*.txt'},'Select all file(s) to be analyzed.','MultiSelect','on');
[file, path]=uigetfile({'*.txt'},'Select all file(s) to be analyzed.','MultiSelect','on');
    [rows,columns]=size(file);
    filename=fullfile(path, file);

%% EXTRACTING DATA FROM FILES
if multi_select==1
	counter_temp=columns;
	file=file';
else
    counter_temp=rows;
end    

for i=1:counter_temp    
    filepath=strcat(path,file(i,:));
    filepath=char(filepath);

if strcmp(file_format, 'txt')
    fileID=fopen(filepath);
    formatSpec='%f %f %f %f';
    rawdata=textscan(fileID,formatSpec);
    fclose(fileID);
end

rawdata = cell2mat(rawdata);
[r, c]=size(rawdata);
MC_Data(i).ID=char(file(i,:));
MC_Data(i).ID=MC_Data(i).ID(1:end-4);
MC_Data(i).Time=(rawdata(1:end,1)-rawdata(1,1))/1000; % Compute time vector (in seconds) and save.
MC_Data(i).Tilt_N_Joy=(rawdata(1:end,2)/200); % Compute tilt + joystick nulling vector (in deg.) and save.

%% Compute Root Mean Square Error (RMSE) and Standard Deviation (SD), then save.
Nulling_RMSE=rms(MC_Data(i).Tilt_N_Joy)
MC_Data(i).Nulling_RMSE=Nulling_RMSE;

Mean=mean(MC_Data(i).Tilt_N_Joy)
MC_Data(i).Nulling_Mean=Mean;
MC_Data(i).Mean_Deviated_Vector=(MC_Data(i).Tilt_N_Joy)-(MC_Data(i).Nulling_Mean);
SD=rms(MC_Data(i).Mean_Deviated_Vector)
MC_Data(i).Nulling_SD=SD;

%% Plot figure(s).
figure
plot(MC_Data(i).Time,MC_Data(i).Tilt_N_Joy,'b'); hold on;
plot(MC_Data(i).Time,MC_Data(i).Mean_Deviated_Vector,'r','LineStyle',':');
xlim([0 120]);
ylim([-10 10]);
title(file,['RMSE: ' num2str(Nulling_RMSE) ';  Mean: ' num2str(Mean) ' degrees']);
xlabel('Time (seconds)');
ylabel('Degrees');
legend('Chair Tilt','Mean Deviated Chair Tilt');
end

