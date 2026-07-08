function rgb = lab2rgb(lab)
    // Convert a Lab image to RGB.
    //
    // Syntax
    //    rgb = lab2rgb(lab)
    //
    // Parameters
    //    lab : Lab image.
    //    rgb : RGB image.
    //
    // Description
    //    lab2rgb converts a CIE Lab image to RGB using OpenCV 5 cvtColor.
    //
    // Examples
    //    rgb = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"));
    //    lab = rgb2lab(rgb);
    //    rgb2 = lab2rgb(lab);
    //
    // See also
    //    rgb2lab
    //    imcvtcolor
    //
    // Authors
    //    Tan Chin Luh

    rgb = imcvtcolor(lab, "lab2rgb");
endfunction
