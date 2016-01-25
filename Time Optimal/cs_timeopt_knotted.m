%cubesat time optimal control
%32 nodes but with guess from 16node solution
close all;
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

%-------------------------------------------
% Guess
%-------------------------------------------
load('25Nsol');
guess.states = x;
guess.controls = u;
guess.time = t;

algorithm.guess = guess;

%----
%knots?


%---------------------------------------
% bounds the state and control variables
%---------------------------------------
bounds.lower.states = [-100; -100; -100; -10; -10;-10; -1;-1;-1;-1];
bounds.upper.states = -bounds.lower.states;

bounds.lower.controls = [-30;-30;-30];
bounds.upper.controls = -bounds.lower.controls;

%------------------
% bound the horizon
%------------------
algorithm.knots.definitions = {'hard','soft','soft','soft','soft','soft','soft','hard'};
algorithm.knots.locations = [0 1 1.25 1.7 1.9 2.5 2.9 3.5];
algorithm.nodes = [10 10 10 10 10 10 10];	
tfMax = 5;
bounds.lower.time 	= [0];			
bounds.upper.time	= [0];

knotFlex = 0;
for i = 2:length(algorithm.knots.locations)
   bounds.lower.time(i)  = algorithm.knots.locations(i) - knotFlex;
   bounds.upper.time(i)  = algorithm.knots.locations(i) + knotFlex;
end
   bounds.lower.time(i)  = algorithm.knots.locations(i) - knotFlex;
   bounds.upper.time(i)  = algorithm.knots.locations(i) + knotFlex;

bounds.lower.time(end)  = bounds.lower.time(end)-.5;
bounds.upper.time(end) = bounds.upper.time(end)+.5;
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

				    % represents some measure of desired solution accuracy

% Call dido
tStart= cputime;    % start CPU clock 
[cost, primal, dual] = dido(CSMTprob, algorithm);
runTime = cputime-tStart
% Ta da!

%%

%plot attitude( quaternion entries)
t = primal.nodes;
x = primal.states;
u = primal.controls;
%save solution
save('70NsolKnotted');
%%
close all
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

scatter(t,u(1,:));
hold all
plot(t,u(1,:));
scatter(t,u(2,:));
plot(t,u(2,:));
scatter(t,u(3,:));
plot(t,u(3,:));
% legend('u1','u2','u3');

figure
scatter(t,ones(1,length(t)))
%hamiltonian
% figure
% plot(t,dual.Hamiltonian)
% title('Hamiltonian');



