close all;clear;clc; warning off;

%% set up
subnum = 1017:1022;  % Subject List 
%subnum = 1022;
numsub = length(subnum);
subskip = [0,1028];  %DNF'd subjects or subjects that didn't complete this part
file_count = 0;
sensorpositionplot = 0;
match_list = [0 0 0.1 0.1 0.25 0.5 0.75 1 1.25 1.5 2 4];

% colors- first 5 are color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];
yellow = [255 190 50]/255;
Color_list = [blue; green; yellow; red; navy; purple];

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
    close all;
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

    file_names = file_path_info2(code_path, subject_path); % get files from file folder
    imu_list = file_names;

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
            continue;
        end

        [acc_aligned, gyro_aligned, yaw, pitch, roll] = GravityAligned(acc, gyro,sensorpositionplot);
        %[Xlimit,Ylimit] = PlotScale(imu_data,time);
        cutacc = acc_aligned(time_cut,:);
        cutgyro = gyro_aligned(time_cut,:);
        cutyaw = yaw(time_cut);
        cutroll = roll(time_cut);
        cutpitch = pitch(time_cut);


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
        mag_acc = sqrt((cutacc(:,2).^2) + (cutacc(:,3).^2));
        mag_gyro = sqrt((gyro_aligned(:,1).^2) + (gyro_aligned(:,2).^2));
        Y_accz = fft(cutacc(:,1));
        Y_accx = fft(cutacc(:,3));
        Y_accy = fft(cutacc(:,2));
        Y_acc = fft(mag_acc); Y_gyro = fft(mag_gyro);

        % fft: roll, pitch, yaw 
        Y_yaw = fft(yaw); Y_pitch = fft(pitch); Y_roll = fft(roll);


        % fft func.:
        %[fft_SpHz_gyro(i,sub),freq_SpHz,P1g,fg] = fftcalc(i,Y_gyro,time,sub,trial_name);
        % [fft_SpHz_acc(i,sub),freq_SpHz,P1a,fa] = fftcalc(i,Y_acc,time,sub,trial_name);
        % [fft_SpHz_yaw(i,sub),freq_SpHz,P1y,fy] = fftcalc(i,Y_yaw,time,sub,trial_name);
        % [fft_SpHz_pitch(i,sub),freq_SpHz,P1p,fp] = fftcalc(i,Y_pitch,time,sub,trial_name);
        % [fft_SpHz_roll(i,sub),freq_SpHz,P1r,fr] = fftcalc(i,Y_roll,time,sub,trial_name);
         %[fft_SpHz_accz(i,sub),freq_SpHz,P1gz,fgz] = fftcalc(i,Y_accz,time,sub,trial_name);
        %[fft_SpHz_accx(i,sub),freq_SpHz,P1gx,fgx] = fftcalc(i,Y_accx,time,sub,trial_name);
        [fft_SpHz_acc(file_count,sub),freq_SpHz(file_count,sub),P1g,fg] = fftcalc(i,Y_acc,time,sub,trial_name);

         [fft_SpHz_accx(file_count,sub),freq_SpHzx(file_count,sub),P1gx,fgx] = fftcalc(i,Y_accx,time,sub,trial_name);
         [fft_SpHz_accz(file_count,sub),freq_SpHzz(file_count,sub),P1gz,fgz] = fftcalc(i,Y_accz,time,sub,trial_name);
         [fft_SpHz_accy(file_count,sub),freq_SpHz(file_count,sub),P1gy,fgy] = fftcalc(i,Y_accy,time,sub,trial_name);
         [fft_SpHz_accymag(file_count,sub),freq_SpHzmag(file_count,sub),P1gymag,fgymag] = fftcalc(i,Y_acc,time,sub,trial_name);

        % 
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
        %     xline(2); xline(9.5);
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
        %     %plot(time(time_cut),cutacc(:,k))
        %     plot(time,acc_aligned(:,k))
        %     xline(2); xline(9.5);
        %     ylim([-8 10])
        %     %xlim(Xlimit)
        %     direction_title_1 = strcat("Acc Aligned ", direction(k));
        %     title(direction_title_1)
        %     xlabel("seconds");
        %     ylabel("m/s^2")
        % end
        % 
        % for l=1:width(gyro_aligned)
        %     subplot(3,3,l+6)
        %     %plot(time(time_cut),cutgyro(:,l))
        %     plot(time,gyro_aligned(:,l))
        %     xline(2); xline(9.5);
        %     ylim([-8 8])
        %     %xlim(Xlimit)
        %     direction_title_2 = strcat("Gyro Aligned ", direction(l));
        %     title(direction_title_2)
        %     xlabel("seconds");
        %     ylabel("deg/sec")
        % end
        % 
        % subplot(3,3,1)
        % %plot(time(time_cut),cutyaw)
        % plot(time,yaw)
        % xline(2); xline(9.5);
        % %xlim(Xlimit)
        % ylim([-10 10])
        % title("Yaw")
        % xlabel("seconds");
        % ylabel("degrees")
        % 
        % subplot(3,3,2)
        % %plot(time(time_cut),cutpitch)
        % plot(time,pitch)
        % xline(2); xline(9.5);
        % %xlim(Xlimit)
        % ylim([-10 10])
        % title("Pitch")
        % xlabel("seconds");
        % ylabel("degrees")
        % 
        % subplot(3,3,3)
        % %plot(time(time_cut),cutroll)
        % plot(time,roll)
        % xline(2); xline(9.5);
        % %xlim(Xlimit)
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

