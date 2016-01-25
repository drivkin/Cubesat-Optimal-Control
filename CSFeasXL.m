function [ xldot ] = CSFeasXL(xls,u,ld,mu_num)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
persistent count
if(isempty(count))
    count = 1
else
    count = count +1
end
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


x = xls(1:10);
lam = xls(11:end);

ww1 = sym('ww1');
ww2 = sym('ww2');
ww3 = sym('ww3');
q0 = sym('q0');
q1 = sym('q1');
q2 = sym('q2');
q3 = sym('q3');
wb1 = sym('wb1');
wb2 = sym('wb2');
wb3 = sym('wb3');
u1 = sym('u1');
u2 = sym('u2');
u3 = sym('u3');

wci = [wb1 wb2 wb3].';
lambda = sym('lambda',[10 1]);
mu = sym('mu',[3 1]);
    
%sum of MOI tensor
Isum = sym('Isum',[3 3]);
IsumINV = sym('IsumINV',[3 3]);

%wheel MOI tensors
Iwx = diag(sym('Iwx',[1 3]));
Iwy = diag(sym('Iwy',[1 3]));
Iwz = diag(sym('Iwz',[1 3]));

allSyms ={ww1,ww2,ww3,wci,q0,q1,q2,q3,...
    u1,u2,u3,lambda,mu,Isum,IsumINV,...
    Iwx,Iwy,Iwz};
allNums = {x(1),x(2),x(3),x(4:6),x(7),x(8),x(9),x(10),...
    u(1),u(2),u(3),lam,mu_num,sumMOI,sumMOIinv,...
    Iw1,Iw2,Iw3};

AS = [];
AN = [];
for j = 1:length(allSyms)
    AS = [AS num2cell(reshape(allSyms{j},1,numel(allSyms{j})))];
    AN = [AN num2cell(reshape(allNums{j},1,numel(allNums{j})))];  
end

ldot = ld;
for i = 1:length(ldot)
     ldot(i) = subs(ldot(i),AS,AN);
%     for j = 1:length(allNums)
%         j
%         ldot(i) = subs(ldot(i),allSyms{j},allNums{j});
%         if(i == 10)
%             allSyms{j}
%             allNums{j}
%             ldot(i)
%         end
%     end
end
x
ldot = double(ldot);

xdot = CSDynSim(x,u);

xldot = [xdot;
           ldot];

end


