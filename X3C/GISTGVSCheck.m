code_path = pwd;
[filename, file_path ]= uigetfile('*.csv');
cd(file_path)
Sample_GIST=readtable(filename);
cd(code_path)
%%
SDWave = 0;
time = Sample_GIST.Time/375;
[Ch1, Ch2, Ch3, currentR, currentL] = GIST_GVS_Est(Sample_GIST, 'DCWV' , SDWave);

figure;
subplot(3,1,1)
plot(time,Ch1); hold on;
plot(time,Sample_GIST.CH1Current/1000);
legend(["Ch1 est", "Ch1 act"])
ylabel("Current (mA)")

subplot(3,1,2)
plot(time,Ch2); hold on;
plot(time,Sample_GIST.CH2Current/1000);
legend(["Ch2 est", "Ch2 act"])
ylabel("Current (mA)")

subplot(3,1,3)
plot(time,Ch3); hold on;
plot(time,Sample_GIST.CH3Current/1000);
legend(["Ch3 est", "Ch3 act"])
ylabel("Current (mA)")
xlabel("time (s)")

figure;
plot(time, (abs(Ch1)+abs(Ch2)+abs(Ch3)));
hold on;
plot(time,(abs(Sample_GIST.CH1Current)+abs(Sample_GIST.CH2Current)+abs(Sample_GIST.CH3Current))/1000);
legend(["Ch3 est", "Ch3 act"]) 
ylabel("Current (mA)")
xlabel("time (s)")

