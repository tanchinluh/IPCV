////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function [s] = stdev2(im)
    //    Standard deviation of 2D matrix elements
    //    
    //    Syntax
    //      s = std2(im)
    //      s = stdev2(im)
    //    
    //    Parameters
    //      im : An matrix/image, which can be integer or double matrix, but must be one channel image.
    //      s : The standard deviation, a scalar of class double.
    //    
    //    Description
    //      std2/stdev2 computes standard deviation of matrix im using stdev(im(:)).
    //    
    //    See also
    //      mean2
    //      corr2
    //    
    //    Authors
    //      Shiqi Yu
    //      Tan Chin Luh

    
    if (size(size(im), 2) >=3) then
        error("The input must be 2D matrix.");
    end

    s = stdev(double(im(:)));
endfunction
