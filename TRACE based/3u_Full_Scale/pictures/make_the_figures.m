clear all
%close all
soln_name  = '3u_master_50N_soln_BC'
load(soln_name)

n = primal.nodes;
u = primal.controls;
w = primal.states(4:6,:);

[laxis lticks] = axesAndTicks([min(min(u)) max(max(u))],0,6)
[raxis rticks] = axesAndTicks([min(min(w)) max(max(w))],0,6)
%[raxis rticks] = axesAndTicks([-30 60],0,6)
H = [];
laxis = [0 n(end) laxis];
raxis = [0 n(end) raxis];
%plot controls and wheel speeds on same plot
handle = figure;
[ax,p1,p2]=plotyy(primal.nodes,primal.controls(1,:),primal.nodes,primal.states(4,:));
set(p1,'LineStyle','--');
set(p1,'Color','blue')
set(p2,'Color','blue')
axis([ax(1)],laxis);
axis([ax(2)],raxis);
set(ax(1),'YTick',lticks);
set(ax(2),'YTick',rticks);

H = [H p1 p2];
hold on

[ax,p1,p2]= plotyy(primal.nodes,primal.controls(2,:),primal.nodes,primal.states(5,:));
set(p1,'LineStyle','--');
set(p1,'Color','green')
set(p2,'Color','green')
axis([ax(1)],laxis);
axis([ax(2)],raxis);
set(ax(1),'YTick',lticks);
set(ax(2),'YTick',rticks);
H = [H p1 p2];

[ax,p1,p2]= plotyy(primal.nodes,primal.controls(3,:),primal.nodes,primal.states(6,:));
set(p1,'LineStyle','--');
set(p1,'Color','red')
set(p2,'Color','red')
axis([ax(1)],laxis);
axis([ax(2)],raxis);
set(ax(1),'YTick',lticks);
set(ax(2),'YTick',rticks);
H = [H p1 p2];


xlabel(ax(1),'time (s)')
ylabel(ax(1),'control torque (N-m)')
ylabel(ax(2),'wheel speed (rad/s)')
legend(H,{'$u_1$','$\omega_w,1$','$u_2$','$\omega_w,2$','$u_3$','$\omega_w,3$'},'interpreter','latex','location','North')

saveas(handle,[soln_name '_controls_and_wheel_speeds.pdf'])
% saveTightFigure(handle,[soln_name '_controls_and_wheel_speeds.pdf'])
%tightfig(handle)