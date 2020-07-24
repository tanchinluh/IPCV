//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function S = imreadmulti(fn,modes)
    //    Reads multi pages image file 
    //    
    //    Syntax
    //      im = imreadmulti(filename)
    //      im = imreadmulti(filename,modes) 
    //    
    //    Parameters
    //      filename : A string, the image filename to be read.
    //      modes : imread mode to be specified for different image format
    //      im : All images will be converted to gray images or RGB images. For gray images, this is a MxN unsigned char matrix; For RGB images, this is a MxNx3 unsigned char matrix.
    //    
    //    Description
    //      imreadmulti reads multi pages image files into Scilab as 4 dimentions matrix.
    //    
    //    Examples
    //      im = imreadmulti(fullpath(getIPCVpath() + "/images/" + 'img_multipage.tiff'));
    //      imshow(im(:,:,:,1);
    //     
    //    See also
    //      imread
    //      imwrite
    //      imshow
    //      imfinfo
    //    
    //    Authors
    //      Tan Chin Luh



    // Checking Input Arguement
    rhs = argn(2);

    if rhs < 1 then error("Expect at least 1 argument, N, which is the Network topology"); end;
    if rhs == 1 then IMREAD_ANYDEPTH=1,IMREAD_ANYCOLOR = 1, end
    if ~isdef('IMREAD_GRAYSCALE')|IMREAD_GRAYSCALE==[] then IMREAD_GRAYSCALE = 0;end;
    if ~isdef('IMREAD_COLOR')|IMREAD_COLOR==[] then IMREAD_COLOR = 0;end;
    if ~isdef('IMREAD_ANYDEPTH')|IMREAD_ANYDEPTH==[] then IMREAD_ANYDEPTH = 0;end;
    if ~isdef('IMREAD_ANYCOLOR')|IMREAD_ANYCOLOR==[] then IMREAD_ANYCOLOR = 0;end;
    if ~isdef('IMREAD_LOAD_GDAL')|IMREAD_LOAD_GDAL==[] then IMREAD_LOAD_GDAL = 0;end;
    if ~isdef('IMREAD_REDUCED_GRAYSCALE_2')|IMREAD_REDUCED_GRAYSCALE_2==[] then IMREAD_REDUCED_GRAYSCALE_2 = 0;end;
    if ~isdef('IMREAD_REDUCED_COLOR_2')|IMREAD_REDUCED_COLOR_2==[] then IMREAD_REDUCED_COLOR_2 = 0;end;
    if ~isdef('IMREAD_REDUCED_GRAYSCALE_4')|IMREAD_REDUCED_GRAYSCALE_4==[] then IMREAD_REDUCED_GRAYSCALE_4 = 0;end;
    if ~isdef('IMREAD_REDUCED_COLOR_4')|IMREAD_REDUCED_COLOR_4==[] then IMREAD_REDUCED_COLOR_4 = 0;end;
    if ~isdef('IMREAD_REDUCED_GRAYSCALE_8')|IMREAD_REDUCED_GRAYSCALE_8==[] then IMREAD_REDUCED_GRAYSCALE_8 = 0;end;
    if ~isdef('IMREAD_REDUCED_COLOR_8')|IMREAD_REDUCED_COLOR_8==[] then IMREAD_REDUCED_COLOR_8 = 0;end;
    if ~isdef('IMREAD_IGNORE_ORIENTATION')|IMREAD_IGNORE_ORIENTATION==[] then IMREAD_IGNORE_ORIENTATION = 0;end;

    modes = IMREAD_GRAYSCALE * uint8(0) | ..
    IMREAD_COLOR * uint8(1) | ..
    IMREAD_ANYDEPTH * uint8(2) | ..
    IMREAD_ANYCOLOR * uint8(4) | ..
    IMREAD_LOAD_GDAL * uint8(8) | ..
    IMREAD_REDUCED_GRAYSCALE_2 * uint8(16) | ..
    IMREAD_REDUCED_COLOR_2 * uint8(17) | ..
    IMREAD_REDUCED_GRAYSCALE_4 * uint8(32) | ..
    IMREAD_REDUCED_COLOR_4 * uint8(33) | ..
    IMREAD_REDUCED_GRAYSCALE_8 * uint8(64) | ..
    IMREAD_REDUCED_COLOR_8 * uint8(65) | ..
    IMREAD_IGNORE_ORIENTATION * uint8(128);
    
    S = int_imreadmulti(fn,modes);


endfunction
