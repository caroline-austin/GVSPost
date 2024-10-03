function [t_s,conf,percepts,others] = Observer_Analysis(time,motion,varargin)
% Inputs
%
% time := model simulation time as a Nx1 vector congruent with model motion 
%
% motion := model simulation models as a Nx6 array with inputs 
% corresponding to wx wy wz x y z
%
% s := motion sickness model parameters in a 8x1 or 1x8 vector
%
% Glevel := the 4th argument (optional). If no input, gravity is 1g down
% in respect to the human observer
%
% plotflag := the 5th argument (optional) for plotting perceptions
% 0: No plots
% 1: GIF
% 2: Gravity Level
% 3: Angular Velocity of wz
%
% Sim Mod := the 6th argument (optional) for using filtered conflicts model
% 0: Standard Observer w/ MS
% 1: Low-pass filter
% 2: No Filter w/ GVS 
%       also need to input a 7th argument for GVS current
%       also need to input a 8th argument for GVS model params
%
%% Initialize
model = 'observerModel_GVS';
sym = 'asymmetric';

% GVS current input
current_in = varargin{2};

% Model parameters for GVS blocks
KRight = 0.5;
KLeft = 1-KRight;
s2= varargin{3};
KGVS = s2(1)*pi/180; % deg/s to rad/s
KReg = s2(2);

