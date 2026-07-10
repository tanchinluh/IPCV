//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function y = imfuse(x1, x2, method, alpha)
    // Image fusion
    //
    // Syntax
    //    y = imfuse(x1, x2)
    //    y = imfuse(x1, x2, method)
    //    y = imfuse(x1, x2, method, alpha)
    //
    // Parameters
    //    x1 : First image
    //    x2 : Second image
    //    method : Fusion method, currently supports "colordiff", "composite", "diff", "cascade", "max" and "min"
    //    alpha : Ratio for composite method, default 0.5
    //    y : Fused image
    //
    // Description
    //    The function combines two images using the selected fusion method.
    //
    // Examples
    //    I1 = imread(fullpath(getIPCVpath() + "/images/lena.bmp"));
    //    I2 = imread(fullpath(getIPCVpath() + "/images/lena7030.bmp"));
    //    [S,TR,ROT,SC] = imphasecorr(I1,I2);
    //    y = imfuse(I1,S,"colordiff");
    //    imshow(y);
    //
    // See also
    //     imtransform
    //     imphasecorr
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 4 then
        error("imfuse: Wrong number of input arguments.");
    end
    if rhs < 3 then method = "colordiff"; end
    if rhs < 4 then alpha = 0.5; end

    ipcv_imfuse_check_size(x1, x2);
    method = convstr(method, "l");

    select method
    case "colordiff"
        g1 = ipcv_imfuse_gray(x1);
        g2 = ipcv_imfuse_gray(x2);
        if typeof(g1(1)) <> typeof(g2(1)) | type(g1(1)) <> type(g2(1)) then
            g1 = im2double(g1);
            g2 = im2double(g2);
        end
        y = cat(3, g2, g1, g1);
    case "composite"
        if alpha < 0 | alpha > 1 then
            error("imfuse: alpha must be between 0 and 1.");
        end
        [a, b] = ipcv_imfuse_match_channels(x1, x2);
        y = (1 - alpha) .* im2double(a) + alpha .* im2double(b);
    case "diff"
        [a, b] = ipcv_imfuse_match_channels(x1, x2);
        if typeof(a(1)) == typeof(b(1)) & type(a(1)) == type(b(1)) then
            y = imabsdiff(a, b);
        else
            y = abs(im2double(a) - im2double(b));
        end
    case "cascade"
        [a, b] = ipcv_imfuse_match_channels(x1, x2);
        y = [a, b];
    case "max"
        [a, b] = ipcv_imfuse_match_channels(x1, x2);
        y = max(a, b);
    case "min"
        [a, b] = ipcv_imfuse_match_channels(x1, x2);
        y = min(a, b);
    else
        error("imfuse: Invalid image fusion method.");
    end
endfunction

function ipcv_imfuse_check_size(x1, x2)
    if size(x1, 1) <> size(x2, 1) | size(x1, 2) <> size(x2, 2) then
        error("imfuse: input images must have the same height and width.");
    end
endfunction

function channels = ipcv_imfuse_channels(x)
    dims = size(x);
    if size(dims, "*") == 2 then
        channels = 1;
    elseif size(dims, "*") == 3 then
        channels = dims(3);
    else
        error("imfuse: inputs must be 2-D grayscale or 3-D RGB images.");
    end
endfunction

function gray = ipcv_imfuse_gray(x)
    channels = ipcv_imfuse_channels(x);
    if channels == 1 then
        gray = x;
    elseif channels == 3 then
        gray = rgb2gray(x);
    else
        error("imfuse: inputs must be grayscale or RGB images.");
    end
endfunction

function [a, b] = ipcv_imfuse_match_channels(x1, x2)
    c1 = ipcv_imfuse_channels(x1);
    c2 = ipcv_imfuse_channels(x2);
    if c1 == c2 then
        a = x1;
        b = x2;
    elseif c1 == 1 & c2 == 3 then
        a = cat(3, x1, x1, x1);
        b = x2;
    elseif c1 == 3 & c2 == 1 then
        a = x1;
        b = cat(3, x2, x2, x2);
    else
        error("imfuse: inputs must be grayscale or RGB images.");
    end
endfunction
