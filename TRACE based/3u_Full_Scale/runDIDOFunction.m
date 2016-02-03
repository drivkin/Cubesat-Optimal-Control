function [primal,dual,cost] = runDIDOFunction(n,guess,CFtype)
%Function that runs DIDO, similar to the scalingFitness function, but use
%to ramp up the node numbers.  Need to do this because DIDO always wants all
%variables cleared in the workspace, and it's a pain
clearvars -except n guess CFtype

%The individual is a vector of 6 scaling values
global scalingFactors
global costSF
global iterationLimit
global iteration
iteration = 0
iterationLimit = 300000;
    if(strcmpi(CFtype,'v2'))
       vec = [0.114062500000000,296.875000000000,11.4062500000000,11.4062500000000,0.114062500000000,2.54687500000000e-05;];
    end
    if(strcmpi(CFtype,'u2'))
      % vec = [0.114062500000000,296.875000000000,11.4062500000000,11.4062500000000,0.114062500000000,10^6;];
        vec = [0.114062500000000,296.875000000000*13.6364,11.4062500000000,11.4062500000000,0.114062500000000,1;];
    end
    if(strcmpi(CFtype,'uv'))
        vec = [0.114062500000000,296.875000000000,11.4062500000000,11.4062500000000,0.114062500000000,1e05;];
    end
    if(strcmpi(CFtype,'master'))
       % vec = [0.114062500000000,296.875000000000,11.4062500000000,11.4062500000000,0.114062500000000,1];
        vec = [0.1011  272.2656   10.1055   22.4805    0.1011    0.8751]; % tiny wheels
    end
    if(strcmpi(CFtype,'time'))
        vec = [0.114062500000000,296.875000000000,11.4062500000000,11.4062500000000,1,1];
    end
vec = vec
scalingFactors = [ vec(1)
    vec(1)
    vec(1)
    vec(2);
    vec(2);
    vec(2);
    vec(3);
    vec(3);
    vec(3);
    vec(3);
    vec(4);
    vec(4);
    vec(4);
    vec(5)] * 1;
costSF = vec(6);

computeConstants;
try
    if(strcmpi(CFtype,'v2'))
        [primal,dual,cost] = runTBv2(n,guess,0);
    end
    if(strcmpi(CFtype,'u2'))
        [primal,dual,cost] = runTBu2(n,guess,0);
    end
    if(strcmpi(CFtype,'uv'))
        [primal,dual,cost] = runTBuv(n,guess,0);
    end
    if(strcmpi(CFtype,'master'))
        [primal,dual,cost] = run_master_power(n,guess,0);
    end
    if(strcmpi(CFtype,'time'))
        [primal,dual,cost] = run_time_optimal(n,guess,0);
    end
    
    primal = designer2SI(primal);
    [ts,xsim] = simulateDynamics(primal);
    QM = computeQualityMetric(primal,xsim);
    QM = QM
    % save('3u_v2_16N_baseline','primal');
catch anyException
    anyException
    anyException.message
    clear all
    %if iteration limit is reached, consider the individual very unfit
    primal = 'iteration limit reached';
    dual = 'iteration limit reached';
    cost = 'iteration limit reached';
end




end

