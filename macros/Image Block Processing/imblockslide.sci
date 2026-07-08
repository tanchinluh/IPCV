//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function y = imblockslide(x,blk,func)
    // Sliding block processing for an image
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
    //    This function is block processing function with sliding blocks. 
    //    Sliding blocks are rectangular partitions that divide an image matrix 
    //    into m-by-n section
    //
    // Examples
    //    A = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
    //    deff('y=myfunc(x)','y = mean(x)');
    //    y = imblockslide(A,[9 9],'myfunc');
    //    imshow(y);
    //
    // See also
    //    imblockproc
    //    im2col 
    //    imcolproc
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
    //    y = uint8(zeros(r,c));
    y = (zeros(r,c));
    for cnt1 = row_pad+1:r2-row_pad

        waitbar(cnt1./(r2-row_pad),winH);

        for cnt2 = col_pad+1:c2-col_pad

            funcstr = strcat([func,'(x2(cnt1-row_pad:cnt1+row_pad,cnt2-col_pad:cnt2+col_pad))']);

            //x4 = func(x3(cnt1:cnt1+m-1,cnt2:cnt2+n-1)); 

            y(cnt1-row_pad,cnt2-col_pad) = evstr(funcstr);

        end
    end
    close(winH);


    if typeof(x(1)) == 'uint8' then
        y = uint8(y);
    end


endfunction
