% Created by: Caroline Austin 2/6/24
% Script 2b of X2B data processing 
% This script reads in the output of script 1 (X2BGet files) and processes
% the IMU data files by running them through the gravity align function and
% then extracting sway metrics?

close all; 
clear all; 
clc; 


%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory % select data folder
plots_path = [file_path '/Plots']; % specify where plots are saved
cd(code_path); cd .. ;
[foldernames]=file_path_info2(code_path, file_path); % get foldernames from file folder

subnum = [2065];  % Subject List 2044:2048, 2050,2052, 2063:
numsub = length(subnum);
subskip = [2049 40005 40006];  %DNF'd subjects or subjects that didn't complete this part

sensorpositionplot = 0;

%%
total_results = zeros(3,2);
three_electrode_fft_SpHz_accx = NaN(10,numsub);
four_electrode_fft_SpHz_accx = NaN(10,numsub);
three_electrode_fft_SpHz_accy = NaN(10,numsub);
four_electrode_fft_SpHz_accy = NaN(10,numsub);
three_electrode_fft_SpHz_accz = NaN(10,numsub);
four_electrode_fft_SpHz_accz = NaN(10,numsub);

for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    subject_path = [file_path '/' subject_str];

    % find IMU data
    cd(code_path); cd ..;
    [IMU_files]=file_path_info2(code_path, [file_path, '/' , subject_str, '/IMU']); % get filenames from file folder
     

    file_count = 0;
    f_index = 0;
    s_index = 0;
    n_index = 0;
    for file = 1:length(IMU_files)
        
        %index through the csv files
        if ~contains(IMU_files(file), '.mat')
            continue
        end
        file_count = file_count+1;
        %load trial data
        cd([subject_path '/IMU']);
        load(IMU_files{file});
        x_tick_label{file_count,sub} = IMU_files{file}(7:12);

        Euler = imu_data(2:end,1:3); % exclude first line of 0's
        % not sure why, but order needs to be rotated like this- maybe so that the
        % axis that is most aligned with what we want to be z is the third?
        acc = imu_data(2:end,[6,5,4]); 
        gyro = pi/180*imu_data(2:end,7:9); % convert to rad/s


        Label.imu = imu_table.Properties.VariableNames(3:11);
        time = 0:1/30:((height(acc)/30)-1/30);
        timeimu = 0:1/30:((height(imu_data)/30)-1/30);
        if length(timeimu) > 285
            time_cut = timeimu > 2 & timeimu < 9.5;
        else
            fft_SpHz_acc(file_count,sub) = NaN;
            fft_SpHz_accx(file_count,sub) = NaN;
            fft_SpHz_accy(file_count,sub) = NaN;
            fft_SpHz_accz(file_count,sub) = NaN;
            fft_SpHz_accmag(file_count,sub) = NaN;

            freq_SpHz(file_count,sub) = NaN;
            freq_SpHzx(file_count,sub) = NaN;
            freq_SpHzy(file_count,sub) = NaN;
            freq_SpHzz(file_count,sub) = NaN;
            freq_SpHzmag(file_count,sub) = NaN;
            continue;
        end

        cd(code_path); cd .. ;
        [acc_aligned, gyro_aligned, yaw, pitch, roll] = GravityAligned(acc, gyro,sensorpositionplot);
        %[Xlimit,Ylimit] = PlotScale(imu_data,time);
        cutacc = acc_aligned(time_cut,:);
        cutgyro = gyro_aligned(time_cut,:);
        cutyaw = yaw(time_cut);
        cutroll = roll(time_cut);
        cutpitch = pitch(time_cut);


        data_type = ["EulerX","EulerY","EulerZ","accX","accY","accZ","gyroX","gyroY","gyroZ"];
        direction = ["Z", "Y", "X"];

        % magnitude of gyro and acc 
        mag_acc = sqrt((cutacc(:,2).^2) + (cutacc(:,3).^2));
        mag_gyro = sqrt((gyro_aligned(:,1).^2) + (gyro_aligned(:,2).^2));
        Y_accz = fft(cutacc(:,1));
        Y_accx = fft(cutacc(:,3));
        Y_accy = fft(cutacc(:,2));
        Y_acc = fft(mag_acc); Y_gyro = fft(mag_gyro);

        % fft: roll, pitch, yaw 
        Y_yaw = fft(yaw); Y_pitch = fft(pitch); Y_roll = fft(roll);

         [fft_SpHz_acc(file_count,sub),freq_SpHz(file_count,sub),P1g,fg] = fftcalc(Y_acc,time);

         [fft_SpHz_accx(file_count,sub),freq_SpHzx(file_count,sub),P1gx,fgx] = fftcalc(Y_accx,time);
         [fft_SpHz_accz(file_count,sub),freq_SpHzz(file_count,sub),P1gz,fgz] = fftcalc(Y_accz,time);
         [fft_SpHz_accy(file_count,sub),freq_SpHz(file_count,sub),P1gy,fgy] = fftcalc(Y_accy,time);
         [fft_SpHz_accymag(file_count,sub),freq_SpHzmag(file_count,sub),P1gymag,fgymag] = fftcalc(Y_acc,time);

        switch x_tick_label{file_count,sub}
            case "3_elec"
                f_index = f_index+1;
                three_electrode_fft_SpHz_accx(f_index,sub) = fft_SpHz_accx(file_count,sub);
                three_electrode_fft_SpHz_accy(f_index,sub) = fft_SpHz_accy(file_count,sub);
                three_electrode_fft_SpHz_accz(f_index,sub) = fft_SpHz_accy(file_count,sub);
            case "4_elec"
                s_index = s_index+1;
                four_electrode_fft_SpHz_accx(s_index,sub) = fft_SpHz_accx(file_count,sub);
                four_electrode_fft_SpHz_accy(s_index,sub) = fft_SpHz_accy(file_count,sub);
                four_electrode_fft_SpHz_accz(s_index,sub) = fft_SpHz_accz(file_count,sub);

        end

    end

