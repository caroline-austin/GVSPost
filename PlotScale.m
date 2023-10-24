function [Xlimit, Ylimit] = PlotScale(imu_data,time)
%PlotScale scales the IMU data on both the x and y axis

Ylimit = [max(max(imu_data(:,1:3))), max(max(imu_data(:,4:6))), max(max(imu_data(:,7:9)))];
Xlimit = [time(1,length(time)-30*10) time(1,length(time)-30*2)];
end
