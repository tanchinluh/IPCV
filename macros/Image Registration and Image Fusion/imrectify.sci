function out = imrectify(image, homography, outputSize)
    // Rectify an image using a 3-by-3 projective homography.
    rhs = argn(2); if rhs < 2 | rhs > 3 then error("imrectify: image and homography are required."); end
    if size(homography, "*") <> 9 then error("imrectify: homography must contain nine values."); end
    homography = matrix(homography, 3, 3);
    if rhs < 3 then outputSize = [size(image, 1) size(image, 2)]; end
    if size(outputSize, "*") <> 2 then error("imrectify: outputSize must be [rows cols]."); end
    if max(abs(homography - eye(3))) < %eps & outputSize(1) == size(image, 1) & outputSize(2) == size(image, 2) then
        out = image;
        return;
    end
    // imtransform retains IPCV's historical transposed matrix convention.
    transformed = imtransform(image, homography', "perspective", outputSize(2), outputSize(1));
    out = ipcv_rectify_restore_type(transformed, image);
endfunction

function out = ipcv_rectify_restore_type(transformed, sample)
    inputType = typeof(sample);
    if typeof(transformed) == inputType then
        out = transformed;
        return;
    end

    values = double(transformed);
    select inputType
    case "boolean" then
        out = values <> 0;
    case "uint8" then
        values(values < 0) = 0;
        values(values > 255) = 255;
        out = uint8(round(values));
    case "uint16" then
        values(values < 0) = 0;
        values(values > 65535) = 65535;
        out = uint16(round(values));
    case "int8" then
        values(values < -128) = -128;
        values(values > 127) = 127;
        out = int8(round(values));
    case "int16" then
        values(values < -32768) = -32768;
        values(values > 32767) = 32767;
        out = int16(round(values));
    case "int32" then
        out = int32(round(values));
    case "constant" then
        out = values;
    else
        out = transformed;
    end
endfunction
