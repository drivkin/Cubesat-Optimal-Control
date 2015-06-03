%cubesat time optimal control
clear all;

%===================
% Problem variables:
%-------------------
% states = 
% pseudo wheel speeds (2 per real wheel) rad/s
% wheel speeds (3) rad/s
% body angular velocity (3) rad/s
% attitude quaternion (4)
% 
% 
% 
% 
% controls = pseudo wheel acceleration (4 per real wheel, 2 per pseudo wheel) (rad/s^2)
%===================
makeGuess = 0;
if(makeGuess)
    load('OE64Nsoln'); 
    guess.states = x;
    guess.controls = u;
    guess.time = t;
    algorithm.guess = guess;
end


%---------------------------------------
% bounds the state and control variables
%---------------------------------------
bounds.lower.states = [0;-100;0;-100;0;-100;-100; -100; -100; -10; -10;-10; -1;-1;-1;-1];
bounds.upper.states = [100;0;100;0;100;0;100; 100; 100; 10; 10;10; 1;1;1;1];

bounds.lower.controls = [0;-30;0;-30;0;-30;0;-30;0;-30;0;-30];
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
quat = angle2quat(yaw,pitch,roll)

bounds.lower.events = [0;0;%inital pseudo wheel speeds
                       0;0;
                       0;0;
                       0;0;0;% initial wheel speed,
                       0;0;0;% initial ang vel,
                       1;0;0;0; % initial quaternion
                       0;0;0;%final ang vel,
                       quat']; % final quaternion
bounds.upper.events = bounds.lower.events; 

% path bound
bounds.lower.path = [0;0;0;0;0;0];
bounds.upper.path = bounds.lower.path;

CSMEprob.cost = 'CSMECost';
CSMEprob.dynamics = 'CSPDynamics';
CSMEprob.events = 'CSPEvents';
CSMEprob.path = 'CSPPath'; %path is for implementing control sum constraints


CSMEprob.bounds = bounds;


algorithm.nodes = [16];					    % represents some measure of desired solution accuracy

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
savename = ['OE' num2str(algorithm.nodes) 'Nsoln'];
save(savename,'t','u','x');

%%
close all
%plot attitude( quaternion entries)
t = primal.nodes;
up = primal.controls;
x = primal.states;
q = x(end-3:end,:);

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
wb = x(10:12,:);
plot(t,wb(1,:))
hold all
plot(t,wb(2,:))
plot(t,wb(3,:))
legend('x','y','z');
title('angular velocity of cubesat in body frame')


%wheel speeds
figure
ww = x(7:9,:);
plot(t,ww(1,:))
hold all
plot(t,ww(2,:))
plot(t,ww(3,:))
legend('w1','w2','w3');
title('reaction wheel speeds (rad/s')

%controls
u=[];
u(1,:) = sum(up(1:4,:),1);
u(2,:) = sum(up(5:8,:),1);
u(3,:) = sum(up(9:12,:),1);
figure
plot(t,u(1,:));
hold all
plot(t,u(2,:));
plot(t,u(3,:));
legend('u1','u2','u3');
title('controls summed');

%hamiltonian
figure
plot(t,dual.Hamiltonian)
title('Hamiltonian');

%pseudo wheels
pww1 = x(1:2,:);
pww2 = x(3:4,:);
pww3 = x(5:6,:);
figure
plot(t,pww1(1,:),'r');
hold on
plot(t,pww1(2,:),'r');
plot(t,pww2(1,:),'g');
plot(t,pww2(2,:),'g');
plot(t,pww3(1,:),'b');
plot(t,pww3(2,:),'b');
title('pseudo wheels');

%pseudo wheel controls

figure
plot(up(1,:),'b')
hold on
plot(up(2,:),'b')
plot(up(3,:),'b')
plot(up(4,:),'b')
plot(up(5,:),'g')
plot(up(6,:),'g')
plot(up(7,:),'g')
plot(up(8,:),'g')
plot(up(9,:),'r')
plot(up(10,:),'r')
plot(up(11,:),'r')
plot(up(12,:),'r')



