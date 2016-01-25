function [ primalSI ] = designer2SI( primal )
%Takes in a DIDO primal structure in designer units and converts it to SI
%units using the global array of scaling factors
                     % body rate x
                     % body rate y
                     % body rate z
                     % wheel rate x
                     % wheel rate y
                     % wheel rate z
                     % q0
                     % q1
                     % q2
                     % q3
                     % u x
                     % u y
                    % u z
                   % time

global scalingFactors

stateSF = scalingFactors(1:10);
controlSF = scalingFactors(11:13);

N = length(primal.nodes);

primalSI = primal;


stateSFmat = repmat(stateSF,1,N);
primalSI.states = (primal.states).*stateSFmat;

controlSFmat = repmat(controlSF,1,N);
primalSI.controls = (primal.controls).*controlSFmat;

primalSI.nodes = primal.nodes*scalingFactors(end);


end

