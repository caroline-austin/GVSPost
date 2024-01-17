figure; 
plot(match_list,fft_SpHz_acc_sort);
legend(["17" "18" "19" "20" "21" "22"]);

%%
figure;
plot(trialinfo_mAval,fft_SpHz_acc, 'square','MarkerSize', 15);
legend(["17" "18" "19" "20" "21" "22"])

%%
figure;
plot(trialinfo_mAval,fft_SpHz_accy, 'square','MarkerSize', 15);
legend(["17" "18" "19" "20" "21" "22"])

%%
figure; 
plot(match_list,fft_SpHz_accy_sort);
legend(["17" "18" "19" "20" "21" "22"]);

%% 
% run IMUmetricsXsens and then load SubjectKGVS before running
sub_symbols = ["ko";"k+"; "k*"; "kx"; "ksquare"; "k^";];
fig = figure;
plot(fft_SpHz_accy_sort(:,11),Gain_sub(5:10),'.','MarkerSize',0.001); hold on;
h=lsline(); hold on;
line_y=h.YData;
line_x=h.XData;
corr_slope=(line_y(2)-line_y(1))/(line_x(2)-line_x(1));
corr_slope_2 = corrcoef(fft_SpHz_accy_sort(:,11),Gain_sub(5:10));
mdl = fitlm(fft_SpHz_accy_sort(:,11),Gain_sub(5:10));
for i = 1:6
    plot(fft_SpHz_accy_sort(i,11),Gain_sub(i+4),sub_symbols(i),'MarkerSize',15, LineWidth= 2);
    hold on;
end

title('Medial-Lateral Sway Near 1Hz v. KGVS');
xlabel('Amount of Sway Near 1Hz at 2mA (m/s^2)');
ylabel('K_G_V_S ');
fontsize(fig, 32, "points")

%%

figure;
plot(fft_SpHz_acc_sort(:,12),Gain_sub(5:10),"o");

%%
% load SubjectKGVS.mat
sub_symbols = ["kpentagram";"k<";"k>"; "kv";"ko";"k+"; "k*"; "kx"; "ksquare"; "k^";];
xoffset2 = [-0.075;-0.06; -0.045; -0.03; -0.015;  0.015; 0.03; 0.045; 0.06; 0.075]; 
fig = figure;hold on;
boxplot(Gain_sub);
xticks([1])
xticklabels(['']);
xlim([0.75 1.25])
for i = 1:length(Gain_sub)
    plot(1+xoffset2(i),Gain_sub(i),sub_symbols(i),'MarkerSize',20, LineWidth= 2);
    hold on;
end
title('K_G_V_S GVS Effect');
xlabel('');
xticks([1])
xticklabels(['']);
ylabel('K_G_V_S ');
fontsize(fig, 32, "points")