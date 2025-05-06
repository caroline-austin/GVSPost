% currently script 4 - reads in SAll and then resamples the Wii balance
% board data and makes plot of CoPsham

close all; 
clear all; 
clc; 

%

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory

cd(file_path);
load('SAll.mat');
cd(code_path);
%% example ROM CoP plots
% 
sham_CoP1 = data.ROM.Wii.EC_FS_NHT.SHAMGVS{2,3}(:, [1 6:7]);
DCWAVE_CoP1 = data.ROM.Wii.EC_FS_NHT.DCONGVS{2,2}(:, [1 6:7]);

sham_CoP2 = data.ROM.Wii.EC_FS_NHT.SHAMGVS{3,2}(:, [1 6:7]);
DCOFF_CoP2 = data.ROM.Wii.EC_FS_NHT.DCSDGVS{3,3}(:, [1 6:7]);

time = 0:20:15000;
sham_CoP1_50Hz = interp1(sham_CoP1(:,1)-sham_CoP1(1,1),sham_CoP1(:,2:3),time,'linear');
DCWAVE_CoP_50Hz = interp1(DCWAVE_CoP1(:,1)-DCWAVE_CoP1(1,1),DCWAVE_CoP1(:,2:3),time,'linear');
sham_CoP2_50Hz = interp1(sham_CoP2(:,1)-sham_CoP2(1,1),sham_CoP2(:,2:3),time,'linear');
DCOFF_CoP2_50Hz = interp1(DCOFF_CoP2(:,1)-DCOFF_CoP2(1,1),DCOFF_CoP2(:,2:3),time,'linear');

% for i = 1:length(DCWAVE_CoP1)-1
%     test(i) = DCWAVE_CoP1(i) - DCWAVE_CoP1(i+1);
% end
% find(test ==0);


% figure;
% plot(time,sham_CoP_50Hz);
f = figure;
f.Position = [100,100, 600, 600];

% sgtitle("Center of Pressure Sway")
% subplot(2,2,1);
plot(sham_CoP1_50Hz(:,2)- mean(sham_CoP1_50Hz(:,2), 'omitnan'), sham_CoP1_50Hz(:,1) - mean(sham_CoP1_50Hz(:,1), 'omitnan'), 'k' );
xlim([-10 10])
ylim([-10 10])
set(gca, 'FontSize', 21);
grid on;
xlabel("Medial Lateral (cm)")
ylabel("Anterior Posterior (cm)")
title([ {"Eyes Closed Foam Surface"} {"No GVS"}])
% %%
% figure;
% plot(time,DCWAVE_CoP_50Hz);
% figure;
% plot((DCWAVE_CoP_50Hz(:,2)), (DCWAVE_CoP_50Hz(:,1))  ); hold on;
% subplot(2,2,2);
f = figure;
f.Position = [100,100, 600, 600];
plot((DCWAVE_CoP_50Hz(:,2)- mean(DCWAVE_CoP_50Hz(:,2), 'omitnan')), (DCWAVE_CoP_50Hz(:,1)- mean(DCWAVE_CoP_50Hz(:,1), 'omitnan')), 'k'  );
xlim([-10 10])
ylim([-10 10])
set(gca, 'FontSize', 21);
grid on;
xlabel("Medial Lateral (cm)")
ylabel("Anterior Posterior (cm)")
title([ {"Eyes Closed Foam Surface"} {"Tilt Coupled GVS"}])
% 
% %%
% figure;
% plot(time,sham_CoP_50Hz);
% figure;
% subplot(2,2,3);
f = figure;
f.Position = [100,100, 600, 600];
plot(sham_CoP2_50Hz(:,2)- mean(sham_CoP2_50Hz(:,2), 'omitnan'), sham_CoP2_50Hz(:,1) - mean(sham_CoP2_50Hz(:,1), 'omitnan') , 'k' );
xlim([-10 10])
ylim([-10 10])
set(gca, 'FontSize', 21);
grid on;
xlabel("Medial Lateral (cm)")
ylabel("Anterior Posterior (cm)")
title([  {"Eyes Closed Foam Surface"} {"No GVS"}])
% %%
% % figure;
% plot(time,DCOFF_CoP_50Hz);
% figure;
% subplot(2,2,4);
f = figure;
f.Position = [100,100, 600, 600];
plot(DCOFF_CoP2_50Hz(:,2)- mean(DCOFF_CoP2_50Hz(:,2), 'omitnan'), DCOFF_CoP2_50Hz(:,1) - mean(DCOFF_CoP2_50Hz(:,1), 'omitnan') , 'k' );
xlim([-10 10])
ylim([-10 10])
set(gca, 'FontSize', 21);
grid on;
xlabel("Medial Lateral (cm)")
ylabel("Anterior Posterior (cm)")
title([  {"Eyes Closed Foam Surface"} {"Tilt Coupled + Disturbance GVS"}])


