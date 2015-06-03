function pc = CSPPath(primal)
x = primal.states;

pw1 = x(1:2,:);
pw2 = x(3:4,:);
pw3 = x(5:6,:);

rw =x(7:9,:);

%make sure only one pseudo wheel spins at a time
pc(1,:) = rw(1,:)-sum(pw1,1);
pc(2,:) = rw(2,:)-sum(pw2,1);
pc(3,:) = rw(3,:)-sum(pw3,1);

pc(4,:) = rw(1,:).^2-sum(pw1.^2,1);
pc(5,:) = rw(2,:).^2-sum(pw2.^2,1);
pc(6,:) = rw(3,:).^2-sum(pw3.^2,1);
end