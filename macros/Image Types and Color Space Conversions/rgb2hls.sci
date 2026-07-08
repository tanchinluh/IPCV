function hls = rgb2hls(rgb)
    // Convert an RGB image to HLS.
    //
    // Syntax
    //    hls = rgb2hls(rgb)
    //
    // Parameters
    //    rgb : RGB image.
    //    hls : HLS image.
    //
    // Description
    //    rgb2hls converts an RGB image to HLS using OpenCV 5 cvtColor.
    //
    // Examples
    //    rgb = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    hls = rgb2hls(rgb);
    //
    // See also
    //    hls2rgb
    //    rgb2hsv
    //    imcvtcolor
    //
    // Authors
    //    Tan Chin Luh

    hls = imcvtcolor(rgb, "rgb2hls");
endfunction
