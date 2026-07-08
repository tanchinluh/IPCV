function rgb = gray2rgb(gray)
    // Convert a grayscale image to RGB.
    //
    // Syntax
    //    rgb = gray2rgb(gray)
    //
    // Parameters
    //    gray : Single-channel image.
    //    rgb : RGB image.
    //
    // Description
    //    gray2rgb converts a grayscale image to a three-channel RGB image using OpenCV 5 cvtColor.
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/" + "baboon.png"), IMREAD_GRAYSCALE=1);
    //    rgb = gray2rgb(im);
    //    imshow(rgb);
    //
    // See also
    //    rgb2gray
    //    imcvtcolor
    //
    // Authors
    //    Tan Chin Luh

    rgb = imcvtcolor(gray, "gray2rgb");
endfunction
