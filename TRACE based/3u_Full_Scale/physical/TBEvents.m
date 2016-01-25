function [ eF ] = TBEvents(primal)
%UNTITLED2 Summary of this function goes here

% global scalingFactors

x = primal.states;
% x(:,1) = x(:,1).*scalingFactors(1:10);
% x(:,2) = x(:,2).*scalingFactors(1:10);


%at the beginning, everything is zero
%at the end, the velocity is zero and the angle is what you set it
%but you don't care about wheel speeds
eF = [x(:,1);
    x(1:3,end);
    x(7:10,end)];
end