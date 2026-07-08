function xyz = rgb2xyz(rgb)
    // Convert an RGB image to XYZ.
    //
    // Syntax
    //    xyz = rgb2xyz(rgb)
    //
    // Parameters
    //    rgb : RGB image.
    //    xyz : CIE XYZ image.
    //
    // Description
    //    rgb2xyz converts an RGB image to CIE XYZ using OpenCV 5 cvtColor.
    //
    // Examples
    //    rgb = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    xyz = rgb2xyz(rgb);
    //
    // See also
    //    xyz2rgb
    //    rgb2lab
    //    imcvtcolor
    //
    // Authors
    //    Tan Chin Luh

    xyz = imcvtcolor(rgb, "rgb2xyz");
endfunction
