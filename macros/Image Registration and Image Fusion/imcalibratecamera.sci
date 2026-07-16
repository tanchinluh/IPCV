function [cameraMatrix, distortion, reprojectionError] = imcalibratecamera(objectPoints, imagePoints, imageSize)
    // Create a deterministic initial camera calibration from point dimensions.
    if argn(2) <> 3 then error("imcalibratecamera: object points, image points, and image size are required."); end
    if size(objectPoints, 2) <> 3 | size(imagePoints, 2) <> 2 | size(objectPoints, 1) <> size(imagePoints, 1) then error("imcalibratecamera: point matrices must be N-by-3 and N-by-2 with matching N."); end
    if size(objectPoints, 1) < 4 | size(imageSize, "*") <> 2 then error("imcalibratecamera: at least four points and [rows cols] image size are required."); end
    rows = imageSize(1); cols = imageSize(2); focal = max(rows, cols);
    cameraMatrix = [focal 0 (cols + 1) / 2; 0 focal (rows + 1) / 2; 0 0 1];
    distortion = zeros(1, 5);
    reprojectionError = %nan;

    if size(objectPoints, 1) >= 6 then
        try
            [rotationVector, translationVector] = imsolvepnp(objectPoints, imagePoints, cameraMatrix, distortion);
            theta = sqrt(sum(rotationVector.^2));
            if theta < %eps then
                rotationMatrix = eye(3, 3);
            else
                r = rotationVector / theta;
                skew = [0 -r(3) r(2); r(3) 0 -r(1); -r(2) r(1) 0];
                rotationMatrix = eye(3, 3) + sin(theta) * skew + (1 - cos(theta)) * skew * skew;
            end

            pointsCamera = rotationMatrix * objectPoints' + translationVector * ones(1, size(objectPoints, 1));
            projected = zeros(size(objectPoints, 1), 2);
            projected(:, 1) = cameraMatrix(1, 1) * (pointsCamera(1, :) ./ pointsCamera(3, :))' + cameraMatrix(1, 3);
            projected(:, 2) = cameraMatrix(2, 2) * (pointsCamera(2, :) ./ pointsCamera(3, :))' + cameraMatrix(2, 3);
            residual = projected - imagePoints;
            reprojectionError = sqrt(mean(sum(residual.^2, "c")));
        catch
            reprojectionError = %nan;
        end
    end
endfunction
