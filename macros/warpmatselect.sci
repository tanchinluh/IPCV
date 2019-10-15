//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function pts = warpmatselect(S,n)
    // Selecting points for image transformation
    //
    // Syntax
    //    pts = warpmatselect(S,n)
    //
    // Parameters
    //    S : Input image
    //    n : Number of points to be selected
    //    pts : Returned points in image coordinates
    //
    // Description
    //    This function allows user to select points of references on image for registration purpose.
    //    The returned parameters are in image coordinates form.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/balloons.png"));
    //    pts = warpmatselect(S,3)
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
    if rhs < 1; error("Expect at least 1 argument, input image"); end    
    if rhs == 1; n = 3; end    

    imshow(S);
    pts = imselect(n);
    sz = size(S);
    pts(:,2) = sz(1) - pts(:,2);

endfunction
