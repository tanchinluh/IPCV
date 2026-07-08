//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================

function [RT,xp] = imradon (I,theta)
    // Calculates the 2D-Radon transform of the matrix
    //
    // Syntax
    //     [RT,xp] = imradon (I,theta)
    //
    // Parameters
    //     I : Image matrix in Scilab
    //     theta : Angles for calculating radon tansform
    //     RT : Matrix of the Radon transform for one of the angles in theta.
    //     xp : Radial coordinates corresponding to each row of RT.
    //
    // Description
    //    Calculates the 2D-Radon transform of the matrix I at angles given
    //    in THETA. To each element of THETA corresponds a column in RT.
    //    The variable XP represents the x-axis of the rotated coordinate.
    //    If THETA is not defined, then 0:179 is assumed.
    //
    // Examples
    //    I = zeros(100,100);
    //    I(25:75, 25:75) = 1;
    //    [RT,xp] = imradon(I);
    //    imshow(RT,hot(64));
    //
    // See also
    //    imhough
    //
    // Authors
    //     Tan Chin Luh
    //

    nargin=argn(2);

    // Error Checking
    //if rhs < 3; error("Expect 3 arguments, source image, block size, and function"); end    
    //if length(blk)~= 2; ; error("Second argument must be a vector of 2"); end    


    // Input checking
    if (nargin == 0 | nargin > 2)
        error ('Must be 2 inpouts');
    elseif (nargin == 1)
        theta = 0:179;
    end


    if (~isvector(theta))
        error("radon: second input must be a vector");
    end
    
    if (~isvector(theta))
        error("radon: second input must be a vector");
    end
    
    if type(I) == 17;
        warning("radon: input image is an RGB image and converted to grayscale for radon transform")
        I = rgb2gray(I);
    end
    
    
    [RT,xp] = int_imradon(im2double(I),theta);

//    [m, n] = size (I);
//    //pause
//    // center of image
//    xc = floor ((m+1)/2);
//    yc = floor ((n+1)/2);
//
//    // divide each pixel into 2x2 subpixels
//
//    d = matrix (I,[1 m 1 n]);
//    d = d([1 1],:,[1 1],:);
//    d = matrix (d,[2*m 2*n])/4;
//
//    b = ceil (sqrt (sum (size (I).^2))/2 + 1);
//    xp = [-b:b]';
//    sz = size(xp);
//
//    [X,Y] = ndgrid (0.75 - xc + [0:2*m-1]/2,0.75 - yc + [0:2*n-1]/2);
//
//    X = X(:)';
//    Y = Y(:)';
//    d = d(:)';
//
//    th = theta*%pi/180;
//
//    for l=1:length (theta)
//        // project each pixel to vector (-sin(th),cos(th))
//        Xp = -sin (th(l)) * X + cos (th(l)) * Y;
//
//        ip = Xp + b + 1;
//
//        k = floor (ip);
//        frac = ip-k;
//
//        RT(:,l) = nan_accumarray (k',d .* (1-frac),sz) + nan_accumarray (k'+1,d .* frac,sz);
//    end

endfunction







