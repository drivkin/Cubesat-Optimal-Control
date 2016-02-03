function [ fAug ] = verDynAndCostFun(xaug,u)
%Allows for integration of controls and dynamics to verify feasibility and
%also integrate cost function to verify cost
x = xaug(1:10);
f = SatDynamics(x,u);

dummy.states = x;
dummy.controls = u;
dummy.nodes = 1;

cDots = zeros(7,1);
[a cDots(1)] = absvTcost(dummy);
[cDots(2)] = TBv2cost(x(4:6));
[cDots(3)] = u2cost(u);
[cDots(4)] = logexpcost(x(4:6),u);
[a cDots(5)] = trunclogexpcost(dummy);


%compute power factors from motor parameters
R_a = 28.2; %motor armature resistance (Ohms)
k_t = .0181;  %motor torque constant (N*m/amp)
k_e = .0181; %motor electrical constant (V*s/rad)
mu_f = 1.35*10^-8 / .104719755;%dynamic friction constant

R_f = k_e^2/mu_f; % resistor equivalent to the friction

u2_factor = R_a/(k_t^2);
uv_factor = 2*R_a*k_e/(R_f*k_t) + k_e/k_t;
v2_factor = R_a*k_e^2/(R_f^2) + k_e^2/R_f;

cDots(6) = master_power(u,x(4:6),u2_factor,uv_factor,v2_factor);
cDots(7) = truncated_master_power(u,x(4:6),u2_factor,uv_factor,v2_factor);

fAug = [f;cDots];
end

