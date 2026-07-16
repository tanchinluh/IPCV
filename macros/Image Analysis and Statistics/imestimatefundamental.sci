function fundamental = imestimatefundamental(points1, points2)
    // Estimate a stereo fundamental matrix from point correspondences.
    if argn(2) <> 2 then error("imestimatefundamental: two point matrices are required."); end
    fundamental = int_imestimatefundamental(points1, points2);
endfunction
