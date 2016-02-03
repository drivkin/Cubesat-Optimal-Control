function [QM] = compareControls(primal,path)
%this function computes the sum of square difference of the controls in the primal
%and those listed in the primal in the path.

primal_new = primal;
u_new = primal_new.controls;
t_new = primal_new.nodes;
u_new_interp = @(ts) [interp1(t_new,u_new(1,:),ts,'pchip');
            interp1(t_new,u_new(2,:),ts,'pchip');
            interp1(t_new,u_new(3,:),ts,'pchip')];
        
load(path);
primal_std = primal;
u_std = primal_std.controls;
t_std = primal_std.nodes;
u_std_interp = @(ts) [interp1(t_std,u_std(1,:),ts,'pchip');
            interp1(t_std,u_std(2,:),ts,'pchip');
            interp1(t_std,u_std(3,:),ts,'pchip')];
  
t = linspace (0,t_std(end),100);
udiff = u_std_interp(t) - u_new_interp(t);

udiff = udiff.*udiff;

QM = sum(sum(udiff));



end

