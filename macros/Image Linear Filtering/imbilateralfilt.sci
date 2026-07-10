function out = imbilateralfilt(image, diameter, sigmaColor, sigmaSpace)
    // MATLAB-style compatibility entry point for bilateral filtering.
    rhs = argn(2);
    if rhs < 2 then diameter = 5; end
    if rhs < 3 then sigmaColor = 75; end
    if rhs < 4 then sigmaSpace = 75; end
    out = imbilateralfilter(image, diameter, sigmaColor, sigmaSpace);
endfunction
