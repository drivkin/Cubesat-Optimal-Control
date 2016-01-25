function [ ts, xsim] = simulateDynamics( primal )
%Using computed control as input, simulate the dynamics of the satellite to
%evaluate feasibility

u = primal.controls;
t = primal.nodes;
x = primal.states;

t0 = t(1);
tf = t(end);

us = @(ts) [interp1(t,u(1,:),ts,'pchip');
            interp1(t,u(2,:),ts,'pchip');
            interp1(t,u(3,:),ts,'pchip')];
        
system = @(ts,xs) SatDynamics(xs,us(ts));

[ts xsim] = ode45(system,[t0 tf],x(:,1));
end