% Define transfer functions
switch sym
    case 'symmetric'
        
        % Regular Symmetric
        % From Kwan 2019
        [num,den] = zp2tf([-26 -188]',[-47 -2578],98);
        % From Fitting avg. Cathode/Anode step response in Forbes 
        m = 5e-3;
        RegDepol = tf(num,den)*tf([1 m*11.35],[1 m*20])*1.1;
        RegHyperpol = RegDepol;
        
        % Irregular Symmetric
        % From Kwan 2019
        [num,den] = zp2tf([-12 -136]',[-18 -2739],418);
        % From Fitting avg. Cathode/Anode step response in Forbes 
        IrregDepol = tf(num,den)*tf([1 m*6.338],[1 m*20])*1.1;
        IrregHyperpol = IrregDepol;

    case'asymmetric'

        num = [44.9920 7.9032e+03 1.5698e+05 4.0337e+03];
        den = [1 1.0376e+03 3.6936e+04 1.5773e+03];
        RegDepol = tf(num,den);
    
        num = [20.5418 1.2203e+03 24.3975];
        den = [1 297.4912 17.2106];
        RegHyperpol = tf(num,den);
        
        num = [151.3870 1.4111e+04 4.2886e+04 2.5762e+03];
        den = [1 617.4363 3.0779e+03 384.0812];
        IrregDepol = tf(num,den);
    
        num = [0 8.2803e+08 9.3501e+10 1.4339e+09];
        den = [1 4.4682e+05 6.7776e+09 4.0666e+08];
        IrregHyperpol = tf(num,den);
end

% Define Interpretive transfer functions
num = 0.437; den = 1;
RegSCCnf = tf(num,den);
RegSCC2Physical = inv(RegSCCnf);

num = 0.542; den = 1;
IrregSCCnf = tf(num,den);
IrregSCC2Physical = inv(IrregSCCnf);


%% Initialize Motion
initializer_array = zeros(length(time),24);

x_in = motion(:,1:3);
omega_in = motion(:,4:6);
xv_in = [initializer_array(:,8),initializer_array(:,9),initializer_array(:,10)];
xvdot_in = [initializer_array(:,11),initializer_array(:,12),initializer_array(:,13)];
omegav_in = [initializer_array(:,14),initializer_array(:,15),initializer_array(:,16)];
gv_in = [initializer_array(:,17),initializer_array(:,18),initializer_array(:,19)];
g_variable_in =initializer_array(:,20);
pos_ON =initializer_array(:,21);
vel_ON =initializer_array(:,22);
angVel_ON =initializer_array(:,23);
g_ON =initializer_array(:,24);

%% Simulation 
% Time and Tolerance Properties set by data input file to ensure a correct
% sampling rate.
delta_t = time(2) - time (1);
duration = length(time)*delta_t;
sample_rate = 1/delta_t;
t = time;
tolerance = 0.02;

% Differentiate Position to Velcoity and Acceleration
v_in = zeros(size(x_in,1),3);
v_in(1:size(x_in,1)-1,:) = diff(x_in,1)/delta_t;

a_in = zeros(size(x_in,1),3);
a_in(1:size(x_in,1)-2,:) = diff(x_in,2)/(delta_t*delta_t);

% Initial Conditions 
%Initialize the GRAVITY input to the model [gx0 gy0 gz0]'
if nargin > 2
    G0 = varargin{1};
else
    ground_truth = 1;
    G0 = [0 0 -ground_truth].*ones(length(time),1); 
end

% Initialize the internal GRAVITY STATE of the model
hypo = 1;
GG0 =[0 0 -hypo]';

% Tilt Angle
g_x = 0;
g_y = 0;
g_z = -1;
g_mag = sqrt(g_x*g_x + g_y*g_y + g_z*g_z);
g_norm = [g_x/g_mag g_y/g_mag g_z/g_mag]';
assignin('base', 'g_norm', g_norm);

% Initialize Quaternions
if g_norm(1) == G0(1) && g_norm(2) == G0(2)
    Q0 = [1 0 0 0]';
    VR_IC = [0 0 0 0];
else
    % Perpendicular Vector
    E_vec = cross(g_norm,[0 0 -1]);
    % Normalize E vector
    E_mag = sqrt(E_vec(1)*E_vec(1) + E_vec(2)*E_vec(2) + E_vec(3)*E_vec(3));
    E = E_vec./E_mag;
    % Calculate Rotation angle
    E_angle = acos(dot(g_norm,[0 0 -1]));
    % Calculate Quaternion
    Q0 = [cos(E_angle/2) E(1)*sin(E_angle/2) E(2)*sin(E_angle/2) E(3)*sin(E_angle/2)]';
    VR_IC = [E,E_angle];
end

% Preload Idiotropic Vecdtor
h = [0 0 -1];
% Preload Idiotropic Bias
w = 0;

% Initialize scc time constants [x y z]'
tau_scc_value = 5.7;
tau_scc=tau_scc_value*[1 1 1]';

%Internal Model SCC Time Constant is Set to CNS time constant,
tau_scc_cap=tau_scc;

% Initialize scc adaptation time constants
tau_a_value = 80;
tau_a=tau_a_value*[1 1 1]';
% Initialize the low-pass filter frequency for scc
f_oto = 2;
% Initialize the lpf frequency for otolith
f_scc = 2;
% Initialize the Ideotropic Bias Amount 'w'
W = 0;
% Initialize Kww feedback gain
kww = 8*[1 1 1]';
% Initialize Kfg feedback gain
kfg = 4*[1 1 1]';
% Initialize Kfw feedback gain
kfw = 8*[1 1 1]';
% Initialize Kaa feedback gain
kaa = -4*[1 1 1]';
% Initialize Kwg feedback gain
kwg = 1*[1 1 1]';

% Initialize Graviceptor Gain
oto_a = 60*[1 1 1]';
% Initialize Adapatation time constant
oto_Ka = 1.3*[1 1 1]';



%% Execute Simulink Model
% Options
options=simset('Solver','ode23s','MaxStep',tolerance,'RelTol',tolerance,'AbsTol',tolerance,'SrcWorkspace','current');
warning ('off','all');

% Execution
tic;
[t_s, XDATA, a_est, gif_est, gif_head, a_head, omega_head,g_head,g_est,...
    omega_est,alpha_omega,e_w,e_f,e_a,SCC_GVS_Reg,SCC_GVS_Irreg,SCC_Physical]...
    = sim(model,duration,options,[]); %#ok<ASGLU>
warning ('on','all');

% Calculate Time of simulation
sim_Time = num2str(toc);

%% Compute Extra Variables
% Bring variables from GUI to workspace
sim_time = t_s;

%Calculate Angular Accelerations for SDAT
%Calculate the time step from simulink
sim_dt = t_s(size(t_s,1)) - t_s(size(t_s,1)-1);

omega_dot_head = zeros(size(omega_head,1),3);
omega_dot_head(1:size(omega_head,1)-1,:) = diff(omega_head,1)/sim_dt;

omega_dot_est = zeros(size(omega_est,1),3);
omega_dot_est(1:size(omega_est,1)-1,:) = diff(omega_est*180/pi,1)/sim_dt;

assignin('base', 'omega_dot_head', omega_dot_head);
assignin('base', 'omega_dot_est', omega_dot_est);
assignin('base', 'sim_dt', sim_dt);

%Calculate Vertical, SVV, Tilt, and Estimated Tilt, along with Errors
tilt_estTEMP(:,1) = tilt_est(1,1,:); %#ok<*NODEF>
tiltTEMP(:,1) = tilt(1,1,:);
tilt = tiltTEMP;
tilt_est = tilt_estTEMP;
SVV = SVV*180/3.14159;
SVV_est = SVV_est*180/3.14159;
tilt = real(tilt*180/3.14159);
tilt_est = real(tilt_est*180/3.14159);
plot_SVV(:,1) = SVV;
plot_SVV(:,2) = SVV_est;
plot_tilt(:,1) = tilt;
plot_tilt(:,2) = tilt_est;


% Store output
conf = {e_a,e_w,e_f,h};
percepts = {g_est,g_head,omega_head,omega_est,a_head,a_est};
others = {SCC_GVS_Reg,SCC_GVS_Irreg,alpha_omega,SCC_Physical,...
          R_Reg,L_Reg,R_Irreg,L_Irreg};

end