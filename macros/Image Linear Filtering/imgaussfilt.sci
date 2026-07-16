function out = imgaussfilt(image, ksize, sigmaX, sigmaY)
    // MATLAB-style compatibility entry point for Gaussian filtering.
    rhs = argn(2);
    if rhs < 2 then ksize = [5 5]; end
    if rhs < 3 then sigmaX = 0; end
    if rhs < 4 then sigmaY = 0; end
    out = imgaussianblur(image, ksize, sigmaX, sigmaY);
endfunction
