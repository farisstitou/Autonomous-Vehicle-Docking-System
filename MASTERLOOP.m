%% Author: Faris Stitou

%MASTER LOOP TO RUN A THEORETICAL SCENARIO OF A SINGLE INSANCE WHERE A
%MEASUREMENT IS RECEIVED FROM THE CAMERA. THE OUTPUT IS THE SPATIAL COORDS
%OF THE LEADER AND THE ORIENTATION OF THE LEADER ITSELF.

%THIS IS ALL JUST AN IMPLEMENTATION OF THE PAPER TO SEE IF IT WORKS.
%I AM NOT SURE ABOUT A REAL SCENARIO, BUT IN THIS CASE IT SEEMS TO WORK
%VERY WELL. WE ACTUALLY SAW VERY SIMILAR RATES OF CONVERGENCE IN STMATH 405.

%-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
%**JUST FOR TESTING. THESE VALUES EMULATE THE FIRST VALUES
%**GATHERED BY WHATEVER VIEWFINDER TOOL WE ARE USING
%
%All the dummy values I used were terrible guesses so I just used AI to
%find me a reasonable guess of the what the first image might return

% true_Rs = [0; 0; 0]; %THE REAL COORDS OF THE LEADER
% true_p = [0.0; -0.00; 0]; %THE REAL ORIENTATION OF THE LEADER
% 
% [~, dummy_deltab] = MSM(true_p, true_Rs, zeros(18,1));
% bmeasure = -dummy_deltab;
% disp(bmeasure);
%_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_

%First model
%These are the unit vectors pointing from the sensor to the beacon
% bmeasure = [-0.489179101092428; -0.055240198752604; -0.87043226473757; 
%             -0.451999015786825;  0.028290821176238; -0.891569693947095;
%             -0.524915964466235;  0.026994786519815; -0.850725873445278;
%             -0.452469217124656;  0.102337195648625; -0.885888653241126;
%             -0.520606810885937; -0.049162106049818; -0.852379983216359;
%             -0.379395780951979; -0.053275543916146; -0.923699387147289];

bmeasure = get_points;
b_unit = unit(bmeasure);
b_unit = b_unit';
b_unit = b_unit(:);


%Unknowns, coordinates are filled with starting values
guess_Rs = [0; 0; 0]; %guess where the target is

%arbitrary orientation values. This is a guess
guess_p = [0; 0; 0]; %guess the rotation

W = eye(18); %THIS MUST CHANGE LATER DEPENDING ON HOW GOOD THE LEDs ARE (SEE 3.24)

%Tolerance can be lowered/highered depending on accuracy.
%This method is insanely accurate so tolerance doesn't 
%have to be high possibly saving some computation.
tolerance = 0.000000001; %for now I will make it high-tolerance
iter = 0;
max_iters = 20;

while true
    iter = iter + 1;
    
    [H, deltab] = MSM(guess_p, guess_Rs, b_unit); % Recalculate H and deltab change to bmeasure or b_unit respectively
    %disp(deltab);
    
    % deltax is the optimal differential correction that minimizes the linearized
    % residual errors. This is function 3.26 seen on p.25
    deltax = (H' * W * H) \ (H' * W * deltab); %I had to get this specific line from 

    guess_Rs = guess_Rs + deltax(1:3); % Update the guess for R values
    guess_p = guess_p + deltax(4:6); % Update the guess for p values
    
    fprintf('Iteration %d | Correction Magnitude: %f\n', iter, norm(deltax));
    % disp(guess_Rs);
    %disp(guess_p);
      

    %Use the norm as the condition which finds the largest value and then 
    %tests it against the set tolerance. This is what decides we are at a
    %good spot to break the loop and send the coordinates over
    if norm(deltax) < tolerance
        disp(guess_Rs);
        disp(guess_p); 
        break
    end

    if iter >= max_iters
        disp('Initial guess caused the sysyem to diverge.');
        break;
    end
end
