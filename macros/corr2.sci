////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function [c] = corr2(imA, imB)
    // 2D correlation coefficient
    //
    // Syntax
    //    c = corr2(imA, imB)
    //
    // Parameters
    //    imA, imB : imA and imB are 2D matrices of the same size.
    //    c : Correlation coefficient, a scalar of class double.
    //
    // Description
    //    corr2 computes correlation coefficient of two 2D matrices imA and imB.
    //    c = sum( (imA-mA).*(imB-mB) / sqrt(sum((imA-mA).^2) * sum((imB-mB).^2))
    //    mA=mean2(imA) and mB=mean2(imB)
    //
    // Examples
    //
    // See also
    //    mean2
    //    std2
    //    stdev2 
    //
    // Authors
    //    Tan Chin Luh. Modified from the original work of Shiqi Yu
        
    if ( (size(size(imA), 2) >=3) | (size(size(imB), 2) >=3)) then
        error("The input must be 2D matrix.");
    end

    //check the image width and height
    if( or( size(imA)<>size(imB) )) then
        //error("The two inputs do not have the same size.");
        //c = filter2(imB,imA);
        c = filter2(imA,imB);
    else

    difA = double(imA) - mean2(imA);
    difB = double(imB) - mean2(imB);

    c = sum( difA.*difB ) / sqrt(sum(difA.^2) * sum(difB.^2));
    end
endfunction
