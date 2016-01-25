function [ primal,dual,cost,runTime ] = run_master_power(n,guess,accurate )
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
global powerFactors
%compute power factors from motor parameters
R_a = 28.2; %motor armature resistance (Ohms)
k_t = .0181;  %motor torque constant (N*m/amp)
k_e = .0181; %motor electrical constant (V*s/rad)
mu_f = 1.35*10^-8 / .104719755;%dynamic friction constant

u2_factor = R_a/(k_t^2);
uv_factor = 2*R_a*mu_f*k_e/k_t + k_e/k_t;
v2_factor = R_a*mu_f^2*k_e^2 + k_e^2*mu_f;

powerFactors(1) = u2_factor;
powerFactors(2) = uv_factor;
powerFactors(3) = v2_factor;

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

OCproblem.cost = 'DIDO_master_power';
OCproblem.dynamics = 'DIDODynamics';
OCproblem.events = 'TBEvents';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%set up bounds
%---------------------------------------
% bounds the state and control variables
%---------------------------------------
lowerOmegaBounds = [-1; -1; -1; -10; -10; -10]*65; %use 10 for original, 65 for bct wheels
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


