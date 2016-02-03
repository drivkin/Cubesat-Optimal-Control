clear all
close all
global scalingFactors
global costSF
[primal,dual,cost] = runDIDOFunction(16,-1,'u2');
guess = '3u_u2_16N_soln_point3BC';
save(guess,'primal','dual','cost');
for n = 20:10:50
    [primal,dual,cost] = runDIDOFunction(n,guess,'u2');
    if(isa(cost,'numeric')) %then iteration limit not reached
        %primal = designer2SI(primal);
        [ts,xsim] = simulateDynamics(primal);
        figure
        t = squeeze(primal.nodes);
        states = squeeze(primal.states);
        qDIDO = states(7:10,:)
        hold all
        scatter(t,qDIDO(1,:));
        scatter(t,qDIDO(2,:));
        scatter(t,qDIDO(3,:));
        scatter(t,qDIDO(4,:));
        plot(ts,xsim(:,7:10))
        
        QM = computeQualityMetric(primal,xsim);
        QM
        savePath = ['3u_u2_' num2str(n) 'N_soln_point3BC'];
        save(savePath,'primal','dual','cost','QM','scalingFactors','costSF');
        guess = savePath;
    else
        'iteration limit reached when trying node number:'
        n
        break;
    end
end
%%
%close all
figure
t = squeeze(primal.nodes);
states = squeeze(primal.states);
qDIDO = states(7:10,:)
hold all
scatter(t,qDIDO(1,:));
scatter(t,qDIDO(2,:));
scatter(t,qDIDO(3,:));
scatter(t,qDIDO(4,:));
plot(ts,xsim(:,7:10))

