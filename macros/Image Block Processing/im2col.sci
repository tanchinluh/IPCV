//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function y = im2col(x,blk)
    // Convert image into series of columns
    //
    // Syntax
    //      y = im2col(x,blk)
    //
    // Parameters
    //    x : Source Image
    //    blk : Block size [m,n]
    //
    // Description
    //    This function is used to convert the image to columns of vector for 
    //    faster processing as Scilab perform better with vectorization code.
    //
    // Examples
    //    A = testmatrix('mag',4);
    //    B = im2col(A,[3 3]);
    //    C = mean(B,1);
    //    D = matrix(C,[4,4])';
    //
    // See also
    //    imblockproc
    //    imblockslide
    //    imcolproc
    //
    // Authors
    //    Tan Chin Luh
    
    rhs=argn(2);

    // Error Checking
    if rhs < 2; error("Expect 2 arguments, source image and block size"); end    
    if length(blk)~= 2; error("Second argument must be a vector of 2"); end    

    m = blk(1);
    n = blk(2);

    [r,c] = size(x);

    if ~modulo(m,2)
        m = m+1;
    end

    if ~modulo(n,2)
        n = n+1;
    end

    row_pad = floor(m/2);
    col_pad = floor(n/2);

    x2 = PadImage(x, 0,0,0,row_pad,row_pad);
    x2 = PadImage(x2, 0,col_pad,col_pad,0,0);


    [r2,c2] = size(x2);

    winH=waitbar('Please Wait...');

    y = (zeros(m*n,prod(size(x))));

    cnt3 = 1;
    for cnt1 = row_pad+1:r2-row_pad

        waitbar(cnt1./(r2-row_pad),winH);

        for cnt2 = col_pad+1:c2-col_pad
            tempdata = (x2(cnt1-row_pad:cnt1+row_pad,cnt2-col_pad:cnt2+col_pad));
            y(:,cnt3) = [tempdata(:)];

            cnt3 = cnt3+1;

        end
    end

    close(winH);
endfunction