end

%% plot results
figure; subplot(2,1,1); boxplot(three_electrode_fft_SpHz_accx); xticklabels([]); title("Three Electrode"); ylim([0 20*10^-3]);
subplot(2,1,2);boxplot(four_electrode_fft_SpHz_accx); xticklabels([]); title("Four Electrode"); ylim([0 20*10^-3]);
xticklabels(subnum); xlabel("Subject");
sgtitle("X sway near 0.5Hz");

figure; subplot(2,1,1); boxplot(three_electrode_fft_SpHz_accy); xticklabels([]); title("Three Electrode"); ylim([0 0.3]);
subplot(2,1,2);boxplot(four_electrode_fft_SpHz_accy); xticklabels([]); title("Four Electrode"); ylim([0 0.3]);
xticklabels(subnum); xlabel("Subject");
sgtitle("Y sway near 0.5Hz");

figure; subplot(2,1,1); boxplot(three_electrode_fft_SpHz_accz); xticklabels([]); title("Three Electrode"); ylim([0 0.4]);
subplot(2,1,2);boxplot(four_electrode_fft_SpHz_accz); xticklabels([]); title("Four Electrode"); ylim([0 0.4]);
xticklabels(subnum); xlabel("Subject");
sgtitle("Z sway near 0.5Hz");

cd(code_path);

function [mfftsphz,freq_SpHz,P1,f] = fftcalc(Y,time)
        %fourier_calc = (fft(gyro_aligned(:,1))); 
        %Y = fft(gyro_aligned(:,1));
        FS = 30; % sampling freq.
        T = 1/FS; % period
        L = length(time); % length of signal
        t = (0:L-1)*T; % time vector 
        time_verify = time - t; % should result in zeros vector

        x_vec = FS/L*(0:L-1);
        %x_vec = FS/L*(-L/2:L/2-1);
        %fft_med = median(abs(fourier_calc));
        %[Max,ind] = max(abs(fourier_calc(2:length(gyro_aligned))));
        %mnxfft_freq(i) = x_vec(ind);

        % Power spectral density
        %S = 0.8 + 0.7*sin(2*pi*1*t) + 2*randn(size(t));  % example signal S, with signal at 1 Hz of amplitude 0.7 plus DC offset and noise
  
        %Fs = 1/(t(2)-t(1));            % Sampling frequency                    
        %T = 1/Fs;             % Sampling period      
        L = length(Y);             % Length of signal
        P2 = abs(Y/L);        % two-sided amplitude spectrum
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);  % to produce the one-sided amplitude spectrum, take the first half of the 2 sided, then multiply in the positive spectrum by 2. You do not need to multiply P1(1) and P1(end) by 2 because these amplitudes correspond to the zero and Nyquist frequencies respectively, and they do not have the complex conjugate pairs in the negative frequencies
        f = FS/L*(0:(L/2));   % Define the frequency domain f for the single sided spectrum
        Hz_val = 0.5; % looking for fft values at 1Hz freq.
        subval = (abs(f - Hz_val));
        accept_range = subval < 0.2; % getting a range of values around 0.5Hz
        
        fft_SpHz = P1(accept_range);
        mfftsphz = max(fft_SpHz);
        locmax = find(P1 == mfftsphz);
        freq_SpHz = f(locmax); % freq. within 0.2 Hz range of 1Hz
        %save_trail_name{i,sub} = trial_name;

        rangeloc = find(accept_range);
        minline = f(rangeloc(1)); maxline = f(rangeloc(end));
        

        % figure;
        % plot(f,P1,'-o','MarkerIndices',locmax,'MarkerFaceColor','red','MarkerSize',8,"LineWidth",3); hold on;
        % xline(maxline,'--','Color','red'); xline(minline,'--','Color','red');
        % ylim([0 1.5]);
        % 
        % sgtitle(strrep(trial_name,'_','.'));
        % title("Single-Sided Amplitude Spectrum")
        % xlabel("f (Hz)")
        % ylabel("|P1(f)|")
end


