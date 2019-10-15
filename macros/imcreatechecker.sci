//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imcreatechecker(n,col,tone)
    // Detect features from an image with FAST algorithm. Usually used for corner features.
    //
    // Syntax
    //     zz = imcreatechecker()
    //     zz = imcreatechecker(n)
    //     zz = imcreatechecker(n,col)
    //     zz = imcreatechecker(n,col,tone)
    //
    // Parameters
    //     n : Power of 2, to create the checker box with size of 2^n. Default value is 8
    //     col : Number of columns for the checker board. Default value is 8
    //     tone : in matrix [a b], which is the in starting and ending "grayness" of the white cells. Default value is [1 1].
    //     imout : Output image
    // 
    // Description
    //    This function used to detect the features of an image using FAST method.Good for corner detection.
    //
    // Examples
    //    S = imcreatechecker(8,8,[1 0.5]);
    //    imshow(S); 
    //
    // See also
    //     imread
    //     imwrite
    //
    // Authors
    //    Tan Chin Luh
    //

    rhs=argn(2);
   
    if rhs < 1; n = 8; end   
    if rhs < 2; col= 8; end
    if rhs < 3; tone= [1 1]; end
 
     if  n<3 | n > 10 then
         error('n should be between 3 to 10');
     end
     
     if modulo(col,2) ==1  | col<2 | col>32 then
         error('col must be an even number from 2 to 32');
     end
     
    sz = 2^n;
    xx = linspace(tone(1),tone(2),sz);
    imout = meshgrid(xx,xx');

    a = [sz/col:sz/col:sz];
    a_start = a(1:2:$)+1;
    a_stop = a(2:2:$);
    b_start = a_start-sz/col;
    b_stop =a_stop-sz/col;

    for cnt = 1:size(a_start,2)

        for cnt2 = 1:size(a_start,2)
            imout(a_start(cnt):a_stop(cnt),a_start(cnt2):a_stop(cnt2)) = 0;
        end

        for cnt2 = 1:size(a_start,2)
            imout(b_start(cnt):b_stop(cnt),b_start(cnt2):b_stop(cnt2)) = 0;
        end      
    end


endfunction
