function [primal,dual,cost, runTime] = runTBu2(n,guess,accurate)
%Runs DIDO. All global constants should be computed outside this function
% inputs:
% n = # of nodes
% guess = path of the mat file with a primal to be used as the guess, -1
% for no guess
% accurate = 1 to use accurate mode, 0 otherwise
%
%outputs:
%primal = resultant primal data structure
%dual = dual data structure
%cost = cost 
%runTIme = run time

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load guess and pass DIDO the function names
if(guess ~= -1)
    load(guess,'primal');
    primal = SI2designer(primal);
    algorithm.guess = primal;
end

if(accurate)
    algorithm.mode = 'accurate';
end

algorithm.nodes = n;

OCproblem.cost = 'DIDOu2cost';
OCproblem.dynamics = 'DIDODynamics';
OCproblem.events = 'TBEvents';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%set up bounds
%---------------------------------------
% bounds the state and control variables
%---------------------------------------
lowerOmegaBounds = [-1; -1; -1; -10; -10; -10]*65;%10 for original, 65 for BC wheels
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
%run script to scale bounds
scaleBounds
%pass bounds to problem
OCproblem.bounds = bounds;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Run DIDO
% Call dido
tStart= cputime;    % start CPU clock
[cost, primal, dual] = dido(OCproblem, algorithm);
runTime = cputime-tStart
end

