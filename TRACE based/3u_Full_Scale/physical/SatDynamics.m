function [ f ] = SatDynamics(x,u)
%Cubesat dynamics, for derivation refer to Karpenko TRACE paper

%states : 1:3 body rate
%         4:6 wheel rates
%         7:10 quat
%controls: 1:3 wheel torques

global I
global GAMMA
global GAMMAinv

omegaBody = x(1:3);
omegaWheels = x(4:6);
qR = x(7:10);

interm = zeros(6,1); % the thing that gets multiplied by the gamma matrix
temp = zeros(3,1);
for j = 1:3
    temp(j) = GAMMA(j,j+3)*omegaWheels(j)+GAMMA(j,j+3)*omegaBody(j);
    %temp = temp + GAMMA(1,j+3)*omegaWheels(j,i) + GAMMA(1,j+3)*A(:,j).'*omegaBody(:,i)
end
%I*omegaBody
interm(1:3) = cross(-omegaBody, I*omegaBody+temp);
interm(4:6) = u;
omegaDots = GAMMAinv*interm;

qw = [0 omegaBody'];
qr = qR';
qrdot = 0.5*quatmultiply(qr,qw);

f = [omegaDots;
    qrdot'];
end

