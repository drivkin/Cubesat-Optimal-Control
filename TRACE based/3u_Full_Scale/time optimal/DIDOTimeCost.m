function [endpoint_cost, running_cost] = DIDOTimeCost( primal )
%DIDO wrapper for time cost function, but because it's so damn simple we'll
%just compute the cost here (plus you don't need to integrate it to verify
%it)
global costSF;
primal = designer2SI(primal);
endpoint_cost = primal.nodes(end);
endpoint_cost = endpoint_cost * costSF;

running_cost = zeros(size(primal.nodes));

end

