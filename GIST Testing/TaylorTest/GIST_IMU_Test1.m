close all;
clear;
clc;

code_path = pwd;
file_path = uigetdir; 
file_list = dir("*.csv");
file_num = length(file_list);

for i = 1:file_num
    file_name = string(file_list(i).name);
    file1 = readmatrix(file_name);
    shot_button = file1(:,7);
    snapshot = find(shot_button == 1);

    angle = file1(snapshot,2)./200;
    shot_angle = file1(snapshot,6)./1000;
    time = (file1(snapshot,1) - file1(1,1))./1000;

    loaded_TTS.(['angle_diff' num2str(i)]) = shot_angle - angle;
    loaded_TTS.(['angle' num2str(i)]) = angle;

    scatter(i,shot_angle,"filled","red");
    hold on
    scatter(i,angle(1),'*',"blue"); 

end

title("No Current")
xlabel("Test")
ylabel("Tilt")


