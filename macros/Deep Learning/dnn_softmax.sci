function y = dnn_softmax(x)
    // Compute softmax probabilities.
    //
    // Syntax
    //    y = dnn_softmax(x)
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 1 then
        error("dnn_softmax: Wrong number of input arguments.");
    end

    values = double(x);
    values = values - max(values);
    ex = exp(values);
    y = ex ./ sum(ex);
endfunction
