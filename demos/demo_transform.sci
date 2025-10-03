////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
////////////////////////////////////////////////////////////
function demo_transform()

    re = messagebox("This demo will show you some visualization of DCT", "Image Transformation", "info", ["Continue" "Stop"], "modal") 

    if re ==1 then

        S = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
        y1 = imdct(S);
        y2 = fft2(im2double(S));

       
        scf()
        subplot(221); imshow(S); title("Original Image");
        subplot(222); imshow(y1,jet(512)); title("DCT");
        subplot(223); imshow(y2,jet(512)); title("FFT");
        subplot(224); imshow(fftshift(y2),jet(512)); title("FFT Shifted");
        
        scf()
        //subplot(221); imshow(S); title("Original Image");
        subplot(131); imsurf(log(y1),32); title("DCT");
        subplot(132); imsurf(log(y2),32); title("FFT");
        subplot(133); imsurf(log(fftshift(y2)),32); title("FFT Shifted"); 
       
//        subplot(223); imshow(imf2); title("Unsharpen  Filter");
//        subplot(224); imshow(imf3); title("Smoothing  Filter");
        messagebox("Thanks!", "End of demo", "info", "Done", "modal") ;        
        //xdel(winsid());
    else
        messagebox("Exit Demo Now", "User Interruption", "warning", "Done", "modal") ;
    end

endfunction
// ====================================================================
demo_transform();
clear demo_transform;
// ====================================================================
