function disparity = imstereosgbm(left, right, numDisparities, blockSize)
    // Approximate semi-global stereo matching with block matching and smoothing.
    disparity = imstereobm(left, right, numDisparities, blockSize);
    disparity = imlocalmean(disparity, [3 3]);
endfunction
