function result = dnn_decode_classification(scores, labels, k, applySoftmax)
    // Decode classification scores into top predictions.
    //
    // Syntax
    //    result = dnn_decode_classification(scores)
    //    result = dnn_decode_classification(scores, labels, k, applySoftmax)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 | rhs > 4 then
        error("dnn_decode_classification: Wrong number of input arguments.");
    end
    if rhs < 2 then labels = []; end
    if rhs < 3 then k = 5; end
    if rhs < 4 then applySoftmax = %f; end

    values = scores;
    if applySoftmax then
        values = dnn_softmax(scores);
    end
    [topScores, topIndices, topLabels] = dnn_topk(values, k, labels);
    result.scores = topScores;
    result.indices = topIndices;
    result.labels = topLabels;
endfunction
