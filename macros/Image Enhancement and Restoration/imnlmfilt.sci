function out = imnlmfilt(image, h, hColor, templateWindowSize, searchWindowSize)
    // MATLAB-style compatibility entry point for OpenCV fast non-local-means denoising.
    rhs = argn(2);
    if rhs < 2 then h = 3; end
    if rhs < 3 then hColor = h; end
    if rhs < 4 then templateWindowSize = 7; end
    if rhs < 5 then searchWindowSize = 21; end
    out = imdenoise(image, h, hColor, templateWindowSize, searchWindowSize);
endfunction
