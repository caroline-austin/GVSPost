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
plot(fft_SpHz_accy_sort(:,12),Gain_sub(5:10),'.','MarkerSize',0.001); hold on;
h=lsline(); hold on;
line_y=h.YData;
line_x=h.XData;
corr_slope=(line_y(2)-line_y(1))/(line_x(2)-line_x(1));
for i = 1:6
    plot(fft_SpHz_accy_sort(i,12),Gain_sub(i+4),sub_symbols(i),'MarkerSize',15, LineWidth= 2);
    hold on;
end

title('Alternate GVS Susceptbility v. GVS Effect');
xlabel('Amount of Sway at 2mA (m/^s)');
ylabel('KGVS (Deg/mA)');
fontsize(fig, 32, "points")

%%

figure;
plot(fft_SpHz_acc_sort(:,12),Gain_sub(5:10),"o");