function luv = rgb2luv(rgb)
    // Convert an RGB image to Luv.
    //
    // Syntax
    //    luv = rgb2luv(rgb)
    //
    // Parameters
    //    rgb : RGB image.
    //    luv : Luv image.
    //
    // Description
    //    rgb2luv converts an RGB image to CIE Luv using OpenCV 5 cvtColor.
    //
    // Examples
    //    rgb = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    luv = rgb2luv(rgb);
    //
    // See also
    //    luv2rgb
    //    rgb2lab
    //    imcvtcolor
    //
    // Authors
    //    Tan Chin Luh

    luv = imcvtcolor(rgb, "rgb2luv");
endfunction
