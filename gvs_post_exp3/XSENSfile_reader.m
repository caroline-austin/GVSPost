function XSENS_data = XSENSfile_reader(filename,  sample_freq,dataLines)
%IMPORTFILE Import data from a text file
%  GIST20231027115332 = IMPORTFILE(FILENAME) reads data from text file
%  FILENAME for the default selection.  Returns the data as a table.
%
%  GIST20231027115332 = IMPORTFILE(FILE, DATALINES) reads data for the
%  specified row interval(s) of text file FILENAME. Specify DATALINES as
%  a positive scalar integer or a N-by-2 array of positive scalar
%  integers for dis-contiguous row intervals.
%
%  Example:
%  GIST20231027115332 = importfile("C:\Users\nicol\OneDrive\Documents\Research\GVS_Post\GIST_20231027_115332.csv", [3, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 01-Nov-2023 16:47:16

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 3
    dataLines = [3, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 10);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Packet","Time", "EulerX", "EulerY", "EulerZ", "AccX", "AccY", "AccZ", "GyroX", "GyroY", "GyroZ"];
opts.VariableTypes = ["double","double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
XSENS_data = readtable(filename, opts);

% sensorpositionplot =0; %default is that we do not want to see the sensor position plot
% if sample_freq >0
% code_path = pwd;
% cd ..\
% XSENS_data(:,6:9) = GravityAligned([XSENS_data.AccX XSENS_data.AccY XSENS_data.AccZ], [XSENS_data.GyroX XSENS_data.GyroY XSENS_data.GyroZ],sensorpositionplot,sample_freq);
% cd(code_path);
% end

end