%% ROM Pass fail plots

% Eyes Open No Head Tilts
EO(:,1) = ROM_pass(data.ROM.Pass.EO_FS_NHT.SHAMGVS(:,2:4));
EO(:,2) = ROM_pass(data.ROM.Pass.EO_FS_NHT.DCONGVS(:,1:3));
EO(:,3) = ROM_pass(data.ROM.Pass.EO_FS_NHT.DCSDGVS(:,1:3));

f=figure;
set(gcf, 'defaultLegendInterpreter', 'latex');
f.Position = [100,100, 600, 400];
plot([1.05 2.05 3.05],EO(1,:)/2*100, 'kd-','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.15 2.15 3.15],EO(2,:)/3*100, 'ko-.','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.85 1.85 2.85],EO(3,:)/3*100, 'ks:', 'MarkerFaceColor','k',MarkerSize= 10); hold on;
plot([0.95 1.95 2.95],EO(4,:)/3*100, 'k^--', 'MarkerFaceColor','k',MarkerSize= 10); hold on;
xticks([1 2 3])
% xticklabels({"NO GVS" "Tilt Coupled GVS" "Tilt Coupled + Disturbance GVS"})
set(gca, 'FontSize', 21);
xticklabels({"" "" ""})
xlim([0.5 3.5])
ylim([-9 109])
ylabel("Pass Percentage");
title({"Eyes Open Foam Surface"});

%%
% Eyes Closed No Head Tilts
EC(:,1) = ROM_pass(data.ROM.Pass.EC_FS_NHT.SHAMGVS(:,2:4));
EC(1,1) = 3;
EC(:,2) = ROM_pass(data.ROM.Pass.EC_FS_NHT.DCONGVS(:,1:3));
EC(:,3) = ROM_pass(data.ROM.Pass.EC_FS_NHT.DCSDGVS(:,1:3));

f=figure;
set(gcf, 'defaultLegendInterpreter', 'latex');
f.Position = [100,100, 600, 400];
plot([1.05 2.05 3.05],EC(1,:)/3*100, 'kd-','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.15 2.15 3.15],EC(2,:)/3*100, 'ko-.','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.85 1.85 2.85],EC(3,:)/3*100, 'ks:','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.95 1.95 2.95],EC(4,:)/3*100, 'k^--','MarkerFaceColor','k', MarkerSize= 10); hold on;
xticks([1 2 3])
% xticklabels({"NO GVS" "Tilt Coupled GVS" "Tilt Coupled + Disturbance GVS"})
set(gca, 'FontSize', 21);
xticklabels({"" "" ""})
xlim([0.5 3.5])
ylim([-9 109])
ylabel("Pass Percentage");
title({"Eyes Closed Foam Surface"});

% Eyes Closed Pitch Head Tilts
EC_PHT(:,1) = ROM_pass(data.ROM.Pass.EC_FS_PHT.SHAMGVS(:,2:4));
EC_PHT(:,2) = ROM_pass(data.ROM.Pass.EC_FS_PHT.DCONGVS(:,1:3));
EC_PHT(:,3) = ROM_pass(data.ROM.Pass.EC_FS_PHT.DCSDGVS(:,1:3));

