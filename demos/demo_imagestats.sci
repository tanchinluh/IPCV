////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
////////////////////////////////////////////////////////////
function demo_imagestats()

    re = messagebox("This demo will show you image statistics and simple analysis", "Image Analysis and Stats", "info", ["Continue" "Stop"], "modal") 

    if re ==1 then

        im = imread(fullpath(getIPCVpath() + "/images/lena.png"));
        drawlater();
        subplot(221); imshow(im); title("Image");
        subplot(222);imhist(im(:,:,1),32,0.5,'red');title("Red component histogram");
        subplot(223);imhist(im(:,:,2),32,0.5,'green');title("Green component histogram");
        subplot(224);imhist(im(:,:,3),32,0.5,'blue');title("Blue component histogram");
        drawnow();

        im = rgb2gray(im);
        scf();
        drawlater();
        subplot(211);imshow(im); title("Gray Image");
        subplot(212);imhist(im,[],1);title("Histogram");
        drawnow();
        scf();
        drawlater();
        E = edge(im, 'sobel',0,'both');
        subplot(221);imshow(E);title("Sobel");

        E = edge(im, 'canny', [0.06, 0.2]);
        subplot(222);imshow(E);title("canny");

        E = edge(im, 'prewitt',0.5,'both');
        subplot(223);imshow(E);title("prewitt");

        E = edge(im, 'fftderiv');
        subplot(224);imshow(E);title("fftderiv");
        drawnow();

        messagebox("Thanks!", "End of demo", "info", "Done", "modal") ;
        
    else
        messagebox("Exit Demo Now", "User Interruption", "warning", "Done", "modal") ;
    end

endfunction
// ====================================================================
demo_imagestats();
clear demo_imagestats;
// ====================================================================
