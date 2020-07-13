//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imrotate(im1,deg,crp)
    // Rotate an image to given angle
    //
    // Syntax
    //     imout = imrotate(im1,deg,crp)
    //
    // Parameters
    //    im1 : Source Image
    //    deg : Rotational angle in degree, positive indicating anti-clockwise direction
    //    crp : Returns only central portion output image which is the same size as source if set to 1
    //    imout : Rotated Image
    //
    // Description
    //    This function rotate an image to a given angle
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/puffin.png"));
    //    J = imrotate(S,45);
    //    imshow(S);
    //    figure(); imshow(J);
    //
    // See also
    //     imtransform
    //
    // Authors
    //    Tan Chin Luh
    //

    rhs=argn(2);
    // Error Checking
    if rhs < 2; error("Expect at least 2 arguments, source image and angle"); end    
    if rhs < 3; crp = 0; end

//    imout = int_imrotate(im1,deg);
    sz = size(im1);

    // Checking on Rotation angle
    deg = modulo(deg,360);
    if abs(deg) >= 0 & abs(deg) <=90
        deg2 = abs(deg);
    elseif abs(deg) > 90 &  abs(deg) <=180
        deg2 = 180 - abs(deg);
    elseif abs(deg) > 180 &  abs(deg) <=270
        deg2 = abs(deg) - 180;
    elseif abs(deg) > 270 &  abs(deg) <=360
        deg2 = 360 - abs(deg);
    end

    alpha = abs(deg2)*%pi/180;


    if  crp == 0

//        // Compute new Image Size
//        // To-Do : Compute better size for 90 degree, and to consider finding a way to do all in C
//        r = max(floor(sz(2)*sin(alpha) + sz(1)*cos(alpha)),sz(2));
//        c = max(floor(sz(2)*cos(alpha) + sz(1)*sin(alpha)),sz(2));
//        r_offset = max(floor((r-sz(1))/2),0);
//        c_offset = max(floor((c-sz(2))/2),0);
//
//
//        // To check Image Type
//        strtype = typeof(im1(1));        
//        if strtype == 'constant' then
//            im2 = zeros(r,c);
//        else    
//            im2 = evstr(strtype + '(zeros(r,c))');        
//        end
//
//        // To check whether image is gray or RGB, and map the old image to the new size    
//        if length(sz) == 3
//            im2 = repmat(im2,[1,1,3]);        
//            im2(r_offset+1:r_offset+sz(1),c_offset+1:c_offset+sz(2),1) = im1(:,:,1);
//            im2(r_offset+1:r_offset+sz(1),c_offset+1:c_offset+sz(2),2) = im1(:,:,2);
//            im2(r_offset+1:r_offset+sz(1),c_offset+1:c_offset+sz(2),3) = im1(:,:,3);
//            if strtype ~= 'constant' then
//                im2 = evstr(strtype + '(im2)');    // a bug to report?
//            end
//        else
//            im2(r_offset+1:r_offset+sz(1),c_offset+1:c_offset+sz(2)) = im1;
//        end

        imout = int_imrotate(im1,deg,0);

    else     
        imout = int_imrotate(im1,deg,1);
    end

endfunction

