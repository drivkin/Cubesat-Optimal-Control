function [ endpointCost,runningCost ] = DIDOlogexpcost( primal )
%Dido wrapper for logexp cost computation, all scaling done here
global costSF;

primal = designer2SI(primal);
v = primal.states(4:6,:);
T = primal.controls;

endpointCost = 0;
runningCost = logexpcost(v,T);
runningCost = runningCost*costSF;

end

