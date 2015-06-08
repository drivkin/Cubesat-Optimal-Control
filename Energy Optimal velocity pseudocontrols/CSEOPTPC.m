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
% controls = wheel acceleration (rad/s^2) (6, 2 per wheel (positive and
% negative))
% velocity pseudocontrols  (6, 2 for each wheel)
%===================
makeGuess = 1;
if(makeGuess)
    load('OEPC30Nsoln'); 
    guess.states = x;
    guess.controls = u;
    guess.time = t;
    algorithm.guess = guess;
end


%---------------------------------------
% bounds the state and control variables
%---------------------------------------
bounds.lower.states = [-100; -100; -100; -10; -10;-10; -1;-1;-1;-1];
bounds.upper.states = -bounds.lower.states;

bounds.lower.controls = [0;-30;0;-30;0;-30;0;-30;0;-30;0;-30]; % first six are actual controls, the next six are the velocity pseudo
bounds.upper.controls = [30;0;30;0;30;0;30;0;30;0;30;0];

%------------------
% bound the horizon
%------------------

bounds.lower.time 	= [0; 10];				
bounds.upper.time	= [0; 10]; %tf must be no greater than 10

%-------------------------------------------
% Set up the bounds on the endpoint function
%-------------------------------------------
yaw = -pi/3; 
pitch = pi/5; 
roll = pi/1;
quat = angle2quat(yaw,pitch,roll);

bounds.lower.events = [0;0;0;0;0;0;1;0;0;0; %initial wheel speed, ang vel, quaternion
    0;0;0;0;0;0;quat']; %final wheel speed, ang vel, quaternion
bounds.upper.events = bounds.lower.events; 

%path constraints
bounds.lower.path = [0;0;0;0;0;0;0;0;0];
bounds.upper.path = bounds.lower.path;


CSMEprob.cost = 'CSMEPCCost';
CSMEprob.dynamics = 'CSMEPCDynamics';
CSMEprob.events = 'CSPCEvents';
CSMEprob.path = 'CSMEPCPath';

CSMEprob.bounds = bounds;

%algorithm.mode = 'accurate'; 

algorithm.nodes = [30];					    % represents some measure of desired solution accuracy

% Call dido
tStart= cputime;    % start CPU clock 
[cost, primal, dual] = dido(CSMEprob, algorithm);
runTime = cputime-tStart
% Ta da!
y = sin(linspace(0,800*pi,8192*2));
sound(y)
%%
%save solution
%plot attitude( quaternion entries)
t = primal.nodes;
x = primal.states;
u = primal.controls;
savename = ['OEPCuv' num2str(algorithm.nodes) 'Nsoln'];
save(savename,'t','u','x');

%%
close all
%plot attitude( quaternion entries)
t = primal.nodes;
u = primal.controls;
x = primal.states;
q = x(7:10,:);

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
plot(t,u(1,:)+u(2,:),'b');
hold on;
plot(t,u(3,:)+u(4,:),'g');
plot(t,u(5,:)+u(6,:),'r');
title('controls');

%hamiltonian
figure
plot(t,dual.Hamiltonian)
title('Hamiltonian');

%pseudo controls
figure
plot(t,u(7,:),'b');
hold on;
plot(t,u(8,:),'b');
plot(t,u(9,:),'g');
plot(t,u(10,:),'g');
plot(t,u(11,:),'r');
plot(t,u(12,:),'r');
title('pseudo-controls');



