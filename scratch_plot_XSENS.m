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
figure;
plot(fft_SpHz_accy_sort(:,12),Gain_sub(5:10),"o");
% legend(["17" "18" "19" "20" "21" "22"]);

%%

figure;
plot(fft_SpHz_acc_sort(:,12),Gain_sub(5:10),"o");