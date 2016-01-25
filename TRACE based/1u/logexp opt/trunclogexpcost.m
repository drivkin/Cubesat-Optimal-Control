function [ endpointCost, runningCost ] = trunclogexpcost( primal )
%the running cost function is the sum of squares of velocities of each
%wheel. Not really obvious why it should be optimal, but its a nice smooth
%one.


x = primal.states;
omegaWheels = x(4:6,:);
T = primal.controls;



%the running cost is the velocity of the wheels squared
 endpointCost = 0;
 const = 10000; %use 10000 for unscaled 1 u
 a = const*omegaWheels.*T;
 b = log(exp(a)+1);
 b(find(a<=0)) = 0;
 runningCost = sum(b,1);

end