f=figure;
set(gcf, 'defaultLegendInterpreter', 'latex');
f.Position = [100,100, 600, 400];
plot([1.05 2.05 3.05],EC_PHT(1,:)/2*100, 'kd-','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.15 2.15 3.15],EC_PHT(2,:)/3*100, 'ko-.','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.85 1.85 2.85],EC_PHT(3,:)/3*100, 'ks:','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.95 1.95 2.95],EC_PHT(4,:)/3*100, 'k^--','MarkerFaceColor','k', MarkerSize= 10); hold on;
xticks([1 2 3])
% xticklabels({"NO GVS" "Tilt Coupled GVS" "Tilt Coupled + Disturbance GVS"})
set(gca, 'FontSize', 21);
xticklabels({"" "" ""})
xlim([0.5 3.5])
ylim([-9 109])
ylabel("Pass Percentage");
title([{"Eyes Closed Foam Surface"} {"Pitch Head Tilts"}]);


% Eyes Closed Roll Head Tilts
EC_RHT(:,1) = ROM_pass(data.ROM.Pass.EC_FS_RHT.SHAMGVS(:,2:4));
EC_RHT(:,2) = ROM_pass(data.ROM.Pass.EC_FS_RHT.DCONGVS(:,1:3));
EC_RHT(:,3) = ROM_pass(data.ROM.Pass.EC_FS_RHT.DCSDGVS(:,1:3));

f=figure;
set(gcf, 'defaultLegendInterpreter', 'latex');
f.Position = [100,100, 600, 400];
plot([1.05 2.05 3.05],EC_RHT(1,:)/2*100, 'kd-','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.15 2.15 3.15],EC_RHT(2,:)/3*100, 'ko-.','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.85 1.85 2.85],EC_RHT(3,:)/3*100, 'ks:','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.95 1.95 2.95],EC_RHT(4,:)/3*100, 'k^--','MarkerFaceColor','k', MarkerSize= 10); hold on;
xticks([1 2 3])
% xticklabels({"NO GVS" "Tilt Coupled GVS" "Tilt Coupled + Disturbance GVS"})
set(gca, 'FontSize', 21);
xticklabels({"" "" ""})
xlim([0.5 3.5])
ylim([-9 109])
ylabel("Pass Percentage");
title([{"Eyes Closed Foam Surface"} {"Roll Head Tilts"}]);


function num_pass =ROM_pass(condition_data)
    pass_index = strcmp(condition_data, 'p');
    num_pass = sum(pass_index,2);
end


%% Tandem Walk
TDM_EC(:,:,1) = cell2mat(data.TDM.raw_time.EC.SHAMGVS(:,2:3));
TDM_EC(:,:,2) = cell2mat(data.TDM.raw_time.EC.DCONGVS(:,1:2));
TDM_EC(:,:,3) = cell2mat(data.TDM.raw_time.EC.DCSDGVS(:,1:2));

f=figure;
set(gcf, 'defaultLegendInterpreter', 'latex');
f.Position = [100,100, 600, 400];
plot([1.03 2.03 3.03],squeeze(TDM_EC(1,1,:)), 'bd-','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.07 2.07 3.07],squeeze(TDM_EC(1,2,:)), 'rd-','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.13 2.13 3.13],squeeze(TDM_EC(2,1,:)), 'bo-.','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.17 2.17 3.17],squeeze(TDM_EC(2,2,:)), 'ro -.','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.83 1.83 2.83],squeeze(TDM_EC(3,1,:)), 'bs:','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.87 1.87 2.87],squeeze(TDM_EC(3,2,:)), 'rs:','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.93 1.93 2.93],squeeze(TDM_EC(4,1,:)), 'b^--','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.97 1.97 2.97],squeeze(TDM_EC(4,2,:)), 'r^--','MarkerFaceColor','k', MarkerSize= 10); hold on;
xticks([1 2 3])
% xticklabels({"NO GVS" "Tilt Coupled GVS" "Tilt Coupled + Disturbance GVS"})
set(gca, 'FontSize', 21);
xticklabels({"" "" ""})
xlim([0.5 3.5])
ylim([-0.5 10.5])
ylabel("Number of Correct Steps");
title({"Eyes Closed"});
grid on;

