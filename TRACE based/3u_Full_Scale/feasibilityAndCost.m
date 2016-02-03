%this script verifies the feasibility of a DIDO solution, plus it evaluates
%the cost with respect to four different running cost functions:
%1. |vT|
%2. v^2
%3. 10000*T^2
%4. log(1*exp(alpha*v*T)) where alpha = 10000
%5. same as 4 but set to zero whenever alpha*v*T < 0

clear all;
close all;
%load the desired solution workspace
global scalingFactors
global costSF


% vec = [0.114062500000000,296.875000000000,11.4062500000000,11.4062500000000,0.114062500000000,2.54687500000000e-05;];
% 
% 
% scalingFactors = [ vec(1)
%     vec(1)
%     vec(1)
%     vec(2);
%     vec(2);
%     vec(2);
%     vec(3);
%     vec(3);
%     vec(3);
%     vec(3);
%     vec(4);
%     vec(4);
%     vec(4);
%     vec(5)] * 1;

load('3u_u2_50N_soln_BC');

costSF = 1;
%primal = designer2SI(primal)
computeConstants;

%primal = designer2SI(primal);
u = primal.controls;
t = primal.nodes;
x = primal.states;


t0 = t(1);
tf = t(end);

us = @(ts) [interp1(t,u(1,:),ts,'pchip');
    interp1(t,u(2,:),ts,'pchip');
    interp1(t,u(3,:),ts,'pchip')];

xaugInit = [x(:,1);0;0;0;0;0;0;0]; %state augmented with values for 7 cost functions

system = @(ts,xaug) verDynAndCostFun(xaug,us(ts));

[ts, xAugODE45] = ode45(system,[t0 tf],xaugInit);

xAug = xAugODE45';

xprop = xAug(1:10,:);
qDIDO = x(7:10,:);
qprop = xprop(7:10,:);

C = xAug(11:17,:);

figure
hold all
plot(ts,qprop(1,:));
plot(ts,qprop(2,:));
plot(ts,qprop(3,:));
plot(ts,qprop(4,:));
scatter(t,qDIDO(1,:));
scatter(t,qDIDO(2,:));
scatter(t,qDIDO(3,:));
scatter(t,qDIDO(4,:));
legend('q1','q2','q3','q4')


% [a cDots(1)] = absvTcost(dummy);
% [a cDots(2)] = TBv2cost(dummy);
% [a cDots(3)] = u2cost(dummy);
% [a cDots(4)] = logexpcost(dummy);
% [a cDots(5)] = trunclogexpcost(dummy);

figure
subplot(2,2,1)
hold all;
plot(ts,C(1,:));
plot(ts,C(5,:));
legend('abs','exp');
title('F = |vT|');

subplot(2,2,2)
plot(ts,C(2,:))
title('F = v^2');

subplot(2,2,3)
plot(ts,C(3,:));
title('F = u^2');

subplot(2,2,4)
plot(ts,C(4,:));
hold all;
plot(ts,C(5,:));
legend('full','truncated');
title('F = log(1+exp(v*T)');

figure
plot(ts,C(6,:));
hold all
plot(ts,C(7,:));
title('master energy');
legend('log-exp-approx','true-truncated');
