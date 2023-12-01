%create a list of all the physical motion and GVS combinations 
% 3 prop x3 motion x2 current = 24
trial_setGVS = ["Angle", "SumofSin4", "-4", "8"; "Angle", "SumofSin4", "4", "8"; ...
    "Angle", "SumofSin5", "-4", "8"; "Angle", "SumofSin5", "4", "8"; ... 
    "Angle", "SumofSin6", "-4", "8" ; "Angle", "SumofSin6", "4", "8"; ... %Angle
    "Ang and Vel", "SumofSin4", "-4", "7.5"; "Ang and Vel", "SumofSin4", "4", "7.5"; ...
    "Ang and Vel", "SumofSin5", "-4", "7.5"; "Ang and Vel", "SumofSin5", "4", "7.5"; ... 
    "Ang and Vel", "SumofSin6", "-4", "7.5" ; "Ang and Vel", "SumofSin6", "4", "7.5";... %Ang and Vel
    "Velocity", "SumofSin4", "-4", "7"; "Velocity", "SumofSin4", "4", "7"; ...
    "Velocity", "SumofSin5", "-4", "7"; "Velocity", "SumofSin5", "4", "7"; ... 
    "Velocity", "SumofSin6", "-4", "7" ; "Velocity", "SumofSin6", "4", "7"... %Vel
    ];
% create a list of all of the sham conditions
% 3 motions X 2 R/L
trial_setSham = ["None", "SumofSin4A", "0", "0"; "None", "SumofSin4B", "0", "0"; ...
    "None", "SumofSin5A", "0", "0"; "None", "SumofSin5B", "0", "0"; ... 
    "None", "SumofSin6A", "0", "0" ; "None", "SumofSin6B", "0", "0"];

%initialize the first and second set of trials
trial_set1 = trial_setGVS;
trial_set2 = trial_set1;

%decide to pull A or B version of the physical motion for the GVS trials by
%generating a T/F vector and assigning A or B suffixes based on the T/F
%criteria - if A is used in set 1 then B is used in set 2
rand_AB =  randi([0, 1], [1, length(trial_setGVS)]);
for i = 1:length(rand_AB)
    if rand_AB(i)
        trial_set1(i,2) = strrep(strjoin([trial_setGVS(i,2), "A"]), " ", "");
        trial_set2(i,2) = strrep(strjoin([trial_setGVS(i,2), "B"]), " ", "");
    else
        trial_set1(i,2) = strrep(strjoin([trial_setGVS(i,2), "B"]), " ", "");
        trial_set2(i,2) = strrep(strjoin([trial_setGVS(i,2), "A"]), " ", "");
    end
end

%compile full set of trials (GVS and sham)
trial_set1 = [trial_set1 ; trial_setSham];
trial_set2 = [trial_set2 ; trial_setSham];

%generate random order so that the same physical motion is not run twice in
%a row ; if it fails, regenerate the order 
iter= 0;
check = 1;
while check == 1
    check = 0;
    iter = iter +1;
    %create random order and put trials in that order
    order1 = randperm(length(trial_set1))+10;
    trial_set1_order = [order1' trial_set1];
    trial_set1_export = sortrows(trial_set1_order);

    %make sure the same exact physical motion is not run twice in a row
    for i = 2:length(trial_set1_export)
        if trial_set1_export(i,3) == trial_set1_export(i-1,3) 
            check =1; 
        end
    end

    if iter >100
        break
    end
end 

iter= 0;
check = 1;
while check == 1
    check = 0;
    iter = iter +1;
    %create random order and put trials in that order
    order2 = randperm(length(trial_set2))+10;
    trial_set2_order = [order2' trial_set2];
    trial_set2_export = sortrows(trial_set2_order);
    %make sure the same exact physical motion is not run twice in a row
    for i = 2:length(trial_set2_export)
        if trial_set2_export(i,3) == trial_set2_export(i-1,3) 
            check =1; 
        end
    end

    if iter >100
        break
    end
end 

