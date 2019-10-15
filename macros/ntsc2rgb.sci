////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// SIP - Scilab Image Processing toolbox
// Copyright (C) 2002-2004  Ricardo Fabbri
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////


function rgbm = ntsc2rgb (yiqm)
    //    Convert a NTSC image to the equivalent RGB image.
    //    
    //    Syntax
    //      RGB = ntsc2rgb(YIQ)
    //    
    //    Parameters
    //      YIQ : A NTSC image (hypermat). The dimension of NTSC should be M x N x 3 , the type should be double and the element value range should be [0,1].
    //      RGB : Output image, which has the same size as NTSC and type of double.
    //    
    //    Description
    //      ntsc2rgb convert a NTSC image to the equivalent RGB image using:
    //    
    //      R = Y + 0.956*I + 0.621*Q
    //    
    //      G = Y - 0.272*I - 0.647*Q
    //    
    //      B = Y - 1.105*I - 1.702*Q
    //    
    //      Supported classe: DOUBLE.
    //    
    //    Examples
    //      RGB = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //      YIQ = rgb2ntsc(RGB);
    //      RGB = ntsc2rgb(YIQ);
    //      imshow(RGB);
    //     
    //    See also
    //      rgb2gray
    //      mat2gray
    //      rgb2hsv
    //      hsv2rgb
    //      rgb2ycbcr
    //      ycbcr2rgb
    //      rgb2ntsc 
    //    
    //    Authors
    //      Shiqi Yu 
    //      Ricardo Fabbri 
    //      Tan Chin Luh


    if argn(2)~=1 then
        error('Invalid number of arguments.')
    end

    yiq2rgbm= [ 1  0.956    0.621
    1  -0.272   -0.647
    1  -1.105   1.702]


    dims = size(yiqm)
    select size(dims,'*')
        //case 2   // nx3 colormap
        //   if dims(2)<>3 then
        //      error('Colormap matrix must have 3 columns.')
        //   end
        //   rgbm = yiq2rgbm*yiqm'
        //   rgbm = rgbm'
    case 3  // mxnx3 YIQ hypermatrix
        if dims(3)<>3 then
            error('NTSC image must have dimentions m x n x 3.')
        end
        yiqm = matrix(yiqm,dims(1)*dims(2),3);
        rgbm = yiq2rgbm*yiqm'
        rgbm = matrix(rgbm',dims)
    else
        error('Incorrect dimentions of 1st. argument.')
    end

endfunction

