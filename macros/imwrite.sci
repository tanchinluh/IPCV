////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function ret = imwrite(im, filename, compression_ratio)
    //    Write image to file
    //    
    //    Syntax
    //      ret=imwrite(im, filename)
    //    
    //    Parameters
    //      im : im can be an M-by-N (greyscale image) or M-by-N-by-3 (color image) matrix. If im is not of class uint8, imwrite will convert the datatype before writing using im2uint8(im) .
    //      filename : A string that specifies the name of the output file.
    //      ret : Return value. If the image is successfully writed into a file, ret will be 1.
    //    
    //    Description
    //      imwrite writes a matrix into a image file. The format of the file is inferred from the extension in the filename parameter. Currently the following file formats are supported:
    //    
    //    Examples
    //      im = rand(200,300);
    //      imwrite(im, 'rand.png');
    //      S = imread('rand.png');
    //      imshow(S);
    //     
    //    See also
    //      imread
    //      imshow
    //      imfinfo
    //    
    //    Authors
    //      Shiqi Yu
    //      Tan Chin Luh

    if  typeof(im) == 'uint16' then
        ret = int_imwrite(im, filename,compression_ratio);
    else
        ret = int_imwrite(im2uint8(im), filename,compression_ratio);
    end


endfunction
