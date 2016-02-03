function [value exponent ] = getSciNote(x)
%get scientific notations of a matrix of values x

xpos = abs(x);

%find zeros and set em to 1,they're gonna cause problems
a=find(xpos == 0);
xpos(a) = 1;
exponent = floor(log10(xpos));
value = x./(10.^exponent);

end

