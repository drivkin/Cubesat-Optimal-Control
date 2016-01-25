function [ eF ] = TBEvents(primal)
%UNTITLED2 Summary of this function goes here
%   The error function consists of inital DCM, which will be 0, and the
stage = 'events'
%N = length(primal.nodes);
x = primal.states;

% qr0 = x(7:10,1);
% w0 = x(4:6,1);
% 
% qrf = x(7:10,end);
% wf = x(4:6,end);

%%%%%%%%%%%%%%

%at the beginning, everything is zero
%at the end, the velocity is zero and the angle is what you set it
%but you don't care about wheel speeds
eF = [x(:,1);
    x(end-6:end,end)];
end