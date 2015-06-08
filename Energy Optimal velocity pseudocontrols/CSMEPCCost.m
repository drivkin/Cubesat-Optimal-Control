function [ endpointCost, runningCost ] = CSMEPCCost( primal )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
u1 = primal.controls;

u = u1(1:6,:);
v = u1(7:12,:);

%the velocity times acceleration
endpointCost = 0;

% runningCost = sum(u.*v,1);

c1 = u(1,:).*(v(1,:));
c2 = u(2,:).*(v(2,:));

c3 = u(3,:).*(v(3,:));
c4 = u(4,:).*(v(4,:));

c5 = u(5,:).*(v(5,:));
c6 = u(6,:).*(v(6,:));

%as an experiment
% c1 = v(1,:).^2;
% c2 = v(2,:).^2;
% 
% c3 = v(3,:).^2;
% c4 = v(4,:).^2;
% 
% c5 = v(5,:).^2;
% c6 = v(6,:).^2;

runningCost = c1+c2+c3+c4+c5+c6;

end
