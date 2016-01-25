function [ endpointCost, runningCost ] = DIDOv2cost( primal )
%DIDO wrapper of v2 cost function, scaling happens here
global costSF;
primal = designer2SI(primal);
v = primal.states(4:6,:);
runningCost = TBv2cost(v)*costSF;
endpointCost = 0;
end

