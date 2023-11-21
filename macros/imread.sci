//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function S = imread(fn,modes)
    //    Reads image file - Add modes support
    //    
    //    Syntax
    //      im = imread(filename)
    //      im = imread(filename,modes) 
    //      im = imread(url)
    //    
    //    Parameters
    //      filename,url : A string, the image filename or a valid URL to be read. For the case of URL, the full syntax must be used. For example, "http://www.tritytech.com/images/phocagallery/roll8_ScilabIOT.png".
    //      modes : imread mode to be specified for different image format
    //      im : All images will be converted to gray images or RGB images. For gray images, this is a MxN unsigned char matrix; For RGB images, this is a MxNx3 unsigned char matrix.
    //    
    //    Description
    //      imread reads many types of image files into Scilab. The format of the file is inferred from the extension in the filename parameter. Currently the following file formats are supported:
    //    
    //      im = imread(filename)
    //    
    //      reads image in filename into im matrix. If filename contains a truecolor image, im is a MxNx3 hypermatrix, so for example im(:,:,1) stands for the red channel. For gray images, im is a MxNx1 unsigned char matrix.
    //    
    //    Examples
    //      im = imread(fullpath(getIPCVpath() + "/images/" + 'baboon.png'));
    //      imshow(im);
    //     
    //    See also
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
    IMREAD_IGNORE_ORIENTATION * uint8(128) 


    if grep(fn,'http://')
        fn = getURL(fn,TMPDIR)
    end
    S = int_imread(fn,modes);

    // if (sum(S==0)+sum(S==255)) == prod(size(S)) & size(S,3) ==1 then
    if (sum(S==0)+sum(S==255)) == prod(size(S)) then
        if size(S,3) == 4;
            S = S(:,:,1:3);
        end
        S = im2bw(S,0.5);
    end

endfunction
