function [ endpointCost, runningCost ] = trunclogexpcost( primal )
%the running cost function is the sum of squares of velocities of each
%wheel. Not really obvious why it should be optimal, but its a nice smooth
%one.


x = primal.states;
omegaWheels = x(4:6,:);
T = primal.controls;

 alpha_max = 1000;

%the running cost is the velocity of the wheels squared
 endpointCost = 0;
 %const = 10000; %use 10000 for unscaled 1 u
 const = 1;
 a = omegaWheels.*T;
 b = smartLogExp(a,alpha_max);
 b(find(a<=0)) = 0;
 runningCost = sum(b);

end