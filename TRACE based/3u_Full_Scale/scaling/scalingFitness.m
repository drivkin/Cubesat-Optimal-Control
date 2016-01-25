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
try
    %[primal,dual,cost] = runTBv2(16,-1,0);
    [primal,dual,cost] = runTBuv(16,-1,0);
    primal = designer2SI(primal);
    [ts,xsim] = simulateDynamics(primal);
    QM = computeQualityMetric(primal,xsim)
    % save('3u_v2_16N_baseline','primal');
catch anyException
    anyException
    clear all
    %if iteration limit is reached, consider the individual very unfit
    QM = 100;
end

fitness = QM;


end

