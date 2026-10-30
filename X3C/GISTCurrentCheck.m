clear all 
% close all
clc 
code_path = pwd;
[filename, file_path] = uigetfile('*.csv');
cd(file_path)
GIST_data=readtable(filename);
cd(code_path)

R_current = GIST_data.CH1Current + GIST_data.CH2Current;
L_current = -GIST_data.CH1Current + GIST_data.CH3Current;

Kroll= -.239;
Kzvel=0.581;
Kpitch = -0.313;
Kxvel = 0.207;
MaxAng = 65;
MaxVel= 20;

R_current_est = GIST_data.Roll*Kroll*2500/MaxAng + GIST_data.ZVelocity*Kzvel*2500/MaxVel + GIST_data.Pitch*Kpitch*2500/MaxAng + GIST_data.XVelocity*Kxvel*2500/MaxVel;
L_current_est = -GIST_data.Roll*Kroll*2500/MaxAng - GIST_data.ZVelocity*Kzvel*2500/MaxVel + GIST_data.Pitch*Kpitch*2500/MaxAng + GIST_data.XVelocity*Kxvel*2500/MaxVel;
%%
figure; 
subplot(2,1,1)
plot(R_current)
hold on
plot(R_current_est)
legend(["Actual" "Est"])
title("Right")

subplot(2,1,2)
plot(L_current)
hold on
plot(L_current_est)
legend(["Actual" "Est"])
title("Left")
sgtitle(filename)