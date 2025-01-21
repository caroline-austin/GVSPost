clear; close all; clc;

Folder = uigetdir;
code_path = pwd;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Provide some time with zero motion at the beginnign and end, if desired
zpad=3;           % sec at beginning runs padded with zeros
zpad_after = 1;     % sec at the end of runs padded with zeros

%% Input information.
Duration=input('1) Enter signal duration (in seconds): ');
fs=input('2) Enter sampling frequency (in Hz): ');
PmA=input('3) Enter peak current desired (in mA): ');

if PmA>4 %can now go up to 4 mA instead of just 3mA
    error('Error: Peak current cannot exceed 4 mA.')
end

% Takes in Number of Electrodes and Cathodes
Num_Electrode=input('4) Enter number of electrodes using (2-5): ');
if Num_Electrode>3 && Num_Electrode<=5
    Electrode_Config=input('4b) Enter number of cathodes (1 or 2): ');
elseif Num_Electrode<2 && Num_Electrode>5
    error('Error: Number of electrodes cannot be <2 or >5.');
end

% Takes in the sink location for Cevette
if Num_Electrode==3
    Electrode_SinkLocation=input('4c) Enter the elecrode sink location (1 = forhead or 2 = neck or 3 = shoulder): ');
end

% Takes in the shape of electrodes for 4 electrode configurations 
if Num_Electrode==4
    Electrode_Shape=input('4c) Enter shape of configuration (Aoyama = 1 or Diamond = 2): ');
end

% Determines waveform, polarity, and current direction
Profile_Type=input('5) Enter profile signal type (1 = Sinusoidal or 2 = Noise 3 = DC): ');
if Profile_Type < 3
    Polarity_Type=input('6) Enter polarity type (1 = Unipolar or 2 = Bipolar): ');
    if Polarity_Type<1 && Polarity_Type>2
        error('Error: Polarity type must be 1 (unipolar) or 2 (bipolar).');
    end
    Current_Direction = 1; 
else 
    Current_Direction=input('6) Enter sway direction (1 = left/backward or 2 = right/forward): ');
end 

% Takes in file name
Filename= (input('7) Enter file name (no spaces and in ''quotes''): '));

dt=1/fs;  %%% seconds per sample.
t=(0:dt:Duration);  %%% time vector (in seconds).
T=length(t);
freq=0:fs/T:fs/2;

%% Run appropriate signal generator.
if Profile_Type==1
    [GVS_Signal]=Sinusoidal(t,fs,PmA,Polarity_Type); %swap out with Sinusoidal_ramp?
elseif Profile_Type==2
    GVS_Signal=Noise(fs,T,PmA,Polarity_Type);
elseif Profile_Type ==3 
    GVS_Signal(1:T) = PmA;
    GVS_Signal(1:fs) = t(1:fs)*PmA;
    GVS_Signal(T-fs+1:T) = t(fs:-1:1)*PmA;
end

% Power Spectral Density Analysis:
%% GVS Signal
xdft=fft(GVS_Signal);
xdft=xdft(1:T/2+1);
psdx=(1/(fs*T))*abs(xdft).^2;
psdx(2:end-1)=2*psdx(2:end-1);

%% Create GVS signals for all electrodes.
Electrode_1_Sig=GVS_Signal;

% Bilateral GVS
if Num_Electrode==2
    Electrode_2_Sig=GVS_Signal*(-1);
    if Current_Direction == 2
        Electrode_1_Sig=GVS_Signal*(-1);
        Electrode_2_Sig=GVS_Signal;
    end
    Electrode_3_Sig=zeros(1,T);
    Electrode_4_Sig=Electrode_3_Sig;
    Electrode_5_Sig=Electrode_3_Sig;

% Cevette Forehead 
elseif Num_Electrode==3 && Electrode_SinkLocation==1
    if Current_Direction == 1
        %electrodes 1&2 are cathodes 3 is the anode (backward)
        Electrode_3_Sig = GVS_Signal;
        Electrode_2_Sig=GVS_Signal*(-.5);
        Electrode_1_Sig=Electrode_2_Sig;
    elseif Current_Direction == 2
        %electrodes 1&2 are anodes 3 is the cathode (forward)
        Electrode_3_Sig = -GVS_Signal;
        Electrode_2_Sig=GVS_Signal*(.5);
        Electrode_1_Sig=Electrode_2_Sig;
    else
        Electrode_2_Sig=GVS_Signal*(-.5);
        Electrode_3_Sig=Electrode_2_Sig;
    end
    Electrode_4_Sig=zeros(1,T);
    Electrode_5_Sig=zeros(1,T); %Electrode_4_Sig;

