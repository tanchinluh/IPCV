function out = imcvtcolor(im, code)
    // Convert an image between common color spaces.
    //
    // Syntax
    //    out = imcvtcolor(im, code)
    //
    // Parameters
    //    im : Input image.
    //    code : Conversion code string. Supported codes are "rgb2gray", "gray2rgb", "rgb2hsv", "hsv2rgb", "rgb2hls", "hls2rgb", "rgb2lab", "lab2rgb", "rgb2xyz", "xyz2rgb", "rgb2luv", "luv2rgb", "rgb2ycrcb", "ycrcb2rgb", "rgb2yuv", and "yuv2rgb".
    //    out : Converted image.
    //
    // Description
    //    imcvtcolor converts images through the OpenCV 5 cvtColor implementation. RGB images use IPCV channel order on the Scilab side. OpenCV-native intermediate spaces keep their documented channel order.
    //
    // Examples
    //    RGB = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //    HSV = imcvtcolor(RGB, "rgb2hsv");
    //    RGB2 = imcvtcolor(HSV, "hsv2rgb");
    //    imshow(RGB2);
    //
    //    G = imcvtcolor(RGB, "rgb2gray");
    //    RGB3 = imcvtcolor(G, "gray2rgb");
    //    imshow(RGB3);
    //
    // See also
    //    rgb2gray
    //    rgb2hsv
    //    hsv2rgb2
    //    rgb2lab
    //    rgb2ycbcr
    //    ycbcr2rgb
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 2 then
        error("imcvtcolor: Wrong number of input arguments: 2 expected.");
    end
    if typeof(code) <> "string" | size(code, "*") <> 1 then
        error("imcvtcolor: input argument #2 must be a single conversion code string.");
    end

    out = int_cvtcolor(im, convstr(code, "l"));
endfunction
