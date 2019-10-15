//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = rgb2lab(imin)
    // Convert from RGB color space to LAB color space
    //
    // Syntax
    //     imout = rgb2lab(imin)
    //
    // Parameters
    //    imin : RGB Image
    //    imout : LAB Image
    //
    // Description
    //    This function convert from rgb to lab
    //
    // Examples
    //
    // See also
    //
    // Authors
    //    Tan Chin Luh
    //



    imout = int_rgb2lab(imin);

endfunction