% Cevette Neck
elseif Num_Electrode==3 && Electrode_SinkLocation==2
    if Current_Direction == 1
        %electrodes 1&2 are cathodes 3 is the anode (backward)
        Electrode_4_Sig = GVS_Signal;
        Electrode_2_Sig=GVS_Signal*(-.5);
        Electrode_1_Sig=Electrode_2_Sig;
    elseif Current_Direction == 2
        %electrodes 1&2 are anodes 3 is the cathode (forward)
        Electrode_4_Sig = -GVS_Signal;
        Electrode_2_Sig=GVS_Signal*(.5);
        Electrode_1_Sig=Electrode_2_Sig;
    else
        Electrode_2_Sig=GVS_Signal*(-.5);
        Electrode_4_Sig=Electrode_2_Sig;
    end
    Electrode_3_Sig=zeros(1,T);
    Electrode_5_Sig=zeros(1,T); %Electrode_4_Sig;

% Cevette Shoulder
elseif Num_Electrode==3 && Electrode_SinkLocation==3
    if Current_Direction == 1
        %electrodes 1&2 are cathodes 3 is the anode (backward)
        Electrode_5_Sig = GVS_Signal;
        Electrode_2_Sig=GVS_Signal*(-.5);
        Electrode_1_Sig=Electrode_2_Sig;
    elseif Current_Direction == 2
        %electrodes 1&2 are anodes 3 is the cathode (forward)
        Electrode_5_Sig = -GVS_Signal;
        Electrode_2_Sig=GVS_Signal*(.5);
        Electrode_1_Sig=Electrode_2_Sig;
    else
        Electrode_2_Sig=GVS_Signal*(-.5);
        Electrode_5_Sig=Electrode_2_Sig;
    end
    Electrode_3_Sig=zeros(1,T);
    Electrode_4_Sig=zeros(1,T); %Electrode_4_Sig;

% Aoyama
elseif Num_Electrode==4 && Electrode_Shape==1
    if Electrode_Config==1
        Electrode_2_Sig=GVS_Signal*(-1/3);
        Electrode_3_Sig=Electrode_2_Sig;
        Electrode_4_Sig=Electrode_2_Sig;
        Electrode_5_Sig=zeros(1,T);
    elseif Electrode_Config==2
        Electrode_5_Sig=zeros(1,T);
        if Current_Direction == 2
            % electrodes 3&4 are anodes(?) and 1&2 are cathodes (forward)
            Electrode_1_Sig=GVS_Signal*(-1);
            Electrode_2_Sig=Electrode_1_Sig;
            Electrode_3_Sig=GVS_Signal;
        else
            % electrodes 1&2 are anodes and 3&4 are cathodes (Backward)
            Electrode_2_Sig=GVS_Signal;
            Electrode_3_Sig=GVS_Signal*(-1);
        end
        Electrode_4_Sig=Electrode_3_Sig;
    end

% Diamond Configuration
elseif Num_Electrode==4 && Electrode_Shape==2
    Pos_Index = find(GVS_Signal>0);
    Neg_Index = find(GVS_Signal<=0);

    if Current_Direction == 2
        GVS_Signal = -GVS_Signal;
    end

    %electrodes 1&2 are cathodes 3 is the anode (backward)
    Electrode_5_Sig=zeros(1,T);
    Electrode_4_Sig(Pos_Index)=0;
    Electrode_3_Sig(Pos_Index)=GVS_Signal(Pos_Index);
    Electrode_2_Sig=GVS_Signal*(-.5);
    Electrode_1_Sig=Electrode_2_Sig;
  
    %electrodes 1&2 are cathodes 4 is the anode (forward)
    Electrode_4_Sig(Neg_Index)=GVS_Signal(Neg_Index);
    Electrode_3_Sig(Neg_Index)=0;

    if Electrode_Shape == 2 && Profile_Type == 3
        if Electrode_SinkLocation == 2
            %electrodes 1&2 are cathodes 3 is the anode (backward)
            Electrode_5_Sig=zeros(1,T);
            Electrode_4_Sig(Pos_Index)=GVS_Signal(Pos_Index);
            Electrode_3_Sig(Pos_Index)=0;
            Electrode_2_Sig=GVS_Signal*(-.5);
            Electrode_1_Sig=Electrode_2_Sig;
          
            %electrodes 1&2 are cathodes 4 is the anode (forward)
            Electrode_4_Sig(Neg_Index)=0;
            Electrode_3_Sig(Neg_Index)=GVS_Signal(Neg_Index);
        end
    end
 
