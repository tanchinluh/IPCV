//      Copyright (C) 2005  Barre-Piquot
//     
//      This program is free software; you can redistribute it and/or
//      modify it under the terms of the GNU General Public License
//      as published by the Free Software Foundation; either version 2
//      of the License, or (at your option) any later version.
//     
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
function level = imgraythresh (I)
    // Calculate Otsu's Global threshold value
    //    
    // Syntax
    //    level = imgraythresh (I)
    //
    // Parameters
    //    I : Source Image
    //    level : Otsu's threshold value
    //
    // Description
    //    The function uses Otsu's method, which chooses the threshold to
    //    minimize the intraclass variance of the black and white pixels. 
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/three_objects.png"));
    //    th = imgraythresh(S);
    //    S2 = im2bw(S,th);
    //    scf; imshow(S2);
    //
    // See also
    //     im2bw
    //
    // Authors
    //    Barre-Piquot (Octave)
    //    Tan Chin Luh (IPCV)
    //

    //     This function is Originally from Barre-Piquot, http://www.irit.fr/recherches/SAMOVA/MEMBERS/JOLY/Homepage_files/IRR05/Barre-Piquot/graythresh.m 
    //     used in Octave by SÃ¸ren Hauberg, and imported to Scilab by Tan C.L.
    // 


    // Input checking
    nargin = argn(2);

    sz = size(I);

    if (nargin ~= 1)
        error('Expected 1 input image');
    end

    //     To be implemented in coming version
    //    if (~isgray(I) & ~isrgb(I))
    //      error("graythresh: input must be an image");
    //    end
    //    
    // If the image is RGB convert it to grayscale
    if (length(sz)==3)
        I = rgb2gray(I);
    end

    // Calculation of the normalized histogram
    n = 256;
    h = imhist(I(:), n);        
    h = h/(length(I(:))+1);

    // Calculation of the cumulated histogram and the mean values
    w = cumsum(h);
    mu = zeros(n, 1); mu(1) = h(1);
    for i=2:n
        mu(i) = mu(i-1) + i*h(i);
    end    

    // Initialisation of the values used for the threshold calculation
    level = find (h > 0, 1);
    w0 = w(level);
    w1 = 1-w0;
    mu0 = mu(level)/w0;
    mu1 = (mu($)-mu(level))/w1;
    maxval = w0*w1*(mu1-mu0)*(mu1-mu0);

    // For each step of the histogram, calculation of the threshold and storing of the maximum
    for i = find (h > 0)
        w0 = w(i);
        w1 = 1-w0;
        mu0 = mu(i)/w0;
        mu1 = (mu($)-mu(i))/w1;
        s = w0*w1*(mu1-mu0)*(mu1-mu0);
        if (s > maxval)
            maxval = s;
            level = i;
        end
    end

    // Normalisation of the threshold        
    level = level./n;
endfunction

