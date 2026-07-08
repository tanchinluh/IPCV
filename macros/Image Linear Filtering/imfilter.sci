////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006 Shiqi Yu
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////

function imf = imfilter(A, F, bound, opsz);
    // Image filtering
    //
    // Syntax
    //      imf = imfilter(im, F, bound, opsz)
    //
    // Parameters
    //      im : An image which will be filterd. The image can be UINT8, INT8, UINT16, INT16, INT32, DOUBLE.
    //      F : A double 2D filter.
    //      imf : The filtered image which has the same dimension and class with im .
    //      bound : Type of boundary, values or keywords. Current supported type with keyword is 'circular'.
    //      opsz : Output image size, either 'full' or 'same'. 
    //
    // Description
    //      imfilter filters an image im with filter F. When im is a mult-channel image, each channel can be filtered with F seperately. Input image pixel values outside the bounds of the image are assumed to equal the nearest array border value.
    //
    //      The only diffence of filter2 with imfilter is the output of filter2 is double matrix, and the output of imfilter has the same type as input and the elements in the output matrix that exceed the range of the integer type will be truncated.
    //
    // Examples
    //      im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //      filter = fspecial('sobel');
    //      imf = imfilter(im, filter);
    //      imshow(imf);
    //
    // See also
    //      fspecial
    //      filter2
    //
    // Authors
    //      Tan Chin Luh
    //

    rhs=argn(2);

    // Error Checking
    if rhs < 2; error("Expect 2 arguments, source image and filter kernel"); end    

    // Setting default behavior
    if rhs == 2; bound = []; opsz = 'same'; end
    if rhs == 3; opsz = 'same'; end
    if bound == []; bound = []; end
    if opsz == []; opsz = 'same'; end

    // Checking size
    [r c] = size(F);
    //[imr,imc,d] = size(A);
    dim = size(A);
    imr = dim(1);
    imc = dim(2);

    if length(dim) == 3 then
        d = dim(3);
    else
        d = 1;
    end


    r2 = floor(r/2);
    c2 = floor(c/2);

    if type(bound) == 1 & ~isempty(bound) then


        for cnt = 1:d
            if typeof(A(1)) == 'constant'  then
                B(:,:,cnt) = PadImage(A(:,:,cnt),bound,c2,c2,r2,r2);
            else
                B(:,:,cnt) = uint8(PadImage(A(:,:,cnt),bound,c2,c2,r2,r2));
            end

        end

        clear A;
        A = int_imfilter(B,F);        
        clear B;



    elseif type(bound) == 10
        select bound
        case  'circular' then

            for cnt = 1:d
                if typeof(A(1)) == 'constant'  then
                    B(:,:,cnt) = [A($-r2+1:$,$-c2+1:$,cnt)     A($-r2+1:$,:,cnt)     A($-r2+1:$,1:c2,cnt);...
                    A(:,$-c2+1:$,cnt)           A(:,:,cnt)                A(:,1:c2,cnt);...
                    A(1:r2,$-c2+1:$,cnt)       A(1:r2,:,cnt)       A(1:r2,1:c2,cnt);];
                else
                    B(:,:,cnt) = uint8([A($-r2+1:$,$-c2+1:$,cnt)     A($-r2+1:$,:,cnt)     A($-r2+1:$,1:c2,cnt);...
                    A(:,$-c2+1:$,cnt)           A(:,:,cnt)                A(:,1:c2,cnt);...
                    A(1:r2,$-c2+1:$,cnt)       A(1:r2,:,cnt)       A(1:r2,1:c2,cnt);]);

                end

            end

            clear A;
            A = int_imfilter(B,F);
            clear B;

        case 'symmetric' then

        case 'replicate' then 

        end


        select opsz
        case 'same' then

            for cnt = 1:d
                imf(:,:,cnt) = A(1+r2:$-r2,1+c2:$-c2,cnt);
            end


        case 'full' then
            imf = A;
        end

        clear A;


    elseif isempty(bound)
        A = int_imfilter(A,F);
        imf = A;
        clear A;


    else
        error('Boundary option should be either numerical value or keywords');
    end






endfunction
