function rgb = hls2rgb(hls)
    // Convert an HLS image to RGB.
    //
    // Syntax
    //    rgb = hls2rgb(hls)
    //
    // Parameters
    //    hls : HLS image.
    //    rgb : RGB image.
    //
    // Description
    //    hls2rgb converts an HLS image to RGB using OpenCV 5 cvtColor.
    //
    // Examples
    //    rgb = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    hls = rgb2hls(rgb);
    //    rgb2 = hls2rgb(hls);
    //
    // See also
    //    rgb2hls
    //    imcvtcolor
    //
    // Authors
    //    Tan Chin Luh

    rgb = imcvtcolor(hls, "hls2rgb");
endfunction
