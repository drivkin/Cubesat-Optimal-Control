function [ endpointCost, runningCost ] = CSMTCost( primal )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


t = primal.nodes;

endpointCost = t(end);
runningCost = 0;



end