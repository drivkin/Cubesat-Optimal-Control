function [ power ] = master_power(u,v,u2_factor,uv_factor,v2_factor)
%This cost function computes the master electrical power for a cubesat
%without regenerative braking. This is power flowing out of the battery.
%If the power is computed as negative, it is set to zero using the logexp
%cost function because of the lack of regen braking.

%the master_power is computed as:
% power = u^2*u2_factor + uv*uv_factor+v2*v2_factor
% the factors are computed as follows:
% u2_factor = R_a/(k_t^2)
% uv_factor = 2*R_a*mu_f*k_e/k_t + k_e/k_t
% v2_factor = R_a*mu_f^2*k_e^2 + ke^2*mu_f

%where:
%R_a = motor armature resistance
%k_t = motor torque constant
%k_e = motor electrical constant
%mu_f = dynamic friction constant



u2 = u.*u;
uv = u.*v;
v2 = v.*v;

Pb = u2*u2_factor + uv*uv_factor + v2*v2_factor;

alpha_max = 1000; %affects the curvature of logexp near zero
Pb_no_regen = smartLogExp(Pb,alpha_max); % do this because no regen braking
power = sum(Pb_no_regen);
end

