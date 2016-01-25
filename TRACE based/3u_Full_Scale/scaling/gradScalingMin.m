% This script attemps to optimize the scaling factors using Fmincon
% in order to do scaling for different cost functions, just need to change
% the runner function in the scalingFitness function

clear all

problem.objective = @scalingFitness;
% problem.x0 = [1 245 1 1 1 .0007];
% problem.lb = [.1 1 .1 .1 .1 .00001];
% problem.ub = [10 300 10 10 10 .1];


% problem.x0 = [0.100000000000000,300,10,10,0.100000000000000,1.00000000000000e-05;];
% problem.lb = [.01 100 10 10 .01 1*10^-10];
% problem.ub = [1 1000 100 100 1 1*10^-3];

problem.x0 = [0.114062500000000,296.875000000000,11.4062500000000,11.4062500000000,0.114062500000000,2.54687500000000e-05;];
problem.lb = [0.114062500000000,296.875000000000,11.4062500000000,11.4062500000000,0.114062500000000,1.0000e-05;];
problem.lb = [0.114062500000000,296.875000000000,11.4062500000000,11.4062500000000,0.114062500000000,1.0000e05;];

problem.solver = 'fmincon';
options.MaxFunEvals = 20;
options.MaxIter = 1;
%options.PlotFcns = @optimplotx;
problem.options = options;
[x,fval] = fmincon(problem)
