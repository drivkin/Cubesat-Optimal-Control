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
load('3u_u2_tTscaled_50Nsoln');
computeConstants;



t = primal.nodes;
x = primal.states;
u = primal.controls;

t0 = t(1);
tf = t(end);

us = @(ts) [interp1(t,u(1,:),ts);
            interp1(t,u(2,:),ts);
            interp1(t,u(3,:),ts)];
        
xaugInit = [x(:,1);0;0;0;0;0]; %state augmented with values for 5 cost functions
        
system = @(ts,xaug) verDynAndCostFun(xaug,us(ts));

[ts, xAugODE45] = ode45(system,[t0 tf],xaugInit);

xAug = xAugODE45';

xprop = xAug(1:10,:);
qDIDO = x(7:10,:);
qprop = xprop(7:10,:);

C = xAug(11:15,:);

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


figure
subplot(2,2,1)
hold all;
plot(ts,C(1,:));
plot(ts,100*C(5,:));
legend('abs','exp');
title('F = |vT|');

subplot(2,2,2)
plot(ts,C(2,:))
title('F = v^2');

subplot(2,2,3)
plot(ts,C(3,:));
title('F = 10000*u^2');

subplot(2,2,4)
plot(ts,C(4,:));
hold all;
plot(ts,C(5,:));
legend('full','truncated');
title('F = log(1+exp(10000*v*T)');
