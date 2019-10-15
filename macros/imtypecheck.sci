//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
// Non-documented internal function
function [y,dim] = imtypecheck(im)


    if ndims(im) < 2 then
        y = [];
        return;
    end;

    datatype = type(im(1));

    if (datatype ~= 1) & (datatype ~= 4) & (datatype ~= 8)
        y = [];
        return;
    end;

    select datatype
    case 1 //double    
        if min(im)<0 | max(im)>1 then
            warning('Image type of double should be in the range of 0-1, unless the output from processing functions such as fft/ifft. Please make sure you''re doing the right thing.');
        end
    case 4 // boolean 
    case 8 // int
        if typeof(im(1))~='uint8' then
            warning('The image type of ' + typeof(im(1)) + ', be sure before proceed.');
        end
    end
    y = datatype;

    dim = ndims(im);
endfunction
