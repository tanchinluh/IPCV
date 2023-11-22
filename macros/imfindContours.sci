//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function Sc = imfindContours(Sbw, rmode, method)
    // Finds contours in a binary image.
    //
    // Syntax
    //    Sc = imfindContours(Sbw, rmode, method)
    //
    // Parameters
    //    Sbw : Input binary image
    //    rmode : Contour retrieval mode, value 0-4 allowed
    //    0 : RETR_EXTERNAL 
    //    1 : RETR_LIST 
    //    2 : RETR_CCOMP 
    //    3 : RETR_TREE 
    //    4 : RETR_FLOODFILL 
    //    method : Contour approximation method, value 0-3 allowed
    //    0 : CHAIN_APPROX_NONE  
    //    1 : CHAIN_APPROX_SIMPLE  
    //    2 : CHAIN_APPROX_TC89_L1 
    //    3 : CHAIN_APPROX_TC89_KCOS 
    //    Sc : List which contains the coordinates for contours, each in one item in list.
    //     
    // Description
    //    This function used to find the contours of a binary image, returned in lists of coordinates.
    //
    // Examples
    //     S = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //     Sbw = im2bw(S,0.5);
    //     Sc = imfindContours(Sbw);
    //     implotContours(S,Sc,5)
    //
    // See also
    //     implotContours
    //     imconvexHull
    //     imconvexityDefects
    //     
    // Authors
    //    Tan Chin Luh
    //

    rhs = argn(2);
    // Error Checking
    if rhs < 1; error("This function needs at least 1 input"); end;
    if rhs < 2; rmode = 2; end;
    if rhs < 3; method = 1; end;

    if rmode == []; rmode = 2; end;
    if method == []; method = 1; end;
    
    if type(Sbw) ~= 4 then
        error("Only Binary image allowed."); 
    end
       
    Sc = int_imfindContours(Sbw, rmode, method);
     
endfunction










