//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function y = imfuse(x1,x2,method,alpha);
    // Image fusion
    //
    // Syntax
    //    y = imfuse(x1,x2,method,alpha);
    //
    // Parameters
    //    x1 : First image
    //    x2 : Second image
    //    method : Fusion method, currently support 'colordiff', 'composite', 'diff','cascade', 'max' and 'min'
    //    alpha : ration for composite method
    //    y : Fused image
    //
    // Description
    //    The function combine 2 images together using different method.
    // 
    // Examples
    //    I1 = imread(fullpath(getIPCVpath() + "/images/lena.bmp"));
    //    I2 = imread(fullpath(getIPCVpath() + "/images/lena7030.bmp"));
    //    [S,TR,ROT,SC]=imphasecorr(I1,I2);
    //    y = imfuse(I1,S,'colordiff');
    //    imshow(y);
    //
    // See also
    //     imfeaturematch
    //     imtransform
    //     
    // Authors
    //    Tan Chin Luh


    //

    select method
    case 'colordiff'
        y(:,:,1) = x2;
        y(:,:,2) = x1;        
        y(:,:,3) = x1;
    case 'composite'
        //alpha = 0.6;
        y = imadd((1-alpha).*im2double(x1),alpha.*im2double(x2));
    case 'diff'
        y = imabsdiff(x1,x2);
    case 'cascade'
        y = [x1,x2];
    case 'max'
        y = max(x1,x2);
    case 'min'
        y = min(x1,x2);   
    else
        error('Invalid image fusion method');

    end



endfunction








