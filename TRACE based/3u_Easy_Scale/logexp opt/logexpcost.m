function [ endpointCost, runningCost ] = logexpcost( primal )
%the running cost function is the sum of squares of velocities of each
%wheel. Not really obvious why it should be optimal, but its a nice smooth
%one.


x = primal.states;
omegaWheels = x(4:6,:);
T = primal.controls;



%the running cost is the velocity of the wheels squared
 endpointCost = 0;
 %const = 10000; %use 10000 for unscaled 1 u
 const = 20;
 a = const*omegaWheels.*T;
 runningCost = (1/20)*sum(log(exp(a)+1),1)

end