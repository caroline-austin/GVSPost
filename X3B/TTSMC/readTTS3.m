%%%%%%%%%%%%
%readTTS.m
%TLL
%3/23/23
%This code sets up the TCP connection between this computer and the TTS and
%receives data from the TTS as it writes the txt file.  Then, it compiles
%this information into a local txt that can be analyzed without stopping
%the VI
%%%%%%%%%%%%

%SETUP
    clear all
    clc
    close all

%initialize TCP server
    port = 18888;
    TCP = tcpserver(port);

    disp('TCP Connection Open')

    file_path = uigetdir;
    code_path = pwd;
%%
%set terminator
    configureTerminator(TCP,"CR/LF")
%clean the TCP line
    flush(TCP)
%set up while loop to read from TTS
    running = true;
    % dataR    = [];
    if exist('dataR','var') == 1
        clear dataR
    end
    i = 1;
    timer = tic; %start a timer to implement a timeout
    disp('Listening...')
%conditions to end while loop - the newLine is the file name, timeout
%reached
    while running
        if TCP.NumBytesAvailable > 0
            count = TCP.NumBytesAvailable;
            newLine = readline(TCP);
            if contains(newLine,".txt") & exist('dataR','var')
                running = false;
                filename = newLine;
            elseif contains(newLine,"ms")
                line_str = strsplit(newLine,'\t');
            else
                line_str = strsplit(newLine);
                dataR(i,:) = line_str;
                i = i+1;
            end
            disp(newLine)
        end
    end
%save the dataR into a txt
if exist('filename','var') == 1
    cd(file_path)
    writematrix(dataR,filename,"Delimiter",'\t');
    cd(code_path);
else
    disp('No filename available!')
end