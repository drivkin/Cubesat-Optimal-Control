function c = CSMEPCPath(primal)
x = primal.states;
u1 = primal.controls;

v =u1(7:12,:);

w = x(1:3,:);

%make sure the pseudo controls add up to v
c(1,:) = w(1,:)-v(1,:)-v(2,:);
c(2,:) = w(2,:)-v(3,:)-v(4,:);
c(3,:) = w(3,:)-v(5,:)-v(6,:);

% %make sure only one pseudo control is active at a time
c(4,:) = w(1,:).^2-v(1,:).^2-v(2,:).^2;
c(5,:) = w(2,:).^2-v(3,:).^2-v(4,:).^2;
c(6,:) = w(3,:).^2-v(5,:).^2-v(6,:).^2;

% make sure only one of the controls per wheel is active at a time
u = u1(1:6,:);

c(7,:) = (u(1,:)+u(2,:)).^2 - u(1,:).^2 - u(2,:).^2;
c(8,:) = (u(3,:)+u(4,:)).^2 - u(3,:).^2 - u(4,:).^2;
c(9,:) = (u(5,:)+u(6,:)).^2 - u(5,:).^2 - u(6,:).^2;

end