function [ endpoint_cost, running_cost ] = DIDOu2cost( primal )
%The DIDO wrapper for the u2 cost. Scaling and unscaling is done here
global costSF;
primal = designer2SI(primal);

running_cost = u2cost(primal.controls);

running_cost = running_cost*costSF;
endpoint_cost = 0;

end

