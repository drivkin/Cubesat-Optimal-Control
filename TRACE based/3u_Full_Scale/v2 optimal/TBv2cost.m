function [ cost ] = TBv2cost( v )
%the running cost function is the sum of squares of velocities of each
%wheel. Not really obvious why it should be optimal, but its a nice smooth
%one.

%the running cost is the velocity of the wheels squared 
  cost = sum(v.^2,1); 

end