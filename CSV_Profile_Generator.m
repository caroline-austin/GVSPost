clear; close all; clc;

%% Input information.
Duration=input('1) Enter signal duration (in seconds): ');
fs=input('2) Enter sampling frequency (in Hz): ');
PmA=input('3) Enter peak current desired (in mA): ');
if PmA>3
    error('Error: Peak current cannot exceed 3 mA.')
end
Polarity_Type=input('4) Enter polarity type (1 = Unipolar or 2 = Bipolar): ');
if Polarity_Type<1 && Polarity_Type>2
    error('Error: Polarity type must be 1 (unipolar) or 2 (bipolar).');
end
Electrode_Num=input('5) Enter number of electrodes using (2-5): ');
if Electrode_Num>3 && Electrode_Num<=5
    Electrode_Config=input('5b) Enter number of cathodes (1 or 2): ');
elseif Electrode_Num<2 && Electrode_Num>5
    error('Error: Number of electrodes cannot be <2 or >5.');
end
Profile_Type=input('6) Enter profile signal type (1 = Sinusoidal or 2 = Noise): ');

dt=1/fs;  %%% seconds per sample.
t=(0:dt:Duration);  %%% time vector (in seconds).
T=length(t);
freq=0:fs/T:fs/2;

%% Run appropriate signal generator.
if Profile_Type==1
    GVS_Signal=Sinusoidal(t,PmA,Polarity_Type);
elseif Profile_Type==2
    GVS_Signal=Noise(fs,T,PmA,Polarity_Type);
end

%% Power Spectral Density Analysis:
%%% GVS Signal
xdft=fft(GVS_Signal);
xdft=xdft(1:T/2+1);
psdx=(1/(fs*T))*abs(xdft).^2;
psdx(2:end-1)=2*psdx(2:end-1);

%% Create GVS signals for all electrodes.
Electrode_1_Sig=GVS_Signal;
if Electrode_Num==2
    Electrode_2_Sig=GVS_Signal*(-1);
    Electrode_3_Sig=zeros(1,T);
    Electrode_4_Sig=Electrode_3_Sig;
    Electrode_5_Sig=Electrode_3_Sig;
elseif Electrode_Num==3
    Electrode_2_Sig=GVS_Signal*(-.5);
    Electrode_3_Sig=Electrode_2_Sig;
    Electrode_4_Sig=zeros(1,T);
    Electrode_5_Sig=Electrode_4_Sig;
elseif Electrode_Num==4
    if Electrode_Config==1
        Electrode_2_Sig=GVS_Signal*(-1/3);
        Electrode_3_Sig=Electrode_2_Sig;
        Electrode_4_Sig=Electrode_2_Sig;
        Electrode_5_Sig=zeros(1,T);
    elseif Electrode_Config==2
        Electrode_2_Sig=GVS_Signal;
        Electrode_3_Sig=GVS_Signal*(-1);
        Electrode_4_Sig=Electrode_3_Sig;
        Electrode_5_Sig=zeros(1,T);
    end
elseif Electrode_Num==5
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

%% Make electrode matrix, then round values to hundredths.
ElectrodesM=[dt Electrode_1_Sig;0 Electrode_2_Sig;0 Electrode_3_Sig;0 Electrode_4_Sig;0 Electrode_5_Sig];
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

%% Create CSV file that removes decimals and adds +/- sign.
X=num2str(NewElectM,'%+04g '); %% Create 5 character string with 3-digit number + symbol, then space after.
%%% Create electrode matrix of 5 character values.
Y(1,:)=strsplit(X(1,:)," ");
Y(2,:)=strsplit(X(2,:)," ");
Y(3,:)=strsplit(X(3,:)," ");
Y(4,:)=strsplit(X(4,:)," ");
Y(5,:)=strsplit(X(5,:)," ");
Profile = Y;
%%% Write CSV file.
save('CHAIR_GVS_Profile.mat', 'Profile');
%writecell(Y,"CHAIR_GVS_Profile_.csv");