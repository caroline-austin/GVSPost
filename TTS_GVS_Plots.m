close all; 
clear all; 
clc; 
% i don't think this file is actually being used right now

%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
gvs_path = [file_path '\GVSProfiles'];
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

subnum = 1002:1002;  % Subject List 
numsub = length(subnum);
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end

    

%get info on matlab (GVS) and csv (TTS) files
cd(gvs_path);
num_gvs_files = length(filenames);
mat_filenames = get_filetype(filenames, 'mat');
num_mat_files = length(mat_filenames);

cd([file_path, '\' , subject_str]);
num_TTS_files = length(filenames);
csv_filenames = get_filetype(filenames, 'csv');
num_csv_files = length(csv_filenames);


% match the GVS (mat) and TTS (csv) files based on a common string in the
% filenames if they match then proceed with making comparison plots 
for i = 1:num_mat_files
    current_mat_file = char(mat_filenames(i));

    if contains(current_mat_file, '4A')
        check_mat_name = '4A';
    elseif contains(current_mat_file, '4B')
        check_mat_name = '4B';
    elseif contains(current_mat_file, '5A')
        check_mat_name = '5A';
    elseif contains(current_mat_file, '5B')
        check_mat_name = '5B';
    elseif contains(current_mat_file, '6A')
        check_mat_name = '6A';
    elseif contains(current_mat_file, '6B')
        check_mat_name = '6B';
    else
        check_mat_name = 'DNE';
    end
%     check_mat_name = current_mat_file(14:22); 
    % may need to update these ^ numbers based on the file name
    % from the GVS     

    %load and store the commanded GVS data as numbers
    cd (gvs_path);
    Commanded_GVS= load(current_mat_file);
    cd (code_path);
    GVS_command1 = (Commanded_GVS.Profile(1,2:end));
    GVS_command = cellfun(@str2num,(GVS_command1))';
%     GVS_command = cell2mat(Commanded_GVS.Profile(1,2:end))';
    
    for j = 1: num_csv_files
        current_csv_file = char(csv_filenames(j));
        check_csv_name = current_csv_file(29:37); 
        % may need to update these ^ numbers based on the subject/file name
        % from the TTS    

        if check_csv_name == check_mat_name
           close all % to limit the number of plots open at once
           % load the matching TTS file and store the appropriate data
           cd(file_path);
           TTS_data = readtable(current_csv_file); 
           cd(code_path);
           time = table2array(TTS_data(1:end-1,1));
           plot_time = (time -time(1))/1000;
           tilt_command = table2array(TTS_data(1:end-1,2))/200;
           tilt_actual = table2array(TTS_data(1:end-1,4))/200;
           GVS_actual_mV= table2array(TTS_data(1:end-1,11))/1000;
           mustBeNonsparse(GVS_actual_mV);
           mustBeFinite(GVS_actual_mV);
           GVS_actual_filt = lowpass(GVS_actual_mV,1,50); %filter raw GVS data
           trial_end = find(time,1, 'last');

%% Plot the TTS Sampling Rate
% the average timestep should be 20 ms (50Hz) this is good to double check
% just in case the SHOT 2 code was active when the data was collected, but
% if you know the SHOT 2 code was commented out then this section can be
% commented out.
        clear sample_tdelta
        for a = 2:length(time(1:trial_end))
            sample_tdelta(a) = time(a)-time(a-1);
        end
        average_tdelta = mean(sample_tdelta); 
        x_1 = 0:length(sample_tdelta)-1;
        x_1 = x_1/50;
        figure; 
        plot(x_1,sample_tdelta); 
        title('TTS Sampling Rate');
        ylabel('Time Step Length (ms)');
        xlabel('Trial Time (s)');
        plotfile=[current_mat_file(1:end-5)];
        cd(plots_path);
        saveas(gcf, [ plotfile num2str(j) 'ttsTimeStep']); 
        cd(code_path);
        hold off; 
%% Plot Commanded TTS angle vs. Commanded GVS value
       figure;
       plot(plot_time(1:trial_end),tilt_command(1:trial_end), plot_time(1:trial_end), GVS_command(1:trial_end)/100);
       hold off;

       legend('TTS tilt angle', 'GVS');
        
       plotTitle = ['Commanded TTS Tilt and GVS Signal'];
       title(plotTitle);

       ylabel('Tilt (Degree) and GVS (mA)');
       xlabel('Trial Time (s)');

       cd(plots_path);
       saveas(gcf, [ plotfile num2str(j) 'Command']); 
       cd(code_path);
       hold off;

%% Plot  Actual TTS angle vs. Actual GVS value (raw and filtered)
           figure;
           plot(plot_time(1:trial_end),tilt_actual(1:trial_end), ... 
               plot_time(1:trial_end), GVS_actual_mV(1:trial_end),... 
               plot_time(1:trial_end), GVS_actual_filt(1:trial_end));
          

           legend('TTS tilt angle', 'raw GVS', 'filt GVS');
            
            plotTitle = ['Actual TTS Tilt and GVS Signal'];
            title(plotTitle);

            ylabel('Tilt (Degree) and GVS (V)');
            xlabel('Trial Time (s)');
            cd(plots_path);
            saveas(gcf, [ plotfile num2str(j) 'Actual']); 
            cd(code_path);
            hold off;
%% Calculate and Plot the Sine Fit versions of the TTS and GVS actual
            [GVS_cfit] = fit(time(1:trial_end),GVS_actual_mV(1:trial_end), 'sin1');
            [tilt_cfit] = fit(time(1:trial_end),tilt_actual(1:trial_end), 'sin1');
            %used tilt a so that the magnitudes would be the same
            GVS_fit = tilt_cfit.a1*sin(GVS_cfit.b1*time(1:trial_end)+GVS_cfit.c1); 
            tilt_fit = tilt_cfit.a1*sin(tilt_cfit.b1*time(1:trial_end)+tilt_cfit.c1);
            
            figure;
            plot(plot_time(1:trial_end), tilt_fit, plot_time(1:trial_end), GVS_fit);
            legend(['TTS tilt angle ' num2str(tilt_cfit.c1)], ['GVS ' num2str(GVS_cfit.c1)]);
            
            plotTitle = ['Sine Fit TTS Tilt and GVS Signal'];
            title(plotTitle);
            ylabel('Tilt (Degree) and GVS (V)');
            xlabel('Trial Time (s)');
            cd(plots_path);
            saveas(gcf, [ plotfile num2str(j) 'Fit']); 
            cd(code_path);
            hold off;

%% Calculate and Plot 0's ('Sync Points') of the TTS and GVS 
% find the points where the GVS/tilt values are zero or the pt right after
% the value was equal to zero 

            clear *zeros* *diff*
            m = 0;
            n = 0; 
            p = 0;
            % find the locations of the zeros by storing the location
            % after the 0
           for l = 2:(length(tilt_actual)-1) 
               if GVS_actual_mV(l) == 0
                % don't store if the current or next value = 0
                % trying to store the lcoation of the point immediately
                % following the zero
               elseif GVS_actual_mV(l+1) == 0
               elseif GVS_actual_mV(l)*GVS_actual_mV(l-1) <=0
                   m = m+1;
                   GVS_actual_zeros_after_x(m) = l;
               end

               if GVS_actual_filt(l) == 0
                % don't store if the current or next value = 0
                % trying to store the lcoation of the point immediately
                % following the zero
               elseif GVS_actual_filt(l+1) == 0
               elseif GVS_actual_filt(l)*GVS_actual_filt(l-1) <=0
                   n = n+1;
                   GVS_filt_zeros_after_x(n) = l;
               end

               if tilt_actual(l) == 0
                % don't store if the current or next value = 0
                % trying to store the lcoation of the point immediately
                % following the zero
               elseif tilt_actual(l+1) == 0
               elseif tilt_actual(l)*tilt_actual(l-1) <=0
                   p = p+1;
                   tilt_actual_zeros_after_x(p) = l;
               end
           end

         % store location @ or before zero
        GVS_actual_zeros_before_x = GVS_actual_zeros_after_x - 1;
        GVS_filt_zeros_before_x = GVS_filt_zeros_after_x - 1;
        tilt_actual_zeros_before_x = tilt_actual_zeros_after_x - 1;

        % store the values at the before/after zero locations
        GVS_actual_zeros_before_y = GVS_actual_mV(GVS_actual_zeros_before_x);
        GVS_actual_zeros_after_y = GVS_actual_mV(GVS_actual_zeros_after_x);
        GVS_filt_zeros_before_y = GVS_actual_filt(GVS_filt_zeros_before_x);
        GVS_filt_zeros_after_y = GVS_actual_filt(GVS_filt_zeros_after_x);
        tilt_actual_zeros_before_y = tilt_actual(tilt_actual_zeros_before_x);
        tilt_actual_zeros_after_y = tilt_actual(tilt_actual_zeros_after_x);

% use linear interpolation to estimate the actual time (location) of the zero values 
%need to figure out what the units are because they are not time I don't
%think and the time in ms between the recordings is not quite const.
% multiplying the location value by the average delta t (20ms) should give
% the correct time location for the x axis
            for k = 1: length(GVS_filt_zeros_after_y)
                GVS_filt_zeros_x(k) = interp1([GVS_filt_zeros_before_y(k), ...
                    GVS_filt_zeros_after_y(k)],[GVS_filt_zeros_before_x(k),... 
                    GVS_filt_zeros_after_x(k)], 0);
            end 

            for k = 1: length(GVS_actual_zeros_after_y)
                GVS_actual_zeros_x(k) = interp1([GVS_actual_zeros_before_y(k), ... 
                    GVS_actual_zeros_after_y(k)],[GVS_actual_zeros_before_x(k),... 
                    GVS_actual_zeros_after_x(k)], 0);
            end 

            for k = 1: length(tilt_actual_zeros_after_y)
                tilt_actual_zeros_x(k) = interp1([tilt_actual_zeros_before_y(k), ... 
                    tilt_actual_zeros_after_y(k)],[tilt_actual_zeros_before_x(k), ... 
                    tilt_actual_zeros_after_x(k)], 0);
            end 
            
            %create arrays to plot against
            zero_fill1 = zeros(length(tilt_actual_zeros_x));
            zero_fill2 = zeros(length(GVS_actual_zeros_x));
            zero_fill3 = zeros(length(GVS_filt_zeros_x));

            %plotting location/time of the zeros
            figure; 
            plot(tilt_actual_zeros_x/50, zero_fill1, 'r*');
            hold on; 
            plot (GVS_actual_zeros_x/50, zero_fill2, 'gsquare');
            hold on;
            plot(GVS_filt_zeros_x/50, zero_fill3,'bo');
            legend_array = strings(length(zero_fill1)+length(zero_fill2)+length(zero_fill3),1);
            legend_array(1) = 'TTS tilt'; 
            legend_array(length(zero_fill1)+1) = 'Raw GVS';
            legend_array(length(zero_fill1)+length(zero_fill2)+1) = 'Filt GVS';
            legend(legend_array);
%             legend({'TTS tilt', 'Raw GVS', 'filt GVS'});

%             plotfile=[current_mat_file(1:end-5)];
            plotTitle = ['TTS Tilt and GVS Sync Points'];
            title(plotTitle);
            
            xlabel('Trial Time (s)');
            cd(plots_path);
            saveas(gcf, [ plotfile num2str(j) 'Sync']); %_trialname_GRF
            cd(code_path);
            hold off;
 %% Calculate and Plot Lead/Lag Time between the TTS and GVS signals

            % calculate the differences between the zeros for the GVS and
            % TTS signals
            s=0;
            u =0;
            for q = 1: length(tilt_actual_zeros_x)
                for r = 1:length(GVS_filt_zeros_x)
                    tilt_filt_diff = tilt_actual_zeros_x(q) - GVS_filt_zeros_x(r);
                    if abs(tilt_filt_diff)<20
                        s=s+1;
                        tilt_filt_xdiff(s) = tilt_filt_diff;
                        time_of_diff_filt(s) = (tilt_actual_zeros_x(q));
                    end

                end
                for r = 1:length(GVS_actual_zeros_x)
                    tilt_GVS_diff = tilt_actual_zeros_x(q) - GVS_actual_zeros_x(r);
                    if abs(tilt_GVS_diff)<20
                        u=u+1;
                        tilt_GVS_xdiff(u) = tilt_GVS_diff;
                        time_of_diff_actual(u) = (tilt_actual_zeros_x(q));
                    end

                end
            end


            figure;
            plot(time_of_diff_actual*average_tdelta/1000, tilt_GVS_xdiff*average_tdelta);
            hold on;
            plot(time_of_diff_filt*average_tdelta/1000,tilt_filt_xdiff*average_tdelta);
            hold on;
            regression_x = [ ones(length(time_of_diff_filt(2:end)),1) (time_of_diff_filt(2:end)*average_tdelta)'];
            b1 = regression_x\(tilt_filt_xdiff(2:end)*average_tdelta)';
            Ycalc = regression_x*b1;
%             figure;
            xlabel('time (s)')
            ylabel('lead or lag time between TTS and GVS signals (ms)')
            plot(time_of_diff_filt(2:end)*average_tdelta/1000,Ycalc);
            legend('diff btwn tilt & raw GVS', 'diff btwn tilt & filt GVS', 'linear fit');
%             plotfile=[current_mat_file(1:end-5)];
            plotTitle = ['Time lead/lag between TTS tilt and GVS'];
            title(plotTitle);
            dim = [.2 .5 .3 .3];
            str = ['+ = GVS leading TTS' newline 'initial: ' num2str(Ycalc(1)) 'ms' newline ' final: ' num2str(Ycalc(end)) 'ms'  newline ' slope: ' num2str(b1(2)*1000) 'ms/s' ];
            annotation('textbox',dim,'String',str,'FitBoxToText','on');
            hold off;
            cd(plots_path);
            saveas(gcf, [ plotfile num2str(j) 'Lag']); %_trialname_GRF
            cd(code_path);

        end

    end


end


end
