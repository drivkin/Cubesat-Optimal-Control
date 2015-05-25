%cubesat time optimal control
clear all;

%===================
% Problem variables:
%-------------------
% states = 
% wheel speeds (3) rad/s
% body angular velocity (3) rad/s
% attitude quaternion (4)
% 
% 
% 
% 
% controls = wheel acceleration (rad/s^2)
%===================


%---------------------------------------
% bounds the state and control variables
%---------------------------------------
bounds.lower.states = [-700; -700; -700; -50; -50;-50; -10;-10;-10;-10];
bounds.upper.states = -bounds.lower.states;

bounds.lower.controls = [-30;-30;-30];
bounds.upper.controls = -bounds.lower.controls;

%------------------
% bound the horizon
%------------------

bounds.lower.time 	= [0; 0];				
bounds.upper.time	= [0; 10];

%-------------------------------------------
% Set up the bounds on the endpoint function
%-------------------------------------------
yaw = -pi/3; 
pitch = pi/5; 
roll = pi/1;
quat = angle2quat(yaw,pitch,roll);

bounds.lower.events = [0;0;0;0;0;0;1;0;0;0; %initial wheel speed, ang vel, quaternion
    0;0;0;quat']; %final ang vel, quaternion
bounds.upper.events = bounds.lower.events; 

CSMTprob.cost = 'CSMTCost';
CSMTprob.dynamics = 'CSDynamics';
CSMTprob.events = 'CSEvents';

CSMTprob.bounds = bounds;


algorithm.nodes = [16];					    % represents some measure of desired solution accuracy

% Call dido
tStart= cputime;    % start CPU clock 
[cost, primal, dual] = dido(CSMTprob, algorithm);
runTime = cputime-tStart
% Ta da!

%%
close all
%plot attitude( quaternion entries)
t = primal.nodes;
u = primal.controls;
x = primal.states;
q = x(7:10,:);
save('16Nsol','t','u','x');

figure
plot(t,q(1,:));
hold all
plot(t,q(2,:));
plot(t,q(3,:));
plot(t,q(4,:));
legend('q1','q2','q3','q4')
title('quaternion');


%omega b_i
figure
wb = x(4:6,:);
plot(t,wb(1,:))
hold all
plot(t,wb(2,:))
plot(t,wb(3,:))
legend('x','y','z');
title('angular velocity of cubesat in body frame')


%wheel speeds
figure
ww = x(1:3,:);
plot(t,ww(1,:))
hold all
plot(t,ww(2,:))
plot(t,ww(3,:))
legend('w1','w2','w3');
title('reaction wheel speeds (rad/s')

%controls
figure

plot(t,u(1,:));
hold all
plot(t,u(2,:));
plot(t,u(3,:));
legend('u1','u2','u3');

%hamiltonian
figure
plot(t,dual.Hamiltonian)
title('Hamiltonian');



