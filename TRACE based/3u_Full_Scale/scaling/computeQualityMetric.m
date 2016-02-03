function [ QM ] = computeQualityMetric(primal,xsim)
%Computes some quality metric of the solution based on its feasibility.
%Currently just going to be the distance between what DIDO thought the
%final quaternion was and what it really was.

xsim = xsim';
xDIDO = primal.states;

qDIDO = xDIDO(7:10,end);
qsim = xsim(7:10,end);
%perhaps naively, just use RSS 
res = qsim - qDIDO;
QM = res'*res;
end

