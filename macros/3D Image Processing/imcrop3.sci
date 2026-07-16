function out = imcrop3(volume, startPoint, cropSize)
    // Crop a 3D volume using [row col slice] start and size coordinates.
    if argn(2) <> 3 then error("imcrop3: volume, start point, and crop size are required."); end
    if size(size(volume), "*") <> 3 | size(startPoint, "*") <> 3 | size(cropSize, "*") <> 3 then error("imcrop3: invalid 3D arguments."); end
    startPoint = round(startPoint); cropSize = round(cropSize);
    stopPoint = startPoint + cropSize - 1;
    if min(startPoint) < 1 | stopPoint(1) > size(volume, 1) | stopPoint(2) > size(volume, 2) | stopPoint(3) > size(volume, 3) then error("imcrop3: crop is outside the volume."); end
    out = volume(startPoint(1):stopPoint(1), startPoint(2):stopPoint(2), startPoint(3):stopPoint(3));
endfunction
