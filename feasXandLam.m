clear all
NCsymbolic
load('50NsolBBconst');
%%
t0 = t(1);
tf = t(end);
initXL = [primal.states(:,1);
            dual.dynamics(:,1)];

us = @(ts) [interp1(t,u(1,:),ts);
            interp1(t,u(2,:),ts);
            interp1(t,u(3,:),ts)];
        
mus = @(ts)[interp1(t,dual.controls(1,:),ts);
    interp1(t,dual.controls(2,:),ts);
    interp1(t,dual.controls(3,:),ts)];
        
system = @(ts,xls) CSFeasXL(xls,us(ts),lambdaDot,mus(ts));

[ts,xlOde45] = ode45(system,[t0 tf],initXL);
%%
close all
figure
hold on
for i = 7:10
    plot(ts,xlOde45(:,i))
    scatter(primal.nodes,primal.states(i,:));
end
    
figure 
hold all
for i = 1:5
    plot(ts,xlOde45(:,i+10));
    scatter(primal.nodes,dual.dynamics(i,:));
end
title('costate evolution based on NC and numerical costates');
    
figure
hold all
for i = 6:10
    plot(ts,xlOde45(:,i+10));
    scatter(primal.nodes,dual.dynamics(i,:));
end
title('costate evolution based on NC and numerical costates');