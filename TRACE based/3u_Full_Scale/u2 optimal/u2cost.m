function [ cost ] = u2cost(u)
 
 %this constant is Ra/kt^2, allows this cost function to reflect the amount
 %of power dissipated by the armature resistance
 c = 8.6078e+04; 
 cost = c*sum(u.^2);
end