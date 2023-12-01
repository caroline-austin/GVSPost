%color blind friendly colors
blue = [ 0.2118    0.5255    0.6275];
green = [0.5059    0.7451    0.6314];
navy = [0.2196    0.2118    0.3804];
purple = [0.4196    0.3059    0.4431];
red =[0.7373  0.1529    0.1922];

fs = 50;
dt = 1/fs;
duration = 60;
t = [0:dt:duration];
num_waves = 4;
%           0.5 Hz     0.33 Hz     0.15Hz        0.4545Hz
test_sin = (sin(t*pi)+sin(t*2/3*pi)+sin(t*2*pi/(6+2/3))+ sin(t*2*pi/(2.2)))/num_waves;
% plot(t, test_sin);
test_cos = (cos(t*pi)+cos(t*2/3*pi)+cos(t*2*pi/(6+2/3))+ cos(t*2*pi/(2.2)))/num_waves;

figure;
subplot(4,1,1, 'FontSize', 15);
title('TTS Tilt Profile', 'FontSize', 36); hold on;
plot(t, 8*test_sin, 'color', green, 'LineWidth',5);
% xlabel('Time (seconds)', 'FontSize',30);
ylabel('Tilt (deg)', 'FontSize',30);
ylim( [-8 8]);
yticks([-8 0 8])

subplot(4,1,2, 'FontSize', 15);
title('Current Proportional to Roll Postion', 'FontSize', 36); hold on;
plot( t, 4*test_sin, 'color', blue, 'LineWidth',5);
% xlabel('Time (seconds)', 'FontSize',30);
% ylabel('Current (mA)', 'FontSize',30);
ylim( [-4 4]);
yticks([-4 0 4])

subplot(4,1,3, 'FontSize', 15);
title('Current Proportional to Roll Velocity', 'FontSize', 36); hold on;
plot( t, 4*test_cos, 'color', red, 'LineWidth',5);
% xlabel('Time (seconds)', 'FontSize',30);
ylabel('Current (mA)', 'FontSize',30);
ylim( [-4 4]);
yticks([-4 0 4])

subplot(4,1,4, 'FontSize', 15);
title('Current Proportional to Roll Postion and Velocity', 'FontSize', 36); hold on; 
plot( t, 4*(test_sin+test_cos)/2, 'color', purple, 'LineWidth',5);
xlabel('Time (seconds)', 'FontSize',30);
% ylabel('Current (mA)', 'FontSize',30);
ylim( [-4 4]);
yticks([-4 0 4])

hold off;
