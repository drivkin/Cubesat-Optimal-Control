function [axes, ticks] = axesAndTicks(range,hit, n)
%range is [lowest_numberhighest_number] you're trying to
%plot. 
%hit that the ticks will definitely hit. Should be inside range. Usually 0
% n is (approx) number of ticks

d = range(2)-range(1);
d = d/n;

[dval dexp] = getSciNote(d);

tickSize = floor(dval+1)*10^dexp;

ticks = hit;
cT = hit;
while(cT<range(2))
    cT = cT+tickSize;
    ticks = [ticks cT];
end

cT = hit;
while(cT>range(1))
    cT = cT - tickSize;
    ticks = [cT ticks];
end
axes = [min(ticks) max(ticks)];






% niceNumbers = [1 2 4 6 8 10];
% 
% [value exponent] = getSciNote(range);
% nnTop = sign(range(2))*niceNumbers*10^exponent(2)
% nnBottom = sign(range(1))*niceNumbers*10^exponent(1)
% 
% 
% axes(2) = nnTop(2);
% axes(1) = nnBottom(1);
% 
% axes(2) = min(nnTop(nnTop>=range(2)));
% axes(1) = max(nnBottom(nnBottom<=range(1)));





end

