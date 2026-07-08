//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function circles = imhoughc(S)
    // Hough circle detection
    //
    // Syntax
    //    circles = imhoughc(S)
    //
    // Parameters
    //    S : Source image.
    //    circles : A 3-by-N matrix. Each column contains [x; y; radius].
    //
    // Description
    //    Detects circles in an image using OpenCV HoughCircles.
    //
    // Examples
    //    S = uint8(zeros(120, 120));
    //    t = 0:%pi/180:2*%pi;
    //    x = round(60 + 30*cos(t));
    //    y = round(60 + 30*sin(t));
    //    S(sub2ind(size(S), y, x)) = 255;
    //    circles = imhoughc(S);
    //
    // See also
    //    imhough
    //    imradon
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 1 then
        error("At least 1 argument expected, an image");
    end

    circles = int_imhoughcircles(S);
endfunction
