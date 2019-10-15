////////////////////////////////////////////////////////////
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function imout = imfill(imin)
//    Filling holes for objects in a binary image
//    
//    Syntax
//    imout = imfill(imin)
//    
//    Parameters
//    imin : A binary image
//    imout : The output with the holes filled.
//    
//    Description
//    This function used to fill the holes in a binary image for better object detection purpose.
//    
//    Examples  
//    S = imread(fullpath(getIPCVpath() + "/images/" + 'coins_gray.jpg'));
//    subplot(131);imshow(S);
//    Sbin = im2bw(~S,0.5);
//    subplot(132);imshow(Sbin);
//    Sfill = imfill(Sbin);
//    subplot(133);imshow(Sfill);
//
//    See also
//    im2bw 
//    
//    Authors
//    Tan Chin Luh
  
    imtype = typeof(imin);

    select imtype
    case 'boolean' then
        imout = int_imfill(imin)
    else
        error("This function supports only binary image for the moment.");
    end
endfunction

