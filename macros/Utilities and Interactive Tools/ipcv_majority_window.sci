function value = ipcv_majority_window(window)
    // Internal callback used by immajority.
    value = sum(window <> 0) >= ceil(size(window, "*") / 2);
endfunction
