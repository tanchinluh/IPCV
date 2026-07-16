function [registered, transform] = imregister(moving, fixed, method)
    // Register a moving image to a fixed image using translation phase correlation.
    if argn(2) < 2 | argn(2) > 3 then error("imregister: moving and fixed images are required."); end
    if argn(2) < 3 then method = "phasecorr"; end
    if convstr(method, "l") <> "phasecorr" then error("imregister: the current implementation supports phasecorr."); end
    [registered, translation, rotation, scale] = imphasecorr(fixed, moving);
    transform = [1 0 0; 0 1 0; translation(1) translation(2) 1];
endfunction
