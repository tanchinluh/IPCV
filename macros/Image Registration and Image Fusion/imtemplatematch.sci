function score = imtemplatematch(image, template, method)
    // Compute an OpenCV template-matching score map.
    rhs = argn(2); if rhs < 2 | rhs > 3 then error("imtemplatematch: image and template are required."); end
    if rhs < 3 then method = "ccorr_normed"; end
    method = convstr(method, "l");
    if method <> "ccorr" & method <> "ccoeff" & method <> "ccorr_normed" & method <> "ccoeff_normed" then
        error("imtemplatematch: method must be ccorr, ccoeff, ccorr_normed, or ccoeff_normed.");
    end
    if ~exists("int_imtemplatematch") then
        error("imtemplatematch: OpenCV gateway is not loaded. Rebuild IPCV and reload the toolbox.");
    end
    score = int_imtemplatematch(image, template, method);
endfunction
