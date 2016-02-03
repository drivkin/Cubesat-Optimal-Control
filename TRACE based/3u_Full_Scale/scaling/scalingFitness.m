function [ fitness ] = scalingFitness( vec )
clearvars -except vec

%The individual is a vector of 6 scaling values
global scalingFactors
global costSF
global iterationLimit
global iteration
iteration = 0
iterationLimit = 20000;
scalingFactors = [ vec(1)
    vec(1)
    vec(1)
    vec(2);
    vec(2);
    vec(2);
    vec(3);
    vec(3);
    vec(3);
    vec(3);
    vec(4);
    vec(4);
    vec(4);
    vec(5)] * 1;
costSF = vec(6);

computeConstants;
load('fmincon_eval_values');
try
%     [primal,dual,cost] = runTBv2(16,-1,0);
    %[primal,dual,cost] = run_master_power(16,-1,0);
    [primal,dual,cost] = runTBu2(16,-1,0);
    primal = designer2SI(primal);
%     [ts,xsim] = simulateDynamics(primal);
%     QM = computeQualityMetric(primal,xsim);
%     QM=QM
    QM = compareControls(primal,'3u_u2_50N_soln');
    primals = [primals primal];
    vectors = [vectors vec];
    QMs = [QMs QM];
    save('fmincon_eval_values','primals','vectors','QMs');
    plot(primal.nodes,primal.controls)
    shg
    %this is because the results given by scalingFitness when called by
    %fmincon seem to be different that when it is called on its own
    clear all
    load('fmincon_eval_values');
    QM = QMs{end}
    % save('3u_v2_16N_baseline','primal');
catch anyException
    anyException
    primals = [primals 'iteration limit reached'];
    vectors = [vectors vec];
    QMs = [QMs 10000000000000000000000000000];
    save('fmincon_eval_values','primals','vectors','QMs');
    clear all
    %if iteration limit is reached, consider the individual very unfit
    QM = 10000000000000000000000000000;
end


fitness = QM;


end

