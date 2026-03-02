%% Author: Faris Stitou

%Create the measurement sensitivity matrix seen in 3.19

%I think this is the main loop so I might not even need have p, Ri and Rs as
%inputs but rather I can hardcode them all in

%I hardcoded in Ri and I think I might aswell hardcode in p and Ri but I
%also added in the residual estimate error as seen in function 3.15

function [H, deltab] = MSM(p, Rs, bmeasure)

    %--------------------Ri-------------------------
    %Known coordinates wrt the target frame

    % Ri = [
    %       %Depth of 0.5m from the target
    %       0.000, -0.346, 0.5; % Beacon 1 (Bottom Tip)
    %       0.300, 0.173, 0.5; % Beacon 2 (Top Right)
    %       -0.300, 0.173, 0.5; % Beacon 3 (Top Left)
    % 
    %       %Depth of 1m from the target
    %       0.000, 0.693, 1.0; % Beacon 4 (Top Tip)
    %       -0.600, -0.346, 1.0; % Beacon 5 (Bottom Left)
    %       0.600, -0.346, 1.0]; % Beacon 6 (Bottom Right)
    %----------------------------------------------------------
    %We made a slight error in the beacon placements. The direction is from
    %the target to the beacon
    % Ri = [
    %       %closer beacons
    %       0.000, -0.346, -0.452; % Beacon 1 (Bottom Tip)
    %       0.300, 0.173, -0.452; % Beacon 2 (Top Right)
    %       -0.300, 0.173, -0.452; % Beacon 3 (Top Left)
    % 
    %       %further beacons
    %       0.000, 0.693, -0.999; % Beacon 4 (Top Tip)
    %       -0.600, -0.346, -0.999; % Beacon 5 (Bottom Left)
    %       0.600, -0.346, -0.999]; % Beacon 6 (Bottom Right)

    %----------------------------------------------------------
    Ri = [1.000,  0.0000000, -0.500; % Beacon 1 (Bottom Tip)
          1.000, -0.4330127,  0.250; % Beacon 2 (Top Right)
          1.000,  0.4330127,  0.250; % Beacon 3 (Top Left)

          %further beacons
          2.000,  0.0000000,  1.000; % Beacon 4 (Top Tip)
          2.000,  0.8660254, -0.500; % Beacon 5 (Bottom Left)
          2.000, -0.8660254, -0.500]; % Beacon 6 (Bottom Right)

    %--------------------Code for building H and Delta_b------------------
    H = [];
    bguess_all = [];
    
    N = 6; %Number of beacons
    C = DCM(p);
    
    format long
    %create the measurement sensitivity matrix, H, seen in 3.19
    for i = 1:N
        beacon_Ri = Ri(i, :)';
        [Bi, bguess] = Bibguess(p, Rs, beacon_Ri);

        hiRs = pos_partial(Bi, C, Rs, beacon_Ri);
        hip = orient_partial(bguess, p);
        
        H = [H; hiRs, hip];
        
        %3.15
        bguess_all = [bguess_all; bguess]; 
        %disp(H); %comment/uncomment for testing purposes
    end
    
    %Finish up 3.15
    deltab = bmeasure - bguess_all;
end