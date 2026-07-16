function points3d = imtriangulate(points1, points2, projection1, projection2)
    // Reconstruct 3D points from two calibrated projection matrices.
    if argn(2) <> 4 then error("imtriangulate: two point matrices and two projection matrices are required."); end
    points3d = int_imtriangulate(points1, points2, projection1, projection2);
endfunction