trialinfo_mAval= trialinfo_mAval';

%%
fft_SpHz_acc_sort = NaN(numsub,length(match_list));
fft_SpHz_accy_sort = NaN(numsub,length(match_list));
for subject = 1:width(trialinfo_mAval)
    check_0 = 0;
    check_01 = 0;
    for trial = 1:length(trialinfo_mAval)
        for match = 1:length(match_list)
            if trialinfo_mAval(trial,subject) == match_list(match)
            
                if match ==1 && check_0 ~= 0
                    continue
                elseif match ==3 && check_01 ~= 0
                    continue
                elseif match ==1
                    check_0 =1;
                elseif match == 3
                    check_01 =1;
                end
                fft_SpHz_acc_sort(subject,match) = fft_SpHz_acc(trial,subject);
                fft_SpHz_accy_sort(subject,match) = fft_SpHz_accy(trial,subject);
            end
        end
        
    end
end

%%
 [C_gy] = boxplotfft(fft_SpHz_accy,numsub,trialinfo_mAval);
 % [C_gx] = boxplotfft(fft_SpHz_accx,numsub,trialinfo_mAval);
 % [C_gz] = boxplotfft(fft_SpHz_accz,numsub,trialinfo_mAval);
 % [C_accmag] = boxplotfft(fft_SpHz_accymag,numsub,trialinfo_mAval);

 % %%
 % figure;
 % % boxchart(fft_SpHz_accy_sort)
 % fft_SpHz_accy_sort(fft_SpHz_accy_sort == 0) = NaN;
 %  boxplot(fft_SpHz_accy_sort)




function [C] = boxplotfft(fft_SpHz,numsub,trialinfo_mAval)
fft_SpHz(fft_SpHz == 0) = NaN; % setting non-recorded values to NaN

% for mHz = 1:numsub
%     trls = fft_SpHz(~isnan(fft_SpHz(:,mHz)),mHz);
%     if length(trls) == length(trialinfo_mAval)
%         val_mat_mA(:,:,mHz) = [trls,trialinfo_mAval(:,mHz)];
%     elseif length(trls) == (length(trialinfo_mAval) - 1)
%         trls1 = [NaN;trls];
%         val_mat_mA(:,:,mHz) = [trls1,trialinfo_mAval(:,mHz)];
%     elseif length(trls) == (length(trialinfo_mAval) - 2)
%         trls2 = [NaN;NaN;trls];
%         val_mat_mA(:,:,mHz) = [trls2,trialinfo_mAval(:,mHz)];
%     end
%     sortval(:,:,mHz) = sortrows(val_mat_mA(:,:,mHz),2);
% end

for mHz = 1:numsub
    val_mat_mA = [fft_SpHz(:,mHz),trialinfo_mAval(:,mHz)];
    sortval(:,:,mHz) = sortrows(val_mat_mA,2);
end

switchmat = permute(sortval,[3 2 1]);

C = [];
for bp = 1:12
 C = [C;switchmat(:,:,bp)];
end

findloc = find(C(:,1) == 0);
for rem = 1:length(findloc)
    C(findloc(rem),:) = NaN;
end

subcode = ["o" "+" "*" "x" "square" "^"];

% viodatx = C(:,1);
% xval = linspace(prctile(viodatx,1),prctile(viodatx,99), 100);
% 
% [f,xi] = ksdensity( viodatx(:),xval,'Bandwidth',0.05,'BoundaryCorrection','reflection');
% 
% figure();
% patch( 0-[f,zeros(1,numel(xi),1),0],[xi,fliplr(xi),xi(1)],'r' );

fig = figure();

