% copy and paste ( [ctrl] [shift] [v] )this into the command line before
% running the first time
% sudo chmod +777 /dev/ttyACM0


clear all
clc
close all


%initialize TCP server
TCP = tcpserver(16666);
%add print statement

%%
code_path = '/home/gvslinux/Documents/ChairGVS';
% file_path = '/home/gvslinux/Documents/ChairGVS/Profiles';

flush(TCP)
clear output
fprintf('Please select your profile to run\n');
[filearg, file_path ]= uigetfile(['*.m' ...
    'at']);
fprintf([filearg '\n' ...
    ...
    ...
    ]);
timeout = 60; %s
cd(file_path) %make sure the profile you want to run is in this folder
file = load(filearg);  
cd(code_path)
period_arg = str2double(file.Profile(1,1))/100; % in seconds per command
%period_arg = 0.016; 

string_args = string(file.Profile(:,2:end));
numcommands = length(string_args); 
commands = strings(1,numcommands); 
fprintf('Concatenating commands...');

for i = 1:length(string_args)

    commands(1,i) = string_args(1,i) + string_args(2,i)  + string_args(3,i) + string_args(4,i) + string_args(5,i);

end

fprintf('Done!\n'); 

global index 
index =1;

port_exist = exist('port');

if port_exist == 1
    clear port
    port = serialport('/dev/ttyACM0',57600);    %changed from serial to serialport 8/16/23 TL
    configureTerminator(port,"CR/LF");
    port.DataBits = 8; 
    port.StopBits = 1; 
    port.Parity = 'none';
else
    port = serialport('/dev/ttyACM0',57600);
    configureTerminator(port,"CR/LF");
    port.DataBits = 8; 
    port.StopBits = 1; 
    port.Parity = 'none';
end

%mystring = '11112222333344445555'; 

%port = 1;

% add start condition here for tcp/ip
tic;
output = {};
i = 1;
go = true;


t = timer('Period',period_arg);
t.BusyMode = 'error'; % throw an error if TimerFcn gets called before previous TimerFcn is stopped, can also be 'drop' or 'queue'. 
t.ErrorFcn = @(~,~)disp('ErrorFcn Called');
t.TasksToExecute = numcommands; 
t.ExecutionMode = 'fixedRate'; 
t.TimerFcn = @(~,~)Serial_Runner(port,commands,numcommands);
t.StartFcn = @(~,thisEvent)disp([thisEvent.Type ' executed '...
    datestr(thisEvent.Data.time,'dd-mmm-yyyy HH:MM:SS.FFF')]);
t.StopFcn = @(~,thisEvent)StopTime(port,t,thisEvent);

%wait for TCP packet from TTS
while (go)
    output{i} = readline(TCP);
    disp(output{i})
    if string(output{i}) == "Start"
        go = false;
        start(t)
        continue
    elseif toc > timeout
        go = false;
        disp('Error: timeout, no "Start" command received.')
        continue
    end
    i = i+1;
end

%start(t)

function Serial_Runner(port_arg,data_arg, cmds_arg)

global index
    if (index <= cmds_arg)
        write(port_arg,data_arg(index),'string');
        index = index + 1; 
    end

end

function StopTime(serial_arg,timer_arg,event_arg)
    disp([event_arg.Type, ' executed '...
    datestr(event_arg.Data.time,'dd-mmm-yyyy HH:MM:SS.FFF')])
    delete(timer_arg);
end

