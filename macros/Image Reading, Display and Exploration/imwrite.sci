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
    //      ret=imwrite(im, filename, format_option)
    //    
    //    Parameters
    //      im : im can be an M-by-N (greyscale image) or M-by-N-by-3 (color image) matrix. If im is not of class uint8, imwrite will convert the datatype before writing using im2uint8(im) .
    //      filename : A string that specifies the name of the output file.
    //      format_option : JPEG output quality from 0 to 100 for .jpg, .jpeg, and .jpe files, or PNG compression level from 0 to 9 for .png files.
    //      ret : Return value. If the image is successfully written into a file, ret will be 1.
    //      
    //    
    //    Description
    //      imwrite writes a matrix into an image file. The format of the file is inferred from the extension in the filename parameter.
    //      For PNG compression, 0 is fastest/largest and 9 is smallest/slowest. Other formats use OpenCV defaults.
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

    if ~exists("compression_ratio","local")  then
        compression_ratio = 75;
    end
    if  typeof(im) == 'uint16' then
        ret = int_imwrite(im, filename,compression_ratio);
    else
        ret = int_imwrite(im2uint8(im), filename,compression_ratio);
    end


endfunction
