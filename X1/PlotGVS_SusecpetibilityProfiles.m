load("ExampleSin1Hz4mA.mat");
red =[0.7373  0.1529    0.1922];
f=figure;
plot(t,(ElectrodesM(1,2:end)), 'color', red, 'LineWidth',5);
title('GVS Profile', FontSize=30)
xlabel('Time (s)');
ylabel('Current (mA)');
ylim( [-4 4]);
yticks([-4 0 4])
xlim( [0 12]);
ax = gca;
ax.XAxis.FontSize = 25;
ax.YAxis.FontSize = 25;
f.Position = [100 100 750 500]