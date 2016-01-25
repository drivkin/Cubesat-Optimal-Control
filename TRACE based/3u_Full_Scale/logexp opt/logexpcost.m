function [cost] = logexpcost( v,T )
%the running cost function is the sum of squares of velocities of each
%wheel. Not really obvious why it should be optimal, but its a nice smooth
%one.

 alpha_max = 1000;
 P = v.*T;
 cost = sum(smartLogExp(P,alpha_max));

end