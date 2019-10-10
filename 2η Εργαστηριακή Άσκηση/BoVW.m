function bincounts = BoVW (Descriptors,C)
D = pdist2(Descriptors,C);
[~, mini] = min(D,[],2);
bincounts = histc(mini, (1:size(C,1)));
bincounts = bincounts./norm(bincounts,2);

end