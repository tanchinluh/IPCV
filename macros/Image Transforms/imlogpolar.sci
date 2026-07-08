//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function y = imlogpolar(x,m);
    // Remaps an image to log-polar space.
    //
    // Syntax
    //    y = imlogpolar(x,m);
    //
    // Parameters
    //    x : Input image
    //    m : Magnitude scale parameter
    //    y : Output image
    //
    // Description
    //    The function cvLogPolar transforms the source image using the following transformation:
    //    p = m*log(sqrt(x^2 + y^2)), phi = atan(y/x)
    // 
    // Examples
    //    x = imread(fullpath(getIPCVpath() + "/images/balloons.png"));
    //    y = imlogpolar(x);
    //    imshow(y);
    //
    // See also
    //     imgettransform
    //     imtransform
    //     
    // Authors
    //    Tan Chin Luh
    //


    //

    rhs=argn(2);
    sz = size(x);

    if rhs < 1; error("Expect at least 1 argument, input image"); end    
    if rhs == 1; 
        fac=max(sz);
        m = round(fac/(log(fac/2)));
    end    

    y = int_imlogpolar(x,m);

endfunction



