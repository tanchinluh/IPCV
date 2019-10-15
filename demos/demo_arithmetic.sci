////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
////////////////////////////////////////////////////////////
function demo_arithmetic()




    re = messagebox("This demo will show you some examples of image arithmetic", "Image Arithmetic", "info", ["Continue" "Stop"], "modal") 

    if re ==1 then

        im1 = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
        im2 = imread(fullpath(getIPCVpath() + "/images/peppers.png"));
        
        
        ima1 = imadd(im1,im2);
        ima2 = imadd(im1,100);
        subplot(221); imshow(im1); title("First Image");
        subplot(222); imshow(im2); title("Second Image");
        subplot(223); imshow(ima1); title("1st Image + 2nd Image");
        subplot(224); imshow(ima2); title("1st Image + constant 100");
        
        ims1 = imsubtract(im1, im2);
        ims2 = imsubtract(im1, 100);
        scf();
        subplot(221); imshow(im1); title("First Image");
        subplot(222); imshow(im2); title("Second Image");
        subplot(223); imshow(ims1); title("1st Image - 2nd Image");
        subplot(224); imshow(ims2); title("1st Image - constant 100");        

        imm1 = immultiply(im1, im2);
        imm2 = immultiply(im1, 2);
        scf();
        subplot(221); imshow(im1); title("First Image");
        subplot(222); imshow(im2); title("Second Image");
        subplot(223); imshow(imm1); title("1st Image x 2nd Image");
        subplot(224); imshow(imm2); title("1st Image x constant 2"); 
        
        imd1 = imdivide(im1, im2);
        imd2 = imdivide(im1, 2);
        scf();
        subplot(221); imshow(im1); title("First Image");
        subplot(222); imshow(im2); title("Second Image");
        subplot(223); imshow(imd1); title("1st Image / 2nd Image");
        subplot(224); imshow(imd2); title("1st Image / constant 2"); 
        messagebox("Thanks!", "End of demo", "info", "Done", "modal") ;        
        //xdel(winsid());
    else
        messagebox("Exit Demo Now", "User Interruption", "warning", "Done", "modal") ;
    end

endfunction
// ====================================================================
demo_arithmetic();
clear demo_arithmetic;
// ====================================================================