% eyes open
TDM_EO(:,:,1) = cell2mat(data.TDM.raw_time.EO.SHAMGVS(:,2:3));
TDM_EO(:,:,2) = cell2mat(data.TDM.raw_time.EO.DCONGVS(:,1:2));
TDM_EO(:,:,3) = cell2mat(data.TDM.raw_time.EO.DCSDGVS(:,1:2));

f=figure;
set(gcf, 'defaultLegendInterpreter', 'latex');
f.Position = [100,100, 600, 400];
plot([1.03 2.03 3.03],squeeze(TDM_EO(1,1,:)), 'bd-','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.07 2.07 3.07],squeeze(TDM_EO(1,2,:)), 'rd-','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.13 2.13 3.13],squeeze(TDM_EO(2,1,:)), 'bo-.','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.17 2.17 3.17],squeeze(TDM_EO(2,2,:)), 'ro -.','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.83 1.83 2.83],squeeze(TDM_EO(3,1,:)), 'bs:','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.87 1.87 2.87],squeeze(TDM_EO(3,2,:)), 'rs:','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.93 1.93 2.93],squeeze(TDM_EO(4,1,:)), 'b^--','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.97 1.97 2.97],squeeze(TDM_EO(4,2,:)), 'r^--','MarkerFaceColor','k', MarkerSize= 10); hold on;
xticks([1 2 3])
% xticklabels({"NO GVS" "Tilt Coupled GVS" "Tilt Coupled + Disturbance GVS"})
set(gca, 'FontSize', 21);
xticklabels({"" "" ""})
xlim([0.5 3.5])
ylim([-0.5 10.5])
ylabel("Number of Correct Steps");
title({"Eyes Open"});
grid on;

%% FMT
 % corrected time
FMT([2 4],:,1) = cell2mat(data.FMT.adj_time.SHAMGVS([2 4],end-2:end));
FMT([1 3],:,1) = cell2mat(data.FMT.adj_time.SHAMGVS([1 3],end-4:end-2));
FMT(:,:,2) = cell2mat(data.FMT.adj_time.DCONGVS(:,1:3));
FMT(:,:,3) = cell2mat(data.FMT.adj_time.DCSDGVS(:,1:3));

