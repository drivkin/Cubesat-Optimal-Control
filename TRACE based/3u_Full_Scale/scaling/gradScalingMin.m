% This script attemps to optimize the scaling factors using Fmincon
% in order to do scaling for different cost functions, just need to change
% the runner function in the scalingFitness function

clear all

problem.objective = @scalingFitness;
% problem.x0 = [1 245 1 1 1 .0007];
% problem.lb = [.1 1 .1 .1 .1 .00001];
% problem.ub = [10 300 10 10 10 .1];

primals = {};
vectors = {};
QMs = {};
save('fmincon_eval_values','primals','vectors','QMs');
% problem.x0 = [0.100000000000000,300,10,10,0.100000000000000,1.00000000000000e-05;];
% problem.lb = [.01 100 10 10 .01 1*10^-10];
% problem.ub = [1 1000 100 100 1 1*10^-3];

% problem.x0 = [0.114062500000000,296.875000000000,11.4062500000000,11.4062500000000,0.114062500000000,2.54687500000000e-05;];
% problem.lb = [0.114062500000000,296.875000000000,11.4062500000000,11.4062500000000,0.114062500000000,1.0000e-05;];
% problem.lb = [0.114062500000000,296.875000000000,11.4062500000000,11.4062500000000,0.114062500000000,1.0000e05;];

% for BC/3 wheels
problem.x0 = [0.114062500000000,296.875000000000*13.6364,11.4062500000000,11.4062500000000,0.114062500000000,1;];
problem.lb = [.001 .1  .01   .01   .01 1*10^-3];
problem.ub = [100 1000 100   100  100  1*10^3];

%[0.106805155435547,100.000007118148,66.9903227231916,100,0.999999881982803,1.11920917034151e-06;]

problem.solver = 'fmincon';
%options.Algorithm = 'sqp';
options.MaxFunEvals = 100;
options.MaxIter = 5;
options.Dispaly = 'iter-detailed';
options.UseParallel = 'true';
%options.PlotFcns = @optimplotx;
problem.options = options;
[x,fval] = fmincon(problem)
