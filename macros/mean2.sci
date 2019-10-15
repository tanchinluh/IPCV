////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//  
////////////////////////////////////////////////////////////
function [m] = mean2(im)
    //    Average/mean of matrix elements
    //    
    //    Syntax
    //      m = mean2(im)
    //    
    //    Parameters
    //      im : An image, which can be integer or double matrix, but must be one channel image.
    //      m : The mean of the values in im , a scalar of class double.
    //    
    //    Description
    //      mean2 computes the mean of a matrix using mean(im(:)).
    //    
    //    See also
    //      corr2
    //      std2
    //      stdev2
    //    
    //    Authors
    //      Shiqi Yu
    //      Tan Chin Luh


    
    if (size(size(im), 2) >=3) then
        error("The input must be 2D matrix.");
    end

    m = mean(double(im(:)));
endfunction
