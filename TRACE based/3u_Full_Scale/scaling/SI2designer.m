function [primalDesigner ] = SI2designer( primalSI )
%Converts the quantities in a primal data structure from SI to designer
%based on the current global scalingFactors
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

global scalingFactors;

stateSF = scalingFactors(1:10);
controlSF = scalingFactors(11:13);
tSF = scalingFactors(14);

N = length(primalSI.nodes);

primalDesigner = primalSI;

stateSFmat = repmat(stateSF,1,N);
primalDesigner.states = (primalSI.states)./stateSFmat;

controlSFmat = repmat(controlSF,1,N);
primalDesigner.controls = (primalSI.controls)./controlSFmat;

primalDesigner.nodes = primalSI.nodes/tSF;

end

