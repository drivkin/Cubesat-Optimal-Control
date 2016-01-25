clear all
vec = [0.100000000000000,300,10,10,0.100000000000000,1.00000000000000e-05;]
vec = [1 245 1 1 1 .0007];
vec = [0.114062500000000,296.875000000000,11.4062500000000,11.4062500000000,0.114062500000000,2.54687500000000e-05;]
%The individual is a vector of 6 scaling values
global scalingFactors
global costSF
global iterationLimit
global iteration
iteration = 0
iterationLimit = 30000;
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
    [primal,dual,cost] = runTBv2(16,-1,0);
    primal = designer2SI(primal);
    [ts,xsim] = simulateDynamics(primal);
    QM = computeQualityMetric(primal,xsim)
    % save('3u_v2_16N_baseline','primal');
catch anyException
%     anyException
%     clear all
%     %if iteration limit is reached, consider the individual very unfit
%     QM = 100;
end
%%
%close all
figure
t = squeeze(primal.nodes);
states = squeeze(primal.states);
qDIDO = states(7:10,:)
hold all
scatter(t,qDIDO(1,:));
scatter(t,qDIDO(2,:));
scatter(t,qDIDO(3,:));
scatter(t,qDIDO(4,:));
plot(ts,xsim(:,7:10))


fitness = QM;