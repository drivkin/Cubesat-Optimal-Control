function [ endpoint_cost, running_cost ] = DIDO_master_power( primal )
%The DIDO function that wraps around the master_power function, does
%scaling, etc

global costSF; %scaling factor for cost
global powerFactors; % the factors necessary to compute the power

endpoint_cost = 0;

primal = designer2SI(primal);

u = primal.controls; %control torques
v = primal.states(4:6,:);%wheel speed

running_cost = master_power(u,v,powerFactors(1),powerFactors(2),powerFactors(3));

running_cost = running_cost*costSF;

end

