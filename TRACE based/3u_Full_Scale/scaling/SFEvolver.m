clear all

gaProblem.fitnessfcn = @scalingFitness;
gaProblem.nvars = 6;
gaProblem.lb = [.1 1 .1 .1 .1 .00001];
gaProblem.ub = [10 300 10 10 10 .1];
options.Generations = 2;
options.PopulationSize = 5;
gaProblem.options = options;
[x,fval] = ga(gaProblem)

% global scalingFactors
% global costSF
% global iterationLimit
% 
% iterationLimit = 20000;
% a = 1
% b = 10
% c = 1
% d = 1
% t = 1
% scalingFactors = [ a;
%     a;
%     a;
%     0.0247818266666667/0.000101000000000000;
%     0.0247818266666667/0.000101000000000000;
%     0.00486182666666667/0.000101000000000000;
%     0.1545;
%     0.8236;
%     0.4755;
%     0.2676;
%     d;
%     d;
%     d;
%     t] * 1;
% costSF = .0001*7;
% 
% computeConstants;
% 
% %running with d = 1, no guess: QM .1832
% %with d = 1, guess with d = .1868
% %20 node d = 1, with d = .01 guess: .1771
% % without guess: .1730
% 
% % try
%    % '3u_v2_16N_baseline'
%     [primal,dual,cost] = runTBv2(16,-1,0);
%     primal = designer2SI(primal);
%     [ts,xsim] = simulateDynamics(primal);
%     QM = computeQualityMetric(primal,xsim)
%    % save('3u_v2_16N_baseline','primal');
% % catch anyException
% %     'too many iterations'
% % end