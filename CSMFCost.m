function [ endpointCost, runningCost ] = CSMFCost( primal )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


t = primal.nodes;
u = primal.controls;
x = primal.states;

%the u^2
 endpointCost = 0;
%  runningCost = u(1,:).^2+u(2,:).^2+u(3,:).^2;

%u^2 * v^2
%runningCost = u(1,:).^2.*x(1,:).^2+u(2,:).^2.*x(2,:).^2+u(3,:).^2.*x(3,:).^2;

%v^2
%runningCost = x(1,:).^2+x(2,:).^2+x(3,:).^2;

%v^2+u^2
runningCost = x(1,:).^2+x(2,:).^2+x(3,:).^2+u(1,:).^2+u(2,:).^2+u(3,:).^2;
end

