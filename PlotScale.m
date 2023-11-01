function [Xlimit, Ylimit] = PlotScale(DataSet,time)
%PlotScale scales the IMU data on both the x and y axis

if max(time) < 10
    Ylimit = [min(min(DataSet(:,1:3))), max(max(DataSet(:,1:3))), min(min(DataSet(:,4:6))), max(max(DataSet(:,4:6))), min(min(DataSet(:,7:9))), max(max(DataSet(:,7:9)))];
    Xlimit = [0,max(time)];
end 

if max(time) >= 10
    Ylimit = [min(min(DataSet(:,1:3))), max(max(DataSet(:,1:3))), min(min(DataSet(:,4:6))), max(max(DataSet(:,4:6))), min(min(DataSet(:,7:9))), max(max(DataSet(:,7:9)))];
    Xlimit = [time(1,length(time)-30*10), time(1,length(time)-30*2)];
end
end
