//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================

function imout = imroifilt(imin,f,mask)
    // Filtering of a selected region
    //
    // Syntax
    //     imout = imroifilt(imin,f,mask)
    //
    // Parameters
    //     imin : Input Image
    //     f : Input filter
    //     mask : Mask for the ROI
    //     imout : Output image
    //
    // Description
    //    This function perform filtering over the region specified in mask.
    //    
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png."));
    //    mask = imroi(S); 
    //    h = fspecial('unsharp');
    //    S2 = imroifilt(S,h,mask);
    //    imshow(S2);
    //
    // See also
    //    imroi
    //    imroifill
    //
    // Authors
    //    Tan Chin Luh
    //


    //

    sz = size(imin);

    S2 = imfilter(imin,f);
    mask2 = im2bw(mask,0.5);

    if length(sz) == 3 then
        for cnt = 1:3
            temp1 = imin(:,:,cnt);  
            temp2 = S2(:,:,cnt);              
            temp1(mask2==%t) = temp2(mask2==%t);
            imout(:,:,cnt) = temp1;
        end
    else
        imin(mask2==%t) = S2(mask2==%t);
        imout = imin;
    end

endfunction




