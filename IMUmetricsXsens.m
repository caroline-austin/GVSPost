close all;clear;clc; warning off;

%% set up
subnum = 1017:1022;  % Subject List 
numsub = length(subnum);
subskip = [0,1021];  %DNF'd subjects or subjects that didn't complete this part
file_count = 0;
sensorpositionplot = 0;

% set up pathing
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
if ismac || isunix
    plots_path = [file_path '/Plots/Measures/IMU']; % specify where plots are saved
elseif ispc
    plots_path = [file_path '\Plots\Measures\IMU']; % specify where plots are saved
end
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

for sub = 1:numsub % first for loop that iterates through subject files
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end

    % subject_path = [file_path, '\PS' , subject_str];
    if ismac || isunix
        subject_path = [file_path, '/' , subject_str, '/IMU_data'];

    elseif ispc
        subject_path = [file_path, '\' , subject_str , '\IMU_data'];
               
    end
    cd(subject_path);

    cd(file_path); % change directories
    Label.TrialInfo = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','P1:T1');
    TrialInfo = readcell('DynamicGVSPlusTilt.xlsx','Sheet',['S' subject_str] ,'Range','P2:T13');
    TrialInfo(cellfun(@(x) any(ismissing(x)), TrialInfo)) = {''};
    cd(code_path);

    imu_list = file_path_info2(code_path, subject_path); % get files from file folder

    for i=1:length(imu_list) % nested for loop that iterates through IMU files in the subject folder

        if (endsWith(imu_list(i),'.csv') == false) % <change this to check if file type is not excel
            continue
        end
       
        file_count = file_count+1; % keeps track of the number of readable files currently read in the cycle
        original_filename = imu_list(i);
        cd(subject_path);
        imu_table = readtable(string(imu_list(i)));
        cd(code_path);

        %pull label info from table and save into Label structure 

        imu_data = table2array(imu_table(:,3:11));

        Euler = imu_data(2:end,1:3); % exclude first line of 0's
        acc = imu_data(2:end,4:6);
        gyro = pi/180*imu_data(2:end,7:9); % convert to rad/s


        Label.imu = imu_table.Properties.VariableNames(3:11);
        time = 0:1/30:((height(acc)/30)-1/30);
        timeimu = 0:1/30:((height(imu_data)/30)-1/30);

        [acc_aligned, gyro_aligned, yaw, pitch, roll] = GravityAligned(acc, gyro,sensorpositionplot);
        [Xlimit,Ylimit] = PlotScale(imu_data,time);

        while strlength(string(TrialInfo(file_count,3))) ~= 5  % makes all trial names the same number of chars
            if strlength(string(TrialInfo(file_count,3))) == 1
                TrialInfo(file_count,3) = mat2cell(string(TrialInfo(file_count,3)) + ".000",1);
            else
                TrialInfo(file_count,3) = mat2cell(string(TrialInfo(file_count,3)) + "0",1);
            end
        end

        trial_name = strrep(cell2mat(strcat(TrialInfo(file_count,2), '_', ...
            string(TrialInfo(file_count,3)), 'mA_', TrialInfo(file_count,4), '_', ...
            string(TrialInfo(file_count,5)), 'Hz', string(TrialInfo(file_count,1)))),'.','_');

        data_type = ["EulerX","EulerY","EulerZ","accX","accY","accZ","gyroX","gyroY","gyroZ"];
        direction = ["Z", "Y", "X"];

        % magnitude of gyro and acc 
        mag_acc = sqrt((acc_aligned(:,1).^2) + (acc_aligned(:,2).^2));
        mag_gyro = sqrt((gyro_aligned(:,1).^2) + (gyro_aligned(:,2).^2));
        Y_gyroz = fft(gyro_aligned(:,3));
        Y_gyrox = fft(gyro_aligned(:,1));
        Y_gyroy = fft(gyro_aligned(:,2));
        Y_acc = fft(mag_acc); Y_gyro = fft(mag_gyro);

        % fft: roll, pitch, yaw 
        Y_yaw = fft(yaw); Y_pitch = fft(pitch); Y_roll = fft(roll);


        % fft func.:
        [fft_SpHz_gyro(i,sub),freq_SpHz,P1g,fg] = fftcalc(i,Y_gyro,time,sub,trial_name);
        [fft_SpHz_acc(i,sub),freq_SpHz,P1a,fa] = fftcalc(i,Y_acc,time,sub,trial_name);
        [fft_SpHz_yaw(i,sub),freq_SpHz,P1y,fy] = fftcalc(i,Y_yaw,time,sub,trial_name);
        [fft_SpHz_pitch(i,sub),freq_SpHz,P1p,fp] = fftcalc(i,Y_pitch,time,sub,trial_name);
        [fft_SpHz_roll(i,sub),freq_SpHz,P1r,fr] = fftcalc(i,Y_roll,time,sub,trial_name);
        [fft_SpHz_gyroz(i,sub),freq_SpHz,P1gz,fgz] = fftcalc(i,Y_gyroz,time,sub,trial_name);
        [fft_SpHz_gyrox(i,sub),freq_SpHz,P1gx,fgx] = fftcalc(i,Y_gyrox,time,sub,trial_name);
        [fft_SpHz_gyroy(i,sub),freq_SpHz,P1gy,fgy] = fftcalc(i,Y_gyroy,time,sub,trial_name);

        % figure;
        % plot(fgz,P1gz,"LineWidth",3)
        % sgtitle(strrep(trial_name,'_','.'));
        % %title("Single-Sided Amplitude Spectrum")
        % xlabel("f (Hz)")
        % ylabel("|P1(f)|")
        
        
        % figure();
        % stem(x_vec,abs((fourier_calc))); hold on;
        % %plot(x_vec,abs(smoothdata(fourier_calc,"gaussian",5))); hold off;
        % title('Complex Magnitude of FFT');
        % xlabel('Frequency [Hz]'); ylabel("|fft|");
        % 
        % figure();
        % sgtitle(trial_name)
        % for j=1:width(imu_data) % nested for loop that plots each column inside of an IMU file 
        %     subplot(3,3,j);
        %     plot(timeimu, imu_data(:,j));
        %     xlim(Xlimit)
        %     title(data_type(j));
        % end
        % 
        % Filename=(['S' subject_str 'IMU' trial_name]);
        % cd(plots_path)
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path)