b = boxplot(C(:,1),C(:,2),"Symbol",'.'); hold on;
% blue = [ 0.2118    0.5255    0.6275];
% b.BoxFaceColor = blue;
% boxchart(C(:,2),C(:,1));  hold on;
for rot = 1:numsub
    find0 = find(sortval(:,2,rot) == 0); find0_1 = find(sortval(:,2,rot) == 0.1);
    find0_25 = find(sortval(:,2,rot) == 0.25); find0_5 = find(sortval(:,2,rot) == 0.5);
    find0_75 = find(sortval(:,2,rot) == 0.75); find1 = find(sortval(:,2,rot) == 1);
    find1_25 = find(sortval(:,2,rot) == 1.25); find1_5 = find(sortval(:,2,rot) == 1.5);
    find2 = find(sortval(:,2,rot) == 2); find4 = find(sortval(:,2,rot) == 4);
    
    subplot = sortval(:,:,rot);
    plcmnt = linspace(0.8,1.2,numsub); col = 0:9;
    repplc = repmat(plcmnt,[10 1]); repplc = repplc';
    ocol = repmat(col,[numsub 1]); matocal = repplc + ocol; 
    plot(matocal(rot,1),sortval(find0,1,rot),subcode(rot),'Color','black', 'MarkerSize', 15, 'LineWidth', 2); 
    plot(matocal(rot,2),sortval(find0_1,1,rot),subcode(rot),'Color','black','MarkerSize', 15, 'LineWidth', 2);
    plot(matocal(rot,3),sortval(find0_25,1,rot),subcode(rot),'Color','black','MarkerSize', 15, 'LineWidth', 2);
    plot(matocal(rot,4),sortval(find0_5,1,rot),subcode(rot),'Color','black','MarkerSize', 15, 'LineWidth', 2);
    plot(matocal(rot,5),sortval(find0_75,1,rot),subcode(rot),'Color','black','MarkerSize', 15, 'LineWidth', 2);
    plot(matocal(rot,6),sortval(find1,1,rot),subcode(rot),'Color','black','MarkerSize', 15, 'LineWidth', 2);
    plot(matocal(rot,7),sortval(find1_25,1,rot),subcode(rot),'Color','black','MarkerSize', 15, 'LineWidth', 2);
    plot(matocal(rot,8),sortval(find1_5,1,rot),subcode(rot),'Color','black','MarkerSize', 15, 'LineWidth', 2);
    plot(matocal(rot,9),sortval(find2,1,rot),subcode(rot),'Color','black','MarkerSize', 15, 'LineWidth', 2);
    plot(matocal(rot,10),sortval(find4,1,rot),subcode(rot),'Color','black','MarkerSize', 15, 'LineWidth', 2);
end

hold off;
% xlabel('Current (mA)','Interpreter','latex','FontSize',25,'FontName','Arial'); 
ylabel('FFT Amplitude Near 1Hz ($\frac{m}{s^2}$)','Interpreter','latex','FontSize',25,'FontWeight','bold');
xlabel('Current (mA)','FontSize',17,'FontName','Arial'); 
% ylabel('FFT Amplitude Near 1Hz (m/s^2)','FontSize',17,'FontName','Arial');
% title('Amount of Medial-Lateral Sway Near 1Hz','Interpreter','latex','FontSize',17, 'FontName','Arial');
title('Amount of Medial-Lateral Sway Near 1Hz','FontSize',32, 'FontName','Arial');
%set font size for the figure so it's legible
        
        set(gca, 'FontName', 'Arial')
        fontsize(fig, 36, "points")
        fig.Position = [100 100 1600 750];
        ylim([0 .9])
end

function [] = violinfunc(C,fstart,fstop)
viodatx = C(:,1);
xval = linspace(prctile(viodatx,1),prctile(viodatx,99), 100);

[f,xi] = ksdensity( viodatx(:),xval,'Bandwidth',0.05,'BoundaryCorrection','reflection');

figure();
patch( 0-[f,zeros(1,numel(xi),1),0],[xi,fliplr(xi),xi(1)],'r' );
end


function [mfftsphz,freq_SpHz,P1,f] = fftcalc(i,Y,time,sub,trial_name)
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
        subval = (abs(f - Hz_val));
        accept_range = subval < 0.4; % getting a range of values around 1Hz
        
        fft_SpHz = P1(accept_range);
        mfftsphz = max(fft_SpHz);
        locmax = find(P1 == mfftsphz);
        freq_SpHz = f(locmax); % freq. within 0.4 Hz range of 1Hz
        %save_trail_name{i,sub} = trial_name;

        rangeloc = find(accept_range);
        minline = f(rangeloc(1)); maxline = f(rangeloc(end));
        

        % figure;
        % plot(f,P1,'-o','MarkerIndices',locmax,'MarkerFaceColor','red','MarkerSize',8,"LineWidth",3); hold on;
        % xline(maxline,'--','Color','red'); xline(minline,'--','Color','red');
        % ylim([0 1.5]);
        % 
        % sgtitle(strrep(trial_name,'_','.'));
        % %title("Single-Sided Amplitude Spectrum")
        % xlabel("f (Hz)")
        % ylabel("|P1(f)|")
end
 


