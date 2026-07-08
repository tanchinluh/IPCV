function rgb = xyz2rgb(xyz)
    // Convert an XYZ image to RGB.
    //
    // Syntax
    //    rgb = xyz2rgb(xyz)
    //
    // Parameters
    //    xyz : CIE XYZ image.
    //    rgb : RGB image.
    //
    // Description
    //    xyz2rgb converts a CIE XYZ image to RGB using OpenCV 5 cvtColor.
    //
    // Examples
    //    rgb = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    xyz = rgb2xyz(rgb);
    //    rgb2 = xyz2rgb(xyz);
    //
    // See also
    //    rgb2xyz
    //    imcvtcolor
    //
    // Authors
    //    Tan Chin Luh

    rgb = imcvtcolor(xyz, "xyz2rgb");
endfunction