elseif Num_Electrode==5
    if Electrode_Config==1
        Electrode_2_Sig=GVS_Signal*(-.25);
        Electrode_3_Sig=Electrode_2_Sig;
        Electrode_4_Sig=Electrode_2_Sig;
        Electrode_5_Sig=Electrode_2_Sig;
    elseif Electrode_Config==2
        if Current_Direction == 2
            Electrode_1_Sig=GVS_Signal*(-1);
            Electrode_2_Sig=Electrode_1_Sig;
            Electrode_3_Sig=GVS_Signal*(2/3);
        else
            Electrode_2_Sig=GVS_Signal;
            Electrode_3_Sig=GVS_Signal*(-2/3);
        end
        Electrode_4_Sig=Electrode_3_Sig;
        Electrode_5_Sig=Electrode_3_Sig;
    end
end

zpad_Zeros= zeros(zpad*fs,1);
zpad_after_Zeros = zeros(zpad_after*fs,1);

%% Make electrode matrix, then round values to hundredths.
ElectrodesM=[dt Electrode_1_Sig;    0  Electrode_2_Sig  ;    0  Electrode_3_Sig  ;    0  Electrode_4_Sig  ;     0  Electrode_5_Sig  ];
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
plot(t,(NewElectM(1,2:end)./100));
xlabel('Time (seconds)');
ylabel('Current (mA)');
subplot(2,3,2);
title('Electrode 2 Signal (White)'); hold on;
plot(t,(NewElectM(2,2:end)./100));
xlabel('Time (seconds)');
ylabel('Current (mA)');
subplot(2,3,3);
title('Electrode 3 Signal (Green)'); hold on;
plot(t,(NewElectM(3,2:end)./100));
xlabel('Time (seconds)');
ylabel('Current (mA)');
subplot(2,3,4);
title('Electrode 4 Signal (Yellow)'); hold on;
plot(t,(NewElectM(4,2:end)./100));
xlabel('Time (seconds)');
ylabel('Current (mA)');
subplot(2,3,5);
title('Electrode 5 Signal (Black)'); hold on;
plot(t,(NewElectM(5,2:end)./100));
xlabel('Time (seconds)');
ylabel('Current (mA)');
subplot(2,3,6);
plot(freq,10*log10(psdx));
grid on;
title('GVS Signal Periodogram Using FFT');
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
% cd('Profiles/');
% saveas(gcf, Filename);
% cd('../');

% %% Plot GVS signals for Poster
% figure;
% subplot(2,3,1);
% title('Electrode 1'); hold on;
% plot(t,(NewElectM(1,2:end)./100), "Color", [0 0.3470 0.7410], LineWidth=5);
% xlim([0 12])
% ylim([-4 4])
% xlabel('Time (s)');
% ylabel('Current (mA)');
% subplot(2,3,2);
% title('Electrode 2'); hold on;
% plot(t,(NewElectM(2,2:end)./100), "Color", [0.8500 0.2250 0.0980], LineWidth=5);
% xlim([0 12])
% ylim([-4 4])
% xlabel('Time (s)');
% ylabel('Current (mA)');
% subplot(2,3,3);
% title('Electrode 3'); hold on;
% plot(t,(NewElectM(3,2:end)./100), "Color", [0.4660 0.7740 0.1880], LineWidth=5);
% xlim([0 12])
% ylim([-4 4])
% xlabel('Time (s)');
% ylabel('Current (mA)');
% subplot(2,3,4);
% title('Electrode 4'); hold on;
% plot(t,(NewElectM(4,2:end)./100), "Color", [0.9290 0.6940 0.1250], LineWidth=5);
% xlim([0 12])
% ylim([-4 4])
% xlabel('Time (s)');
% ylabel('Current (mA)');
% subplot(2,3,5);
% title('Electrode 5'); hold on;
% plot(t,(NewElectM(5,2:end)./100), "Color", "black", LineWidth=5);
% xlim([0 12])
% ylim([-4 4])
% xlabel('Time (s)');
% ylabel('Current (mA)');
% set(gcf,'position',[100,100,1500,800])  
% 
% % cd('Profiles/');
% % saveas(gcf, Filename);
% % cd('../');

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
cd(Folder);
save([Filename '.mat'], 'Profile');
cd(code_path);
%writecell(Y,"CHAIR_GVS_Profile_.csv");
