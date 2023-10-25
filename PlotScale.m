function [Xlimit, Ylimit] = PlotScale(DataSet,time)
%PlotScale scales the IMU data on both the x and y axis

Ylimit = [min(min(DataSet)), max(max(DataSet))];
Xlimit = [time(1,length(time)-30*10), time(1,length(time)-30*2)];
end
