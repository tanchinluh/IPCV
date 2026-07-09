function [scores, indices, selectedLabels] = dnn_topk(x, k, labels)
    // Return the top K scores and one-based indices.
    //
    // Syntax
    //    [scores, indices] = dnn_topk(x)
    //    [scores, indices, selectedLabels] = dnn_topk(x, k, labels)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 | rhs > 3 then
        error("dnn_topk: Wrong number of input arguments.");
    end
    if rhs < 2 then k = 5; end
    if rhs < 3 then labels = []; end

    values = matrix(double(x), -1, 1);
    [sortedValues, sortedIndices] = gsort(values, "g", "d");
    k = min(max(round(k), 1), size(sortedValues, "*"));
    scores = sortedValues(1:k);
    indices = sortedIndices(1:k);

    selectedLabels = [];
    if size(labels, "*") > 0 then
        selectedLabels = labels(indices);
    end
endfunction
