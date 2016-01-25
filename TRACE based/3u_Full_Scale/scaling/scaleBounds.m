%This script converts the "bounds" DIDO struct to designer units using the
%global scalingFactors vector of scaling factors

%scalingFactors vector
% body rate x
% body rate y
% body rate z
% wheel rate x
% wheel rate y
% wheel rate z
% q0
% q1
% q2
% q3
% u x
% u y
% u z
% time

global scalingFactors
stateSF = scalingFactors(1:10);
controlSF = scalingFactors(11:13);

bounds.lower.states = (bounds.lower.states)./stateSF;
bounds.upper.states = (bounds.upper.states)./stateSF;

bounds.lower.controls = (bounds.lower.controls)./controlSF;
bounds.upper.controls = (bounds.upper.controls)./controlSF;

bounds.lower.time = bounds.lower.time/scalingFactors(end);
bounds.upper.time = bounds.upper.time/scalingFactors(end);

x0 = bounds.lower.events(1:10);
xf = bounds.lower.events(11:end);

x0 = x0./stateSF;
xf
xf = xf./[stateSF(1:3); stateSF(7:10)];

bounds.lower.events = [x0;xf];
bounds.upper.events = [x0;xf];


