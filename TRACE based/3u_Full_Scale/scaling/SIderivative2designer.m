function [ fDes ] = SIderivative2designer( f )
%Takes in f matrix in SI units and converts designer units using the global
%scalingFactors array 

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
stateSFMat = repmat(stateSF,1,size(f,2));
tSFMat = repmat(scalingFactors(end),size(f));

fDes = f.*(tSFMat./stateSFMat);

end

