%% What we finalize
load('SubjectFitsnb2.mat');
colors;

figure;
hold on
boxplot(Gain_sub)
scatter(1*ones(length(Gain_sub),1),Gain_sub)
hold off


mu = mean((Gain_sub));
sigma = std((Gain_sub));
x = -3:0.001:3;
Pop = normpdf(x,mu,sigma);

figure;
hold on
area(x,Pop*4,'FaceColor',[0 0 0],'FaceAlpha',0.5)
histogram(Gain_sub+rand(10,1)/10,10,'Normalization', 'count')
hold off
yticks([])
% yticklabels({'0','1'})
ylabel('pdf')
xlabel('Individual Susceptibility Factor')
set(gca,'FontSize',16)


% [h p c stats]=ttest(Gain_sub);

save("SubjectKGVS.mat","Gain_sub")