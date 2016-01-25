%Once DIDO gives some output with states and costates, this script uses
%those to automatically generate a new vector of scaling factors, based on
%the idea that the magnitudes of the states and the costates should be
%about the same

n = primal.nodes; 
d = diff(n);
d1 = [d 0];
d2 = [0 d];
w = ((d1+d2)/2)/(n(end)); %averaging weights
w = w';

avgStateMag = abs(primal.statedots)*w;
avgCostateMag = abs(dual.dynamics)*w;

mCM = mean(avgCostateMag)
if(mCM < sqrt(10) && mCM >sqrt(.1))
    mCM = 1;
end
nextCostSF = costSF*mCM;

% avgStateMag = mean(abs(primal.states),2);
% avgCostateMag = mean(abs(dual.dynamics),2);

nextStateSF = sqrt(avgStateMag./avgCostateMag);

avgControlMag = abs(primal.controls)*w;
avgMuMag = abs(dual.controls)*w;

% avgControlMag = mean(abs(primal.controls),2);
% avgMuMag = mean(abs(dual.controls),2);

nextControlSF = sqrt(avgControlMag./avgMuMag);

a = [nextStateSF; nextControlSF; 1];
b = find((a<sqrt(10)) & (a> sqrt(.1)));
a(b) = 1;
nextScaleFactors = a.*scalingFactors;

%try not scaling quaternions
%nextScaleFactors(7:10) = 1;

nextScaleFactors(end) = 1;

save('nextFactors','nextScaleFactors','nextCostSF')