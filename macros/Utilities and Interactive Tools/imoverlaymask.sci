//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2026  Tan Chin Luh
//=============================================================================
function out = imoverlaymask(image, mask, rgb, alpha, boundary)
    // Blend a binary or label mask over an image.
    //
    // Syntax
    //    out = imoverlaymask(image, mask)
    //    out = imoverlaymask(image, mask, rgb, alpha, boundary)
    //
    // Parameters
    //    image : Input image.
    //    mask : Binary or label mask. Nonzero pixels are treated as foreground.
    //    rgb : Optional RGB overlay color, default [255 0 0].
    //    alpha : Optional foreground opacity from 0 to 1, default 0.35.
    //    boundary : Optional boolean. When true, draw a stronger boundary.
    //    out : RGB uint8 overlay image.
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 5 then
        error("imoverlaymask: Wrong number of input arguments.");
    end
    if rhs < 3 then rgb = [255 0 0]; end
    if rhs < 4 then alpha = 0.35; end
    if rhs < 5 then boundary = %f; end
    if alpha < 0 | alpha > 1 then
        error("imoverlaymask: alpha must be between 0 and 1.");
    end
    if size(mask, 1) <> size(image, 1) | size(mask, 2) <> size(image, 2) then
        error("imoverlaymask: mask size must match the image height and width.");
    end

    src = ipcv_to_uint8_rgb(image);
    if type(mask) == 4 then
        mask01 = double(mask);
    else
        mask01 = double(mask <> 0);
    end
    maskAlpha = mask01 * alpha;
    out = src;

    for c = 1:3
        out(:, :, c) = uint8(double(src(:, :, c)) .* (1 - maskAlpha) + rgb(c) * maskAlpha);
    end

    if boundary then
        edgeMask = imgradient(uint8(mask01), imcreatese("ellipse", 3, 3)) > 0;
        for c = 1:3
            out(:, :, c) = uint8(double(out(:, :, c)) .* double(~edgeMask) + rgb(c) * double(edgeMask));
        end
    end
endfunction

function rgbImage = ipcv_to_uint8_rgb(image)
    values = double(image);
    if typeof(image(1)) == "uint8" then
        u8 = image;
    else
        if max(values) <= 1 then
            values = values * 255;
        end
        values = min(max(values, 0), 255);
        u8 = uint8(values);
    end

    dims = size(u8);
    if size(dims, "*") == 2 then
        rgbImage = cat(3, u8, u8, u8);
    else
        rgbImage = u8(:, :, 1:3);
    end
endfunction
