function [ endpointCost, runningCost ] = TBv2cost( primal )
%the running cost function is the sum of squares of velocities of each
%wheel. Not really obvious why it should be optimal, but its a nice smooth
%one.


x = primal.states;
omegaWheels = x(4:6,:);


%the running cost is the velocity of the wheels squared
 endpointCost = 0;
 
 %.01 multiplier for 3u tT scaled. For unscaled 1u use scale factor of 1
  runningCost = .01*sum(omegaWheels.^2,1); 

end