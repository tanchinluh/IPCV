//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2026  Tan Chin Luh
//=============================================================================
function overlay = imshow_segmentation(image, mask, rgb, alpha, titleText)
    // Display an image with a segmentation mask overlay.
    //
    // Syntax
    //    overlay = imshow_segmentation(image, mask)
    //    overlay = imshow_segmentation(image, mask, rgb, alpha, titleText)
    //
    // Parameters
    //    image : Input image.
    //    mask : Binary or label mask.
    //    rgb : Optional RGB overlay color, default [255 0 0].
    //    alpha : Optional foreground opacity from 0 to 1, default 0.35.
    //    titleText : Optional figure title.
    //    overlay : RGB overlay image displayed by the function.
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 5 then
        error("imshow_segmentation: Wrong number of input arguments.");
    end
    if rhs < 3 then rgb = [255 0 0]; end
    if rhs < 4 then alpha = 0.35; end
    if rhs < 5 then titleText = "Segmentation"; end

    overlay = imoverlaymask(image, mask, rgb, alpha, %t);
    scf();
    imshow(overlay);
    if titleText <> "" then
        title(titleText);
    end
endfunction
