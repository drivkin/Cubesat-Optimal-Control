
global I %moment of inertia of everything together with wheels loose
global GAMMA %gamma matrix like karpenko paper
global GAMMAinv 
global A %matrix of column vectors mapping wheel quantities about rotating axes to the body frame

%scale factor defined in main script

A = [1 0 0;
    0 1 0;
    0 0 1]; 

%1U
I = [0.00152828000000000,2.11600000000000e-05,2.11600000000000e-05; 
    2.11600000000000e-05,0.00152828000000000,2.11600000000000e-05;
    2.11600000000000e-05,2.11600000000000e-05,0.00152828000000000;];

% %3U
% I = scaleFactor* [0.0247818266666667,2.10533333333333e-05,6.10533333333338e-05;
%     2.10533333333333e-05,0.0247818266666667,6.10533333333337e-05;
%     6.10533333333338e-05,6.10533333333338e-05,0.00486182666666667;] 


Iw = [0.000101000000000000 0.000101000000000000 0.000101000000000000]; %inertial moments of wheels about axes of rotation

%populating GAMMA matrix
GAMMA = zeros(6,6);
temp = I;
for i = 1:3
    temp = temp+A(:,i)*Iw(i)*A(:,i).';
end

GAMMA(1:3,1:3) = temp;
for i = 4:6
    GAMMA(i,i) = Iw(i-3);
    GAMMA(1:3,i) = squeeze(A(:,i-3))*squeeze(Iw(i-3));
    GAMMA(i,1:3) = Iw(i-3)*A(:,i-3).';
end
    
GAMMAinv = inv(GAMMA);