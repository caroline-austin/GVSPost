close all; 
clear all; 
clc; 

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
    subject_path = [file_path, '\PS' , subject_str];

    cd(subject_path);
    load(['PS', subject_str, '.mat ']);
    
    
    cd(code_path);
    [subject_filenames]=file_path_info2(code_path,subject_path ); % get files from file folder
    num_files = length(subject_filenames);
    mat_filenames = get_filetype(subject_filenames, 'mat');
    num_mat_files = length(mat_filenames);

    for file = 1:num_mat_files
        current_file = char(mat_filenames(file));
       if length(current_file)<26
           continue
       end

       check_name = current_file(8:9); %reduce by one when transitioning to regular subjects
       trial_number = current_file(end-5:end-4);
       current_val = current_file();
       proportional = current_file();
       cd(subject_path);
       load([current_file]);
       cd(code_path); 
       %could probably do this with an eval instead 
        switch check_name

            case '4A'
                GVS_4A(:,1) = tilt_command;
                [~,GVS_col]=size(GVS_4A);
                GVS_4A(:,GVS_col+1) = GVS_command(2:end);
                GVS_4A(:,GVS_col+2) = GVS_actual_mV;
                GVS_4A(:,GVS_col+3) = GVS_actual_filt;
                
                Label.GVS_4A(GVS_col+1,:) = string([ current_file(11:end-4), '_GVS_command']);
                Label.GVS_4A(GVS_col+2,:) = string([ current_file(11:end-4), '_GVS_actual_mV']);
                Label.GVS_4A(GVS_col+3,:) = string([ current_file(11:end-4), '_GVS_actual_filt']);

                tilt_4A(:,1)=tilt_command;
                tilt_4A(:,2)=tilt_velocity;
                [~,tilt_col]=size(tilt_4A);
                tilt_4A(:,tilt_col+1) = tilt_actual;
                Label.tilt_4A(tilt_col+1,:) = string([ current_file(11:end-4), '_tilt_actual']);

                shot_4A(:,1)=tilt_command;
                [~,shot_col]=size(shot_4A);
                shot_4A(:,shot_col+1) = shot_actual;
                Label.shot_4A(shot_col+1,:) = string([ current_file(11:end-4), '_shot_actual']);

            case '4B'
                GVS_4B(:,1) = tilt_command;
                [~,GVS_col]=size(GVS_4B);
                GVS_4B(:,GVS_col+1) = GVS_command;%(2:end);
                GVS_4B(:,GVS_col+2) = GVS_actual_mV;
                GVS_4B(:,GVS_col+3) = GVS_actual_filt;
                
                Label.GVS_4B(GVS_col+1,:) = string([ current_file(11:end-4), '_GVS_command']);
                Label.GVS_4B(GVS_col+2,:) = string([ current_file(11:end-4), '_GVS_actual_mV']);
                Label.GVS_4B(GVS_col+3,:) = string([ current_file(11:end-4), '_GVS_actual_filt']);

                tilt_4B(:,1)=tilt_command;
                tilt_4B(:,2)=tilt_velocity;
                [~,tilt_col]=size(tilt_4B);
                tilt_4B(:,tilt_col+1) = tilt_actual;
                Label.tilt_4B(tilt_col+1,:) = string([ current_file(11:end-4), '_tilt_actual']);

                shot_4B(:,1)=tilt_command;
                [~,shot_col]=size(shot_4B);
                shot_4B(:,shot_col+1) = shot_actual;
                Label.shot_4B(shot_col+1,:) = string([ current_file(11:end-4), '_shot_actual']);

            case '5A'
                GVS_5A(:,1) = tilt_command;
                [~,GVS_col]=size(GVS_5A);
                GVS_5A(:,GVS_col+1) = GVS_command(2:end);
                GVS_5A(:,GVS_col+2) = GVS_actual_mV;
                GVS_5A(:,GVS_col+3) = GVS_actual_filt;
                
                Label.GVS_5A(GVS_col+1,:) = string([ current_file(11:end-4), '_GVS_command']);
                Label.GVS_5A(GVS_col+2,:) = string([ current_file(11:end-4), '_GVS_actual_mV']);
                Label.GVS_5A(GVS_col+3,:) = string([ current_file(11:end-4), '_GVS_actual_filt']);

                tilt_5A(:,1)=tilt_command;
                tilt_5A(:,2)=tilt_velocity;
                [~,tilt_col]=size(tilt_5A);
                tilt_5A(:,tilt_col+1) = tilt_actual;
                Label.tilt_5A(tilt_col+1,:) = string([ current_file(11:end-4), '_tilt_actual']);

                shot_5A(:,1)=tilt_command;
                [~,shot_col]=size(shot_5A);
                shot_5A(:,shot_col+1) = shot_actual;
                Label.shot_5A(shot_col+1,:) = string([ current_file(11:end-4), '_shot_actual']);
            case '5B'
                GVS_5B(:,1) = tilt_command;
                [~,GVS_col]=size(GVS_5B);
                GVS_5B(:,GVS_col+1) = GVS_command;%(2:end);
                GVS_5B(:,GVS_col+2) = GVS_actual_mV;
                GVS_5B(:,GVS_col+3) = GVS_actual_filt;
                
                Label.GVS_5B(GVS_col+1,:) = string([ current_file(11:end-4), '_GVS_command']);
                Label.GVS_5B(GVS_col+2,:) = string([ current_file(11:end-4), '_GVS_actual_mV']);
                Label.GVS_5B(GVS_col+3,:) = string([ current_file(11:end-4), '_GVS_actual_filt']);

                tilt_5B(:,1)=tilt_command;
                tilt_5B(:,2)=tilt_velocity;
                [~,tilt_col]=size(tilt_5B);
                tilt_5B(:,tilt_col+1) = tilt_actual;
                Label.tilt_5B(tilt_col+1,:) = string([ current_file(11:end-4), '_tilt_actual']);

                shot_5B(:,1)=tilt_command;
                [~,shot_col]=size(shot_5B);
                shot_5B(:,shot_col+1) = shot_actual;
                Label.shot_5B(shot_col+1,:) = string([ current_file(11:end-4), '_shot_actual']);

            case '6A'
                GVS_6A(:,1) = tilt_command;
                [~,GVS_col]=size(GVS_6A);
                GVS_6A(:,GVS_col+1) = GVS_command;%(2:end);
                GVS_6A(:,GVS_col+2) = GVS_actual_mV;
                GVS_6A(:,GVS_col+3) = GVS_actual_filt;
                
                Label.GVS_6A(GVS_col+1,:) = string([ current_file(11:end-4), '_GVS_command']);
                Label.GVS_6A(GVS_col+2,:) = string([ current_file(11:end-4), '_GVS_actual_mV']);
                Label.GVS_6A(GVS_col+3,:) = string([ current_file(11:end-4), '_GVS_actual_filt']);

                tilt_6A(:,1)=tilt_command;
                tilt_6A(:,2)=tilt_velocity;
                [~,tilt_col]=size(tilt_6A);
                tilt_6A(:,tilt_col+1) = tilt_actual;
                Label.tilt_6A(tilt_col+1,:) = string([ current_file(11:end-4), '_tilt_actual']);

                shot_6A(:,1)=tilt_command;
                [~,shot_col]=size(shot_6A);
                shot_6A(:,shot_col+1) = shot_actual;
                Label.shot_6A(shot_col+1,:) = string([ current_file(11:end-4), '_shot_actual']);

            case '6B'
                GVS_6B(:,1) = tilt_command;
                [~,GVS_col]=size(GVS_6B);
                GVS_6B(:,GVS_col+1) = GVS_command;%(2:end);
                GVS_6B(:,GVS_col+2) = GVS_actual_mV;
                GVS_6B(:,GVS_col+3) = GVS_actual_filt;
                
                Label.GVS_6B(GVS_col+1,:) = string([ current_file(11:end-4), '_GVS_command']);
                Label.GVS_6B(GVS_col+2,:) = string([ current_file(11:end-4), '_GVS_actual_mV']);
                Label.GVS_6B(GVS_col+3,:) = string([ current_file(11:end-4), '_GVS_actual_filt']);

                tilt_6B(:,1)=tilt_command;
                tilt_6B(:,2)=tilt_velocity;
                [~,tilt_col]=size(tilt_6B);
                tilt_6B(:,tilt_col+1) = tilt_actual;
                Label.tilt_6B(tilt_col+1,:) = string([ current_file(11:end-4), '_tilt_actual']);

                shot_6B(:,1)=tilt_command;
                [~,shot_col]=size(shot_6B);
                shot_6B(:,shot_col+1) = shot_actual;
                Label.shot_6B(shot_col+1,:) = string([ current_file(11:end-4), '_shot_actual']);

        end
    


    end

    time = (time- time(1))/1000;
