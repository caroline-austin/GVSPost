%% Script 4 for X3C Functional Mobility Testing
% this script takes the data from script 2 and plots the outcome metrics

% close all; 
clear all; 
clc; 

%% setup
subnum = [ 3096:3100];  % Subject List 
numsub = length(subnum);
subskip = [ 1013 40005 40006];  %DNF'd subjects or subjects that didn't complete this part 

include = [" "];%FMT TDM TTS"];

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory it should be the Data folder for the experiment (on Sharepoint)
plots_path = [file_path '/Plots']; % specify where plots are saved
gvs_path = [file_path '/GVSProfiles']; %specify where to grab default GVS profiles from
% tts_path = [file_path '/TTSProfiles']; %specify where to grab baseline TTS profiles from

cd(file_path)
load('SAll.mat')
cd(code_path);

GVS_fields = fieldnames(data.TTS.RMS);

if contains(include,'FMT')
%% FMT

net_time = [];
net_label = [];
raw_time = [];
raw_label = [];
errors = [];
err_label = [];


for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    
    
    for gvs_cond = 1:length(GVS_fields)
        net_store = [data.FMT.adj_time.(GVS_fields{gvs_cond}){sub,:}];
        net_time = [ net_time net_store ];
        num_rom_trials=length(net_store );
        label = repmat(gvs_cond,1,num_rom_trials);
        net_label = [net_label  label];

        raw_store = [data.FMT.raw_time.(GVS_fields{gvs_cond}){sub,:}];
        raw_time = [ raw_time raw_store ];
        num_rom_trials=length(raw_store );
        label = repmat(gvs_cond,1,num_rom_trials);
        raw_label = [raw_label  label];

        err_store = [data.FMT.errors.(GVS_fields{gvs_cond}){sub,:}];
        errors = [ errors err_store ];
        num_rom_trials=length(err_store );
        label = repmat(gvs_cond,1,num_rom_trials);
        err_label = [err_label  label];
    end

end

figure;
boxplot(net_time,net_label)
xticklabels(["Head Coupled GVS"   "Sum of Sines GVS" "NO GVS"])
ylabel("Time (s)")
title("FMT Net Time")

figure;
boxplot(raw_time,raw_label)
xticklabels(["Head Coupled GVS"   "Sum of Sines GVS" "NO GVS"])
ylabel("Time (s)")
title("FMT Raw Time")

figure;
boxplot(errors,err_label)
xticklabels(["Head Coupled GVS"   "Sum of Sines GVS" "NO GVS"])
ylabel("Time (s)")
title("FMT Errors")
end

if contains(include, 'TDM')

%% Tandem 
TDM_fields = fieldnames(data.TDM.GIST);
steps = [];
step_label = [];

for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end

    index = 0;

    for phys_cond = 1:length(TDM_fields)
        for gvs_cond = 1:length(GVS_fields)
            index = index +1;
            step_store = [data.TDM.steps.(TDM_fields{phys_cond}).(GVS_fields{gvs_cond}){sub,:}];
            steps = [ steps step_store ];
            num_rom_trials=length(step_store );
            label = repmat(index,1,num_rom_trials);
            step_label = [step_label  label];

    
        end
    end


end

figure;
boxplot(steps,step_label)
xticklabels(["Head Coupled GVS"   "Sum of Sines GVS" "NO GVS" "Head Coupled GVS"   "Sum of Sines GVS" "NO GVS"])
ylabel("Correct Steps")
title("Tandem Walk")
end

if contains(include, 'ROM')

%% ROM
ROM_fields = fieldnames(data.ROM.GIST);
pass = [];
pass_time = [];
pass_label = [];

for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end

    index = 0;

    for phys_cond = 1:length(ROM_fields)
        for gvs_cond = 1:length(GVS_fields)
            index = index +1;


            time_store = [data.ROM.Pass.(ROM_fields{phys_cond}).(GVS_fields{gvs_cond}){sub,:}];
            pass_time = [ pass_time time_store ];
            num_rom_trials=length(time_store );
            label = repmat(index,1,num_rom_trials);
            pass_label = [pass_label  label];

            

    
        end
    end


