function [rotationVector, translationVector] = imsolvepnp(objectPoints, imagePoints, cameraMatrix, distortion)
    // Estimate camera pose from corresponding 3D and 2D points.
    rhs = argn(2);
    if rhs < 3 | rhs > 4 then error("imsolvepnp: object points, image points, and camera matrix are required."); end
    if rhs == 3 then
        [rotationVector, translationVector] = int_imsolvepnp(objectPoints, imagePoints, cameraMatrix);
    else
        [rotationVector, translationVector] = int_imsolvepnp(objectPoints, imagePoints, cameraMatrix, distortion);
    end
endfunction
