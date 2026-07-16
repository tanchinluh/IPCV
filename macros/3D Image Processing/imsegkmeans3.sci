function [labels, centers] = imsegkmeans3(volume, clusterCount, maxIterations)
    // Segment a 3D scalar volume with compact k-means iterations.
    rhs = argn(2); if rhs < 2 | rhs > 3 then error("imsegkmeans3: volume and cluster count are required."); end
    if size(size(volume), "*") <> 3 | clusterCount < 2 then error("imsegkmeans3: a 3D volume and at least two clusters are required."); end
    if rhs < 3 then maxIterations = 20; end
    values = double(volume); flat = matrix(values, -1, 1); minValue = min(flat); maxValue = max(flat);
    centers = linspace(minValue, maxValue, clusterCount); labels = ones(size(flat, 1), 1);
    for iteration = 1:maxIterations
        oldCenters = centers;
        for i = 1:size(flat, 1)
            [dummy, labels(i)] = min(abs(flat(i) - centers));
        end
        for k = 1:clusterCount
            members = flat(labels == k); if ~isempty(members) then centers(k) = mean(members); end
        end
        if max(abs(centers - oldCenters)) < 1e-8 then break; end
    end
    labels = matrix(labels, size(volume));
endfunction
