function [ xdot ] = CSPDynamics( primal )
%Cubesat dynamics using DCM
%Constant Matrices
N = length(primal.nodes);
%sumMOI is the sum of the moments of inertial off all the bodies (three
%momentum wheels + the body) about their centers of mass and the moment of
%inertia about the center of mass of the satellite expressed int the body
%frame
sumMOI = [0.00152828000000000,2.11600000000000e-05,2.11600000000000e-05;
    2.11600000000000e-05,0.00152828000000000,2.11600000000000e-05;
    2.11600000000000e-05,2.11600000000000e-05,0.00152828000000000;];
sumMOIinv = [654.577898071825,-8.93927375258147,-8.93927375258147;
    -8.93927375258147,654.577898071825,-8.93927375258147;
    -8.93927375258147,-8.93927375258147,654.577898071825];

%Moments of inertia of the reaction wheels about their centers of mass
% expressed in the body frame
Iw1 = [0.000101000000000000,0,0;
    0,5.07000000000000e-05,0;
    0,0,5.07000000000000e-05;];

Iw2 = [5.07000000000000e-05,0,0;
    0,0.000101000000000000,0;
    0,0,5.07000000000000e-05;];

Iw3 = [5.07000000000000e-05,0,0;
    0,5.07000000000000e-05,0;
    0,0,0.000101000000000000;];


%extracting and reshaping from primal
x = primal.states;
%pseudo wheel speeds
pww = x(1:6,:);
%wheels speeds
ww = x(7:9,:);
%putting them in vector form
ww1 = zeros(3,N);
ww1(1,:) = ww(1,:);
ww2 = zeros(3,N);
ww2(2,:) = ww(2,:);
ww3 = zeros(3,N);
ww3(3,:) = ww(3,:);

%angular velocity of body wrt inertial
wb = x(10:12,:);

%quaternion between body and inertial
qR = x(13:16,:);

%pseudo wheel accelerations (which is the control)
up = primal.controls;

%total acceleration is the sum of the four pseudo wheel accelerations
u(1,:) = sum(up(1:4,:),1);
u(2,:) = sum(up(5:8,:),1);
u(3,:) = sum(up(9:12,:),1);

%putting them in vector form
u1 = zeros(3,N);
u1(1,:) = u(1,:);
u2 = zeros(3,N);
u2(2,:) = u(2,:);
u3 = zeros(3,N);
u3(3,:) = u(3,:);

%implementing dynamics


pwwdot(1,:) = up(1,:)+up(2,:);
pwwdot(2,:) = up(3,:)+up(4,:);
pwwdot(3,:) = up(5,:)+up(6,:);
pwwdot(4,:) = up(7,:)+up(8,:);
pwwdot(5,:) = up(9,:)+up(10,:);
pwwdot(6,:) = up(11,:)+up(12,:);

wwdot = u;
wbdot = zeros(3,N);
qRdot = zeros(4,N);
for i=1:N
    %computing angular acceleration of body frame
    term1 = Iw1*u1(:,i)+Iw2*u2(:,i)+Iw3*u3(:,i);
    term2 = skew(wb(:,i))*(Iw1*ww1(:,i)+Iw2*ww2(:,i)+Iw3*ww3(:,i));
    term3 = skew(wb(:,i))*sumMOI*wb(:,i);
    rhs = 0 - term1 - term2 - term3;
    wbdot(:,i) = sumMOIinv*rhs;
    
    %rotation matrix derivative
    qw = [0 wb(:,i)'];
    qr = qR(:,i)';
    qrdot = 0.5*quatmultiply(qr,qw);
    qRdot(:,i) = qrdot';
end


%recombining into xdot
xdot = zeros(size(x));
xdot(1:6,:) = pwwdot;
xdot(7:9,:) = wwdot;
xdot(10:12,:) = wbdot;
xdot(13:16,:) = qRdot;

end