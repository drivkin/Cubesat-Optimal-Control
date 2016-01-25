%generates the figure for the extended abstract
%1. |vT|
%2. v^2
%3. 10000*T^2
%4. log(1*exp(alpha*v*T)) where alpha = 10000
%5. same as 4 but set to zero whenever alpha*v*T < 0

close all
clear all
load('logexpsolnCosts');
CLE = C;
tLE = ts;

load('v2solnCosts');
Cv2 = C;
tv2 = ts;

load('u2solnCosts');
Cu2 = C;
tu2 = ts;

normCF = [1 CLE(2,end)/Cv2(2,end) CLE(3,end)/Cu2(3,end);
        Cv2(1,end)/CLE(1,end) 1 Cv2(3,end)/Cu2(3,end);
        Cu2(1,end)/CLE(1,end) Cu2(2,end)/Cv2(2,end) 1]



figure
subplot(1,2,1)
hold all;
plot(tLE/10,CLE(1,:)*1000);
plot(tv2/10,Cv2(1,:)*1000);
plot(tu2/10,Cu2(1,:)*1000);
xlabel('Scaled time');
ylabel('Scaled cost');
title('Work Energy Cost of Three Different Solutions');
legend('Approx. work energy optimal solution','frictional loss optimal solution','resistive loss optimal solution');