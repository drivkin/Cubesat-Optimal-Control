
NCsymbolic
% v^2 cost
load('v2OF64Nworkspace');

%tf cost
%load('50NodeTimeOptimalSolutionWorkspace');

sumMOI = [0.00152828000000000,2.11600000000000e-05,2.11600000000000e-05;
    2.11600000000000e-05,0.00152828000000000,2.11600000000000e-05;
    2.11600000000000e-05,2.11600000000000e-05,0.00152828000000000;];
sumMOIinv = [654.577898071825,-8.93927375258147,-8.93927375258147;
    -8.93927375258147,654.577898071825,-8.93927375258147;
    -8.93927375258147,-8.93927375258147,654.577898071825];
%Moments of inertia of the reaction wheels about their centers of mass
% expressed in the body frame
Iw1 = [0.000101000000000000,0,0;
    0,5.07000000000000e-05,0;
    0,0,5.07000000000000e-05;];

Iw2 = [5.07000000000000e-05,0,0;
    0,0.000101000000000000,0;
    0,0,5.07000000000000e-05;];

Iw3 = [5.07000000000000e-05,0,0;
    0,5.07000000000000e-05,0;
    0,0,0.000101000000000000;];


allSyms ={ww1,ww2,ww3,wci,q0,q1,q2,q3,...
    u1,u2,u3,lambda,mu,Isum,IsumINV,...
    Iwx,Iwy,Iwz};

for i =1:algorithm.nodes
    allNums = {x(1,i),x(2,i),x(3,i),x(4:6,i),x(7,i),x(8,i),x(9,i),x(10,i),...
        u(1,i),u(2,i),u(3,i),dual.states(:,i),dual.controls(:,i),sumMOI,sumMOIinv,...
        Iw1,Iw2,Iw3};
    HMCval(:,i) = HMC;
    i
    for j = 1:length(allNums)
        HMCval(:,i) = subs(HMCval(:,i),allSyms{j},allNums{j});
    end
% %     %trying to do it for an absolute valued cost function |av|
% %     %everything is the same as for av, but if velocity and acceleration
% %     %have opposite sign then the wheel speed used in HMC should be the
% %     %negative of the true speed
% %     uu = dual.controls(:,i);
% %     www = x(1:3,i);
% %     uuwww = uu.*www;
% %     s = sign(uuwww);
% %     www = www.*s;
% %     HMCabs(:,i) = HMC;
% %     allNums{1} = www(1);
% %     allNums{2} = www(2);
% %     allNums{3} = www(3);
% %     i
% %      for j = 1:length(allNums)
% %         HMCabs(:,i) = subs(HMCabs(:,i),allSyms{j},allNums{j});
% %      end
end
HMCval = double(HMCval);

% %only for the silly absolute value stuff
% HMCval = double(HMCabs);


%%
figure
plot(t,HMCval(1,:));
hold all
plot(t,HMCval(2,:));
plot(t,HMCval(3,:));
legend('dH/du1','dH/du2','dH/du3');
title('Hamiltonian Minimization Condition');

