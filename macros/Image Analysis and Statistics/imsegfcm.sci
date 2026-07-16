function [labels, centers] = imsegfcm(image, clusterCount, iterations, fuzziness)
    // Segment intensity values using a compact fuzzy C-means solver.
    rhs = argn(2);
    if rhs < 2 | rhs > 4 then error("imsegfcm: image and cluster count are required."); end
    if rhs < 3 then iterations = 20; end
    if rhs < 4 then fuzziness = 2; end
    if clusterCount < 2 | iterations < 1 | fuzziness <= 1 then error("imsegfcm: invalid clustering parameters."); end
    values = im2double(image);
    if size(size(values), "*") == 3 then values = rgb2gray(values); end
    rows = size(values, 1); cols = size(values, 2); data = matrix(values, -1, 1);
    low = min(data); high = max(data);
    centers = linspace(low, high, clusterCount)';
    membership = zeros(size(data, 1), clusterCount);
    for iter = 1:iterations
        for n = 1:size(data, 1)
            distances = abs(data(n) - centers) + %eps;
            weights = distances .^ (-2 / (fuzziness - 1));
            membership(n, :) = (weights / sum(weights))';
        end
        for k = 1:clusterCount
            weights = membership(:, k) .^ fuzziness;
            centers(k) = sum(weights .* data) / max(sum(weights), %eps);
        end
    end
    labels = zeros(size(data, 1), 1);
    for n = 1:size(data, 1)
        [dummy, label] = max(membership(n, :));
        labels(n) = label;
    end
    labels = matrix(labels, rows, cols);
endfunction