% save files

        % cd(subject_path);
        % vars_2_save = ['Label ' 'original_filename ' 'imu_data ' 'time'];
        % eval(['  save ' ['S' subject_str 'IMU' trial_name '.mat '] vars_2_save ' vars_2_save']);     
        % cd(code_path);
        % close all;

        %% Gravity Aligned Plots

        % figure();
        % sgtitle(strrep(trial_name,'_','.'));
        % 
        % for k=1:width(acc_aligned)
        %     subplot(3,3,k+3)
        %     plot(time,acc_aligned(:,k))
        %     ylim([-8 10])
        %     xlim(Xlimit)
        %     direction_title_1 = strcat("Acc Aligned ", direction(k));
        %     title(direction_title_1)
        %     xlabel("seconds");
        %     ylabel("m/s^2")
        % end
        % 
        % for l=1:width(gyro_aligned)
        %     subplot(3,3,l+6)
        %     plot(time,gyro_aligned(:,l))
        %     ylim([-8 8])
        %     xlim(Xlimit)
        %     direction_title_2 = strcat("Gyro Aligned ", direction(l));
        %     title(direction_title_2)
        %     xlabel("seconds");
        %     ylabel("degrees")
        % end
        % 
        % subplot(3,3,1)
        % plot(time,yaw)
        % xlim(Xlimit)
        % ylim([-10 10])
        % title("Yaw")
        % xlabel("seconds");
        % ylabel("degrees")
        % 
        % subplot(3,3,2)
        % plot(time,pitch)
        % xlim(Xlimit)
        % ylim([-10 10])
        % title("Pitch")
        % xlabel("seconds");
        % ylabel("degrees")
        % 
        % subplot(3,3,3)
        % plot(time,roll)
        % xlim(Xlimit)
        % ylim([-10 10])
        % title("Roll")
        % xlabel("seconds");
        % ylabel("degrees")
        % 
        % Filename=(['S' subject_str 'IMU' trial_name '_GravityAligned']);
        % cd(plots_path)
        % saveas(gcf, [char(Filename) '.fig']);
        % cd(code_path)
        % 
        % cd(subject_path);
        % vars_2_save = ['Label ' 'original_filename ' 'imu_data ' 'time'];
        % eval(['  save ' ['S' subject_str 'IMU' trial_name '.mat '] vars_2_save ' vars_2_save']);     
        % cd(code_path);
