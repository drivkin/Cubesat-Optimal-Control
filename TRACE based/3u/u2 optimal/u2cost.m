function [ endpointCost, runningCost ] = u2cost( primal )
%the running cost function is the sum of squares of velocities of each
%wheel. Not really obvious why it should be optimal, but its a nice smooth
%one.



T = primal.controls;



%the running cost is the velocity of the wheels squared
 endpointCost = 0;
 %runningCost = 10000*sum(T.^2,1); for 1u
 runningCost = .1*sum(T.^2,1); %3u scaled

end