global costSF;
global scalingFactors;

costSF = 1;
scalingFactors = [1; % body rate x
    1; % body rate y
    1; % body rate z
    1; % wheel rate x
    1; % wheel rate y
    1; % wheel rate z
    1; % q0
    1; % q1
    1; % q2
    1; % q3
    1; % u x
    1; % u y
    1; % u z
    1]; % time
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%messin with the 1u
%Lessons learned:

%increased SF on controls seems to help with feasibility (
%at least getting the wheel speeds near zero at the end)

%scaling quaternions so that all endpoints are either + or - 1 doesn't seem
%to have much effect 

%increasing time sf to 30 seems to make solution worse, as does setting it
%to 1/30th

%scaling the the z axis wheel by a factor of 10 seems to increase run time

%scaling all the wheels by 10 seems to have no effect

%scaling all the wheels by 100 breaks it

%scaling all wheels by .1 seems to increase run time

%scaling all wheels by .01 breaks it, makes reaction wheels not hit zero at
%end

%controls dual is equally bad for all wheels: .1 and all wheels .01. Trying
%to figure out the difference between these two

%Increasing MOI by factor of 10 keeping all scaling factors zero messes it
%up

%Dividing the 3u moi by a factor of 10 improves things significantly.
%However, diving by a factor of 100 seems to break it again, so it seems as
%if there's some optimal balance between the MOI of the satellite and that
%of the momentum wheel. Can we approach this balance by using the scaling
%factors? Should be able to I think, maybe.

%compensating for a 10x increase in MOI with a .1 factor on the body rate
%didn't fix the problem

%compensation and increasing time (real time, not time scaling factor) by a
%factor of 10 did seem to help, but wihtout the compensation with the .1 on
%the body rate it gave SOL error

%with tf = 30 again tried increasing control authority by a factor of 10,
%solution improved, it's similar to time = 300 with body rate sf of .1.
%Adding the sf of .1, seems to make to difference.

%changing cost and scaling factors doesn't seem to do anything except
%potentially reduce the time to a (shitty) solution

%Amazingly, increasing both reaction wheel I and control authority by a
%factor of 10 does not bring back the good, original solutions. WTF?!?!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


costSF = 1;
scalingFactors = [1; % body rate x
    1; % body rate y
    1; % body rate z
    1;%0.00152828000000000/0.000101000000000000; % wheel rate x
    1;%0.00152828000000000/0.000101000000000000; % wheel rate y
    1;%0.00152828000000000/0.000101000000000000; % wheel rate z
    1;
    1;
    1;
    1;
    1; % u x
    1; % u y
    1; % u z
    1]; % time

% scalingFactors = [   0.3776;
%     0.3120;
%     0.2401;
%     92.1151;
%     75.9024;
%     42.2163;
%     0.1624;
%     0.1531;
%     0.1651;
%     0.1897;
%     0.0408;
%     0.0527;
%     0.0624;
%     1.0000];
% 
a = 1
b = 10
c = 1
d = .01
t = 1
scalingFactors = [ a;
    a;
    a;
    0.0247818266666667/0.000101000000000000;
    0.0247818266666667/0.000101000000000000;
    0.00486182666666667/0.000101000000000000;
    0.1545;
    0.8236;
    0.4755;
    0.2676;
    d;
    d;
    d;
    t] * 1;
costSF = .0001*7;
% % 
% costSF = .005;
% scalingFactors = [1; % body rate x
%     1; % body rate y
%     1; % body rate z
%     1; % wheel rate x
%     1; % wheel rate y
%     1; % wheel rate z
%     1; % q0
%     1; % q1
%     1; % q2
%     1; % q3
%     70; % u x
%     70; % u y
%     70; % u z
%     1]; % time

% load('nextFactors');
% costSF = nextCostSF;
% scalingFactors = nextScaleFactors;
