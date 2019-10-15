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
    //    figure(); imshow(J);
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

    x2=im2uint8(x);
    [Histogram, ListOfBins] = imhist(x2,256);
    CumHist = cumsum(Histogram);
    a = find(CumHist~=0);
    cdfmin = CumHist(a(1));

    [m,n] = size(x);

    //for cnt1 = 1:m
    //    for cnt2 = 1:n
    //        
    //        x(cnt1,cnt2) = round((CumHist(x(cnt1,cnt2)+1)-cdfmin)/(m*n-cdfmin)*255);
    //    end
    //    
    //end

    y2 = round((CumHist(imadd(x2,1))-cdfmin)/(m*n-cdfmin)*255);
    y3 = matrix(y2,m,n);


    if typeof(x(1)) == 'uint8' then
        y = uint8(y3);
    else
        y = im2double(y3./255);
    end    


    //y = uint8(y3);



endfunction