%         close all;

    end
    %eval (['clear ' vars_2_save])
    file_count = 0;
    %savesubfft{sub} = mnxfft_freq;
    for mA = 1:length(TrialInfo)
        if isstring(TrialInfo{mA,3})
            trialinfo_mAval(sub,mA) = str2num(TrialInfo{mA,3});
        else
            trialinfo_mAval(sub,mA) = (TrialInfo{mA,3});
        end

    end

end   

% [C_acc] = boxplotfft(fft_SpHz_acc,numsub,trialinfo_mAval);
[C_gyro] = boxplotfft(fft_SpHz_gyro,numsub,trialinfo_mAval);
% [C_yaw] = boxplotfft(fft_SpHz_yaw,numsub,trialinfo_mAval);
% [C_pitch] = boxplotfft(fft_SpHz_pitch,numsub,trialinfo_mAval);
% [C_roll] = boxplotfft(fft_SpHz_roll,numsub,trialinfo_mAval);
% [C_gz] = boxplotfft(fft_SpHz_gyroz,numsub,trialinfo_mAval);
% [C_gx] = boxplotfft(fft_SpHz_gyroy,numsub,trialinfo_mAval);
% [C_gy] = boxplotfft(fft_SpHz_gyrox,numsub,trialinfo_mAval);




function [C] = boxplotfft(fft_SpHz,numsub,trialinfo_mAval)
fft_SpHz(fft_SpHz == 0) = NaN;

for mHz = 1:numsub
    trls = fft_SpHz(~isnan(fft_SpHz(:,mHz)),mHz);
    if length(trls) == length(trialinfo_mAval)
        val_mat_mA(:,:,mHz) = [trls,trialinfo_mAval(mHz,:)'];
    elseif length(trls) == (length(trialinfo_mAval) - 1)
        trls1 = [NaN;trls];
        val_mat_mA(:,:,mHz) = [trls1,trialinfo_mAval(mHz,:)'];
    elseif length(trls) == (length(trialinfo_mAval) - 2)
        trls2 = [NaN;NaN;trls];
        val_mat_mA(:,:,mHz) = [trls2,trialinfo_mAval(mHz,:)'];
    end
end

sortval = sort(val_mat_mA);
switchmat = permute(sortval,[3 2 1]);

C = [];
for bp = 1:12
 C = [C;switchmat(:,:,bp)];
end

figure();
boxplot(C(:,1),C(:,2));
xlabel('mA'); ylabel('P1 amplitude spectrum');
end


function [fft_SpHz,freq_SpHz,P1,f] = fftcalc(i,Y,time,sub,trial_name)
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
        Hz_val = 1; % looking for fft values at 1Hz freq.
        [subval, loc] = min(abs(f - Hz_val));
        freq_SpHz = f(loc); % freq. closest to 1 Hz
        fft_SpHz = P1(loc);
        %save_trail_name{i,sub} = trial_name;
        

        % figure;
        % plot(f,P1,"LineWidth",3)
        % sgtitle(strrep(trial_name,'_','.'));
        % %title("Single-Sided Amplitude Spectrum")
        % xlabel("f (Hz)")
        % ylabel("|P1(f)|")
end
 


