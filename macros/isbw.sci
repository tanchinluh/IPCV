////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2007  Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
// Non-documented internal function
function [ret] = isbw(im)
    ret = %F;	

    if (argn(2) <> 1)
        error("Usage: isbw(im)");
    end

    //if not a 1-channel image
    if(~ (size(size(im),2) ==2) )
        return;
    end

    ret = typeof(im(1))=='boolean';
endfunction
