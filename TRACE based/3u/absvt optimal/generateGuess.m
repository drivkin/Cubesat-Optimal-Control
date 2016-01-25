load('TBv2_32Nsoln');
%primal.controls(:,3:end-3) = 0;
guess = primal;
clearvars -except guess;
algorithm.guess = guess;
