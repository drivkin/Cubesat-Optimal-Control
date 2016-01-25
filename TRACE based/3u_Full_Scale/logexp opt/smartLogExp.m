function [ out ] = smartLogExp(in,alpha_max)
%Computes a log exp which approximates the true uv cost function but
%smoothed out at zero, and works for a wide range of inputs


%need to compute either a different value of alpha, or a different base for
%each value, so that it doesn't explode. The question is how do we decided
%how smooth we want the curve to be around zero? If we just ensure that all
%values of the input are in the linear region, that's just like not
%smoothing it at all. Probably the thing to do is just choose a large,
%constant scaling factor, and then just not apply it to anything that's big
%enough to cause infinities. 

%What we will do is define an alpha_max, where alpha won't be bigger than
%that, even for the smallest numbers. For big numbers, alpha will be
%progressively smaller, so that they don't cause an inf.

%depends on maximum number representable in Matlab, which is something like
%10^308, but why push it? e^100 is a pretty big number already.
thresh = 100;

alpha_mat = alpha_max*ones(size(in));
interm = alpha_max*in;
too_big = find(interm>thresh);
alpha_mat(too_big) = thresh./in(too_big);

out = log(exp(in.*alpha_mat)+1)./alpha_mat;

end