end
pass = pass_time==15;

for condition = 1:max(pass_label)
 num_pass(condition)= sum(pass(pass_label ==condition));
 num_rom_trials(condition)= length(find(pass_label ==condition ));
 pass_percent(condition) = num_pass(condition)/num_rom_trials(condition);
end

% figure;
% boxplot(pass_time,pass_label)
% 
% xticklabels(["Head Coupled GVS"  "NO GVS" "Sum of Sines GVS" "Head Coupled GVS"  "NO GVS" "Sum of Sines GVS" "Head Coupled GVS"  "NO GVS" "Sum of Sines GVS" "Head Coupled GVS"  "NO GVS" "Sum of Sines GVS"])
% xlabel("Eyes Closed     Pitch Tilts     Roll Tilts     Eyes Open")
% ylabel("Time (s)")
% title("ROM Time")

figure; 
% plot(pass_label, pass_time, '*k')
jitter = 0.25;
pass_label_jit= pass_label + (rand(size(pass_label)) - 0.5) * jitter;
scatter(pass_label_jit,pass_time, 'filled','MarkerFaceAlpha', 0.4)
% swarmchart(pass_label, pass_time, 'filled', 'XJitter', 'rand', 'XJitterWidth', 0.2);
% xlabel('Group');
% ylabel('Value');
xticks([1:12])
xticklabels(["Head Coupled GVS"   "Sum of Sines GVS" "NO GVS" "Head Coupled GVS"   "Sum of Sines GVS" "NO GVS" "Head Coupled GVS"   "Sum of Sines GVS" "NO GVS" "Head Coupled GVS"   "Sum of Sines GVS" "NO GVS"])
xlabel("Eyes Closed     Pitch Tilts     Roll Tilts     Eyes Open")
ylabel("Time (s)")
title("ROM Time")

figure; 
bar(pass_percent)
xticks([1:12])
xticklabels(["Head Coupled GVS"   "Sum of Sines GVS" "NO GVS" "Head Coupled GVS"   "Sum of Sines GVS" "NO GVS" "Head Coupled GVS"   "Sum of Sines GVS" "NO GVS" "Head Coupled GVS"   "Sum of Sines GVS" "NO GVS"])
xlabel("Eyes Closed     Pitch Tilts     Roll Tilts     Eyes Open")
ylabel("Total Pass Percentage")
title("ROM Pass Percentage")
end

if contains(include, 'TTS')

%% TTS

RMS_time = [];
RMS_label = [];
VAR = [];
VAR_label = [];
bias = [];
bias_label = [];


for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    
    
    for gvs_cond = 1:length(GVS_fields)
        RMS_store = [data.TTS.RMS.(GVS_fields{gvs_cond}){sub,:}];
        RMS_time = [ RMS_time RMS_store ];
        num_rom_trials=length(RMS_store );
        label = repmat(gvs_cond,1,num_rom_trials);
        RMS_label = [RMS_label  label];

        VAR_store = [data.TTS.VAR.(GVS_fields{gvs_cond}){sub,:}];
        VAR = [ VAR VAR_store ];
        num_rom_trials=length(VAR_store );
        label = repmat(gvs_cond,1,num_rom_trials);
        VAR_label = [VAR_label  label];

        bias_store = [data.TTS.AVG.(GVS_fields{gvs_cond}){sub,:}];
        bias = [ bias bias_store ];
        num_rom_trials=length(bias_store );
        label = repmat(gvs_cond,1,num_rom_trials);
        bias_label = [bias_label  label];
    end

end

figure;
boxplot(RMS_time,RMS_label)
xticklabels(["Head Coupled GVS"   "Sum of Sines GVS" "NO GVS"])
ylabel("RMS")
title("TTS MC RMS")

figure;
boxplot(VAR,VAR_label)
xticklabels(["Head Coupled GVS"   "Sum of Sines GVS" "NO GVS"])
ylabel("VAR")
title("TTS MC VAR")

figure;
boxplot(bias,bias_label)
xticklabels(["Head Coupled GVS"   "Sum of Sines GVS" "NO GVS"])
ylabel("bias (deg)")
title("TTS MC bias")
end