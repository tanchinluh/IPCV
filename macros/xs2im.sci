////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
// Copyright (C) 2012 - DIGITEO - Allan CORNET
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
// 
////////////////////////////////////////////////////////////

function im =  xs2im(win_num, varargin)
    //    Convert graphics to an image matrix.
    //    
    //    Syntax
    //      im = xs2im(win_num,[color])
    //    
    //    Parameters
    //      win_num : Integer scalar or vector.
    //      color : Optional integer. 0 means black and white and 1 means color. The default value is 1.
    //      im : The returned image, uint8 type hyper-matrix.
    //    
    //    Description
    //      xs2im convert the recorded graphics of the window win_num to an image matrix. This function works only if the selected driver is "Rec" in the window win_num or if the window is in "new style".
    //    
    //    Examples
    //      scf(0)
    //      plot2d()
    //      im = xs2im(0);
    //      imshow(im);
    //     
    //    See also
    //      im2double
    //    
    //    Authors
    //      Shiqi Yu
    //      Tan Chin Luh


    if length(varargin)==1 then
        iscolor = varargin(1);
    else
        iscolor = 1;
    end
    imfile = TMPDIR + "/ipcv-tmp-" + strcat(string(getdate())) + ".ppm";
    xs2ppm(win_num, imfile);
    im = imread(imfile);
    mdelete(imfile);
endfunction 
