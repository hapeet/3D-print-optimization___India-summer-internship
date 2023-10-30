A = [1 1 1 1 1 0 0 0 1 1];


% one collumn sum
dA = diff(A);
idxs = [0, find(diff(A))];

volA = 0;
for i = 2:length(idxs)
    if dA(idxs(i))>0
        volA = volA + (idxs(i) - idxs(i-1));
    end
end

