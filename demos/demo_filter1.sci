////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
////////////////////////////////////////////////////////////
function demo_filter1()

    re = messagebox("This demo will show you some examples of image filtering in spatial domain", "Image Filter in Spatial Domain", "info", ["Continue" "Stop"], "modal") 

    if re ==1 then

        im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
        filter = fspecial('sobel');
        imf1 = imfilter(im, filter);
        filter = fspecial('unsharp');
        imf2 = imfilter(im, filter);
        filter = fspecial('average');
        imf3 = imfilter(im, filter);
        scf();
        subplot(221); imshow(im); title("Original image");
        subplot(222); imshow(imf1); title("Sobel Filter");
        subplot(223); imshow(imf2); title("Unsharpen  Filter");
        subplot(224); imshow(imf3); title("Smoothing  Filter");
        messagebox("Thanks!", "End of demo", "info", "Done", "modal") ;        
        //xdel(winsid());
    else
        messagebox("Exit Demo Now", "User Interruption", "warning", "Done", "modal") ;
    end

endfunction
// ====================================================================
demo_filter1();
clear demo_filter1;
// ====================================================================
