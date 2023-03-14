% use the find function to identify all cells with the word roll then with
% the word pitch - this function can return the locations of those cells
% and from that I can create a map of the trials where roll, pitch, yaw
% (and/or a combo) are reported - I would want my indices to be current
% level and montage/configuration with configuration being more important
% than current level. 
% And then for part two the profile type may be of more
% interest than the current level (or maybe only express current level as a
% function of the participant normalized min max low ) I definitely want to
% create a map using the rhythmic/ intermitent/ continous and map those to
% the profile types, configurations (and maybe current levles? - 4
% dimensions might be too many to affectively visualize, but could just
% organize it that way and then pull the data out into separate more
% digestable plots. Also is probably important to plot tilt v. translation
% and general instability, but that is more nuanced and I think can wait
% until after HRP. I would also prioritize the MotionSense (subject
% reported) over the Observed, but the code for those will be pretty much
% identical - except I only use right/left or forward/back descriptors
% rather than roll/pitch, but it's the same idea with the find function,
% just substituting the words it's looking for - the indexing/ matrix of
% independent variables plotted against eachother should be the same.
% Subject reported is prioritized over observed because I want to be able
% to look at the IMU data a little too if possible. 