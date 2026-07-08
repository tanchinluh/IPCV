//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================

function y = imnorm(x)
    // Normalize input 2-D Image to the range of 0-1 for double, or 0-255 for uint8
    //
    // Syntax
    //  y = imnorm(x)
    //
    // Parameters
    //  x : Input 2-D matrix
    //  y : Normalized output matrix
    //
    // Description
    //  This function is used to normalized the 2-D matrix to the range of 0-1, or 0-255 for uint8, 
    //  to ensure the 2-D matrix follows the image representation standard in double or uint8 format.
    //
    // Examples
    //  s = rand(5,5);
    //  s2 = imnorm(s);
    //  disp(s2);
    //
    // See also
    // 
    // Authors
    //    Tan Chin Luh
    //



    //
    if type(x(1)) == 1 then
        y = (x - min(x))/(max(x)-min(x));
    elseif type(x(1)) == 8
        y = im2double(x);
        if inttype(x(1)) == 11 then
            y = (y - min(y))/(max(y)-min(y)).*255;
            y = uint8(y);
        elseif inttype(x(1)) == 12 then
            y = (y - min(y))/(max(y)-min(y)).*65535;
            y = uint16(y);
        elseif inttype(x(1)) == 14 then
            y = (y - min(y))/(max(y)-min(y)).*2^32-1;
            y = uint32(y);
        else
            error('Unexpected error');
        end

    else
        error('Unexpected error');
    end




endfunction

