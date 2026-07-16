function value = ipcv_entropy_window(window)
    // Internal callback used by imlocalentropy.
    levels = floor(min(max(double(window), 0), 1) * 31) + 1;
    counts = zeros(32, 1);
    for k = 1:size(levels, "*")
        counts(levels(k)) = counts(levels(k)) + 1;
    end
    probabilities = counts / size(levels, "*");
    value = 0;
    for k = 1:size(probabilities, "*")
        if probabilities(k) > 0 then value = value - probabilities(k) * log2(probabilities(k)); end
    end
endfunction
