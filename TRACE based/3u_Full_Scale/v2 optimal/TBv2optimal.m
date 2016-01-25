% run F = v^2 cost function using dyamics as described in trace paper


close all;
clear all;
%===================
% Problem variables:
%-------------------
% states =
% body angular velocity (3) rad/s
% wheels speeds (3) rad/s
% attitude quaternion (4)
%
%
%
%
% controls = wheel torque (rad/s^2)
%===================
% for k = 40:10:70
    close all
    clearvars -except k
    %-------------------------------------------
    % Guess
    %-------------------------------------------
    %
    load(['3u_TBv2_FullScale_50Nsoln']);
    algorithm.guess = primal;
   algorithm.mode = 'accurate';
    clearvars -except algorithm k;
%     
    %----
    %knots?
    
    %
    % %---------------------------------------
    % % bounds the state and control variables
    % %---------------------------------------
    % bounds.lower.states = [-1; -1; -1; -10; -10;-10; -1;-1;-1;-1];
    % bounds.upper.states = -bounds.lower.states;
    %
    % bounds.lower.controls = [-.003;-.003;-.003];
    % bounds.upper.controls = -bounds.lower.controls;
    %
    % %------------------
    % % fixed time
    % %------------------
    %
    % bounds.lower.time 	= [0; 10];
    % bounds.upper.time	= [0; 10];
    
    %set scale factors
    setScalingFactors;
    
    %messin around with designer units
    %---------------------------------------
    % bounds the state and control variables
    %---------------------------------------
    lowerOmegaBounds = [-1; -1; -1; -10; -10; -10]*10;
    bounds.lower.states = [lowerOmegaBounds; -1;-1;-1;-1];
    bounds.upper.states = -bounds.lower.states;
    
    bounds.lower.controls = [-.003;-.003;-.003];
    bounds.upper.controls = -bounds.lower.controls;
    
    %------------------
    % fixed time
    %------------------
    
    bounds.lower.time 	= [0; 30];
    bounds.upper.time	= [0; 30];
    
    %-------------------------------------------
    % Set up the bounds on the endpoint function
    %-------------------------------------------
    yaw = -pi/3;
    pitch = pi/5;
    roll = pi/1;
    quat = 1*angle2quat(yaw,pitch,roll);
    
    bounds.lower.events = [0;0;0;0;0;0;1;0;0;0; %initial wheel speed, ang vel, quaternion
        0;0;0;quat']; %final ang vel, quaternion
    bounds.upper.events = bounds.lower.events;
    
    %run script that converts all the bounds to designer units
    scaleBounds;
    
    %run the script that generates constants
    computeConstants;
    
    TBv2prob.cost = 'TBv2cost';
    TBv2prob.dynamics = 'DIDODynamics';
    TBv2prob.events = 'TBEvents';
    
    TBv2prob.bounds = bounds;
    
    algorithm.nodes = 50  % represents some measure of desired solution accuracy
    
 
    
    
    % Call dido
    tStart= cputime;    % start CPU clock
    [cost, primal, dual] = dido(TBv2prob, algorithm);
    runTime = cputime-tStart
    % Ta da!
    
    %save workspace
    save(['3u_TBv2_FullScale_' num2str(algorithm.nodes) 'Nsoln_accurate']);
    
% end

%% compute the scaling factors for the next iteration
nextScalingFactors;

%%
close all
%primal = designer2SI(primal);
% %plot attitude( quaternion entries)
t = primal.nodes;
x = primal.states;
u = primal.controls;
q = x(7:10,:);

figure
plot(t,q(1,:));
hold all
plot(t,q(2,:));
plot(t,q(3,:));
plot(t,q(4,:));
legend('q1','q2','q3','q4')
title('quaternion');
%
%
%omega b_i
figure
wb = x(1:3,:);
plot(t,wb(1,:))
hold all
plot(t,wb(2,:))
plot(t,wb(3,:))
legend('x','y','z');
title('angular velocity of cubesat in body frame')
%
%
% %wheel speeds
figure
ww = x(4:6,:);
plot(t,ww(1,:))
hold all
plot(t,ww(2,:))
plot(t,ww(3,:))
legend('w1','w2','w3');
title('reaction wheel speeds (rad/s')
%
% %controls
figure

plot(t,u(1,:));
hold all
plot(t,u(2,:));
plot(t,u(3,:));
legend('u1','u2','u3');
%
%hamiltonian
figure
plot(t,dual.Hamiltonian)
title('Hamiltonian');

%costates
figure
plot(t,dual.dynamics(1:6,:)')
title('costates for omegas')
legend('wb1','wb2','wb3','ww1','ww2','ww3')

figure
plot(t,dual.dynamics(7:10,:)')
title('costates for q');
legend('q0','q1','q2','q3')
%
%
%