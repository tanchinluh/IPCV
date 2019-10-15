//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function se = imcreatese(setype,r,c)
    // Creating Structure Element for Morphological operation
    //
    // Syntax
    //    se = imcreatese(setype,r,c)
    //
    // Parameters
    //    setype : Type of structure element, currently support 'rect', 'ellipse' and 'cross'
    //    r : Number of rows
    //    c : Number of colomns
    //    se : Created structure element
    //
    // Description
    //    The function constructs and returns the structuring element that can be 
    //    further passed to any morphology filter. You can also construct an arbitrary 
    //    mask yourself and use it as the structuring element
    //
    // Examples
    //    a = zeros(10,10);
    //    a(4:7,4:7) = 1;
    //    se = imcreatese('rect',3,3);
    //    b = imdilate(a,se);
    //    disp(b);
    //
    // See also
    //    imcreatese
    //    imdilate
    //    imerode
    //    imopen
    //    imclose
    //    imgradient
    //    imtophat
    //    imblackhat
    //
    // Authors
    //    Tan Chin Luh
    //


    //

    // Error Checking
    rhs=argn(2);

    if rhs < 3; error("Expect 3 arguments, se type, rows and cols"); end
    // End of Error Checking

    str = strstr(['rect','ellipse','cross'],setype);

    if isempty(str)|sum(length(str)~=0)>1 then
        error('SE tpye must be either ''rect'', ''ellipse'' and ''cross''');
    end


    select strcat(str)
    case 'rect'
        se = int_imcreatese(int8(0),int8(r),int8(c));
    case 'cross' then
        se = int_imcreatese(int8(1),int8(r),int8(c));
    case 'ellipse' then
        se = int_imcreatese(int8(2),int8(r),int8(c));    
    else
        error('unexpected error');
    end



endfunction



