function [ ] = flipThrough( primals,vectors )
figure
for i = 1:length(primals)
    primal = primals{i};
    if(isa(primal,'struct'))
        plot(primal.nodes,primal.controls);
        i = i
        vec = vectors{i}
        pause;
    end



end

