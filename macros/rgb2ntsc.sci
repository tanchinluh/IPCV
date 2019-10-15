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

function yiqm = rgb2ntsc (rgbm)
//    Convert a RGB image to the equivalent NTSC image YIQ.
//    
//    Syntax
//      YIQ = rgb2ntsc(RGB)
//    
//    Parameters
//      RGB : A RGB image (hypermat), the dimension of RGB should be M x N x 3 .
//      YIQ : Output image, which has the same size as RGB and type of double.
//    
//    Description
//      rgb2ntsc convert a RGB image to the equivalent NTSC image YIQ using:
//    
//      Y = 0.299*R + 0.587*G + 0.114*B
//    
//      I = 0.596*R - 0.274*G - 0.322*B
//    
//      Q = 0.212*R - 0.523*G - 0.311*B
//    
//      Supported classes: INT8, UINT8, INT16, UINT16, INT32, DOUBLE. If RGB is not a double image, it will be converted to double image first in the procedure.
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
//      ntsc2rgb
//    
//    Authors
//      Shiqi Yu
//      Ricardo Fabbri 
//      Tan Chin Luh




    if argn(2)~=1 then
        error('Invalid number of arguments.')
    end

    rgbm = im2double(rgbm);

    rgb2yiqm= [ 0.299 0.587    0.114
    0.596 -0.274   -0.322 
    0.212 -0.523   0.311];

    dims = size(rgbm)
    select size(dims,'*')
        //case 2   // nx3 colormap
        //   if dims(2)<>3 then
        //      error('Colormap matrix must have 3 columns.')
        //   end
        //   yiqm = rgb2yiqm*rgbm'
        //   yiqm = yiqm'
    case 3  // mxnx3 rgb hypermatrix
        if dims(3)<>3 then
            error('RGB image must have dimentions m x n x 3.')
        end
        rgbm = matrix(rgbm,dims(1)*dims(2),3);
        yiqm = rgb2yiqm*rgbm'
        yiqm = matrix(yiqm',dims)
    else
        error('Incorrect dimentions of 1st. argument.')
    end

endfunction
