//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function y = imhistequal(x)
    // Histogram Equalization
    //
    // Syntax
    //     y = imhistequal(x)
    //
    // Parameters
    //     x : Source Image
    //     y : Output Image with enhanced contrast of images
    //
    // Description
    //    This method usually increases the global contrast of many images, 
    //    especially when the usable data of the image is represented by close 
    //    contrast values. Through this adjustment, the intensities can be better 
    //    distributed on the histogram. This allows for areas of lower local 
    //    contrast to gain a higher contrast. Histogram equalization accomplishes 
    //    this by effectively spreading out the most frequent intensity values.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/Lena_dark.png"));
    //    J = imhistequal(S);
    //    imshow(S);
    //    scf; imshow(J);
    //
    // See also
    //    imadjust
    //
    // Authors
    //    Tan Chin Luh
    //
    // Bibliography
    // 1. Wikipedia : http://en.wikipedia.org/wiki/Histogram_equalization
    // 

    function yplane = equalize_plane(xplane)
        xplane8 = im2uint8(xplane);
        [Histogram, ListOfBins] = imhist(xplane8,256);
        CumHist = cumsum(Histogram);
        a = find(CumHist~=0);
        [m,n] = size(xplane8);

        if size(a, "*") == 0 then
            yplane = xplane8;
            return;
        end

        cdfmin = CumHist(a(1));
        denom = m*n-cdfmin;

        if denom <= 0 then
            yplane = xplane8;
            return;
        end

        y2 = round((CumHist(imadd(xplane8,1))-cdfmin)/denom*255);
        yplane = uint8(matrix(y2,m,n));
    endfunction

    dims = size(x);

    if length(dims) == 2 then
        y8 = equalize_plane(x);
    elseif length(dims) == 3 & dims(3) == 3 then
        x8 = im2uint8(x);
        lab = rgb2lab(x8);
        lab(:,:,1) = equalize_plane(lab(:,:,1));
        y8 = int_cvtcolor(lab, "lab2rgb");
    else
        error("The input image should be a 2D grayscale image or an M x N x 3 RGB image.");
    end

    if typeof(x(1)) == "uint8" then
        y = y8;
    else
        y = im2double(y8);
    end    


    //y = uint8(y3);



endfunction
