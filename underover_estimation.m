clc; close; clear;

subnum = 1011:1021;  % Subject List 
numsub = length(subnum);
subskip = [1006 1007 1008 1009 1010 1013 40006];  %DNF'd subjects or subjects that didn't complete this part
match_list = ["N700"; "N750"; "N800"; "000mA";"P700"; "P750"; "P800"];
%match_list = 
datatype = 'BiasTimeGain';      % options are '', 'Bias', 'BiasTime', 'BiasTimeGain'

code_path = pwd; %save code directory
file_path = uigetdir; %user selects file directory
if ismac || isunix
    plots_path = [file_path '/Plots']; % specify where plots are saved
    gvs_path = [file_path '/GVSProfiles'];
elseif ispc
    plots_path = [file_path '\Plots']; % specify where plots are saved
    gvs_path = [file_path '\GVSProfiles'];
end

[filenames]=file_path_info2(code_path, file_path); % get files from file folder

for sub = 1:11
    subject = subnum(sub);
    subject_str = num2str(subject);
    % skip subjects that DNF'd or there is no data for
    if ismember(subject,subskip) == 1
       continue
    end   

    %load subject file
    if ismac || isunix
        subject_path = [file_path, '/' , subject_str];
        cd(subject_path);
        load(['S', subject_str, 'Group' datatype '.mat']);
        cd(code_path);
    elseif ispc
        subject_path = [file_path, '\' , subject_str];
        cd(subject_path);
        load(['S', subject_str, 'Group' datatype '.mat ']);
        cd(code_path);
    end

    % col 1: both values (+); col 2: SHOT (-) tilt (+); col 3: SHOT (+) tilt
    % (-); col 4: SHOT (-) tilt (-); 
    % shot y 4_A
    [delta_y_shot_4A_N7,delta_y_shot_4A_N7_2,delta_y_shot_4A_N75,delta_y_shot_4A_N75_2,delta_y_shot_4A_N8,delta_y_shot_4A_N8_2,delta_y_shot_4A_P0,...
        delta_y_shot_4A_P0_2,delta_y_shot_4A_P0_3,delta_y_shot_4A_P7,delta_y_shot_4A_P7_2,delta_y_shot_4A_P75,delta_y_shot_4A_P75_2,delta_y_shot_4A_P8,delta_y_shot_4A_P8_2] = lengthfinder('shot_4A',Label,shot_4A,'tilt_4A',tilt_4A);

   [P74A,P724A,P754A,P7524A,P84A,P824A,P04A,P024A,P034A,PP74A,PP724A,PP754A,PP7524A,PP84A,PP824A] = avgP(delta_y_shot_4A_N7,delta_y_shot_4A_N7_2,delta_y_shot_4A_N75,delta_y_shot_4A_N75_2,delta_y_shot_4A_N8,delta_y_shot_4A_N8_2,delta_y_shot_4A_P0,...
       delta_y_shot_4A_P0_2,delta_y_shot_4A_P0_3,delta_y_shot_4A_P7,delta_y_shot_4A_P7_2,delta_y_shot_4A_P75,delta_y_shot_4A_P75_2,delta_y_shot_4A_P8,delta_y_shot_4A_P8_2,shot_4A,tilt_4A);
   
   [N74A(:,sub),N724A(:,sub),N754A(:,sub),N7524A(:,sub),N84A(:,sub),N824A(:,sub),P04Ap(:,sub),P024Ap(:,sub),P034Ap(:,sub),P74Ap(:,sub),P724Ap(:,sub),P754Ap(:,sub),P7524Ap(:,sub),P84Ap(:,sub),P824Ap(:,sub)] = binovun(P74A,P724A,P754A,P7524A,P84A,P824A,P04A,P024A,P034A,PP74A,PP724A,PP754A,PP7524A,PP84A,PP824A);

    % shot y 4_B
    [delta_y_shot_4B_N7,delta_y_shot_4B_N7_2,delta_y_shot_4B_N75,delta_y_shot_4B_N75_2,delta_y_shot_4B_N8,delta_y_shot_4B_N8_2,delta_y_shot_4B_P0,...
        delta_y_shot_4B_P0_2,delta_y_shot_4B_P0_3,delta_y_shot_4B_P7,delta_y_shot_4B_P7_2,delta_y_shot_4B_P75,delta_y_shot_4B_P75_2,delta_y_shot_4B_P8,delta_y_shot_4B_P8_2] = lengthfinder('shot_4B',Label,shot_4B,'tilt_4B',tilt_4B);

    [P74B,P724B,P754B,P7524B,P84B,P824B,P04B,P024B,P034B,PP74B,PP724B,PP754B,PP7524B,PP84B,PP824B] = avgP(delta_y_shot_4B_N7,delta_y_shot_4B_N7_2,delta_y_shot_4B_N75,delta_y_shot_4B_N75_2,delta_y_shot_4B_N8,delta_y_shot_4B_N8_2,delta_y_shot_4B_P0,...
       delta_y_shot_4B_P0_2,delta_y_shot_4B_P0_3,delta_y_shot_4B_P7,delta_y_shot_4B_P7_2,delta_y_shot_4B_P75,delta_y_shot_4B_P75_2,delta_y_shot_4B_P8,delta_y_shot_4B_P8_2,shot_4B,tilt_4B);

    [N74B(:,sub),N724B(:,sub),N754B(:,sub),N7524B(:,sub),N84B(:,sub),N824B(:,sub),P04Bp(:,sub),P024Bp(:,sub),P034Bp(:,sub),P74Bp(:,sub),P724Bp(:,sub),P754Bp(:,sub),P7524Bp(:,sub),P84Bp(:,sub),P824Bp(:,sub)] = binovun(P74B,P724B,P754B,P7524B,P84B,P824B,P04B,P024B,P034B,PP74B,PP724B,PP754B,PP7524B,PP84B,PP824B);
    % shot y 5A
    [delta_y_shot_5A_N7,delta_y_shot_5A_N7_2,delta_y_shot_5A_N75,delta_y_shot_5A_N75_2,delta_y_shot_5A_N8,delta_y_shot_5A_N8_2,delta_y_shot_5A_P0,...
        delta_y_shot_5A_P0_2,delta_y_shot_5A_P0_3,delta_y_shot_5A_P7,delta_y_shot_5A_P7_2,delta_y_shot_5A_P75,delta_y_shot_5A_P75_2,delta_y_shot_5A_P8,delta_y_shot_5A_P8_2] = lengthfinder('shot_5A',Label,shot_5A,'tilt_5A',tilt_5A);

    [P75A,P725A,P755A,P7525A,P85A,P825A,P05A,P025A,P035A,PP75A,PP725A,PP755A,PP7525A,PP85A,PP825A] = avgP(delta_y_shot_5A_N7,delta_y_shot_5A_N7_2,delta_y_shot_5A_N75,delta_y_shot_5A_N75_2,delta_y_shot_5A_N8,delta_y_shot_5A_N8_2,delta_y_shot_5A_P0,...
        delta_y_shot_5A_P0_2,delta_y_shot_5A_P0_3,delta_y_shot_5A_P7,delta_y_shot_5A_P7_2,delta_y_shot_5A_P75,delta_y_shot_5A_P75_2,delta_y_shot_5A_P8,delta_y_shot_5A_P8_2,shot_5A,tilt_5A);

    [N75A(:,sub),N725A(:,sub),N755A(:,sub),N7525A(:,sub),N85A(:,sub),N825A(:,sub),P05Ap(:,sub),P025Ap(:,sub),P035Ap(:,sub),P75Ap(:,sub),P725Ap(:,sub),P755Ap(:,sub),P7525Ap(:,sub),P85Ap(:,sub),P825Ap(:,sub)] = binovun(P75A,P725A,P755A,P7525A,P85A,P825A,P05A,P025A,P035A,PP75A,PP725A,PP755A,PP7525A,PP85A,PP825A);
   
    % shot y 5B
    [delta_y_shot_5B_N7,delta_y_shot_5B_N7_2,delta_y_shot_5B_N75,delta_y_shot_5B_N75_2,delta_y_shot_5B_N8,delta_y_shot_5B_N8_2,delta_y_shot_5B_P0,...
        delta_y_shot_5B_P0_2,delta_y_shot_5B_P0_3,delta_y_shot_5B_P7,delta_y_shot_5B_P7_2,delta_y_shot_5B_P75,delta_y_shot_5B_P75_2,delta_y_shot_5B_P8,delta_y_shot_5B_P8_2] = lengthfinder('shot_5B',Label,shot_5B,'tilt_5B',tilt_5B);

    [P75B,P725B,P755B,P7525B,P85B,P825B,P05B,P025B,P035B,PP75B,PP725B,PP755B,PP7525B,PP85B,PP825B] = avgP(delta_y_shot_5B_N7,delta_y_shot_5B_N7_2,delta_y_shot_5B_N75,delta_y_shot_5B_N75_2,delta_y_shot_5B_N8,delta_y_shot_5B_N8_2,delta_y_shot_5B_P0,...
        delta_y_shot_5B_P0_2,delta_y_shot_5B_P0_3,delta_y_shot_5B_P7,delta_y_shot_5B_P7_2,delta_y_shot_5B_P75,delta_y_shot_5B_P75_2,delta_y_shot_5B_P8,delta_y_shot_5B_P8_2,shot_5B,tilt_5B);

    [N75B(:,sub),N725B(:,sub),N755B(:,sub),N7525B(:,sub),N85B(:,sub),N825B(:,sub),P05Bp(:,sub),P025Bp(:,sub),P035Bp(:,sub),P75Bp(:,sub),P725Bp(:,sub),P755Bp(:,sub),P7525Bp(:,sub),P85Bp(:,sub),P825Bp(:,sub)] = binovun(P75B,P725B,P755B,P7525B,P85B,P825B,P05B,P025B,P035B,PP75B,PP725B,PP755B,PP7525B,PP85B,PP825B);
  
    % shot y 6A
    [delta_y_shot_6A_N7,delta_y_shot_6A_N7_2,delta_y_shot_6A_N75,delta_y_shot_6A_N75_2,delta_y_shot_6A_N8,delta_y_shot_6A_N8_2,delta_y_shot_6A_P0,...
        delta_y_shot_6A_P0_2,delta_y_shot_6A_P0_3,delta_y_shot_6A_P7,delta_y_shot_6A_P7_2,delta_y_shot_6A_P75,delta_y_shot_6A_P75_2,delta_y_shot_6A_P8,delta_y_shot_6A_P8_2] = lengthfinder('shot_6A',Label,shot_6A,'tilt_6A',tilt_6A);

    [P76A,P726A,P756A,P7526A,P86A,P826A,P06A,P026A,P036A,PP76A,PP726A,PP756A,PP7526A,PP86A,PP826A] = avgP(delta_y_shot_6A_N7,delta_y_shot_6A_N7_2,delta_y_shot_6A_N75,delta_y_shot_6A_N75_2,delta_y_shot_6A_N8,delta_y_shot_6A_N8_2,delta_y_shot_6A_P0,...
        delta_y_shot_6A_P0_2,delta_y_shot_6A_P0_3,delta_y_shot_6A_P7,delta_y_shot_6A_P7_2,delta_y_shot_6A_P75,delta_y_shot_6A_P75_2,delta_y_shot_6A_P8,delta_y_shot_6A_P8_2,shot_6A,tilt_6A);

    [N76A(:,sub),N726A(:,sub),N756A(:,sub),N7526A(:,sub),N86A(:,sub),N826A(:,sub),P06Ap(:,sub),P026Ap(:,sub),P036Ap(:,sub),P76Ap(:,sub),P726Ap(:,sub),P756Ap(:,sub),P7526Ap(:,sub),P86Ap(:,sub),P826Ap(:,sub)] = binovun(P76A,P726A,P756A,P7526A,P86A,P826A,P06A,P026A,P036A,PP76A,PP726A,PP756A,PP7526A,PP86A,PP826A);
    
    % shot y 6B
    [delta_y_shot_6B_N7,delta_y_shot_6B_N7_2,delta_y_shot_6B_N75,delta_y_shot_6B_N75_2,delta_y_shot_6B_N8,delta_y_shot_6B_N8_2,delta_y_shot_6B_P0,...
        delta_y_shot_6B_P0_2,delta_y_shot_6B_P0_3,delta_y_shot_6B_P7,delta_y_shot_6B_P7_2,delta_y_shot_6B_P75,delta_y_shot_6B_P75_2,delta_y_shot_6B_P8,delta_y_shot_6B_P8_2] = lengthfinder('shot_6B',Label,shot_6B,'tilt_6B',tilt_6B);

    [P76B,P726B,P756B,P7526B,P86B,P826B,P06B,P026B,P036B,PP76B,PP726B,PP756B,PP7526B,PP86B,PP826B] = avgP(delta_y_shot_6B_N7,delta_y_shot_6B_N7_2,delta_y_shot_6B_N75,delta_y_shot_6B_N75_2,delta_y_shot_6B_N8,delta_y_shot_6B_N8_2,delta_y_shot_6B_P0,...
        delta_y_shot_6B_P0_2,delta_y_shot_6B_P0_3,delta_y_shot_6B_P7,delta_y_shot_6B_P7_2,delta_y_shot_6B_P75,delta_y_shot_6B_P75_2,delta_y_shot_6B_P8,delta_y_shot_6B_P8_2,shot_6B,tilt_6B);

    [N76B(:,sub),N726B(:,sub),N756B(:,sub),N7526B(:,sub),N86B(:,sub),N826B(:,sub),P06Bp(:,sub),P026Bp(:,sub),P036Bp(:,sub),P76Bp(:,sub),P726Bp(:,sub),P756Bp(:,sub),P7526Bp(:,sub),P86Bp(:,sub),P826Bp(:,sub)] = binovun(P76B,P726B,P756B,P7526B,P86B,P826B,P06B,P026B,P036B,PP76B,PP726B,PP756B,PP7526B,PP86B,PP826B);

    
end


function [N7,N72,N75,N752,N8,N82,P0,P02,P03,P7,P72,P75,P752,P8,P82] = binovun(delta_y_shot_4A_N7,delta_y_shot_4A_N7_2,delta_y_shot_4A_N75,delta_y_shot_4A_N75_2,delta_y_shot_4A_N8,delta_y_shot_4A_N8_2,delta_y_shot_4A_P0,...
        delta_y_shot_4A_P0_2,delta_y_shot_4A_P0_3,delta_y_shot_4A_P7,delta_y_shot_4A_P7_2,delta_y_shot_4A_P75,delta_y_shot_4A_P75_2,delta_y_shot_4A_P8,delta_y_shot_4A_P8_2)
for k = 1:4

    % Overestimates/Underestimates:
    delta_y_shot_4A_N7{k}(isinf(delta_y_shot_4A_N7{k})) = []; nN7 = abs(delta_y_shot_4A_N7{k})>1;
    delta_y_shot_4A_N7_2{k}(isinf(delta_y_shot_4A_N7_2{k})) = []; nN72 = abs(delta_y_shot_4A_N7_2{k})>1;
    delta_y_shot_4A_N75{k}(isinf(delta_y_shot_4A_N75{k})) = []; nN75 = abs(delta_y_shot_4A_N75{k})>1;
    delta_y_shot_4A_N75_2{k}(isinf(delta_y_shot_4A_N75_2{k})) = []; nN752 = abs(delta_y_shot_4A_N75_2{k})>1;
    delta_y_shot_4A_N8{k}(isinf(delta_y_shot_4A_N8{k})) = []; nN8 = abs(delta_y_shot_4A_N8{k})>1;
    delta_y_shot_4A_N8_2{k}(isinf(delta_y_shot_4A_N8_2{k})) = []; nN82 = abs(delta_y_shot_4A_N8_2{k})>1;
    delta_y_shot_4A_P0{k}(isinf(delta_y_shot_4A_P0{k})) = []; nP0 = abs(delta_y_shot_4A_P0{k})>1;
    delta_y_shot_4A_P0_2{k}(isinf(delta_y_shot_4A_P0_2{k})) = []; nP02 = abs(delta_y_shot_4A_P0_2{k})>1;
    delta_y_shot_4A_P0_3{k}(isinf(delta_y_shot_4A_P0_3{k})) = []; nP03 = abs(delta_y_shot_4A_P0_3{k})>1;
    delta_y_shot_4A_P75{k}(isinf(delta_y_shot_4A_P75{k})) = []; nP75 = abs(delta_y_shot_4A_P75{k})>1;
    delta_y_shot_4A_P75_2{k}(isinf(delta_y_shot_4A_P75_2{k})) = []; nP752 = abs(delta_y_shot_4A_P75_2{k})>1;
    delta_y_shot_4A_P7{k}(isinf(delta_y_shot_4A_P7{k})) = []; nP7 = abs(delta_y_shot_4A_P7{k})>1;
    delta_y_shot_4A_P7_2{k}(isinf(delta_y_shot_4A_P7_2{k})) = []; nP72 = abs(delta_y_shot_4A_P7_2{k})>1;
    delta_y_shot_4A_P8{k}(isinf(delta_y_shot_4A_P8{k})) = []; nP8 = abs(delta_y_shot_4A_P8{k})>1;
    delta_y_shot_4A_P8_2{k}(isinf(delta_y_shot_4A_P8_2{k})) = []; nP82 = abs(delta_y_shot_4A_P8_2{k})>1;

    % Values:
    nN7o(k) = nnz(nN7); nN7u(k) = nnz(~nN7);
    nN72o(k) = nnz(nN72); nN72u(k) = nnz(~nN72);
    nN75o(k) = nnz(nN75); nN75u(k) = nnz(~nN75);
    nN752o(k) = nnz(nN752); nN752u(k) = nnz(~nN752);
    nN8o(k) = nnz(nN8); nN8u(k) = nnz(~nN8); 
    nN82o(k) = nnz(nN82); nN82u(k) = nnz(~nN82);
    nP0o(k) = nnz(nP0); nP0u(k) = nnz(~nP0);
    nP02o(k) = nnz(nP02); nP02u(k) = nnz(~nP02);
    nP03o(k) = nnz(nP03); nP03u(k) = nnz(~nP03);
    nP75o(k) = nnz(nP75); nP75u(k) = nnz(~nP75);
    nP752o(k) = nnz(nP752); nP752u(k) = nnz(~nP752);
    nP7o(k) = nnz(nP7); nP7u(k) = nnz(~nP7);
    nP72o(k) = nnz(nP72); nP72u(k) = nnz(~nP72);
    nP8o(k) = nnz(nP8); nP8u(k) = nnz(~nP8);
    nP82o(k) = nnz(nP82); nP82u(k) = nnz(~nP82);



end

% Percentages:
oe_7 = sum(nN7o)/(sum(nN7o) + sum(nN7u)); ue_7 = sum(nN7u)/(sum(nN7o) + sum(nN7u));
N7 = [oe_7,ue_7];
oe_72 = sum(nN72o)/(sum(nN72o) + sum(nN72u)); ue_72 = sum(nN72u)/(sum(nN72o) + sum(nN72u));
N72 = [oe_72,ue_72];
oe_75 = sum(nN75o)/(sum(nN75o) + sum(nN75u)); ue_75 = sum(nN75u)/(sum(nN75o) + sum(nN75u));
N75 = [oe_75,ue_75];
oe_752 = sum(nN752o)/(sum(nN752o) + sum(nN752u)); ue_752 = sum(nN752u)/(sum(nN752o) + sum(nN752u));
N752 = [oe_752,ue_752];
oe_8 = sum(nN8o)/(sum(nN8o) + sum(nN8u)); ue_8 = sum(nN8u)/(sum(nN8o) + sum(nN8u));
N8 = [oe_8,ue_8];
oe_82 = sum(nN82o)/(sum(nN82o) + sum(nN82u)); ue_82 = sum(nN82u)/(sum(nN82o) + sum(nN82u));
N82 = [oe_82,ue_82];

oe_0 = sum(nP0o)/(sum(nP0o) + sum(nP0u)); ue_0 = sum(nP0u)/(sum(nP0o) + sum(nP0u));
P0 = [oe_0,ue_0];
oe_02 = sum(nP02o)/(sum(nP02o) + sum(nP02u)); ue_02 = sum(nP02u)/(sum(nP02o) + sum(nP02u));
P02 = [oe_02,ue_02];
oe_03 = sum(nP03o)/(sum(nP03o) + sum(nP03u)); ue_03 = sum(nP03u)/(sum(nP03o) + sum(nP03u));
P03 = [oe_03,ue_03];

oe_P7 = sum(nP7o)/(sum(nP7o) + sum(nP7u)); ue_P7 = sum(nP7u)/(sum(nP7o) + sum(nP7u));
P7 = [oe_P7,ue_P7];
oe_P72 = sum(nP72o)/(sum(nP72o) + sum(nP72u)); ue_P72 = sum(nP72u)/(sum(nP72o) + sum(nP72u));
P72 = [oe_P72,ue_P72];
oe_P75 = sum(nP75o)/(sum(nP75o) + sum(nP75u)); ue_P75 = sum(nP75u)/(sum(nP75o) + sum(nP75u));
P75 = [oe_P75,ue_P75];
oe_P752 = sum(nP752o)/(sum(nP752o) + sum(nP752u)); ue_P752 = sum(nP752u)/(sum(nP752o) + sum(nP752u));
P752 = [oe_P752,ue_P752];
oe_P8 = sum(nP8o)/(sum(nP8o) + sum(nP8u)); ue_P8 = sum(nP8u)/(sum(nP8o) + sum(nP8u));
P8 = [oe_P8,ue_P8];
oe_P82 = sum(nP82o)/(sum(nP82o) + sum(nP82u)); ue_P82 = sum(nP82u)/(sum(nP82o) + sum(nP82u));
P82 = [oe_P82,ue_P82];

end


function [P7,P72,P75,P752,P8,P82,P0,P02,P03,PP7,PP72,PP75,PP752,PP8,PP82] = avgP(delta_y_shot_4A_N7,delta_y_shot_4A_N7_2,delta_y_shot_4A_N75,delta_y_shot_4A_N75_2,delta_y_shot_4A_N8,delta_y_shot_4A_N8_2,delta_y_shot_4A_P0,...
        delta_y_shot_4A_P0_2,delta_y_shot_4A_P0_3,delta_y_shot_4A_P7,delta_y_shot_4A_P7_2,delta_y_shot_4A_P75,delta_y_shot_4A_P75_2,delta_y_shot_4A_P8,delta_y_shot_4A_P8_2,shot,tilt)

% N7_00
if delta_y_shot_4A_N7 == 0
    P7 = {NaN,NaN,NaN,NaN};
else
    col1_N7 = find(delta_y_shot_4A_N7(:,1) == 1); col2_N7 = find(delta_y_shot_4A_N7(:,2) == 1);
    col3_N7 = find(delta_y_shot_4A_N7(:,3) == 1); col4_N7 = find(delta_y_shot_4A_N7(:,4) == 1);
    % (+)
    P17 = shot(col1_N7)./tilt(col1_N7); P47 = shot(col4_N7)./tilt(col4_N7);
    % (-)
    P27 = 1 + abs(shot(col2_N7)./tilt(col2_N7)); P37 = 1 + abs(shot(col3_N7)./tilt(col3_N7));
    
    P7 = {P17,P27,P37,P47};
end

if delta_y_shot_4A_N7_2 == 0
    P72 = {NaN,NaN,NaN,NaN};
else
    col1_N72 = find(delta_y_shot_4A_N7_2(:,1) == 1); col2_N72 = find(delta_y_shot_4A_N7_2(:,2) == 1);
    col3_N72 = find(delta_y_shot_4A_N7_2(:,3) == 1); col4_N72 = find(delta_y_shot_4A_N7_2(:,4) == 1);
    % (+)
    P172 = shot(col1_N72)./tilt(col1_N72); P472 = shot(col4_N72)./tilt(col4_N72);
    % (-)
    P272 = 1 + abs(shot(col2_N72)./tilt(col2_N72)); P372 = 1 + abs(shot(col3_N72)./tilt(col3_N72));
    
    P72 = {P172,P272,P372,P472};
end

%N7_50
if delta_y_shot_4A_N75 == 0
    P75 = {NaN,NaN,NaN,NaN};
else
    col1_N75 = find(delta_y_shot_4A_N75(:,1) == 1); col2_N75 = find(delta_y_shot_4A_N75(:,2) == 1);
    col3_N75 = find(delta_y_shot_4A_N75(:,3) == 1); col4_N75 = find(delta_y_shot_4A_N75(:,4) == 1);
    % (+)
    P175 = shot(col1_N75)./tilt(col1_N75); P475 = shot(col4_N75)./tilt(col4_N75);
    % (-)
    P275 = 1 + abs(shot(col2_N75)./tilt(col2_N75)); P375 = 1 + abs(shot(col3_N75)./tilt(col3_N75));
    
    P75 = {P175,P275,P375,P475};
end

if delta_y_shot_4A_N75_2 == 0
    P752 = {NaN,NaN,NaN,NaN};
else
    col1_N752 = find(delta_y_shot_4A_N75_2(:,1) == 1); col2_N752 = find(delta_y_shot_4A_N75_2(:,2) == 1);
    col3_N752 = find(delta_y_shot_4A_N75_2(:,3) == 1); col4_N752 = find(delta_y_shot_4A_N75_2(:,4) == 1);
    % (+)
    P1752 = shot(col1_N752)./tilt(col1_N752); P4752 = shot(col4_N752)./tilt(col4_N752);
    % (-)
    P2752 = 1 + abs(shot(col2_N752)./tilt(col2_N752)); P3752 = 1 + abs(shot(col3_N752)./tilt(col3_N752));

    P752 = {P1752,P2752,P3752,P4752};
end

% N8_00
if delta_y_shot_4A_N8 == 0
    P8 = {NaN,NaN,NaN,NaN};
else
    col1_N8 = find(delta_y_shot_4A_N8(:,1) == 1); col2_N8 = find(delta_y_shot_4A_N8(:,2) == 1);
    col3_N8 = find(delta_y_shot_4A_N8(:,3) == 1); col4_N8 = find(delta_y_shot_4A_N8(:,4) == 1);
    % (+)
    P18 = shot(col1_N8)./tilt(col1_N8); P48 = shot(col4_N8)./tilt(col4_N8);
    % (-)
    P28 = 1 + abs(shot(col2_N8)./tilt(col2_N8)); P38 = 1 + abs(shot(col3_N8)./tilt(col3_N8));
    
    P8 = {P18,P28,P38,P48};
end

if delta_y_shot_4A_N8_2 == 0
    P82 = {NaN,NaN,NaN,NaN};
else
col1_N82 = find(delta_y_shot_4A_N8_2(:,1) == 1); col2_N82 = find(delta_y_shot_4A_N8_2(:,2) == 1);
col3_N82 = find(delta_y_shot_4A_N8_2(:,3) == 1); col4_N82 = find(delta_y_shot_4A_N8_2(:,4) == 1);
% (+)
P182 = shot(col1_N82)./tilt(col1_N82); P482 = shot(col4_N82)./tilt(col4_N82);
% (-)
P282 = 1 + abs(shot(col2_N82)./tilt(col2_N82)); P382 = 1 + abs(shot(col3_N82)./tilt(col3_N82));

P82 = {P182,P282,P382,P482};
end

% P0_00
if delta_y_shot_4A_P0 == 0
    P0 = {NaN,NaN,NaN,NaN};
else
    col1_P0 = find(delta_y_shot_4A_P0(:,1) == 1); col2_P0 = find(delta_y_shot_4A_P0(:,2) == 1);
    col3_P0 = find(delta_y_shot_4A_P0(:,3) == 1); col4_P0 = find(delta_y_shot_4A_P0(:,4) == 1);
    % (+)
    P10 = shot(col1_P0)./tilt(col1_P0); P40 = shot(col4_P0)./tilt(col4_P0);
    % (-)
    P20 = 1 + abs(shot(col2_P0)./tilt(col2_P0)); P30 = 1 + abs(shot(col3_P0)./tilt(col3_P0));
    
    P0 = {P10,P20,P30,P40};
end

if delta_y_shot_4A_P0_2 == 0
    P02 = {NaN,NaN,NaN,NaN};
else
    col1_P02 = find(delta_y_shot_4A_P0_2(:,1) == 1); col2_P02 = find(delta_y_shot_4A_P0_2(:,2) == 1);
    col3_P02 = find(delta_y_shot_4A_P0_2(:,3) == 1); col4_P02 = find(delta_y_shot_4A_P0_2(:,4) == 1);
    % (+)
    P102 = shot(col1_P02)./tilt(col1_P02); P402 = shot(col4_P02)./tilt(col4_P02);
    % (-)
    P202 = 1 + abs(shot(col2_P02)./tilt(col2_P02)); P302 = (shot(col3_P02)./tilt(col3_P02));
    
    P02 = {P102,P202,P302,P402};
end

if delta_y_shot_4A_P0_3 == 0
    P03 = {NaN,NaN,NaN,NaN};
else
    col1_P03 = find(delta_y_shot_4A_P0_3(:,1) == 1); col2_P03 = find(delta_y_shot_4A_P0_3(:,2) == 1);
    col3_P03 = find(delta_y_shot_4A_P0_3(:,3) == 1); col4_P03 = find(delta_y_shot_4A_P0_3(:,4) == 1);
    % (+)
    P103 = shot(col1_P03)./tilt(col1_P03); P403 = shot(col4_P03)./tilt(col4_P03);
    % (-)
    P203 = 1 + abs(shot(col2_P03)./tilt(col2_P03)); P303 = (shot(col3_P03)./tilt(col3_P03));

    P03 = {P103,P203,P303,P403};
end

% P7_00
if delta_y_shot_4A_P7 == 0
    PP7 = {NaN,NaN,NaN,NaN};
else
    col1_P7 = find(delta_y_shot_4A_P7(:,1) == 1); col2_P7 = find(delta_y_shot_4A_P7(:,2) == 1);
    col3_P7 = find(delta_y_shot_4A_P7(:,3) == 1); col4_P7 = find(delta_y_shot_4A_P7(:,4) == 1);
    % (+)
    P17 = shot(col1_P7)./tilt(col1_P7); P47 = shot(col4_P7)./tilt(col4_P7);
    % (-)
    P27 = 1 + abs(shot(col2_P7)./tilt(col2_P7)); P37 = 1 + abs(shot(col3_P7)./tilt(col3_P7));
    
    PP7 = {P17,P27,P37,P47};
end

if delta_y_shot_4A_P7_2 == 0
    PP72 = {NaN,NaN,NaN,NaN};
else
    col1_P72 = find(delta_y_shot_4A_P7_2(:,1) == 1); col2_P72 = find(delta_y_shot_4A_P7_2(:,2) == 1);
    col3_P72 = find(delta_y_shot_4A_P7_2(:,3) == 1); col4_P72 = find(delta_y_shot_4A_P7_2(:,4) == 1);
    % (+)
    P172 = shot(col1_P72)./tilt(col1_P72); P472 = shot(col4_P72)./tilt(col4_P72);
    % (-)
    P272 = 1 + abs(shot(col2_P72)./tilt(col2_P72)); P372 = (shot(col3_P72)./tilt(col3_P72));

    PP72 = {P172,P272,P372,P472};
end

% P7_50
if delta_y_shot_4A_P75 == 0
    PP75 = {NaN,NaN,NaN,NaN};
else
    col1_P75 = find(delta_y_shot_4A_P75(:,1) == 1); col2_P75 = find(delta_y_shot_4A_P75(:,2) == 1);
    col3_P75 = find(delta_y_shot_4A_P75(:,3) == 1); col4_P75 = find(delta_y_shot_4A_P75(:,4) == 1);
    % (+)
    P175 = shot(col1_P75)./tilt(col1_P75); P475 = shot(col4_P75)./tilt(col4_P75);
    % (-)
    P275 = 1 + abs(shot(col2_P75)./tilt(col2_P75)); P375 = 1 + abs(shot(col3_P75)./tilt(col3_P75));
    
    PP75 = {P175,P275,P375,P475};
end

if delta_y_shot_4A_P75_2 == 0
    PP752 = {NaN,NaN,NaN,NaN};
else
    col1_P752 = find(delta_y_shot_4A_P75_2(:,1) == 1); col2_P752 = find(delta_y_shot_4A_P75_2(:,2) == 1);
    col3_P752 = find(delta_y_shot_4A_P75_2(:,3) == 1); col4_P752 = find(delta_y_shot_4A_P75_2(:,4) == 1);
    % (+)
    P1752 = shot(col1_P752)./tilt(col1_P752); P4752 = shot(col4_P752)./tilt(col4_P752);
    % (-)
    P2752 = 1 + abs(shot(col2_P752)./tilt(col2_P752)); P3752 = (shot(col3_P752)./tilt(col3_P752));

    PP752 = {P1752,P2752,P3752,P4752};
end

% P8_00
if delta_y_shot_4A_P8 == 0
    PP8 = {NaN,NaN,NaN,NaN};
else
    col1_P8 = find(delta_y_shot_4A_P8(:,1) == 1); col2_P8 = find(delta_y_shot_4A_P8(:,2) == 1);
    col3_P8 = find(delta_y_shot_4A_P8(:,3) == 1); col4_P8 = find(delta_y_shot_4A_P8(:,4) == 1);
    % (+)
    P18 = shot(col1_P8)./tilt(col1_P8); P48 = shot(col4_P8)./tilt(col4_P8);
    % (-)
    P28 = 1 + abs(shot(col2_P8)./tilt(col2_P8)); P38 = 1 + abs(shot(col3_P8)./tilt(col3_P8));
    
    PP8 = {P18,P28,P38,P48};
end

if delta_y_shot_4A_P8_2 == 0
    PP82 = {NaN,NaN,NaN,NaN};
else
    col1_P82 = find(delta_y_shot_4A_P8_2(:,1) == 1); col2_P82 = find(delta_y_shot_4A_P8_2(:,2) == 1);
    col3_P82 = find(delta_y_shot_4A_P8_2(:,3) == 1); col4_P82 = find(delta_y_shot_4A_P8_2(:,4) == 1);
    % (+)
    P182 = shot(col1_P82)./tilt(col1_P82); P482 = shot(col4_P82)./tilt(col4_P82);
    % (-)
    P282 = 1 + abs(shot(col2_P82)./tilt(col2_P82)); P382 = (shot(col3_P82)./tilt(col3_P82));

    PP82 = {P182,P282,P382,P482};
end

end




function [P7,P72,P75,P752,P8,P82,P0,P02,P03,PP7,PP72,PP75,PP752,PP8,PP82] = lengthfinder(shot_val,Label,sv,tilt_val,tv)
% shot_val = 'shot_4A'; tilt_val = 'tilt_4A';
% sv = shot_4A; tv = tilt_4A;
cont_shot_N7_00 = contains(Label.(shot_val),'N_4_00mA_7_00'); 
cont_shot_N7_50 = contains(Label.(shot_val),'N_4_00mA_7_50');
cont_shot_N8_00 = contains(Label.(shot_val),'N_4_00mA_8_00');
cont_shot_P0_00 = contains(Label.(shot_val),'P_0_00mA_0_00');
cont_shot_P7_00 = contains(Label.(shot_val),'P_4_00mA_7_00');
cont_shot_P7_50 = contains(Label.(shot_val),'P_4_00mA_7_50');
cont_shot_P8_00 = contains(Label.(shot_val),'P_4_00mA_8_00');

cont_tilt_N7_00 = contains(Label.(tilt_val),'N_4_00mA_7_00');
cont_tilt_N7_50 = contains(Label.(tilt_val),'N_4_00mA_7_50');
cont_tilt_N8_00 = contains(Label.(tilt_val),'N_4_00mA_8_00');
cont_tilt_P0_00 = contains(Label.(tilt_val),'P_0_00mA_0_00');
cont_tilt_P7_00 = contains(Label.(tilt_val),'P_4_00mA_7_00');
cont_tilt_P7_50 = contains(Label.(tilt_val),'P_4_00mA_7_50');
cont_tilt_P8_00 = contains(Label.(tilt_val),'P_4_00mA_8_00');


% col 1: both values (+); col 2: SHOT (-) tilt (+); col 3: SHOT (+) tilt
% (-); col 4: SHOT (-) tilt (-); 
find7 = find(cont_shot_N7_00 == 1);
find7_2 = find(cont_tilt_N7_00 == 1);
 
if length(find(cont_shot_N7_00 == 1)) == 1
    P7 = [(sv(:,find7(1))>=0)./(tv(:,find7_2(1))>=0),(sv(:,find7(1))<=0)./(tv(:,find7_2(1)) >= 0),(sv(:,find7(1))>=0)./(tv(:,find7_2(1)) <= 0),(sv(:,find7(1))<=0)./(tv(:,find7_2(1)) <= 0)];
    P72 = 0;
elseif length(find(cont_shot_N7_00 == 1)) == 2
    P7 = [(sv(:,find7(1))>=0)./(tv(:,find7_2(1))>=0),(sv(:,find7(1))<=0)./(tv(:,find7_2(1)) >= 0),(sv(:,find7(1))>=0)./(tv(:,find7_2(1)) <= 0),(sv(:,find7(1))<=0)./(tv(:,find7_2(1)) <= 0)];
    P72 = [(sv(:,find7(2))>=0)./(tv(:,find7_2(4))>=0),(sv(:,find7(2))<=0)./(tv(:,find7_2(4)) >= 0),(sv(:,find7(2))>=0)./(tv(:,find7_2(4)) <= 0),(sv(:,find7(2))<=0)./(tv(:,find7_2(4)) <= 0)];
elseif length(find(cont_shot_N7_00 == 1)) == 0
    P7 = 0;
    P72 = 0;
end


find75 = find(cont_shot_N7_50 == 1);
find75_2 = find(cont_tilt_N7_50 == 1);
if length(find(cont_shot_N7_50 == 1)) == 1
    P75 = [(sv(:,find75(1))>=0)./(tv(:,find75_2(1))>=0),(sv(:,find75(1))<=0)./(tv(:,find75_2(1)) >= 0),(sv(:,find75(1))>=0)./(tv(:,find75_2(1)) <= 0),(sv(:,find75(1))<=0)./(tv(:,find75_2(1)) <= 0)];
    P752 = 0;
elseif length(find(cont_shot_N7_50 == 1)) == 2
    P75 = [(sv(:,find75(1))>=0)./(tv(:,find75_2(1))>=0),(sv(:,find75(1))<=0)./(tv(:,find75_2(1)) >= 0),(sv(:,find75(1))>=0)./(tv(:,find75_2(1)) <= 0),(sv(:,find75(1))<=0)./(tv(:,find75_2(1)) <= 0)];
    P752 = [(sv(:,find75(2))>=0)./(tv(:,find75_2(4))>=0),(sv(:,find75(2))<=0)./(tv(:,find75_2(4)) >= 0),(sv(:,find75(2))>=0)./(tv(:,find75_2(4)) <= 0),(sv(:,find75(2))<=0)./(tv(:,find75_2(4)) <= 0)];
elseif length(find(cont_shot_N7_50 == 1)) == 0
    P75 = 0;
    P752 = 0;
end

find8 = find(cont_shot_N8_00 == 1);
find8_2 = find(cont_tilt_N8_00 == 1);
if length(find(cont_shot_N8_00 == 1)) == 1
    P8 = [(sv(:,find8(1))>=0)./(tv(:,find8_2(1))>=0),(sv(:,find8(1))<=0)./(tv(:,find8_2(1)) >= 0),(sv(:,find8(1))>=0)./(tv(:,find8_2(1)) <= 0),(sv(:,find8(1))<=0)./(tv(:,find8_2(1)) <= 0)];
    P82 = 0;
elseif length(find(cont_shot_N8_00 == 1)) == 2
    P8 = [(sv(:,find8(1))>=0)./(tv(:,find8_2(1))>=0),(sv(:,find8(1))<=0)./(tv(:,find8_2(1)) >= 0),(sv(:,find8(1))>=0)./(tv(:,find8_2(1)) <= 0),(sv(:,find8(1))<=0)./(tv(:,find8_2(1)) <= 0)];
    P82 = [(sv(:,find8(2))>=0)./(tv(:,find8_2(4))>=0),(sv(:,find8(2))<=0)./(tv(:,find8_2(4)) >= 0),(sv(:,find8(2))>=0)./(tv(:,find8_2(4)) <= 0),(sv(:,find8(2))<=0)./(tv(:,find8_2(4)) <= 0)];
elseif length(find(cont_shot_N8_00 == 1)) == 0
    P8 = 0;
    P82 = 0;
end

find_zeros = find(cont_shot_P0_00 == 1);
find_zeros_2 = find(cont_tilt_P0_00 == 1);
if length(find(cont_shot_P0_00 == 1)) == 1
    P0 = [(sv(:,find_zeros(1))>=0)./(tv(:,find_zeros_2(1))>=0),(sv(:,find_zeros(1))<=0)./(tv(:,find_zeros_2(1)) >= 0),(sv(:,find_zeros(1))>=0)./(tv(:,find_zeros_2(1)) <= 0),(sv(:,find_zeros(1))<=0)./(tv(:,find_zeros_2(1)) <= 0)];
    P02 = 0;
    P03 = 0;
elseif length(find(cont_shot_P0_00 == 1)) == 2
    P0 = [(sv(:,find_zeros(1))>=0)./(tv(:,find_zeros_2(1))>=0),(sv(:,find_zeros(1))<=0)./(tv(:,find_zeros_2(1)) >= 0),(sv(:,find_zeros(1))>=0)./(tv(:,find_zeros_2(1)) <= 0),(sv(:,find_zeros(1))<=0)./(tv(:,find_zeros_2(1)) <= 0)];
    P02 = [(sv(:,find_zeros(2))>=0)./(tv(:,find_zeros_2(4))>=0),(sv(:,find_zeros(2))<=0)./(tv(:,find_zeros_2(4)) >= 0),(sv(:,find_zeros(2))>=0)./(tv(:,find_zeros_2(4)) <= 0),(sv(:,find_zeros(2))<=0)./(tv(:,find_zeros_2(4)) <= 0)];
    P03 = 0;
elseif length(find(cont_shot_P0_00 == 1)) == 3
    P0 = [(sv(:,find_zeros(1))>=0)./(tv(:,find_zeros_2(1))>=0),(sv(:,find_zeros(1))<=0)./(tv(:,find_zeros_2(1)) >= 0),(sv(:,find_zeros(1))>=0)./(tv(:,find_zeros_2(1)) <= 0),(sv(:,find_zeros(1))<=0)./(tv(:,find_zeros_2(1)) <= 0)];
    P02 = [(sv(:,find_zeros(2))>=0)./(tv(:,find_zeros_2(4))>=0),(sv(:,find_zeros(2))<=0)./(tv(:,find_zeros_2(4)) >= 0),(sv(:,find_zeros(2))>=0)./(tv(:,find_zeros_2(4)) <= 0),(sv(:,find_zeros(2))<=0)./(tv(:,find_zeros_2(4)) <= 0)];
    P03 = [(sv(:,find_zeros(3))>=0)./(tv(:,find_zeros_2(7))>=0),(sv(:,find_zeros(3))<=0)./(tv(:,find_zeros_2(7)) >= 0),(sv(:,find_zeros(3))>=0)./(tv(:,find_zeros_2(7)) <= 0),(sv(:,find_zeros(3))<=0)./(tv(:,find_zeros_2(7)) <= 0)];
elseif length(find(cont_shot_P0_00 == 1)) == 0
    P0 = 0;
    P02 = 0;
    P03 = 0;
end

findP7 = find(cont_shot_P7_00 == 1);
findP7_2 = find(cont_tilt_P7_00 == 1);
if length(find(cont_shot_P7_00 == 1)) == 1
    PP7 = [(sv(:,findP7(1))>=0)./(tv(:,findP7_2(1))>=0),(sv(:,findP7(1))<=0)./(tv(:,findP7_2(1)) >= 0),(sv(:,findP7(1))>=0)./(tv(:,findP7_2(1)) <= 0),(sv(:,findP7(1))<=0)./(tv(:,findP7_2(1)) <= 0)];
    PP72 = 0;
elseif length(find(cont_shot_P7_00 == 1)) == 2
    PP7 = [(sv(:,findP7(1))>=0)./(tv(:,findP7_2(1))>=0),(sv(:,findP7(1))<=0)./(tv(:,findP7_2(1)) >= 0),(sv(:,findP7(1))>=0)./(tv(:,findP7_2(1)) <= 0),(sv(:,findP7(1))<=0)./(tv(:,findP7_2(1)) <= 0)];
    PP72 = [(sv(:,findP7(2))>=0)./(tv(:,findP7_2(4))>=0),(sv(:,findP7(2))<=0)./(tv(:,findP7_2(4)) >= 0),(sv(:,findP7(2))>=0)./(tv(:,findP7_2(4)) <= 0),(sv(:,findP7(2))<=0)./(tv(:,findP7_2(4)) <= 0)];
elseif length(find(cont_shot_P7_00 == 1)) == 0
    PP7 = 0;
    PP72 = 0;
end

findP75 = find(cont_shot_P7_50 == 1);
findP75_2 = find(cont_tilt_P7_50 == 1);
if length(find(cont_shot_P7_50 == 1)) == 1
    PP75 = [(sv(:,findP75(1))>=0)./(tv(:,findP75_2(1))>=0),(sv(:,findP75(1))<=0)./(tv(:,findP75_2(1)) >= 0),(sv(:,findP75(1))>=0)./(tv(:,findP75_2(1)) <= 0),(sv(:,findP75(1))<=0)./(tv(:,findP75_2(1)) <= 0)];
    PP752 = 0;
elseif length(find(cont_shot_P7_50 == 1)) == 2
    PP75 = [(sv(:,findP75(1))>=0)./(tv(:,findP75_2(1))>=0),(sv(:,findP75(1))<=0)./(tv(:,findP75_2(1)) >= 0),(sv(:,findP75(1))>=0)./(tv(:,findP75_2(1)) <= 0),(sv(:,findP75(1))<=0)./(tv(:,findP75_2(1)) <= 0)];
    PP752 = [(sv(:,findP75(2))>=0)./(tv(:,findP75_2(4))>=0),(sv(:,findP75(2))<=0)./(tv(:,findP75_2(4)) >= 0),(sv(:,findP75(2))>=0)./(tv(:,findP75_2(4)) <= 0),(sv(:,findP75(2))<=0)./(tv(:,findP75_2(4)) <= 0)];
elseif length(find(cont_shot_P7_50 == 1)) == 0
    PP75 = 0;
    PP752 = 0;
end


findP8 = find(cont_shot_P8_00 == 1);
findP8_2 = find(cont_tilt_P8_00 == 1);
if length(find(cont_shot_P8_00 == 1)) == 1
    PP8 = [(sv(:,findP8(1))>=0)./(tv(:,findP8_2(1))>=0),(sv(:,findP8(1))<=0)./(tv(:,findP8_2(1)) >= 0),(sv(:,findP8(1))>=0)./(tv(:,findP8_2(1)) <= 0),(sv(:,findP8(1))<=0)./(tv(:,findP8_2(1)) <= 0)];
    PP82 = 0;
elseif length(find(cont_shot_P8_00 == 1)) == 2
    PP8 = [(sv(:,findP8(1))>=0)./(tv(:,findP8_2(1))>=0),(sv(:,findP8(1))<=0)./(tv(:,findP8_2(1)) >= 0),(sv(:,findP8(1))>=0)./(tv(:,findP8_2(1)) <= 0),(sv(:,findP8(1))<=0)./(tv(:,findP8_2(1)) <= 0)];
    PP82 = [(sv(:,findP8(2))>=0)./(tv(:,findP8_2(4))>=0),(sv(:,findP8(2))<=0)./(tv(:,findP8_2(4)) >= 0),(sv(:,findP8(2))>=0)./(tv(:,findP8_2(4)) <= 0),(sv(:,findP8(2))<=0)./(tv(:,findP8_2(4)) <= 0)];
elseif length(find(cont_shot_P8_00 == 1)) == 0
    PP8 = 0;
    PP82 = 0;
end




end


% for i = 1:(length(tilt_6B) - 1)
%     delta_x = time(i+1) - time(i);
% 
%     % shot y 4_A
%     [delta_y_shot_4A_N7,delta_y_shot_4A_N7_2,delta_y_shot_4A_N75,delta_y_shot_4A_N75_2,delta_y_shot_4A_N8,delta_y_shot_4A_N8_2,delta_y_shot_4A_P0,...
%         delta_y_shot_4A_P0_2,delta_y_shot_4A_P0_3,delta_y_shot_4A_P7,delta_y_shot_4A_P7_2,delta_y_shot_4A_P75,delta_y_shot_4A_P75_2,delta_y_shot_4A_P8,delta_y_shot_4A_P8_2] = lengthfinder('shot_4A',i,Label,shot_4A,'tilt_4A',tilt_4A);
% 
% 
%     [DN7_4A(i),DN7_4A_2(i),DN75_4A(i),DN75_4A_2(i),DN8_4A(i),DN8_4A_2(i),DP0_4A(i),DP02_4A(i),DP03_4A(i),DP7_4A(i),DP7_4A_2(i),...
%     DP75_4A(i),DP75_4A_2(i),DP8_4A(i),DP8_4A_2(i)] = seg(delta_y_shot_4A_N7,delta_y_shot_4A_N7_2,delta_y_shot_4A_N75,delta_y_shot_4A_N75_2,delta_y_shot_4A_N8,delta_y_shot_4A_N8_2,delta_y_shot_4A_P0,...
%         delta_y_shot_4A_P0_2,delta_y_shot_4A_P0_3,delta_y_shot_4A_P7,delta_y_shot_4A_P7_2,delta_y_shot_4A_P75,delta_y_shot_4A_P75_2,delta_y_shot_4A_P8,delta_y_shot_4A_P8_2,delta_x);
% 
% 
%     % shot y 4_B
%     [delta_y_shot_4B_N7,delta_y_shot_4B_N7_2,delta_y_shot_4B_N75,delta_y_shot_4B_N75_2,delta_y_shot_4B_N8,delta_y_shot_4B_N8_2,delta_y_shot_4B_P0,...
%         delta_y_shot_4B_P0_2,delta_y_shot_4B_P0_3,delta_y_shot_4B_P7,delta_y_shot_4B_P7_2,delta_y_shot_4B_P75,delta_y_shot_4B_P75_2,delta_y_shot_4B_P8,delta_y_shot_4B_P8_2] = lengthfinder('shot_4B',i,Label,shot_4B,'tilt_4B',tilt_4B);
% 
%     [DN7_4B(i),DN7_4B_2(i),DN75_4B(i),DN75_4B_2(i),DN8_4B(i),DN8_4B_2(i),DP0_4B(i),DP02_4B(i),DP03_4B(i),DP7_4B(i),DP7_4B_2(i),...
%     DP75_4B(i),DP75_4B_2(i),DP8_4B(i),DP8_4B_2(i)] = seg(delta_y_shot_4B_N7,delta_y_shot_4B_N7_2,delta_y_shot_4B_N75,delta_y_shot_4B_N75_2,delta_y_shot_4B_N8,delta_y_shot_4B_N8_2,delta_y_shot_4B_P0,...
%         delta_y_shot_4B_P0_2,delta_y_shot_4B_P0_3,delta_y_shot_4B_P7,delta_y_shot_4B_P7_2,delta_y_shot_4B_P75,delta_y_shot_4B_P75_2,delta_y_shot_4B_P8,delta_y_shot_4B_P8_2,delta_x);
% 
% 
%     % shot y 5A
%     [delta_y_shot_5A_N7,delta_y_shot_5A_N7_2,delta_y_shot_5A_N75,delta_y_shot_5A_N75_2,delta_y_shot_5A_N8,delta_y_shot_5A_N8_2,delta_y_shot_5A_P0,...
%         delta_y_shot_5A_P0_2,delta_y_shot_5A_P0_3,delta_y_shot_5A_P7,delta_y_shot_5A_P7_2,delta_y_shot_5A_P75,delta_y_shot_5A_P75_2,delta_y_shot_5A_P8,delta_y_shot_5A_P8_2] = lengthfinder('shot_5A',i,Label,shot_5A,'tilt_5A',tilt_5A);
% 
%     [DN7_5A(i),DN7_5A_2(i),DN75_5A(i),DN75_5A_2(i),DN8_5A(i),DN8_5A_2(i),DP0_5A(i),DP02_5A(i),DP03_5A(i),DP7_5A(i),DP7_5A_2(i),...
%     DP75_5A(i),DP75_5A_2(i),DP8_5A(i),DP8_5A_2(i)] = seg(delta_y_shot_5A_N7,delta_y_shot_5A_N7_2,delta_y_shot_5A_N75,delta_y_shot_5A_N75_2,delta_y_shot_5A_N8,delta_y_shot_5A_N8_2,delta_y_shot_5A_P0,...
%         delta_y_shot_5A_P0_2,delta_y_shot_5A_P0_3,delta_y_shot_5A_P7,delta_y_shot_5A_P7_2,delta_y_shot_5A_P75,delta_y_shot_5A_P75_2,delta_y_shot_5A_P8,delta_y_shot_5A_P8_2,delta_x);
% 
%     % shot y 5B
%     [delta_y_shot_5B_N7,delta_y_shot_5B_N7_2,delta_y_shot_5B_N75,delta_y_shot_5B_N75_2,delta_y_shot_5B_N8,delta_y_shot_5B_N8_2,delta_y_shot_5B_P0,...
%         delta_y_shot_5B_P0_2,delta_y_shot_5B_P0_3,delta_y_shot_5B_P7,delta_y_shot_5B_P7_2,delta_y_shot_5B_P75,delta_y_shot_5B_P75_2,delta_y_shot_5B_P8,delta_y_shot_5B_P8_2] = lengthfinder('shot_5B',i,Label,shot_5B,'tilt_5B',tilt_5B);
% 
%    [DN7_5B(i),DN7_5B_2(i),DN75_5B(i),DN75_5B_2(i),DN8_5B(i),DN8_5B_2(i),DP0_5B(i),DP02_5B(i),DP03_5B(i),DP7_5B(i),DP7_5B_2(i),...
%     DP75_5B(i),DP75_5B_2(i),DP8_5B(i),DP8_5B_2(i)] = seg(delta_y_shot_5B_N7,delta_y_shot_5B_N7_2,delta_y_shot_5B_N75,delta_y_shot_5B_N75_2,delta_y_shot_5B_N8,delta_y_shot_5B_N8_2,delta_y_shot_5B_P0,...
%         delta_y_shot_5B_P0_2,delta_y_shot_5B_P0_3,delta_y_shot_5B_P7,delta_y_shot_5B_P7_2,delta_y_shot_5B_P75,delta_y_shot_5B_P75_2,delta_y_shot_5B_P8,delta_y_shot_5B_P8_2,delta_x); 
% 
%     % shot y 6A
%     [delta_y_shot_6A_N7,delta_y_shot_6A_N7_2,delta_y_shot_6A_N75,delta_y_shot_6A_N75_2,delta_y_shot_6A_N8,delta_y_shot_6A_N8_2,delta_y_shot_6A_P0,...
%         delta_y_shot_6A_P0_2,delta_y_shot_6A_P0_3,delta_y_shot_6A_P7,delta_y_shot_6A_P7_2,delta_y_shot_6A_P75,delta_y_shot_6A_P75_2,delta_y_shot_6A_P8,delta_y_shot_6A_P8_2] = lengthfinder('shot_6A',i,Label,shot_6A,'tilt_6A',tilt_6A);
% 
%     [DN7_6A(i),DN7_6A_2(i),DN75_6A(i),DN75_6A_2(i),DN8_6A(i),DN8_6A_2(i),DP0_6A(i),DP02_6A(i),DP03_6A(i),DP7_6A(i),DP7_6A_2(i),...
%     DP75_6A(i),DP75_6A_2(i),DP8_6A(i),DP8_6A_2(i)] = seg(delta_y_shot_6A_N7,delta_y_shot_6A_N7_2,delta_y_shot_6A_N75,delta_y_shot_6A_N75_2,delta_y_shot_6A_N8,delta_y_shot_6A_N8_2,delta_y_shot_6A_P0,...
%         delta_y_shot_6A_P0_2,delta_y_shot_6A_P0_3,delta_y_shot_6A_P7,delta_y_shot_6A_P7_2,delta_y_shot_6A_P75,delta_y_shot_6A_P75_2,delta_y_shot_6A_P8,delta_y_shot_6A_P8_2,delta_x);
% 
%     % shot y 6B
%     [delta_y_shot_6B_N7,delta_y_shot_6B_N7_2,delta_y_shot_6B_N75,delta_y_shot_6B_N75_2,delta_y_shot_6B_N8,delta_y_shot_6B_N8_2,delta_y_shot_6B_P0,...
%         delta_y_shot_6B_P0_2,delta_y_shot_6B_P0_3,delta_y_shot_6B_P7,delta_y_shot_6B_P7_2,delta_y_shot_6B_P75,delta_y_shot_6B_P75_2,delta_y_shot_6B_P8,delta_y_shot_6B_P8_2] = lengthfinder('shot_6B',i,Label,shot_6B,'tilt_6B',tilt_6B);
% 
%     [DN7_6B(i),DN7_6B_2(i),DN75_6B(i),DN75_6B_2(i),DN8_6B(i),DN8_6B_2(i),DP0_6B(i),DP02_6B(i),DP03_6B(i),DP7_6B(i),DP7_6B_2(i),...
%     DP75_6B(i),DP75_6B_2(i),DP8_6B(i),DP8_6B_2(i)] = seg(delta_y_shot_6B_N7,delta_y_shot_6B_N7_2,delta_y_shot_6B_N75,delta_y_shot_6B_N75_2,delta_y_shot_6B_N8,delta_y_shot_6B_N8_2,delta_y_shot_6B_P0,...
%         delta_y_shot_6B_P0_2,delta_y_shot_6B_P0_3,delta_y_shot_6B_P7,delta_y_shot_6B_P7_2,delta_y_shot_6B_P75,delta_y_shot_6B_P75_2,delta_y_shot_6B_P8,delta_y_shot_6B_P8_2,delta_x);
% 
% 
% 
% 
% end
% 
% [rec_4A_N7,rec_4A_N7_2,rec_4A_N75,rec_4A_N75_2,rec_4A_N8,rec_4A_N8_2,rec_4A_P0,rec_4A_P02,...
%     rec_4A_P03,rec_4A_P7,rec_4A_P7_2,rec_4A_P75,rec_4A_P75_2,rec_4A_P8,rec_4A_P8_2] = sumfunc(DN7_4A,DN7_4A_2,DN75_4A,DN75_4A_2,DN8_4A,DN8_4A_2,DP0_4A,DP02_4A,DP03_4A,DP7_4A,DP7_4A_2,...
%     DP75_4A,DP75_4A_2,DP8_4A,DP8_4A_2);
% 
% [rec_4B_N7,rec_4B_N7_2,rec_4B_N75,rec_4B_N75_2,rec_4B_N8,rec_4B_N8_2,rec_4B_P0,rec_4B_P02,...
%     rec_4B_P03,rec_4B_P7,rec_4B_P7_2,rec_4B_P75,rec_4B_P75_2,rec_4B_P8,rec_4B_P8_2] = sumfunc(DN7_4B,DN7_4B_2,DN75_4B,DN75_4B_2,DN8_4B,DN8_4B_2,DP0_4B,DP02_4B,DP03_4B,DP7_4B,DP7_4B_2,...
%     DP75_4B,DP75_4B_2,DP8_4B,DP8_4B_2);
% 
% [rec_5A_N7,rec_5A_N7_2,rec_5A_N75,rec_5A_N75_2,rec_5A_N8,rec_5A_N8_2,rec_5A_P0,rec_5A_P02,...
%     rec_5A_P03,rec_5A_P7,rec_5A_P7_2,rec_5A_P75,rec_5A_P75_2,rec_5A_P8,rec_5A_P8_2] = sumfunc(DN7_5A,DN7_5A_2,DN75_5A,DN75_5A_2,DN8_5A,DN8_5A_2,DP0_5A,DP02_5A,DP03_5A,DP7_5A,DP7_5A_2,...
%     DP75_5A,DP75_5A_2,DP8_5A,DP8_5A_2);
% 
% [rec_5B_N7,rec_5B_N7_2,rec_5B_N75,rec_5B_N75_2,rec_5B_N8,rec_5B_N8_2,rec_5B_P0,rec_5B_P02,...
%     rec_5B_P03,rec_5B_P7,rec_5B_P7_2,rec_5B_P75,rec_5B_P75_2,rec_5B_P8,rec_5B_P8_2] = sumfunc(DN7_5B,DN7_5B_2,DN75_5B,DN75_5B_2,DN8_5B,DN8_5B_2,DP0_5B,DP02_5B,DP03_5B,DP7_5B,DP7_5B_2,...
%     DP75_5B,DP75_5B_2,DP8_5B,DP8_5B_2);
% 
% [rec_6A_N7,rec_6A_N7_2,rec_6A_N75,rec_6A_N75_2,rec_6A_N8,rec_6A_N8_2,rec_6A_P0,rec_6A_P02,...
%     rec_6A_P03,rec_6A_P7,rec_6A_P7_2,rec_6A_P75,rec_6A_P75_2,rec_6A_P8,rec_6A_P8_2] = sumfunc(DN7_6A,DN7_6A_2,DN75_6A,DN75_6A_2,DN8_6A,DN8_6A_2,DP0_6A,DP02_6A,DP03_6A,DP7_6A,DP7_6A_2,...
%     DP75_6A,DP75_6A_2,DP8_6A,DP8_6A_2);
% 
% [rec_6B_N7,rec_6B_N7_2,rec_6B_N75,rec_6B_N75_2,rec_6B_N8,rec_6B_N8_2,rec_6B_P0,rec_6B_P02,...
%     rec_6B_P03,rec_6B_P7,rec_6B_P7_2,rec_6B_P75,rec_6B_P75_2,rec_6B_P8,rec_6B_P8_2] = sumfunc(DN7_6B,DN7_6B_2,DN75_6B,DN75_6B_2,DN8_6B,DN8_6B_2,DP0_6B,DP02_6B,DP03_6B,DP7_6B,DP7_6B_2,...
%     DP75_6B,DP75_6B_2,DP8_6B,DP8_6B_2);
% 
% [REC_4A_N7(sub),REC_4A_N75(sub),REC_4A_N8(sub),REC_4A_P0(sub),REC_4A_P7(sub),REC_4A_P75(sub),REC_4A_P8(sub)] = avgrec(rec_4A_N7,rec_4A_N7_2,rec_4A_N75,rec_4A_N75_2,rec_4A_N8,rec_4A_N8_2,rec_4A_P0,rec_4A_P02,...
%     rec_4A_P03,rec_4A_P7,rec_4A_P7_2,rec_4A_P75,rec_4A_P75_2,rec_4A_P8,rec_4A_P8_2);
% 
% [REC_4B_N7(sub),REC_4B_N75(sub),REC_4B_N8(sub),REC_4B_P0(sub),REC_4B_P7(sub),REC_4B_P75(sub),REC_4B_P8(sub)] = avgrec(rec_4B_N7,rec_4B_N7_2,rec_4B_N75,rec_4B_N75_2,rec_4B_N8,rec_4B_N8_2,rec_4B_P0,rec_4B_P02,...
%     rec_4B_P03,rec_4B_P7,rec_4B_P7_2,rec_4B_P75,rec_4B_P75_2,rec_4B_P8,rec_4B_P8_2);
% 
% [REC_5A_N7(sub),REC_5A_N75(sub),REC_5A_N8(sub),REC_5A_P0(sub),REC_5A_P7(sub),REC_5A_P75(sub),REC_5A_P8(sub)] = avgrec(rec_5A_N7,rec_5A_N7_2,rec_5A_N75,rec_5A_N75_2,rec_5A_N8,rec_5A_N8_2,rec_5A_P0,rec_5A_P02,...
%     rec_5A_P03,rec_5A_P7,rec_5A_P7_2,rec_5A_P75,rec_5A_P75_2,rec_5A_P8,rec_5A_P8_2);
% 
% [REC_5B_N7(sub),REC_5B_N75(sub),REC_5B_N8(sub),REC_5B_P0(sub),REC_5B_P7(sub),REC_5B_P75(sub),REC_5B_P8(sub)] = avgrec(rec_5B_N7,rec_5B_N7_2,rec_5B_N75,rec_5B_N75_2,rec_5B_N8,rec_5B_N8_2,rec_5B_P0,rec_5B_P02,...
%     rec_5B_P03,rec_5B_P7,rec_5B_P7_2,rec_5B_P75,rec_5B_P75_2,rec_5B_P8,rec_5B_P8_2);
% 
% [REC_6A_N7(sub),REC_6A_N75(sub),REC_6A_N8(sub),REC_6A_P0(sub),REC_6A_P7(sub),REC_6A_P75(sub),REC_6A_P8(sub)] = avgrec(rec_6A_N7,rec_6A_N7_2,rec_6A_N75,rec_6A_N75_2,rec_6A_N8,rec_6A_N8_2,rec_6A_P0,rec_6A_P02,...
%     rec_6A_P03,rec_6A_P7,rec_6A_P7_2,rec_6A_P75,rec_6A_P75_2,rec_6A_P8,rec_6A_P8_2);
% 
% [REC_6B_N7(sub),REC_6B_N75(sub),REC_6B_N8(sub),REC_6B_P0(sub),REC_6B_P7(sub),REC_6B_P75(sub),REC_6B_P8(sub)] = avgrec(rec_6B_N7,rec_6B_N7_2,rec_6B_N75,rec_6B_N75_2,rec_6B_N8,rec_6B_N8_2,rec_6B_P0,rec_6B_P02,...
%     rec_6B_P03,rec_6B_P7,rec_6B_P7_2,rec_6B_P75,rec_6B_P75_2,rec_6B_P8,rec_6B_P8_2);
% 
% end
% 
% REC_TOT_4A = [REC_4A_N7;REC_4A_N75;REC_4A_N8;REC_4A_P0;REC_4A_P7;REC_4A_P75;REC_4A_P8]; 
% REC_TOT_4A_avg = mean(REC_TOT_4A,2);
% 
% REC_TOT_4B = [REC_4B_N7;REC_4B_N75;REC_4B_N8;REC_4B_P0;REC_4B_P7;REC_4B_P75;REC_4B_P8]; 
% REC_TOT_4B_avg = mean(REC_TOT_4B,2);
% 
% REC_TOT_5A = [REC_5A_N7;REC_5A_N75;REC_5A_N8;REC_5A_P0;REC_5A_P7;REC_5A_P75;REC_5A_P8]; 
% REC_TOT_5A_avg = mean(REC_TOT_5A,2);
% 
% REC_TOT_5B = [REC_5B_N7;REC_5B_N75;REC_5B_N8;REC_5B_P0;REC_5B_P7;REC_5B_P75;REC_5B_P8]; 
% REC_TOT_5B_avg = mean(REC_TOT_5B,2);
% 
% REC_TOT_6A = [REC_6A_N7;REC_6A_N75;REC_6A_N8;REC_6A_P0;REC_6A_P7;REC_6A_P75;REC_6A_P8]; 
% REC_TOT_6A_avg = mean(REC_TOT_6A,2);
% 
% REC_TOT_6B = [REC_6B_N7;REC_6B_N75;REC_6B_N8;REC_6B_P0;REC_6B_P7;REC_6B_P75;REC_6B_P8]; 
% REC_TOT_6B_avg = mean(REC_TOT_6B,2);
% 
% %% Functions
% 
% function [REC_4A_N7,REC_4A_N75,REC_4A_N8,REC_4A_P0,REC_4A_P7,REC_4A_P75,REC_4A_P8] = avgrec(rec_4A_N7,rec_4A_N7_2,rec_4A_N75,rec_4A_N75_2,rec_4A_N8,rec_4A_N8_2,rec_4A_P0,rec_4A_P02,...
%     rec_4A_P03,rec_4A_P7,rec_4A_P7_2,rec_4A_P75,rec_4A_P75_2,rec_4A_P8,rec_4A_P8_2)
% if (rec_4A_N7_2 == 0) || (rec_4A_N7 == 0)
%     REC_4A_N7 = (rec_4A_N7 + rec_4A_N7_2);
% else
%     REC_4A_N7 = (rec_4A_N7 + rec_4A_N7_2)/2;
% end
% 
% if (rec_4A_N75_2 == 0) || (rec_4A_N75 == 0)
%     REC_4A_N75 = (rec_4A_N75 + rec_4A_N75_2);
% else
%     REC_4A_N75 = (rec_4A_N75 + rec_4A_N75_2)/2;
% end
% 
% if (rec_4A_N8_2 == 0) || (rec_4A_N8 == 0)
%     REC_4A_N8 = (rec_4A_N8 + rec_4A_N8_2);
% else
%     REC_4A_N8 = (rec_4A_N8 + rec_4A_N8_2)/2;
% end
% 
% if (rec_4A_P7_2 == 0) || (rec_4A_P7 == 0)
%     REC_4A_P7 = (rec_4A_P7 + rec_4A_P7_2);
% else
%     REC_4A_P7 = (rec_4A_P7 + rec_4A_P7_2)/2;
% end
% 
% if (rec_4A_P75_2 == 0) || (rec_4A_P75 == 0)
%     REC_4A_P75 = (rec_4A_P75 + rec_4A_P75_2);
% else
%     REC_4A_P75 = (rec_4A_P75 + rec_4A_P75_2)/2;
% end
% 
% if (rec_4A_P8_2 == 0) || (rec_4A_P8 == 0)
%     REC_4A_P8 = (rec_4A_P8 + rec_4A_P8_2);
% else
%     REC_4A_P8 = (rec_4A_P8 + rec_4A_P8_2)/2;
% end
% 
% if (rec_4A_P0 == 0) && (rec_4A_P02 == 0)
%     REC_4A_P0 = (rec_4A_P03);
% elseif (rec_4A_P02 == 0)&&(rec_4A_P03 == 0)
%     REC_4A_P0 = (rec_4A_P0);
% elseif (rec_4A_P0==0)&&(rec_4A_P03 == 0)
%     REC_4A_P0 = (rec_4A_P02);
% elseif (rec_4A_P0 == 0)||(rec_4A_P02 == 0) || (rec_4A_P03 == 0)
%     REC_4A_P0 = (rec_4A_P0+rec_4A_P02+rec_4A_P03)/2;
% else
%     REC_4A_P0 = (rec_4A_P0+rec_4A_P02+rec_4A_P03)/3;
% end
% 
% end
% 
% function [rec_4A_N7,rec_4A_N7_2,rec_4A_N75,rec_4A_N75_2,rec_4A_N8,rec_4A_N8_2,rec_4A_P0,rec_4A_P02,...
%     rec_4A_P03,rec_4A_P7,rec_4A_P7_2,rec_4A_P75,rec_4A_P75_2,rec_4A_P8,rec_4A_P8_2] = sumfunc(DN7,DN7_2,DN75,DN75_2,DN8,DN8_2,DP0,DP02,DP03,DP7,DP7_2,...
%     DP75,DP75_2,DP8,DP8_2)
% 
% rec_4A_N7 = sum(DN7); rec_4A_N75 = sum(DN75); rec_4A_N8 = sum(DN8); rec_4A_P0 = sum(DP0);
% rec_4A_P02 = sum(DP02); rec_4A_P7 = sum(DP7); rec_4A_P75 = sum(DP75); rec_4A_P8 = sum(DP8);
% 
% rec_4A_N7_2 = sum(DN7_2); rec_4A_N75_2 = sum(DN75_2); rec_4A_N8_2 = sum(DN8_2);
% rec_4A_P03 = sum(DP03); rec_4A_P7_2 = sum(DP7_2); rec_4A_P75_2 = sum(DP75_2); rec_4A_P8_2 = sum(DP8_2);
% end
% 
% function [DN7_4A,DN7_4A_2,DN75_4A,DN75_4A_2,DN8_4A,DN8_4A_2,DP0_4A,DP02_4A,DP03_4A,DP7_4A,DP7_4A_2,...
%     DP75_4A,DP75_4A_2,DP8_4A,DP8_4A_2] = seg(N7,N72,N75,N752,N8,N82,P0,P02,P03,P7,P72,P75,P752,P8,P82,delta_x)
%     if N72 == 0
%         DN7_4A = sqrt((delta_x^2) + (N7^2));
%         DN7_4A_2 = 0;
%     else
%         DN7_4A = sqrt((delta_x^2) + (N7^2));
%         DN7_4A_2 = sqrt((delta_x^2) + (N72^2));
%     end
% 
% 
% 
%     if N752 == 0
%         DN75_4A = sqrt((delta_x^2) + (N75^2));
%         DN75_4A_2 = 0;
%     else
%         DN75_4A = sqrt((delta_x^2) + (N75^2));
%         DN75_4A_2 = sqrt((delta_x^2) + (N752^2));
%     end
% 
%     if N82 == 0
%         DN8_4A = sqrt((delta_x^2) + (N8^2));
%         DN8_4A_2 = 0;
%     else
%         DN8_4A = sqrt((delta_x^2) + (N8^2));
%         DN8_4A_2 = sqrt((delta_x^2) + (N82^2));
%     end
% 
%     if P02 == 0 && P03 == 0
%         DP0_4A = sqrt((delta_x^2) + (P0^2));
%         DP02_4A = 0;
%         DP03_4A = 0;
%     elseif P03 == 0
%         DP0_4A = sqrt((delta_x^2) + (P0^2));
%         DP02_4A = sqrt((delta_x^2) + (P02^2));
%         DP03_4A = 0;
%     else
%         DP0_4A = sqrt((delta_x^2) + (P0^2));
%         DP02_4A = sqrt((delta_x^2) + (P02^2));
%         DP03_4A = sqrt((delta_x^2) + (P03^2));
%     end
% 
%     if P72 == 0
%         DP7_4A = sqrt((delta_x^2) + (P7^2));
%         DP7_4A_2 = 0;
%     else
%         DP7_4A = sqrt((delta_x^2) + (P7^2));
%         DP7_4A_2 = sqrt((delta_x^2) + (P72^2));
%     end
% 
%     if P752 == 0
%         DP75_4A = sqrt((delta_x^2) + (P75^2));
%         DP75_4A_2 = 0;
%     else
%         DP75_4A = sqrt((delta_x^2) + (P75^2));
%         DP75_4A_2 = sqrt((delta_x^2) + (P752^2));
%     end
% 
%     if P82 == 0
%         DP8_4A = sqrt((delta_x^2) + (P8^2));
%         DP8_4A_2 = 0;
%     else
%         DP8_4A = sqrt((delta_x^2) + (P8^2));
%         DP8_4A_2 = sqrt((delta_x^2) + (P82^2));
%     end
% 
% 
% end
% 
% % Finding the delta in y-pos:
% function [P7,P72,P75,P752,P8,P82,P0,P02,P03,PP7,PP72,PP75,PP752,PP8,PP82] = lengthfinder(shot_val,i,Label,sv,tilt_val,tv)
% 
% cont_shot_N7_00 = contains(Label.(shot_val),'N_4_00mA_7_00'); 
% cont_shot_N7_50 = contains(Label.(shot_val),'N_4_00mA_7_50');
% cont_shot_N8_00 = contains(Label.(shot_val),'N_4_00mA_8_00');
% cont_shot_P0_00 = contains(Label.(shot_val),'P_0_00mA_0_00');
% cont_shot_P7_00 = contains(Label.(shot_val),'P_4_00mA_7_00');
% cont_shot_P7_50 = contains(Label.(shot_val),'P_4_00mA_7_50');
% cont_shot_P8_00 = contains(Label.(shot_val),'P_4_00mA_8_00');
% 
% cont_tilt_N7_00 = contains(Label.(tilt_val),'N_4_00mA_7_00');
% cont_tilt_N7_50 = contains(Label.(tilt_val),'N_4_00mA_7_50');
% cont_tilt_N8_00 = contains(Label.(tilt_val),'N_4_00mA_8_00');
% cont_tilt_P0_00 = contains(Label.(tilt_val),'P_0_00mA_0_00');
% cont_tilt_P7_00 = contains(Label.(tilt_val),'P_4_00mA_7_00');
% cont_tilt_P7_50 = contains(Label.(tilt_val),'P_4_00mA_7_50');
% cont_tilt_P8_00 = contains(Label.(tilt_val),'P_4_00mA_8_00');
% 
% 
% find7_t = find(cont_tilt_N7_00 == 1);
% find7 = find(cont_shot_N7_00 == 1);
% if isempty(find7_t)
%     delta_y_shot_N7 = 0;
%     delta_y_shot_N7_2 = 0;
%     P7 = 0;
%     P72 = 0;
% else
%     fpmvali = tv(i,find7_t);
% 
%     if (fpmvali(1) >= 0) || ~any(cont_shot_N7_00)
%         if length(find(cont_shot_N7_00 == 1)) == 1
%             delta_y_shot_N7 = sv(i,cont_shot_N7_00) - tv(i,find7_t(1));
%             delta_y_shot_N7_2 = 0;
%             P7 = sv(i,cont_shot_N7_00)/tv(i,find7_t(1));
%             P72 = 0;
%         elseif length(find(cont_shot_N7_00 == 1)) == 2
%             delta_y_shot_N7 = sv(i,find7(1)) - tv(i,find7_t(1));
%             delta_y_shot_N7_2 = sv(i,find7(2)) - tv(i,find7_t(4));
%             P7 = sv(i,find7(1))/tv(i,find7_t(1));
%             P72 = sv(i,find7(2))/tv(i,find7_t(4));
%         elseif any(cont_shot_N7_00) == 0
%             delta_y_shot_N7 = 0;
%             delta_y_shot_N7_2 = 0;
%             P7 = 0;
%             P72 = 0;
%         end
%     elseif fpmvali(1) < 0
%         if length(find(cont_shot_N7_00 == 1)) == 1
%             delta_y_shot_N7 = (-1)*(sv(i,cont_shot_N7_00) - tv(i,find7_t(1)));
%             delta_y_shot_N7_2 = 0;
%             P7 = sv(i,find7(1))/tv(i,find7_t(1));
%             P72 = 0;
%         elseif length(find(cont_shot_N7_00 == 1)) == 2
%             delta_y_shot_N7 = (-1)*(sv(i,find7(1)) - tv(i,find7_t(1)));
%             delta_y_shot_N7_2 = (-1)*(sv(i,find7(2)) - tv(i,find7_t(4)));
%              P7 = sv(i,find7(1))/tv(i,find7_t(1));
%             P72 = sv(i,find7(2))/tv(i,find7_t(4));
%         elseif any(cont_shot_N7_00) == 0
%             delta_y_shot_N7 = 0;
%             delta_y_shot_N7_2 = 0;
%              P7 = 0;
%             P72 = 0;
%         end
%     end
% end
% 
% 
% 
% 
% 
% 
%     find75 = find(cont_shot_N7_50 == 1);
%     find75_2 = find(cont_tilt_N7_50 == 1);
%     if isempty(find75_2)
%         delta_y_shot_N75 = 0;
%         delta_y_shot_N75_2 = 0;
%         P75 = 0;
%         P752 = 0;
%     else
%         fpmvali75 = tv(i,find75_2(1));
%         if (fpmvali75 >= 0) || ~any(cont_shot_N7_50)
%             if length(find(cont_shot_N7_50 == 1)) == 1
%                 delta_y_shot_N75 = sv(i,cont_shot_N7_50) - tv(i,find75_2(1));
%                 delta_y_shot_N75_2 = 0;
%                 P75 = sv(i,find75(1))/tv(i,find75_2(1));
%                 P752 = 0;
%             elseif length(find(cont_shot_N7_50 == 1)) == 2
%                 delta_y_shot_N75 = sv(i,find75(1)) - tv(i,find75_2(1));
%                 delta_y_shot_N75_2 = sv(i,find75(2)) - tv(i,find75_2(4));
%                 P75 = sv(i,find75(1))/tv(i,find75_2(1));
%                 P752 = sv(i,find75(2))/tv(i,find75_2(4));
%             elseif any(cont_shot_N7_50) == 0
%                 delta_y_shot_N75 = 0;
%                 delta_y_shot_N75_2 = 0;
%             end
%         elseif (fpmvali75 < 0) 
%             if length(find(cont_shot_N7_50 == 1)) == 1
%                 delta_y_shot_N75 = (-1)*(sv(i,cont_shot_N7_50) - tv(i,find75_2(1)));
%                 delta_y_shot_N75_2 = 0;
%                 P75 = sv(i,find75(1))/tv(i,find75_2(1));
%                 P752 = 0;
%             elseif length(find(cont_shot_N7_50 == 1)) == 2
%                 delta_y_shot_N75 = (-1)*(sv(i,find75(1)) - tv(i,find75_2(1)));
%                 delta_y_shot_N75_2 = (-1)*(sv(i,find75(2)) - tv(i,find75_2(4)));
%                 P75 = sv(i,find75(1))/tv(i,find75_2(1));
%                 P752 = sv(i,find75(2))/tv(i,find75_2(4));
%             elseif any(cont_shot_N7_50) == 0
%                 delta_y_shot_N75 = 0;
%                 delta_y_shot_N75_2 = 0;
%             end
%         end
% 
%     end
% 
%     find8 = find(cont_shot_N8_00 == 1);
%     find8_2 = find(cont_tilt_N8_00 == 1);
%     if isempty(find8_2)
%         delta_y_shot_N8 = 0;
%         delta_y_shot_N8_2 = 0;
%         P8 = 0;
%         P82 = 0;
%     else
%         fpmvali8 = tv(i,find8_2(1));
%         if fpmvali8 >= 0 || ~any(cont_shot_N8_00)
%             if length(find(cont_shot_N8_00 == 1)) == 1
%                 delta_y_shot_N8 = sv(i,cont_shot_N8_00) - tv(i,find8_2(1));
%                 delta_y_shot_N8_2 = 0;
%                 P8 = sv(i,find8(1))/tv(i,find8_2(1));
%                 P82 = 0;
%             elseif length(find(cont_shot_N8_00 == 1)) == 2
%                 delta_y_shot_N8 = sv(i,find8(1)) - tv(i,find8_2(1));
%                 delta_y_shot_N8_2 = sv(i,find8(2)) - tv(i,find8_2(4));
%                 P8 = sv(i,find8(1))/tv(i,find8_2(1));
%                 P82 = sv(i,find8(2))/tv(i,find8_2(4));
%             elseif any(cont_shot_N8_00) == 0
%                 delta_y_shot_N8 = 0;
%                 delta_y_shot_N8_2 = 0;
%             end
%         elseif fpmvali8 < 0 
%             if length(find(cont_shot_N8_00 == 1)) == 1
%                 delta_y_shot_N8 = (-1)*(sv(i,cont_shot_N8_00) - tv(i,find8_2(1)));
%                 delta_y_shot_N8_2 = 0;
%                 P8 = sv(i,find8(1))/tv(i,find8_2(1));
%                 P82 = 0;
%             elseif length(find(cont_shot_N8_00 == 1)) == 2
%                 delta_y_shot_N8 = (-1)*(sv(i,find8(1)) - tv(i,find8_2(1)));
%                 delta_y_shot_N8_2 = (-1)*(sv(i,find8(2)) - tv(i,find8_2(4)));
%                 P8 = sv(i,find8(1))/tv(i,find8_2(1));
%                 P82 = sv(i,find8(2))/tv(i,find8_2(4));
%             elseif any(cont_shot_N8_00) == 0
%                 delta_y_shot_N8 = 0;
%                 delta_y_shot_N8_2 = 0;
%                 P8 = 0;
%                 P82 = 0;
%             end
%         end
% 
%     end
% 
% 
%     find_zeros = find(cont_shot_P0_00 == 1);
%     find_zeros_2 = find(cont_tilt_P0_00 == 1);
%     if isempty(find_zeros_2)
%         delta_y_shot_P0 = 0;
%         delta_y_shot_P0_2 = 0;
%         delta_y_shot_P0_3 = 0;
%         P0 = 0;
%         P02 = 0;
%         P03 = 0;
%     else
%         fpmvali0 = tv(i,find_zeros_2(1));
%         if fpmvali0 >= 0 || ~any(cont_shot_P0_00)
%             if length(find(cont_shot_P0_00 == 1)) == 1
%                 delta_y_shot_P0 = sv(i,cont_shot_P0_00) - tv(i,find_zeros_2(1));
%                 delta_y_shot_P0_2 = 0;
%                 delta_y_shot_P0_3 = 0;
%                 P0 = sv(i,find_zeros(1))/tv(i,find_zeros_2(1));
%                 P02 = 0;
%                 P03 = 0;
%             elseif length(find(cont_shot_P0_00 == 1)) == 2
%                 delta_y_shot_P0 = sv(i,find_zeros(1)) - tv(i,find_zeros_2(1));
%                 delta_y_shot_P0_2 = sv(i,find_zeros(2)) - tv(i,find_zeros_2(4));
%                 delta_y_shot_P0_3 = 0;
%                 P0 = sv(i,find_zeros(1))/tv(i,find_zeros_2(1));
%                 P02 = sv(i,find_zeros(2))/tv(i,find_zeros_2(4));
%                 P03 = 0;
%             elseif length(find(cont_shot_P0_00 == 1)) == 3
%                 delta_y_shot_P0 = sv(i,find_zeros(1)) - tv(i,find_zeros_2(1));
%                 delta_y_shot_P0_2 = sv(i,find_zeros(2)) - tv(i,find_zeros_2(4));
%                 delta_y_shot_P0_3 = sv(i,find_zeros(3)) - tv(i,find_zeros_2(7));
%                 P0 = sv(i,find_zeros(1))/tv(i,find_zeros_2(1));
%                 P02 = sv(i,find_zeros(2))/tv(i,find_zeros_2(4));
%                 P03 = sv(i,find_zeros(3))/tv(i,find_zeros_2(7));
%             elseif any(cont_shot_P0_00) == 0
%                 delta_y_shot_P0 = 0;
%                 delta_y_shot_P0_2 = 0;
%                 delta_y_shot_P0_3 = 0;
%             end
%         elseif fpmvali0 < 0
%             if length(find(cont_shot_P0_00 == 1)) == 1
%                 delta_y_shot_P0 = (-1)*(sv(i,cont_shot_P0_00) - tv(i,find_zeros_2(1)));
%                 delta_y_shot_P0_2 = 0;
%                 delta_y_shot_P0_3 = 0;
%                 P0 = sv(i,find_zeros(1))/tv(i,find_zeros_2(1));
%                 P02 = 0;
%                 P03 = 0;
%             elseif length(find(cont_shot_P0_00 == 1)) == 2
%                 delta_y_shot_P0 = (-1)*(sv(i,find_zeros(1)) - tv(i,find_zeros_2(1)));
%                 delta_y_shot_P0_2 = (-1)*(sv(i,find_zeros(2)) - tv(i,find_zeros_2(4)));
%                 delta_y_shot_P0_3 = 0;
%                 P0 = sv(i,find_zeros(1))/tv(i,find_zeros_2(1));
%                 P02 = sv(i,find_zeros(2))/tv(i,find_zeros_2(4));
%                 P03 = 0;
%             elseif length(find(cont_shot_P0_00 == 1)) == 3
%                 delta_y_shot_P0 = (-1)*(sv(i,find_zeros(1)) - tv(i,find_zeros_2(1)));
%                 delta_y_shot_P0_2 = (-1)*(sv(i,find_zeros(2)) - tv(i,find_zeros_2(4)));
%                 delta_y_shot_P0_3 = (-1)*(sv(i,find_zeros(3)) - tv(i,find_zeros_2(7)));
%                 P0 = sv(i,find_zeros(1))/tv(i,find_zeros_2(1));
%                 P02 = sv(i,find_zeros(2))/tv(i,find_zeros_2(4));
%                 P03 = sv(i,find_zeros(3))/tv(i,find_zeros_2(7));
%             elseif any(cont_shot_P0_00) == 0
%                 delta_y_shot_P0 = 0;
%                 delta_y_shot_P0_2 = 0;
%                 delta_y_shot_P0_3 = 0;
%             end
%         end
%     end
% 
%     findP7 = find(cont_shot_P7_00 == 1);
%     findP7_2 = find(cont_tilt_P7_00 == 1);
%     if isempty(findP7_2)
%         delta_y_shot_P7 = 0;
%         delta_y_shot_P7_2 = 0;
%         PP7 = 0;
%         PP72 = 0;
%     else
%         fpmvalip7 = tv(i,findP7_2(1));
%     if fpmvalip7 >= 0 || ~any(cont_shot_P7_00)
%         if length(find(cont_shot_P7_00 == 1)) == 1
%             delta_y_shot_P7 = sv(i,cont_shot_P7_00) - tv(i,findP7_2(1));
%             delta_y_shot_P7_2 = 0;
%             PP7 = sv(i,findP7(1))/tv(i,findP7_2(1));
%             PP72 = 0;
%         elseif length(find(cont_shot_P7_00 == 1)) == 2
%             delta_y_shot_P7 = sv(i,findP7(1)) - tv(i,findP7_2(1));
%             delta_y_shot_P7_2 = sv(i,findP7(2)) - tv(i,findP7_2(4));
%             PP7 = sv(i,findP7(1))/tv(i,findP7_2(1));
%             PP72 = sv(i,findP7(2))/tv(i,findP7_2(4));
%         elseif any(cont_shot_P7_00) == 0
%             delta_y_shot_P7 = 0;
%             delta_y_shot_P7_2 = 0;
%         end
%     elseif fpmvalip7 < 0
%         if length(find(cont_shot_P7_00 == 1)) == 1
%             delta_y_shot_P7 = (-1)*(sv(i,cont_shot_P7_00) - tv(i,findP7_2(1)));
%             delta_y_shot_P7_2 = 0;
%             PP7 = sv(i,findP7(1))/tv(i,findP7_2(1));
%             PP72 = 0;
%         elseif length(find(cont_shot_P7_00 == 1)) == 2
%             delta_y_shot_P7 = (-1)*(sv(i,findP7(1)) - tv(i,findP7_2(1)));
%             delta_y_shot_P7_2 = (-1)*(sv(i,findP7(2)) - tv(i,findP7_2(4)));
%             PP7 = sv(i,findP7(1))/tv(i,findP7_2(1));
%             PP72 = sv(i,findP7(2))/tv(i,findP7_2(4));
%         elseif any(cont_shot_P7_00) == 0
%             delta_y_shot_P7 = 0;
%             delta_y_shot_P7_2 = 0;
%         end
%     end
%     end
% 
% 
% 
%     findP75 = find(cont_shot_P7_50 == 1);
%     findP75_2 = find(cont_tilt_P7_50 == 1);
%     if isempty(findP75_2)
%         delta_y_shot_P75 = 0;
%         delta_y_shot_P75_2 = 0;
%         PP75 = 0;
%         PP752 = 0;
%     else
%         fpmvalip75 = tv(i,findP75_2(1));
% 
%         if fpmvalip75 >= 0 || ~any(cont_shot_P7_50)
%             if length(find(cont_shot_P7_50 == 1)) == 1
%                 delta_y_shot_P75 = sv(i,cont_shot_P7_50) - tv(i,findP75_2(1));
%                 delta_y_shot_P75_2 = 0;
%                 PP75 = sv(i,findP75(1))/tv(i,findP75_2(1));
%                 PP752 = 0;
%             elseif length(find(cont_shot_P7_50 == 1)) == 2
%                 delta_y_shot_P75 = sv(i,findP75(1)) - tv(i,findP75_2(1));
%                 delta_y_shot_P75_2 = sv(i,findP75(2)) - tv(i,findP75_2(4));
%                 PP75 = sv(i,findP75(1))/tv(i,findP75_2(1));
%                 PP752 = sv(i,findP75(2))/tv(i,findP75_2(4));
%             elseif any(cont_shot_P7_50) == 0
%                 delta_y_shot_P75 = 0;
%                 delta_y_shot_P75_2 = 0;
%             end
%         elseif fpmvalip75 < 0
%             if length(find(cont_shot_P7_50 == 1)) == 1
%                 delta_y_shot_P75 = (-1)*(sv(i,cont_shot_P7_50) - tv(i,findP75_2(1)));
%                 delta_y_shot_P75_2 = 0;
%                 PP75 = sv(i,findP75(1))/tv(i,findP75_2(1));
%                 PP752 = 0;
%             elseif length(find(cont_shot_P7_50 == 1)) == 2
%                 delta_y_shot_P75 = (-1)*(sv(i,findP75(1)) - tv(i,findP75_2(1)));
%                 delta_y_shot_P75_2 = (-1)*(sv(i,findP75(2)) - tv(i,findP75_2(4)));
%                 PP75 = sv(i,findP75(1))/tv(i,findP75_2(1));
%                 PP752 = sv(i,findP75(2))/tv(i,findP75_2(4));
%             elseif any(cont_shot_P7_50) == 0
%                 delta_y_shot_P75 = 0;
%                 delta_y_shot_P75_2 = 0;
%             end
%         end
%     end
% 
% 
%     findP8 = find(cont_shot_P8_00 == 1);
%     findP8_2 = find(cont_tilt_P8_00 == 1);
%     if isempty(findP8_2)
%         delta_y_shot_P8 = 0;
%         delta_y_shot_P8_2 = 0;
%         PP8 = 0;
%         PP82 = 0;
%     else
%         fpmvalip8 = tv(i,findP8_2(1));
%         if fpmvalip8 >= 0 || ~any(cont_shot_P8_00)
%             if length(find(cont_shot_P8_00 == 1)) == 1
%                 delta_y_shot_P8 = sv(i,cont_shot_P8_00) - tv(i,findP8_2(1));
%                 delta_y_shot_P8_2 = 0;
%                 PP8 = sv(i,findP8(1))/tv(i,findP8_2(1));
%                 PP82 = 0;
%             elseif length(find(cont_shot_P8_00 == 1)) == 2
%                 delta_y_shot_P8 = sv(i,findP8(1)) - tv(i,findP8_2(1));
%                 delta_y_shot_P8_2 = sv(i,findP8(2)) - tv(i,findP8_2(4));
%                 PP8 = sv(i,findP8(1))/tv(i,findP8_2(1));
%                 PP82 = sv(i,findP8(2))/tv(i,findP8_2(4));
%             elseif any(cont_shot_P8_00) == 0
%                 delta_y_shot_P8 = 0;
%                 delta_y_shot_P8_2 = 0;
%             end
%         elseif fpmvalip8 < 0
%             if length(find(cont_shot_P8_00 == 1)) == 1
%                 delta_y_shot_P8 = (-1)*(sv(i,cont_shot_P8_00) - tv(i,findP8_2(1)));
%                 delta_y_shot_P8_2 = 0;
%                 PP8 = sv(i,findP8(1))/tv(i,findP8_2(1));
%                 PP82 = 0;
%             elseif length(find(cont_shot_P8_00 == 1)) == 2
%                 delta_y_shot_P8 = (-1)*(sv(i,findP8(1)) - tv(i,findP8_2(1)));
%                 delta_y_shot_P8_2 = (-1)*(sv(i,findP8(2)) - tv(i,findP8_2(4)));
%                 PP8 = sv(i,findP8(1))/tv(i,findP8_2(1));
%                 PP82 = sv(i,findP8(2))/tv(i,findP8_2(4));
%             elseif any(cont_shot_P8_00) == 0
%                 delta_y_shot_P8 = 0;
%                 delta_y_shot_P8_2 = 0;
%             end
%         end
%     end
% end
% 