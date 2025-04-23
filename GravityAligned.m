function  [acc_aligned, gyro_aligned, yaw, pitch, roll] = GravityAligned(acc, gyro,sensorpositionplot,sample_freq)
    
    FUSE = imufilter('SampleRate',sample_freq);
    q = FUSE(acc,gyro); % goes from Inertial to Sensor
    Eulers = eulerd(q, 'ZYX', 'frame'); % sensor = Rx'*Ry'*Rz'*global
    [yaw, pitch, roll] = quat2angle(q);

    acc_aligned = zeros(length(acc),3);
    gyro_aligned = zeros(length(gyro),3);
    for i = 1:length(acc)
        theta = Eulers(i,3);
        phi = Eulers(i,2);
        Rx = [1 0 0;0 cosd(theta) -sind(theta);...
              0 sind(theta) cosd(theta)];
        Ry = [cosd(phi) 0 sind(phi); 0 1 0;...
             -sind(phi) 0 cosd(phi)];

        % Excludes Rz to keep ML and AP aligned with x and y in the subject 
        % coordinated system vs. some fixed yaw inertial reference frame
        % yaw = -Eulers(i,1);
        % Rz = [cosd(yaw) -sind(phi) 0; 
        %       sind(yaw) cosd(yaw) 0; 0 0 1];
        acc_aligned(i,:) = (Rx*Ry*acc(i,:)')'; % Rz*Ry*Rx*sensor to go back
        gyro_aligned(i,:) = (Rx*Ry*gyro(i,:)')'; % Rz*Ry*Rx*sensor to go back
    end

    if sensorpositionplot == 1
        pp=poseplot;
        for ii=1:size(acc,1)
            qimu = FUSE(acc(ii,:), gyro(ii,:));
            set(pp, "Orientation", qimu)
            drawnow limitrate
            pause(0.05)
        end
    end
end