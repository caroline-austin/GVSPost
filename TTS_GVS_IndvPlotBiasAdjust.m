close all; 
clear all; 
clc; 
%code section 2b

%% 
code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
plots_path = [file_path '\Plots']; % specify where plots are saved
gvs_path = [file_path '\GVSProfiles'];
[filenames]=file_path_info2(code_path, file_path); % get files from file folder

subnum = 1011:1011;  % Subject List 
numsub = length(subnum);
subskip = [40005 40006];  %DNF'd subjects or subjects that didn't complete this part

for sub = 1:numsub
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end
    subject_path = [file_path, '\' , subject_str];
%     subject_path = [file_path, '\PS' , subject_str];

    cd(subject_path);
    load(['PS', subject_str, 'Group.mat ']);
        
    cd(code_path);
    [subject_filenames]=file_path_info2(code_path,subject_path ); % get files from file folder
    num_files = length(subject_filenames);
    mat_filenames = get_filetype(subject_filenames, 'mat');
    num_mat_files = length(mat_filenames);

        tilt_4A_avg = sum(tilt_4A)/length(tilt_4A);
        shot_4A_avg = sum(shot_4A)/length(shot_4A);
        index = 1;
        for i = 1:length(tilt_4A_avg)
            if ~ rem(i+2,3)
            tilt_4A_actual_avg(:,index) = tilt_4A_avg(:,i);
            index = index+1;
            end
        end
        
        bias_4A = tilt_4A_actual_avg-shot_4A_avg;


        tilt_4B_avg = sum(tilt_4B)/length(tilt_4B);
        shot_4B_avg = sum(shot_4B)/length(shot_4B);
        index = 1;
        for i = 1:length(tilt_4B_avg)
            if ~ rem(i+2,3)
            tilt_4B_actual_avg(:,index) = tilt_4B_avg(:,i);
            index = index+1;
            end
        end
        
        bias_4B = tilt_4B_actual_avg-shot_4B_avg;


        tilt_5A_avg = sum(tilt_5A)/length(tilt_5A);
        shot_5A_avg = sum(shot_5A)/length(shot_5A);
        index = 1;
        for i = 1:length(tilt_5A_avg)
            if ~ rem(i+2,3)
            tilt_5A_actual_avg(:,index) = tilt_5A_avg(:,i);
            index = index+1;
            end
        end
        
        bias_5A = tilt_5A_actual_avg-shot_5A_avg;


        tilt_5B_avg = sum(tilt_5B)/length(tilt_5B);
        shot_5B_avg = sum(shot_5B)/length(shot_5B);
        index = 1;
        for i = 1:length(tilt_5B_avg)
            if ~ rem(i+2,3)
            tilt_5B_actual_avg(:,index) = tilt_5B_avg(:,i);
            index = index+1;
            end
        end
        
        bias_5B = tilt_5B_actual_avg-shot_5B_avg;


        tilt_6A_avg = sum(tilt_6A)/length(tilt_6A);
        shot_6A_avg = sum(shot_6A)/length(shot_6A);
        index = 1;
        for i = 1:length(tilt_6A_avg)
            if ~ rem(i+2,3)
            tilt_6A_actual_avg(:,index) = tilt_6A_avg(:,i);
            index = index+1;
            end
        end
        
        bias_6A = tilt_6A_actual_avg-shot_6A_avg;


        tilt_6B_avg = sum(tilt_6B)/length(tilt_6B);
        shot_6B_avg = sum(shot_6B)/length(shot_6B);
        index = 1;
        for i = 1:length(tilt_6B_avg)
            if ~ rem(i+2,3)
            tilt_6B_actual_avg(:,index) = tilt_6B_avg(:,i);
            index = index+1;
            end
        end
        
        bias_6B = tilt_6B_actual_avg-shot_6B_avg;
        
        bias_correction = 0;
        sham_indices_4A = find(contains(Label.shot_4A, '0_00mA'));
        for j = 1:length(sham_indices_4A)
            bias_correction = bias_correction + bias_4A(sham_indices_4A(j));
        end
        sham_indices_4B = find(contains(Label.shot_4B, '0_00mA'));
        for j = 1:length(sham_indices_4B)
            bias_correction = bias_correction + bias_4B(sham_indices_4B(j));
        end
        sham_indices_5A = find(contains(Label.shot_5A, '0_00mA'));
        for j = 1:length(sham_indices_5A)
            bias_correction = bias_correction + bias_5A(sham_indices_5A(j));
        end
        sham_indices_5B = find(contains(Label.shot_5B, '0_00mA'));
        for j = 1:length(sham_indices_5B)
            bias_correction = bias_correction + bias_5B(sham_indices_5B(j));
        end
        sham_indices_6A = find(contains(Label.shot_6A, '0_00mA'));
        for j = 1:length(sham_indices_6A)
            bias_correction = bias_correction + bias_6A(sham_indices_6A(j));
        end
        sham_indices_6B = find(contains(Label.shot_6B, '0_00mA'));
        for j = 1:length(sham_indices_6B)
            bias_correction = bias_correction + bias_6B(sham_indices_6B(j));
        end
        num_sham_trials = length(sham_indices_4A) + length(sham_indices_4B)+ ...
            length(sham_indices_5A)+length(sham_indices_5B) + ... 
            length(sham_indices_6A)+length(sham_indices_6B);

        bias_correction = bias_correction/ num_sham_trials;

        shot_4A = shot_4A + bias_correction;
        shot_4B = shot_4B + bias_correction;
        shot_5A = shot_5A + bias_correction;
        shot_5B = shot_5B + bias_correction;
        shot_6A = shot_6A + bias_correction;
        shot_6B = shot_6B + bias_correction;


%% save files
   cd(subject_path);
   vars_2_save = ['Label Trial_Info time trial_end shot_4A tilt_4A GVS_4A  ' ...
       ' shot_5A tilt_5A GVS_5A shot_6A tilt_6A GVS_6A shot_4B tilt_4B GVS_4B  ' ...
       'shot_5B tilt_5B GVS_5B shot_6B tilt_6B GVS_6B'];
   eval(['  save ' ['PS', subject_str, 'GroupAdj.mat '] vars_2_save ' vars_2_save']);      
   cd(code_path)
   eval (['clear ' vars_2_save])
   close all;


end

% %% debugging
% for i = 1:16
% %     if i == 17
% %         plot(time, tilt_4A(:,i)); legend();
% %     end
% plot(time, tilt_4A(:,i)); legend();
% hold on;
% end