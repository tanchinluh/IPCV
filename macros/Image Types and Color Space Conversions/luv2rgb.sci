function rgb = luv2rgb(luv)
    // Convert a Luv image to RGB.
    //
    // Syntax
    //    rgb = luv2rgb(luv)
    //
    // Parameters
    //    luv : Luv image.
    //    rgb : RGB image.
    //
    // Description
    //    luv2rgb converts a CIE Luv image to RGB using OpenCV 5 cvtColor.
    //
    // Examples
    //    rgb = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    luv = rgb2luv(rgb);
    //    rgb2 = luv2rgb(luv);
    //
    // See also
    //    rgb2luv
    //    imcvtcolor
    //
    // Authors
    //    Tan Chin Luh

    rgb = imcvtcolor(luv, "luv2rgb");
endfunction
