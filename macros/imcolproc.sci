//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function y = imcolproc(x,blk,func)
    // Sliding block processing for an image, with vectorization
    //
    // Syntax
    //     y = imblockproc(x,blk,func)
    //
    // Parameters
    //    x : Source Image
    //    blk : Block size [m,n]
    //    func : A function name which provide the processing function. The fucntion
    //    must be loaded into memory first or it must be in the current directory.
    //
    // Description
    //    This function is block processing function with sliding blocks, with each
    //    sliding blocks converted to column matrix for faster performance.
    //
    // Examples
    //    A = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
    //    deff('y=myfunc(x)','y = mean(x,1)');
    //    y = imcolproc(A,[9 9],'myfunc');
    //    imshow(y);
    //
    // See also
    //    imblockproc
    //    imblockslide
    //    im2col 
    //
    // Authors
    //    Tan Chin Luh
    //




    rhs=argn(2);

    // Error Checking
    if rhs < 3; error("Expect 3 arguments, source image, block size, and function"); end    
    if length(blk)~= 2; error("Second argument must be a vector of 2"); end    

    m = blk(1);
    n = blk(2);

    [r,c] = size(x);

    x2 = im2col(x,[m n]);

    funcstr = strcat([func,'(x2)']);

    x3 = evstr(funcstr);    

    y = matrix(x3,c,r)';

    if typeof(x(1)) == 'uint8' then
        y = uint8(y);
    end

endfunction

