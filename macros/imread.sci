//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
// Copyright (C) 2025 - UTC - Stéphane Mottelet
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
    //      filename,url : A string, the image filename or a valid URL to be read. For the case of URL, the full syntax must be used. For example, "https://gitlab.com/uploads/-/system/project/avatar/3330423/puffin.png".
    //      modes : imread mode to be specified for different image format
    //  
    //      im : All images will be converted to gray images or RGB images. For gray images, this is a MxN unsigned char matrix; For RGB images, this is a MxNx3 unsigned char matrix.
    //    
    //    Description
    //      imread reads many types of image files into Scilab. The format of the file is inferred from the extension in the filename parameter. Currently the following file formats are supported:
    //    
    //      im = imread(filename)
    //    
    //      reads image in filename into im matrix. If filename contains a truecolor image, im is a MxNx3 hypermatrix, so for example im(:,:,1) stands for the red channel. For gray images, im is a MxNx1 unsigned char matrix.
    //
    //    The imread mode can be controlled by setting any of these optional arguments to 1:
    //
    //    IMREAD_UNCHANGED (return the loaded image as is (with alpha channel, otherwise it gets cropped). Ignore EXIF orientation)
    //
    //    IMREAD_GRAYSCALE (convert image to the single channel grayscale image)
    //
    //    IMREAD_COLOR (convert image to the 3 channel color image)
    //
    //    IMREAD_ANYDEPTH (return 16-bit/32-bit image when the input has the corresponding depth, otherwise convert it to 8-bit)
    //
    //    IMREAD_ANYCOLOR (the image is read in any possible color format)
    //
    //    IMREAD_LOAD_GDAL (use the gdal driver for loading the image)
    //
    //    IMREAD_REDUCED_GRAYSCALE_2 (convert image to the single channel grayscale image and the image size reduced 1/2)
    //
    //    IMREAD_REDUCED_COLOR_2 (convert image to the 3 channelcolor image and the image size reduced 1/2)
    //
    //    IMREAD_REDUCED_GRAYSCALE_4 (convert image to the single channel grayscale image and the image size reduced 1/4)
    //
    //    IMREAD_REDUCED_COLOR_4 (convert image to the 3 channelcolor image and the image size reduced 1/4)
    //
    //    IMREAD_REDUCED_GRAYSCALE_8  (convert image to the single channel grayscale image and the image size reduced 1/8)
    //
    //    IMREAD_REDUCED_COLOR_8 (convert image to the 3 channelcolor image and the image size reduced 1/8)
    //
    //    IMREAD_IGNORE_ORIENTATION (do not rotate the image according to EXIF's orientation flag)
    //    
    //    Examples
    //      im = imread(fullpath(getIPCVpath() + "/images/" + 'baboon.png'));
    //      imshow(im);
    //
    //      im = imread(fullpath(getIPCVpath() + "/images/" + 'puffin.png'),IMREAD_UNCHANGED=1);
    //      imshow(im);
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
    if rhs == 1 then IMREAD_ANYCOLOR=1,IMREAD_ANYDEPTH=1 end
    if ~isdef('IMREAD_UNCHANGED')|IMREAD_UNCHANGED==[] then IMREAD_UNCHANGED = 0;end;
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

    modes =  IMREAD_UNCHANGED * int8(-1) | ..
    IMREAD_GRAYSCALE * int8(0) | ..
    IMREAD_COLOR * int8(1) | ..
    IMREAD_ANYDEPTH * int8(2) | ..
    IMREAD_ANYCOLOR * int8(4) | ..
    IMREAD_LOAD_GDAL * int8(8) | ..
    IMREAD_REDUCED_GRAYSCALE_2 * int8(16) | ..
    IMREAD_REDUCED_COLOR_2 * int8(17) | ..
    IMREAD_REDUCED_GRAYSCALE_4 * int8(32) | ..
    IMREAD_REDUCED_COLOR_4 * int8(33) | ..
    IMREAD_REDUCED_GRAYSCALE_8 * int8(64) | ..
    IMREAD_REDUCED_COLOR_8 * int8(65) | ..
    IMREAD_IGNORE_ORIENTATION * int8(128) 

    if [ grep(fn,'http://') grep(fn,'https://') ]
        fn = http_get(fn,fullfile(TMPDIR,hash(fn,"md5")))
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