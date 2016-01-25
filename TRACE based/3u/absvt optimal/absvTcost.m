function [ endpointCost, runningCost ] = absvTcost( primal )
%the running cost function is the sum of squares of velocities of each
%wheel. Not really obvious why it should be optimal, but its a nice smooth
%one.


x = primal.states;
omegaWheels = x(4:6,:);
torque = primal.controls;

stage = 'costfn'

%the running cost is the velocity of the wheels squared
 endpointCost = 0;
 a = omegaWheels.*torque;
 %b = .1*torque.^2;
 a(find(a<0)) = 0;
 runningCost = sum(a,1);

end