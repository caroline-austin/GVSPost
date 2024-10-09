clear ; close all; clc;
code_path = pwd;
fs=50;
%% Edit Inputs Here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%Info for saving the Files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% set the folder that you want to save the files to
% file_path = '/home/gvslinux/Documents/ChairGVS/Profiles/TTS/DynamicTilt/Ang_50_Vel_50/SumOfSin6B';
% file_path = 'C:\Users\caroa\OneDrive - UCB-O365\Research\Testing\GVSProfiles\TTSPitchTilt';
file_path = 'C:\Users\caroa\OneDrive - UCB-O365\Research\Testing\GVSProfiles\GVSwaveformOptimization';
%'/home/gvslinux/Documents/ChairGVS/Profiles/TTS/DynamicTilt';
% uncomment the mkdir line if the folder does not already exist
mkdir(file_path) 

% a good naming convention is 
% MontageName_Current_mA_Duration_s_Profile_Type_freq/dir 
% can also add polarity and/or fs to end if applicable
% I might make code that automatically names the profile based on the input
% information
% Filename = 'Bilateral_0_10mA_12s_left_bipolar_50Hz'; % the name you would like to file to be saved as 

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Parameters to modify for all/any profile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% number of electrodes in the montage (must be at least 2 and no more than 5)
% 2 = bilateral 3 = Cevette, 4 = Aoyama
Num_Electrode = 2; 

% 7 = tilt velocity; 8 = tilt angle ; 
% between 7 and 8 = scaled contribution (closer to 7 is more velocity
% weighted, closer to 8 is more angle weighted)
Proportional = 7.5;

PmA = [4.0]; %[- 4 0 4];

