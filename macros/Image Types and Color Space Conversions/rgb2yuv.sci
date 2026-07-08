function yuv = rgb2yuv(rgb)
    // Convert an RGB image to YUV.
    //
    // Syntax
    //    yuv = rgb2yuv(rgb)
    //
    // Parameters
    //    rgb : RGB image.
    //    yuv : YUV image.
    //
    // Description
    //    rgb2yuv converts an RGB image to YUV using OpenCV 5 cvtColor.
    //
    // Examples
    //    rgb = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    yuv = rgb2yuv(rgb);
    //
    // See also
    //    yuv2rgb
    //    rgb2ycbcr
    //    imcvtcolor
    //
    // Authors
    //    Tan Chin Luh

    yuv = imcvtcolor(rgb, "rgb2yuv");
endfunction
