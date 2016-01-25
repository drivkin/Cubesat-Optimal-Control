function [ fAug ] = verDynAndCostFun(xaug,u)
%Allows for integration of controls and dynamics to verify feasibility and
%also integrate cost function to verify cost
x = xaug(1:10);
dummy.states = x;
dummy.controls = u;
dummy.nodes = 1;

f = TBDynamics(dummy);

cDots = zeros(5,1);
[a cDots(1)] = absvTcost(dummy);
[a cDots(2)] = TBv2cost(dummy);
[a cDots(3)] = u2cost(dummy);
[a cDots(4)] = logexpcost(dummy);
[a cDots(5)] = trunclogexpcost(dummy);

fAug = [f;cDots];
end

