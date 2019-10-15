//=============================================================================
// Copyright (C) Trity Technologies - 2012 -
// http://www.gnu.org/licenses/gpl-2.0.txt
//=============================================================================
function y = tifread(fn)
    // Special function to read 12-bits 1024x1024 CCD image
    //
    // Syntax
    //     y = tifread(fn)
    //
    // Parameters
    //    fn : Tiff image file name
    //    y : Imported image
    //
    // Description
    //    This function is experimental, to read in fixed size of 12 bits tif image file
    //
    // Examples
    //
    // See also
    //     imread
    //
    // Authors
    //    Copyright (C) 2012 - Trity Technologies.
    //



    fid = mopen(fn);

    mseek(8, fid);

    byte12bit = 1024*1024;
    byte8bit = 1024*1024*12/8;

    bytes = mgetstr(byte8bit, fid);

    b = ascii(bytes);

    //row = 512;
    s = int_tifread(length(b),b);

    y = matrix(s,1024,1024)';
    mclose(fid);
endfunction
