//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function [] = impixelval(S)
    // Interactive tool to inspect pixel value at selected point
    //
    // Syntax
    //    impixelval(S)
    //
    // Parameters
    //    S : Scilab Image
    //
    // Description
    //    This is an interactive tool to inspect pixel value by clicking the mouse butoon on the figure
    //
    // Examples
    //  S = imread(getIPCVpath() + "/images/" + "balloons.png");
    //  impixelval(S)
    //
    // See also
    //    impixel, improfile, iminspect
    //
    // Authors
    //    Tan Chin Luh
    //    
imshow(S);
//realtimeinit(2.00);
seteventhandler('impixel_event');

endfunction
