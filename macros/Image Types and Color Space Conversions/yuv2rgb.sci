function rgb = yuv2rgb(yuv)
    // Convert a YUV image to RGB.
    //
    // Syntax
    //    rgb = yuv2rgb(yuv)
    //
    // Parameters
    //    yuv : YUV image.
    //    rgb : RGB image.
    //
    // Description
    //    yuv2rgb converts a YUV image to RGB using OpenCV 5 cvtColor.
    //
    // Examples
    //    rgb = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    yuv = rgb2yuv(rgb);
    //    rgb2 = yuv2rgb(yuv);
    //
    // See also
    //    rgb2yuv
    //    rgb2ycbcr
    //    imcvtcolor
    //
    // Authors
    //    Tan Chin Luh

    rgb = imcvtcolor(yuv, "yuv2rgb");
endfunction