%% Plot 4A with function
    [pos_prof] = find(contains(Label.shot_4A, 'P'));
    pos_colors=['r'; 'r'; 'g'; 'g';'c'; 'c';'b';'b'];
    PlotGVSTTSPerception(Label.shot_4A,Label.GVS_4A, tilt_4A(1:trial_end,:),shot_4A(1:trial_end,:),GVS_4A(1:trial_end,:), time(1:trial_end),pos_colors,pos_prof);
    subplot(3,1,1)
    title('4A Positive GVS Affects on Tilt Perception')

    cd(plots_path);
    saveas(gcf, [ 'Positive_4A_4_00mA_Perception' subject_str]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_4A, 'N'));
    [zero_prof] = find(contains(Label.shot_4A, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_4A,Label.GVS_4A, tilt_4A(1:trial_end,:),shot_4A(1:trial_end,:),GVS_4A(1:trial_end,:), time(1:trial_end),pos_colors,neg_prof);
    subplot(3,1,1)
    title('4A Negative GVS Affects on Tilt Perception')

    cd(plots_path);
    saveas(gcf, [ 'Negative_4A_4_00mA_Perception' subject_str]); 
    cd(code_path);
    hold off;


%% Plot 4B with function
    [pos_prof] = find(contains(Label.shot_4B, 'P'));
    pos_colors=['r'; 'g'; 'c'; 'b'];
    PlotGVSTTSPerception(Label.shot_4B,Label.GVS_4B, tilt_4B(1:trial_end,:),shot_4B(1:trial_end,:),GVS_4B(1:trial_end,:), time(1:trial_end),pos_colors,pos_prof);
    subplot(3,1,1)
    title('4B Positive GVS Affects on Tilt Perception')

    cd(plots_path);
    saveas(gcf, [ 'Positive_4B_4_00mA_Perception' subject_str]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_4B, 'N'));
    [zero_prof] = find(contains(Label.shot_4B, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_4B,Label.GVS_4B, tilt_4B(1:trial_end,:),shot_4B(1:trial_end,:),GVS_4B(1:trial_end,:), time(1:trial_end),pos_colors,neg_prof);
    subplot(3,1,1)
    title('4B Negative GVS Affects on Tilt Perception')

    cd(plots_path);
    saveas(gcf, [ 'Negative_4B_4_00mA_Perception' subject_str]); 
    cd(code_path);
    hold off;

% Plot 5A with function
    [pos_prof] = find(contains(Label.shot_5A, 'P'));
    pos_colors=['r'; 'r'; 'g'; 'g'; 'g'; 'c'; 'c';'b';'b'];
    PlotGVSTTSPerception(Label.shot_5A,Label.GVS_5A, tilt_5A(1:trial_end,:),shot_5A(1:trial_end,:),GVS_5A(1:trial_end,:), time(1:trial_end),pos_colors,pos_prof);
    subplot(3,1,1)
    title('5A Positive GVS Affects on Tilt Perception')

    cd(plots_path);
    saveas(gcf, [ 'Positive_5A_4_00mA_Perception' subject_str]); 
    cd(code_path);
    hold off;
    pos_colors=['r'; 'r'; 'g';  'g';'c'; 'c';'b';'b'];
    [neg_prof] = find(contains(Label.shot_5A, 'N'));
    [zero_prof] = find(contains(Label.shot_5A, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_5A,Label.GVS_5A, tilt_5A(1:trial_end,:),shot_5A(1:trial_end,:),GVS_5A(1:trial_end,:), time(1:trial_end),pos_colors,neg_prof);
    subplot(3,1,1)
    title('5A Negative GVS Affects on Tilt Perception')

    cd(plots_path);
    saveas(gcf, [ 'Negative_5A_4_00mA_Perception' subject_str]); 
    cd(code_path);
    hold off;


%% Plot 5B with function
    [pos_prof] = find(contains(Label.shot_5B, 'P'));
    pos_colors=['r'; 'g'; 'c'; 'b'];
    PlotGVSTTSPerception(Label.shot_5B,Label.GVS_5B, tilt_5B(1:trial_end,:),shot_5B(1:trial_end,:),GVS_5B(1:trial_end,:), time(1:trial_end),pos_colors,pos_prof);
    subplot(3,1,1)
    title('5B Positive GVS Affects on Tilt Perception')

    cd(plots_path);
    saveas(gcf, [ 'Positive_5B_4_00mA_Perception' subject_str]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_5B, 'N'));
    [zero_prof] = find(contains(Label.shot_5B, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_5B,Label.GVS_5B, tilt_5B(1:trial_end,:),shot_5B(1:trial_end,:),GVS_5B(1:trial_end,:), time(1:trial_end),pos_colors,neg_prof);
    subplot(3,1,1)
    title('5B Negative GVS Affects on Tilt Perception')

    cd(plots_path);
    saveas(gcf, [ 'Negative_5B_4_00mA_Perception' subject_str]); 
    cd(code_path);
    hold off;    

%% Plot 6A with function
    [pos_prof] = find(contains(Label.shot_6A, 'P'));
    pos_colors=['r'; 'r'; 'g'; 'c'; 'b'];
    PlotGVSTTSPerception(Label.shot_6A,Label.GVS_6A, tilt_6A(1:trial_end,:),shot_6A(1:trial_end,:),GVS_6A(1:trial_end,:), time(1:trial_end),pos_colors,pos_prof);
    subplot(3,1,1)
    title('6A Positive GVS Affects on Tilt Perception')

    cd(plots_path);
    saveas(gcf, [ 'Positive_6A_4_00mA_Perception' subject_str]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_6A, 'N'));
    [zero_prof] = find(contains(Label.shot_6A, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_6A,Label.GVS_6A, tilt_6A(1:trial_end,:),shot_6A(1:trial_end,:),GVS_6A(1:trial_end,:), time(1:trial_end),pos_colors,neg_prof);
    subplot(3,1,1)
    title('6A Negative GVS Affects on Tilt Perception')

    cd(plots_path);
    saveas(gcf, [ 'Negative_6A_4_00mA_Perception' subject_str]); 
    cd(code_path);
    hold off;


%% Plot 6B with function
    [pos_prof] = find(contains(Label.shot_6B, 'P'));
    pos_colors=['r'; 'g'; 'c'; 'b'];
    PlotGVSTTSPerception(Label.shot_6B,Label.GVS_6B, tilt_6B(1:trial_end,:),shot_6B(1:trial_end,:),GVS_6B(1:trial_end,:), time(1:trial_end),pos_colors,pos_prof);
    subplot(3,1,1)
    title('6B Positive GVS Affects on Tilt Perception')

    cd(plots_path);
    saveas(gcf, [ 'Positive_6B_4_00mA_Perception' subject_str]); 
    cd(code_path);
    hold off;

    [neg_prof] = find(contains(Label.shot_6B, 'N'));
    [zero_prof] = find(contains(Label.shot_6B, '_0_'));
    neg_prof = [zero_prof ; neg_prof];
    PlotGVSTTSPerception(Label.shot_6B,Label.GVS_6B, tilt_6B(1:trial_end,:),shot_6B(1:trial_end,:),GVS_6B(1:trial_end,:), time(1:trial_end),pos_colors,neg_prof);
    subplot(3,1,1)
    title('6B Negative GVS Affects on Tilt Perception')

    cd(plots_path);
    saveas(gcf, [ 'Negative_6B_4_00mA_Perception' subject_str]); 
    cd(code_path);
    hold off;    


%% old 
%     %% plot 4A
%     [neg_prof] = find(contains(Label.shot_4A, 'N'));
%     [pos_prof] = find(contains(Label.shot_4A, 'P'));
%     pos_colors=['r'; 'r'; 'g'; 'c'; 'b'];
%     neg_colors=['g'; 'c'; 'b'];
%     figure; 
%     subplot(3,1,1)
%     plot(time,tilt_4A(:,3), 'k');
%     pos_legend(1) = "TTS Commanded Tilt";
%     hold on;
%     pos_length = length(pos_prof);
%     for i = 1:pos_length
% %         if i == pos_length
% %         plot(time,-1*shot_4A(:,pos_prof(i)), pos_colors(i))
% %         else
%         plot(time,shot_4A(:,pos_prof(i)), pos_colors(i))
%        
% %         end
%         line_label = char(Label.shot_4A(pos_prof(i)));
%         pos_legend(i+1) =(strrep(line_label(1:13), '_', '.'));
%     end
%     legend(pos_legend)
%     xlabel('Time (s)');
%     ylabel('Tilt (degrees)')
%     title('4A Positve GVS Affects on Tilt Perception')
%     ylim([-15 15]);
%     xlim([0 31]);
%     
%     subplot(3,1,2)
%     plot(time, tilt_4A(:,2))
%     xlabel('Time (s)');
%     ylabel('Angular Velocity (degrees/s)')
%      xlim([0 31]);
% 
%     [gvs_prof] = find(contains(Label.GVS_4A, 'command'));
%     gvs_colors=['g'; 'c'; 'b' ; 'r'; 'r'; 'g'; 'c';  'b'];
% 
%     subplot(3,1,3)
%     gvs_legend(1) = "test";
%     for i = 1:length(gvs_prof)
%         if find(pos_prof == (gvs_prof(i)-2*(i-1)))
%             plot(time,GVS_4A(:,gvs_prof(i)), gvs_colors(i))
%             hold on;
%             line_label = char(Label.GVS_4A(gvs_prof(i)));
% %             gvs_legend(i) =(strrep(line_label(1:13), '_', '.'));
%         end
%     end
% %     legend(gvs_legend)
%     xlabel('Time (s)');
%     ylabel('Current (mA)')
%      xlim([0 31]);
% 
%     hold off;
% 
%     cd(plots_path);
%    saveas(gcf, [ 'Positive_4A_4_00mA_Perception']); 
%    cd(code_path);
%    hold off;
% 
%     figure; 
%     subplot(3,1,1)
%     plot(time,tilt_4A(:,3), 'k');
%     neg_legend(1) = "TTS Commanded Tilt";
%     hold on;
%     for i = 1:length(neg_prof)
%         plot(time,shot_4A(:,neg_prof(i)), neg_colors(i))
%         line_label = char(Label.shot_4A(neg_prof(i)));
%         neg_legend(i+1) =(strrep(line_label(1:13), '_', '.'));
%     end
%     legend(neg_legend)
%     xlabel('Time (s)');
%     ylabel('Tilt (degrees)')
%     title('4A Negative GVS Affects on Tilt Perception')
%     ylim([-15 15]);
%      xlim([0 31]);
% 
%     subplot(3,1,2)
%     plot(time, tilt_4A(:,2))
%     xlabel('Time (s)');
%     ylabel('Angular Velocity (degrees/s)');
%      xlim([0 31]);
% 
%     [gvs_prof] = find(contains(Label.GVS_4A, 'command'));
% %     gvs_colors=['g'; 'g';'c'; 'c'; 'b' ; 'b';'r'; 'r'; 'g'; 'g'; 'g';'c'; 'c'; 'b' ; 'b'];
% 
%     subplot(3,1,3)
%     gvs_legend(1) = "test";
%     for i = 1:length(gvs_prof)
%         if find(neg_prof == (gvs_prof(i)-2*(i-1)))
%             plot(time,GVS_4A(:,gvs_prof(i)), gvs_colors(i))
%             hold on;
%             line_label = char(Label.GVS_4A(gvs_prof(i)));
% %             gvs_legend(i) =(strrep(line_label(1:13), '_', '.'));
%         end
%     end
% %     legend(gvs_legend)
%     xlabel('Time (s)');
%     ylabel('Current (mA)');
%      xlim([0 31]);
% 
%     hold off;
% 
%     cd(plots_path);
%    saveas(gcf, [ 'Negative_4A_4_00mA_Perception']); 
%    cd(code_path);
%    hold off;
% 
% %     plot(time,shot_4A(:,2:end), time,tilt_4A(:,1));  
% 
%     %% plot 5A
%     [neg_prof] = find(contains(Label.shot_5A, 'N'));
%     [pos_prof] = find(contains(Label.shot_5A, 'P'));
%     pos_colors=['r';'r'; 'g';'c'; 'b'];
%     neg_colors=['g'; 'c'; 'b'];
%     figure; 
%     subplot(3,1,1)
%     plot(time,tilt_5A(:,3), 'k');
%     clear pos_legend
%     pos_legend(1) = "TTS Commanded Tilt";
%     hold on;
%     for i = 1:length(pos_prof)
%         plot(time,shot_5A(:,pos_prof(i)), pos_colors(i))
%         line_label = char(Label.shot_5A(pos_prof(i)));
%         pos_legend(i+1) =(strrep(line_label(1:13), '_', '.'));
%     end
%     legend(pos_legend)
%     xlabel('Time (s)');
%     ylabel('Tilt (degrees)')
%     title('5A Positve GVS Affects on Tilt Perception')
%     ylim([-15 15]);
%      xlim([0 31]);
%     
%     subplot(3,1,2)
%     plot(time, tilt_5A(:,2))
%     xlabel('Time (s)');
%     ylabel('Angular Velocity (degrees/s)');
%      xlim([0 31]);
% 
%     [gvs_prof] = find(contains(Label.GVS_5A, 'command'));
%     gvs_colors=['g';'c'; 'b' ; 'r';'r'; 'g';'c'; 'b'];
% 
%     subplot(3,1,3)
%     gvs_legend(1) = "test";
%     for i = 1:length(gvs_prof)
%         if find(pos_prof == (gvs_prof(i)-2*(i-1)))
%             plot(time,GVS_5A(:,gvs_prof(i)), gvs_colors(i))
%             hold on;
%             line_label = char(Label.GVS_5A(gvs_prof(i)));
% %             gvs_legend(i) =(strrep(line_label(1:13), '_', '.'));
%         end
%     end
% %     legend(gvs_legend)
%     xlabel('Time (s)');
%     ylabel('Current (mA)');
%      xlim([0 31]);
% 
%     hold off;
% 
%     cd(plots_path);
%    saveas(gcf, [ 'Positive_5A_4_00mA_Perception']); 
%    cd(code_path);
%    hold off;
% 
%     figure; 
%     subplot(3,1,1)
%     plot(time,tilt_5A(:,3), 'k');
%     clear neg_legend
%     neg_legend(1) = "TTS Commanded Tilt";
%     hold on;
%     for i = 1:length(neg_prof)
%         plot(time,shot_5A(:,neg_prof(i)), neg_colors(i))
%         line_label = char(Label.shot_5A(neg_prof(i)));
%         neg_legend(i+1) =(strrep(line_label(1:13), '_', '.'));
%     end
%     legend(neg_legend)
%     xlabel('Time (s)');
%     ylabel('Tilt (degrees)')
%     title('5A Negative GVS Affects on Tilt Perception')
%     ylim([-15 15]);
%      xlim([0 31]);
% 
%     subplot(3,1,2)
%     plot(time, tilt_5A(:,2))
%     xlabel('Time (s)');
%     ylabel('Angular Velocity (degrees/s)');
%      xlim([0 31]);
% 
%     [gvs_prof] = find(contains(Label.GVS_5A, 'command'));
% %     gvs_colors=['g'; 'g';'c'; 'c'; 'b' ; 'b';'r'; 'r'; 'g'; 'g'; 'c'; 'c'; 'b' ; 'b'];
% 
%     subplot(3,1,3)
%     gvs_legend(1) = "test";
%     for i = 1:length(gvs_prof)
%         if find(neg_prof == (gvs_prof(i)-2*(i-1)))
%             plot(time,GVS_5A(:,gvs_prof(i)), gvs_colors(i))
%             hold on;
%             line_label = char(Label.GVS_5A(gvs_prof(i)));
% %             gvs_legend(i) =(strrep(line_label(1:13), '_', '.'));
%         end
%     end
% %     legend(gvs_legend)
%     xlabel('Time (s)');
%     ylabel('Current (mA)');
%      xlim([0 31]);
% 
%     hold off;
% 
%     cd(plots_path);
%    saveas(gcf, [ 'Negative_5A_4_00mA_Perception']); 
%    cd(code_path);
%    hold off;


%% save files
   cd(subject_path);
   vars_2_save = ['Label Trial_Info time shot_4A tilt_4A GVS_4A  shot_5A tilt_5A GVS_5A'];
   eval(['  save ' ['PS', subject_str, 'Group.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])


end

% %% debugging
% for i = 1:16
% %     if i == 17
% %         plot(time, tilt_4A(:,i)); legend();
% %     end
% plot(time, tilt_4A(:,i)); legend();
% hold on;
% end