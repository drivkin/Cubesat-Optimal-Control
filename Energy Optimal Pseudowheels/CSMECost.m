function [ endpointCost, runningCost ] = CSMECost( primal )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


t = primal.nodes;
u = primal.controls;
x = primal.states;

%each ux contains 4 controls, positive and negative for each pseudo wheel
u1 = u(1:4,:);
u2 = u(5:8,:);
u3 = u(9:12,:);

%contains both pseudo wheels, the first is positive, the second negative
xp1 = x(1:2,:);
xp2 = x(3:4,:);
xp3 = x(5:6,:);

%the input energy is the cost
 endpointCost = 0;
 runningCost = (u1(1,:)-u1(2,:)).*xp1(1,:)+(u1(4,:)-u1(3,:)).*xp1(2,:)...
                +(u2(1,:)-u2(2,:)).*xp2(1,:)+(u2(4,:)-u2(3,:)).*xp2(2,:)...
                +(u3(1,:)-u3(2,:)).*xp3(1,:)+(u3(4,:)-u3(3,:)).*xp3(2,:);

end