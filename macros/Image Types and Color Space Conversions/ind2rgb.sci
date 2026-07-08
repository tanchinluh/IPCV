////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
//=============================================================================
// Copyright (C) Trity Technologies - 2017 -
// http://www.gnu.org/licenses/gpl-2.0.txt
//=============================================================================
function imout = ind2rgb(imin,map)
    // Convert index image to RGB image 
    //
    // Syntax
    //    imout = ind2rgb(imin,map)
    //
    // Parameters
    //    imin : Source indexed image    
    //    map : Colormap
    //    imout : Output rgb image    
    //
    // Description
    //    This function convert the index image to RGB image with its' index and colormap. The output image is in double format.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/puffin.png"));
    //    [X,map] = rgb2ind(S,8);
    //    imshow(X,map);
    //    S2 = ind2rgb(X,map);
    //    scf();imshow(S2)
    //
    // See also
    //    rgb2ind
    //
    // Authors
    //    Tan Chin Luh
    
    rhs=argn(2);
    if rhs < 2; error("Expect 2 arguments, input indexed image and colormap"); end    
    S = map(imin,:);
    imout = matrix(S,[size(imin) 3]);
endfunction
