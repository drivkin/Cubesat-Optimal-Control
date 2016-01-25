function [ f ] = TBDynamics( primal )
%Implements dynamics as shown in Mark Karpenko's TRACE paper
%states : 1:3 body rate
%         4:6 wheel rates
%         7:10 quat

stage = 'dynamics'

x = primal.states;
u = primal.controls;
N = length(primal.nodes);

global I %moment of inertia of everything together with wheels loose
global GAMMA %gamma matrix like karpenko paper
global GAMMAinv 
global A %matrix of column vectors mapping wheel quantities about rotating axes to the body frame

omegaBody = x(1:3,:);
omegaWheels = x(4:6,:);
qR = x(7:10,:);

interm = zeros(6,1); % the thing that gets multiplied by the gamma matrix
f = zeros(10,N);
temp = zeros(3,1);
for i = 1:N
    for j = 1:3
        temp = temp + GAMMA(1,j+3)*omegaWheels(j,i) + GAMMA(1,j+3)*A(:,j).'*omegaBody(:,i);
    end
    interm(1:3) = -cross(I*omegaBody(:,i), temp);
    interm(4:6) = u(:,i);
    omegaDots = GAMMAinv*interm;
    
    qw = [0 omegaBody(:,i)'];
    qr = qR(:,i)';
    qrdot = 0.5*quatmultiply(qr,qw);

    
    
    f(:,i) = [omegaDots;
            qrdot'];
end
end

