function [ f ] = DIDODynamics( primal )
%unpacks primal data structure and passes one node at a time to the
%dynamics computing function. Also, does unscaling and rescaling.

global iteration
global iterationLimit;

if(isempty(iteration))
    iteration = 1;
else
    iteration = iteration + 1;
    if(mod(iteration,1000) == 0)
        iteration = iteration
    end
end

if(iteration > iterationLimit)
    iterationException = MException('DR:ILimit','Iteration Limit Reached');
    throw(iterationException)
end
    
primal = designer2SI(primal);
N = length(primal.nodes);
x = primal.states;
u = primal.controls;

f = zeros(10,N);
for i = 1:N
    f(:,i) = SatDynamics(x(:,i),u(:,i));
end

f = SIderivative2designer(f);
end

