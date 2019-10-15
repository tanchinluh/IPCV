//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function y = imblockproc(x,blk,func)
    // Distict block processing for an image
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
    //    This function is block processing function with distinct blocks. 
    //    Distinct blocks are rectangular partitions that divide an image matrix 
    //    into m-by-n section
    //
    // Examples
    //    A = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
    //    deff('y=myfunc(x)','y = mean(x)');
    //    y = imblockproc(A,[9 9],'myfunc');
    //    imshow(y);
    //
    // See also
    //    imblockslide
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

    bottompad = modulo(r,m);
    if bottompad ~=0
        x2 = PadImage(x, 0,0,0,0,m-bottompad);
    else 
        x2 = x;
    end

    rightpad = modulo(c,n);
    if rightpad ~=0
        x2 = PadImage(x2, 0,0,n-rightpad,0,0);
    end

    [r2,c2] = size(x2);
    x3 = x2;

    m_block = r2/m;
    n_block = c2/n;

    // To load the function
    if ~isdef(func) then
        exec(func+'.sci');
    end

    funcstr = strcat([func,'(x3(m*(1-1)+1:m*1,n*(1-1)+1:n*1))']);
    y_temp = evstr(funcstr);

    [r3,c3] = size(y_temp);

    m_div_fac = r3/m;
    n_div_fac = c3/n;

    // Modified to remain the datatype of output image to be same as input
    //y = uint8(zeros(m_block.*r3,n_block.*c3));
    y = (zeros(m_block.*r3,n_block.*c3));
    
    for cnt1 = 1:m_block
        for cnt2 = 1:n_block

            funcstr = strcat([func,'(x3(m*(cnt1-1)+1:m*cnt1,n*(cnt2-1)+1:n*cnt2))']);

            //x4 = func(x3(cnt1:cnt1+m-1,cnt2:cnt2+n-1)); 
            y(m*m_div_fac*(cnt1-1)+1:m*m_div_fac*cnt1,n*n_div_fac*(cnt2-1)+1:n*n_div_fac*cnt2) = evstr(funcstr);
        end
    end
//pause

    if typeof(x(1)) == 'uint8' then
        y = uint8(y);
    end
    

    
endfunction
