//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function info = imfinfo(filename)
    //    Read image file information
    //
    //    Syntax
    //      info = imfinfo(filename)
    //
    //    Parameters
    //      filename : A string, the image filename to inspect.
    //      info : A list containing image size, OpenCV depth code, channel count, and page count.
    //
    //    Description
    //      imfinfo reads basic image metadata without returning image pixels.
    //      info(1) is [width height], info(2) is the OpenCV depth code, info(3) is the channel count, and info(4) is the page or frame count.
    //      Depth codes are 0=uint8, 1=int8, 2=uint16, 3=int16, 4=int32, 5=single, and 6=double.
    //
    //    Examples
    //      filename = fullpath(getIPCVpath() + "/images/" + "baboon.png");
    //      info = imfinfo(filename);
    //      info(1)
    //      info(3)
    //      info(4)
    //
    //    See also
    //      imread
    //      imreadmulti
    //      imwrite
    //
    //    Authors
    //      Tan Chin Luh

    rhs = argn(2);
    if rhs <> 1 then
        error("imfinfo: Expect one input argument, image filename.");
    end
    if typeof(filename) <> "string" | size(filename, "*") <> 1 then
        error("imfinfo: filename must be a scalar string.");
    end

    info = int_imfinfo(filename);
endfunction
