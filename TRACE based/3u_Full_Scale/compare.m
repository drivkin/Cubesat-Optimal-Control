%compares two files
file1 = '3u_time_50N_soln_BC';
file2 = '3u_master_50N_soln_BC';

load(file1);
primal1 = primal;
dual1 = dual;
clearvars -except primal1 dual1 file2

load(file2);
primal2 = primal;
dual2 = dual;
clearvars -except primal1 dual1 primal2 dual2
%%
close all
figure

subplot(2,1,1)
plot(primal1.nodes,primal1.states)
title('states')
subplot(2,1,2)
plot(primal2.nodes,primal2.states)

figure
subplot(2,1,1)
plot(primal1.nodes,dual1.dynamics)
title('lambdas')
subplot(2,1,2)
plot(primal2.nodes,dual2.dynamics)

figure
subplot(2,1,1)
plot(primal1.nodes,primal1.controls)
title('controls')
subplot(2,1,2)
plot(primal2.nodes,primal2.controls)

figure
subplot(2,1,1)
plot(primal1.nodes,dual1.controls)
title('mus')
subplot(2,1,2)
plot(primal2.nodes,dual2.controls)

figure
subplot(2,1,1)
plot(primal1.nodes,primal1.statedots)
title('statedots')
subplot(2,1,2)
plot(primal2.nodes,primal2.statedots)

figure
subplot(2,1,1)
plot(primal1.nodes,dual1.states)
title('dual.states')
subplot(2,1,2)
plot(primal2.nodes,dual2.states)