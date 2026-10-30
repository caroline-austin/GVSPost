function [Ch1, Ch2, Ch3, currentR, currentL] = GIST_GVS_Est(imu_data, GVS_type,SDWave)

    SDWave_fs = 100;
    GIST_fs = 375;
    max_mA = 2.5;
    max_ang = 10;
    max_vel = 20;
    
    Var_names = imu_data.Properties.VariableNames;
    % roll = resample(imu_data.Roll,SDWave_fs,GIST_fs); % store roll tilt
    % z_vel = resample(imu_data.ZVelocity,SDWave_fs,GIST_fs); % store roll tilt velocity 
    % pitch = resample(imu_data.Pitch,SDWave_fs,GIST_fs); % store pitch tilt
    % x_vel = resample(imu_data.XVelocity,SDWave_fs,GIST_fs); % store pitch tilt velocity 
    % yaw = resample(imu_data.Yaw,SDWave_fs,GIST_fs); % store yaw 
    % y_vel = resample(imu_data.YVelocity,SDWave_fs,GIST_fs); % store yaw velocity 

    roll = imu_data.Roll; % store roll tilt
    z_vel = imu_data.ZVelocity; % store roll tilt velocity 
    pitch = imu_data.Pitch; % store pitch tilt
    x_vel = imu_data.XVelocity; % store pitch tilt velocity 
    yaw =  imu_data.Yaw; % store yaw 
    y_vel =  imu_data.YVelocity; % store yaw velocity 

    len_data= length(roll);
    len_Offset = length(SDWave);

    if len_data <len_Offset
        SDWave = SDWave(1:len_data);
    end
   

    if contains(GVS_type, 'DCWV')
        
        K1 = [892 0 0 0 0 995]/1000; % roll, pitch, yaw, x_vel, y_vel, z_vel   -> note that -K1 here is because GIST sign convention is flipped (ie negative mo
        K2 = [0 143 0 133 0 0]/1000; % roll, pitch, yaw, x_vel, y_vel, z_vel
        K3 = [0 143 0 133 0 0]/1000; % roll, pitch, yaw, x_vel, y_vel, z_vel
        SDWave = 0;
    else
        K1 = [0 0 0 0 0 0]; % roll, pitch, yaw, x_vel, y_vel, z_vel   
        K2 = [0 0 0 0 0 0]; % roll, pitch, yaw, x_vel, y_vel, z_vel
        K3 = [0 0 0 0 0 0]; % roll, pitch, yaw, x_vel, y_vel, z_vel
    end
        
    if contains(GVS_type, 'SDWV')
        if len_data <len_Offset
            SDWave = SDWave(1:len_data);
        elseif len_data > len_Offset
            SDWave = [SDWave; SDWave(1:(len_data-len_Offset))];
        end
    else
        SDWave = 0;
    end 
    
    Ch1 = ((roll*K1(1) +pitch*K1(2) +yaw*K1(3))*max_mA/max_ang + (x_vel *K1(4) + y_vel *K1(5) + z_vel*K1(6)) *max_mA/max_vel );
    Ch2 = ((roll*K2(1) +pitch*K2(2) +yaw*K2(3))*max_mA/max_ang + (x_vel *K2(4) + y_vel *K2(5) + z_vel*K2(6)) *max_mA/max_vel );
    Ch3 = ((roll*K3(1) +pitch*K3(2) +yaw*K3(3))*max_mA/max_ang + (x_vel *K3(4) + y_vel *K3(5) + z_vel*K3(6)) *max_mA/max_vel );

    Ch1(Ch1>max_mA) = max_mA;
    Ch2(Ch2>max_mA) = max_mA;
    Ch3(Ch3>max_mA) = max_mA;

    Ch1(Ch1<-max_mA) = -max_mA;
    Ch2(Ch2<-max_mA) = -max_mA;
    Ch3(Ch3<-max_mA) = -max_mA;

    Ch1 = Ch1 +SDWave/1000;
    Ch2 = Ch2 +SDWave/1000;
    Ch3 = Ch3 +SDWave/1000;
    currentR = Ch1+Ch2;
    currentL = -Ch1+Ch3;

end