% C = [-0.5, -0.25, 0., 0.25 0.5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Profile Type Modifiers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set this as 1 for sinusoidal and noise; 
% for DC profiles use 1 for left/backward and 2 for right/forward
Current_Direction = 1; 

% Provide some time with zero motion at the beginning and end, if desired
% this adds time to the duration
zpad=0;           % sec at beginning runs padded with zeros
zpad_after = 0;     % sec at the end of runs padded with zeros

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if Num_Electrode = 4 or 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specifies the number of cathodes ( 1 or 2) 
% only for configurations with 4 or 5 electrodes
% set as 2 for Aoyama config
Electrode_Config = 2; 

% 1 = Sinusoidal, 2 = Noise, 3 = DC
% for this code set as 2 if you want a power spectral density plot and any
% other number otherwise
Profile_Type = 1; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select the TTS file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd ../..
[input_filearg,input_path] = uigetfile('*.txt');
fprintf([input_filearg '\n']);

cd(input_path) %make sure the profile you want to run is in this folder
TTS_file = load(input_filearg);  
cd(code_path);

for iter = 1:length(PmA)

% GVS_Signal = (TTS_file(:,8)*C(iter))';

if ismember(Proportional, [1 2 3 4 5 6 7 8])
    
    GVS_Signal = (TTS_file(:,Proportional))'; 
    signal_max = max(abs(GVS_Signal));
    scale = PmA(iter)/signal_max;
    C = scale;
    
elseif Proportional < 8 && Proportional > 1
       Type_1 = floor(Proportional);
       Type_2 = ceil(Proportional);

       Weight_1 = Type_2 - Proportional;
       Weight_2 = 1-Weight_1; 

       Signal_1 = (TTS_file(:,Type_1))'; 
       Signal_2 = (TTS_file(:,Type_2))'; 

       signal_max1 = max(abs(Signal_1));
       signal_max2 = max(abs(Signal_2));

       Signal_1 = Signal_1 / signal_max1;
       Signal_2 = Signal_2 / signal_max2;

       GVS_Signal = Signal_1*Weight_1+Signal_2*Weight_2;

       signal_max = max(abs(GVS_Signal));
       GVS_Signal = GVS_Signal/max(abs(GVS_Signal));

       scale = (PmA(iter));
%        C = scale/(signal_max1*Weight_1+signal_max2*Weight_2);
       C = scale/signal_max;

elseif Proportional <1 && Proportional>0
    %special case where proportional to angle and abs(velocity)

       Type_2 = 8; % angle
       Type_1 = 7; % velocity

       Weight_1 = 1-Proportional; 
       Weight_2 = 1-Weight_1; 

       Signal_1 = abs((TTS_file(:,Type_1)))'; 
       Signal_2 = (TTS_file(:,Type_2))'; 

       signal_max1 = max(abs(Signal_1));
       signal_max2 = max(abs(Signal_2));

       Signal_1 = Signal_1 / signal_max1;
       Signal_2 = Signal_2 / signal_max2;

       [loc] =find(Signal_2<0);
       Signal_1(loc) = Signal_1(loc)*-1;

       GVS_Signal = Signal_1*Weight_1+Signal_2*Weight_2;

       signal_max = max(abs(GVS_Signal));
       GVS_Signal = GVS_Signal/max(abs(GVS_Signal));

       scale = (PmA(iter));
%        C = scale/(signal_max1*Weight_1+signal_max2*Weight_2);
       C = scale/signal_max;

elseif Proportional >-1 && Proportional<0
    %special case where proportional to velocity and abs(angle)

       Type_2 = 8; % angle
       Type_1 = 7; % velocity

       Weight_1 = 1+Proportional; % equal weighting for now
       Weight_2 = 1-Weight_1; 

       Signal_1 = (TTS_file(:,Type_1))'; 
       Signal_2 = abs(TTS_file(:,Type_2))'; 

       signal_max1 = max(abs(Signal_1));
       signal_max2 = max(abs(Signal_2));

       Signal_1 = Signal_1 / signal_max1;
       Signal_2 = Signal_2 / signal_max2;

       [loc] =find(Signal_1<0);
       Signal_2(loc) = Signal_2(loc)*-1;

       GVS_Signal = Signal_1*Weight_1+Signal_2*Weight_2;

       signal_max = max(abs(GVS_Signal));
       GVS_Signal = GVS_Signal/max(abs(GVS_Signal));

       scale = (PmA(iter));
%        C = scale/(signal_max1*Weight_1+signal_max2*Weight_2);
       C = scale/signal_max;
  
end 

GVS_Signal = GVS_Signal*(scale);
maxGVS = max(abs(GVS_Signal));

GVS_Signal = [ zeros(zpad*fs) GVS_Signal];

dt =1/fs;
T = length(GVS_Signal);
t = (0:T-1)*dt;

Filename = strtrim(strjoin([input_filearg(1:end-4) "_" num2str(PmA(iter)) "mA_prop"  num2str(Proportional)])); %C(iter)
Filename = strrep(Filename, '.', '_');
Filename = strrep(Filename, ' ', '');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Other setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PmA = max(abs(GVS_Signal));

if maxGVS>6 %can now go up to 6 mA instead of just 3mA
    error('Error: Peak current cannot exceed 6 mA.')
end
if Num_Electrode<2 || Num_Electrode>5
    error('Error: Number of electrodes cannot be <2 or >5.');
end


% 
% dt=1/fs;  %%% seconds per sample.
% t=(0:dt:Duration);  %%% time vector (in seconds).
% T=length(t);
% freq=0:fs/T:fs/2;
% 
% %% Run appropriate signal generator.
% if Profile_Type==1
%     [GVS_Signal]=Sinusoidal_Ramp(t,fs,PmA,Polarity_Type,Sin_freq);
%     T = length(GVS_Signal);
%     t = (0:T-1)*dt;
% elseif Profile_Type==2
%     GVS_Signal=Noise(fs,T,PmA,Polarity_Type);
% elseif Profile_Type ==3 %DC
%     GVS_Signal(1:T) = PmA;
%     GVS_Signal(1:ramp_time*fs) = t(1:ramp_time*fs)*PmA/ramp_time;
%     GVS_Signal((T-ramp_time*fs)+1:T) = t(ramp_time*fs:-1:1)*PmA/ramp_time;
% end

% Power Spectral Density Analysis:
%% GVS Signal
xdft=fft(GVS_Signal);
xdft=xdft(1:T/2+1);
psdx=(1/(fs*T))*abs(xdft).^2;
psdx(2:end-1)=2*psdx(2:end-1);

%% Create GVS signals for all electrodes.
Electrode_1_Sig=GVS_Signal;
if Num_Electrode==2
    Electrode_2_Sig=GVS_Signal*(-1);
    if Current_Direction ==2
        Electrode_1_Sig=GVS_Signal*(-1);
        Electrode_2_Sig=GVS_Signal;
    end
    Electrode_3_Sig=zeros(1,T);
    Electrode_4_Sig=Electrode_3_Sig;
    Electrode_5_Sig=Electrode_3_Sig;
elseif Num_Electrode==3
    if Current_Direction == 1
        %electrodes 1&2 are cathodes 5 is the anode (backward)
        Electrode_5_Sig = GVS_Signal;
        Electrode_2_Sig=GVS_Signal*(-.5);
        Electrode_1_Sig=Electrode_2_Sig;
        Electrode_3_Sig=zeros(1,T); %Electrode_4_Sig;
    elseif Current_Direction == 2
        %electrodes 1&2 are anodes 5 is the cathode (forward)
        Electrode_5_Sig = -GVS_Signal;
        Electrode_2_Sig=GVS_Signal*(.5);
        Electrode_1_Sig=Electrode_2_Sig;
        Electrode_3_Sig=zeros(1,T); %Electrode_4_Sig;
    else
        Electrode_2_Sig=GVS_Signal*(-.5);
        Electrode_3_Sig=Electrode_2_Sig;
        Electrode_5_Sig=zeros(1,T); %Electrode_4_Sig;
    end
    Electrode_4_Sig=zeros(1,T);
    
elseif Num_Electrode==4
    if Electrode_Config==1
        Electrode_2_Sig=GVS_Signal*(-1/3);
        Electrode_3_Sig=Electrode_2_Sig;
        Electrode_4_Sig=Electrode_2_Sig;
        Electrode_5_Sig=zeros(1,T);
    elseif Electrode_Config==2
        Electrode_5_Sig=zeros(1,T);% may need to switch this to match the length of the sinusoid - seems to be and 2 second difference?
        if Current_Direction == 2
            % electrodes 3&4 are anodes(+) and 1&2 are cathodes(-)
            % (forward)- positive motion coupling
            Electrode_1_Sig=GVS_Signal*(-1);
            Electrode_2_Sig=Electrode_1_Sig;
            Electrode_3_Sig=GVS_Signal;
        else
            % electrodes 1&2 are anodes (+) and 3&4 are cathodes (-) 
            % (Backward) - negative motion coupling 
            Electrode_2_Sig=GVS_Signal;
            Electrode_3_Sig=GVS_Signal*(-1);
        end
        Electrode_4_Sig=Electrode_3_Sig;
    end
elseif Num_Electrode==5
    if Electrode_Config==1
        Electrode_2_Sig=GVS_Signal*(-.25);
        Electrode_3_Sig=Electrode_2_Sig;
        Electrode_4_Sig=Electrode_2_Sig;
        Electrode_5_Sig=Electrode_2_Sig;
    elseif Electrode_Config==2
        Electrode_2_Sig=GVS_Signal;
        Electrode_3_Sig=GVS_Signal*(-2/3);
        Electrode_4_Sig=Electrode_3_Sig;
        Electrode_5_Sig=Electrode_3_Sig;
    end
end

zpad_Zeros= zeros(zpad*fs,1);
zpad_after_Zeros = zeros(zpad_after*fs,1);

%% Make electrode matrix, then round values to hundredths.
ElectrodesM=[dt Electrode_1_Sig(2:end);    0  Electrode_2_Sig(2:end)  ;    0  Electrode_3_Sig(2:end)  ;    0  Electrode_4_Sig(2:end)  ;     0  Electrode_5_Sig(2:end)  ];
ElectM100=ElectrodesM.*100; %% Multiply by 100 to remove the decimal.
RoundElectM=round(ElectM100); %% Rounds to whole numbers.
%%% Check that they all sum to zero. 
SumElectrodes=sum(RoundElectM);
j=find(SumElectrodes);
if min(SumElectrodes(2:end))<-3 && max(SumElectrodes(2:end))>3
    error('Error: Sum of electrodes at certain iterations is >30 uA. Check "j" values to see which iterations do not sum to zero.')
end
%%% Subtract additional currents (<30 uA) from Electrode 5.
ModElect5=[0 (RoundElectM(5,2:end)-SumElectrodes(2:end))];
NewElectM=[RoundElectM(1:4,:);ModElect5];
%%% Check that they all sum to zero again.
SumElectNew=sum(NewElectM(1:5,2:end));
k=find(SumElectNew);
if k~=0
    error('Error: Electrodes did not sum to zero. Check "k" values.')
end

%% Plot GVS signals.
figure;
subplot(2,3,1);
title('Electrode 1 Signal (Blue)'); hold on;
plot(t(1:end-1),(NewElectM(1,2:end)./100));
xlabel('Time (seconds)');
ylabel('Current (mA)');
subplot(2,3,2);
title('Electrode 2 Signal (White)'); hold on;
plot(t(1:end-1),(NewElectM(2,2:end)./100));
xlabel('Time (seconds)');
ylabel('Current (mA)');
subplot(2,3,3);
title('Electrode 3 Signal (Green)'); hold on;
plot(t(1:end-1),(NewElectM(3,2:end)./100));
xlabel('Time (seconds)');
ylabel('Current (mA)');
subplot(2,3,4);
title('Electrode 4 Signal (Yellow)'); hold on;
plot(t(1:end-1),(NewElectM(4,2:end)./100));
xlabel('Time (seconds)');
ylabel('Current (mA)');
subplot(2,3,5);
title('Electrode 5 Signal (Black)'); hold on;
plot(t(1:end-1),(NewElectM(5,2:end)./100));
xlabel('Time (seconds)');
ylabel('Current (mA)');
subplot(2,3,6);
dim = [.75 .1 .4 .3];
str = strjoin(["C = " num2str(C)]);
annotation('textbox',dim, 'String',str,'FitBoxToText','on');
% legend(str)
if Profile_Type == 2
plot(freq,10*log10(psdx));
grid on;
title('GVS Signal Periodogram Using FFT');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
end
cd(file_path);
saveas(gcf, Filename);
cd(code_path);

%% Create CSV file that removes decimals and adds +/- sign.
X=num2str(NewElectM,'%+04g '); %% Create 5 character string with 3-digit number + symbol, then space after.
%%% Create electrode matrix of 5 character values.
Y(1,:)=strsplit(X(1,:)," ");
Y(2,:)=strsplit(X(2,:)," ");
Y(3,:)=strsplit(X(3,:)," ");
Y(4,:)=strsplit(X(4,:)," ");
Y(5,:)=strsplit(X(5,:)," ");
Profile = Y;
%%% Write matlab file and save plot
cd(file_path);
save([char(Filename) '.mat'], 'Profile');
cd(code_path);

clear GVS_Signal Signal_1 Signal_2
end
%writecell(Y,"CHAIR_GVS_Profile_.csv");
