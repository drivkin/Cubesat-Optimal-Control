clear all
tf = sym('tf'); %final time because we're doing time optimal soln
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
x = [ww1;
    ww2;
    ww3;
    wb1;
    wb2;
    wb3;
    q0;
    q1;
    q2;
    q3;];
    
%sum of MOI tensor
Isum = sym('Isum',[3 3]);
IsumINV = sym('IsumINV',[3 3]);

%wheel MOI tensors
Iwx = diag(sym('Iwx',[1 3]));
Iwy = diag(sym('Iwy',[1 3]));
Iwz = diag(sym('Iwz',[1 3]));

%vector versions of stuff

%wheel accelerations
aw1 = [u1 0 0].';
aw2 = [0 u2 0].';
aw3 = [0 0 u3].';

%wheel speeds
ww1v = [ww1 0 0].';
ww2v = [0 ww2 0].';
ww3v = [0 0 ww3].';

% angular velocity of body (center of mass) frame to inertial
wci = [wb1 wb2 wb3].';

%skew symmetric version of wci (essentially for cross products)
WCI = skew(wci);




fww = [u1;
        u2;
        u3];
%     
% fq =[ -wb1*q1 - wb2*q2 - wb3*q3;
%             wb1*q0 + wb3*q2 - wb2*q3;
%             wb2*q0 - wb3*q1 + wb1*q3;
%             wb3*q0 + wb2*q1 - wb1*q2];
        
fq = 0.5*quatmultDR([q0 q1 q2 q3],[0 wb1 wb2 wb3]);
fq = fq.';
        
term1 = WCI*Isum*wci;
term2 = Iwx*aw1+Iwy*aw2+Iwz*aw3;
term3 = WCI*(Iwx*ww1v+Iwy*ww2v+Iwz*ww3v);
fwb = IsumINV*(-term1 - term2 - term3);

f = [fww;
    fwb;
    fq;];


%% Necessary conditions / costate stuff
lambda = sym('lambda',[10 1]);

mu = sym('mu',[3 1]);
u = [u1;
    u2;
    u3];

%v^2 solution
%H = ww1^2+ww2^2+ww3^2+lambda.'*f;

%|uv| solution
%H = abs(ww1*u1)+abs(ww2*u2)+abs(ww3*u3)+lambda.'*f;

%uv solution
%H = ww1*u1+ww2*u2+ww3*u3+lambda.'*f;

%u^2v^2 solution
%H = ww1^2*u1^2+ww2^2*u2^2+ww3^2*u3^2+lambda.'*f;

%tf solution
H = lambda.'*f;

LoH = H+mu.'*u;

for i = 1:3
    HMC(i) = diff(LoH,u(i));
end

HMC = HMC.';

for i = 1:10
    lambdaDot(i) = -diff(LoH,x(i));
end
lambdaDot = lambdaDot.';
        