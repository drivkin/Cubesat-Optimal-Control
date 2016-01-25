clear all
close all

%% Approximate cost function
i = linspace(-2,2,1000);
alpha = [1 5 10];

J1 = i;
J1(find(J1<0)) = 0;

h=figure
hold all;
for k = 1: length(alpha)
    J2(k,:) = 1/alpha(k)*log(1+exp(alpha(k)*i));
    plot(i,J2(k,:));
end
plot(i,J1);

legend({'$\hat{UM}, \alpha = 1$','$\hat{UM}, \alpha = 5$', '$\hat{UM}, \alpha = 10$','$UM$'},'Interpreter','latex');

saveTightFigure(h,'cfapprox.pdf');

%% Control Trajectories

load('u2_50Nsoln');
u_u2 = primal.controls;
t_u2 = primal.nodes;

load('TBv2_50Nsoln');
u_v2 = primal.controls;
t_v2 = primal.nodes;

load('LOGEXP_50Nsoln');
u_le = primal.controls;
t_le = primal.nodes;

h = figure
plot(t_le,u_le);
pbaspect([1 1 1])
title({'$\hat{UV}$ Solution'},'Interpreter','latex')
legend({'$u_{1}$','$u_{2}$', '$u_{3}$'},'Interpreter','latex');
saveTightFigure(h,'u_le.pdf');

h = figure
plot(t_v2,u_v2);
pbaspect([1 1 1])
title({'$FL$ Solution'},'Interpreter','latex')
legend({'$u_{1}$','$u_{2}$', '$u_{3}$'},'Interpreter','latex');
saveTightFigure(h,'u_v2.pdf');

h = figure
plot(t_u2, u_u2);
pbaspect([1 1 1])
title({'$RL$ Solution'},'Interpreter','latex')
legend({'$u_{1}$','$u_{2}$', '$u_{3}$'},'Interpreter','latex');
saveTightFigure(h,'u_u2.pdf');
shg



