//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function S = imread(fn)
    //    Reads image file
    //    
    //    Syntax
    //      im = imread(filename) 
    //      im = imread(url)
    //    
    //    Parameters
    //      filename,url : A string, the image filename or a valid URL to be read. The extension determines the type of the image. For the case of URL, the full syntax must be used. For example, "http://www.tritytech.com/images/phocagallery/roll8_ScilabIOT.png".
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

    if grep(fn,'http://')
        fn = getURL(fn,TMPDIR)
    end
    S = int_imread(fn);
    
    // if (sum(S==0)+sum(S==255)) == prod(size(S)) & size(S,3) ==1 then
    if (sum(S==0)+sum(S==255)) == prod(size(S)) then
        if size(S,3) == 4;
            S = S(:,:,1:3);
        end
        S = im2bw(S,0.5);
    end
    
endfunction