f=figure;
set(gcf, 'defaultLegendInterpreter', 'latex');
f.Position = [100,100, 600, 400];
plot([1.03 2.03 3.03],squeeze(FMT(1,1,:)), 'bd-','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.07 2.07 3.07],squeeze(FMT(1,2,:)), 'rd-','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.07 2.07 3.07],squeeze(FMT(1,3,:)), 'cd-','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.13 2.13 3.13],squeeze(FMT(2,1,:)), 'bo-.','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.17 2.17 3.17],squeeze(FMT(2,2,:)), 'ro -.','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.17 2.17 3.17],squeeze(FMT(2,3,:)), 'co -.','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.83 1.83 2.83],squeeze(FMT(3,1,:)), 'bs:','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.87 1.87 2.87],squeeze(FMT(3,2,:)), 'rs:','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.87 1.87 2.87],squeeze(FMT(3,3,:)), 'cs:','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.93 1.93 2.93],squeeze(FMT(4,1,:)), 'b^--','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.97 1.97 2.97],squeeze(FMT(4,2,:)), 'r^--','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.97 1.97 2.97],squeeze(FMT(4,3,:)), 'c^--','MarkerFaceColor','k', MarkerSize= 10); hold on;
xticks([1 2 3])
% xticklabels({"NO GVS" "Tilt Coupled GVS" "Tilt Coupled + Disturbance GVS"})
set(gca, 'FontSize', 21);
xticklabels({"" "" ""})
xlim([0.5 3.5])
ylim([15 40])
ylabel("Time (s)");
title([{"Functional Mobility Obstacle Course"} {"Net Completion Time"}]);
grid on;
 %% TTS

 GVS_type = fieldnames(data.TTS.TTS);

 for condition = 1:length(GVS_type)
     [num_sub, replicates]= size(data.TTS.TTS.(GVS_type{condition})); 
     for sub = 1:num_sub
         for trial = 1:replicates
             TTS_time = (data.TTS.TTS.(GVS_type{condition}){sub,trial}(1:end,1) - data.TTS.TTS.(GVS_type{condition}){sub,trial}(1,1));
             TTS_time = TTS_time{:,:}/1000;

             TTS_tilt = (data.TTS.TTS.(GVS_type{condition}){sub,trial}(1:end,5));
             TTS_tilt = TTS_tilt{:,:}/200;

             TTS_joystick = (data.TTS.TTS.(GVS_type{condition}){sub,trial}(1:end,7));
             TTS_joystick = TTS_joystick{:,:}/200;

             Nulling_RMSE = rms(TTS_tilt);
             Nulling_mean = mean(TTS_tilt);
             Nulling_MeanRemovedRMSE = rms(TTS_tilt-Nulling_mean);

             data.TTS.RMSE.(GVS_type{condition}){sub, trial} = Nulling_RMSE;
             data.TTS.Mean.(GVS_type{condition}){sub, trial} = Nulling_mean;
             data.TTS.MeanRemovedRMSE.(GVS_type{condition}){sub, trial} = Nulling_MeanRemovedRMSE;

         end

     end

 end
%%

 MC(:,:,1) = cell2mat(data.TTS.MeanRemovedRMSE.SHAMGVS(:,1:4));
MC(:,:,2) = cell2mat(data.TTS.MeanRemovedRMSE.DCONGVS(:,1:4));
MC(:,:,3) = cell2mat(data.TTS.MeanRemovedRMSE.DCSDGVS(:,1:4));

f=figure;
set(gcf, 'defaultLegendInterpreter', 'latex');
f.Position = [100,100, 600, 400];
plot([1.03 2.03 3.03],squeeze(MC(1,1,:)), 'bd','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.07 2.07 3.07],squeeze(MC(1,2,:)), 'rd','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.07 2.07 3.07],squeeze(MC(1,3,:)), 'cd','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.03 2.03 3.03],squeeze(MC(1,4,:)), 'gd','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.13 2.13 3.13],squeeze(MC(2,1,:)), 'bo','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.17 2.17 3.17],squeeze(MC(2,2,:)), 'ro','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.17 2.17 3.17],squeeze(MC(2,3,:)), 'co','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([1.13 2.13 3.13],squeeze(MC(2,4,:)), 'go','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.83 1.83 2.83],squeeze(MC(3,1,:)), 'bs','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.87 1.87 2.87],squeeze(MC(3,2,:)), 'rs','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.87 1.87 2.87],squeeze(MC(3,3,:)), 'cs','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.83 1.83 2.83],squeeze(MC(3,4,:)), 'gs','MarkerFaceColor','k', MarkerSize= 10); hold on;

plot([0.93 1.93 2.93],squeeze(MC(4,1,:)), 'b^','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.97 1.97 2.97],squeeze(MC(4,2,:)), 'r^','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.97 1.97 2.97],squeeze(MC(4,3,:)), 'c^','MarkerFaceColor','k', MarkerSize= 10); hold on;
plot([0.93 1.93 2.93],squeeze(MC(4,4,:)), 'g^','MarkerFaceColor','k', MarkerSize= 10); hold on;
xticks([1 2 3])
% xticklabels({"NO GVS" "Tilt Coupled GVS" "Tilt Coupled + Disturbance GVS"})
set(gca, 'FontSize', 21);
xticklabels({"" "" ""})
xlim([0.5 3.5])
ylim([1 3.25])
ylabel(" RMSE (deg)");
title([{"Manual Control Nulling"} {"Mean Removed RMSE"}]);
grid on;
