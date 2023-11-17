////////////////////////////////////////////////////////////
// SIVP - Scilab Image and Video Processing toolbox
// Copyright (C) 2006  Shiqi Yu
//
// SIP - Scilab Image Processing toolbox
// Copyright (C) 2002-2004  Ricardo Fabbri
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////


function [border, thresh]=edge(Img, method, thresh, dir_or_sig, sig)
    // Find edges in a single channel image.
    //
    // Syntax
    //    E = edge(im, method)
    //    E = edge(im, method, thresh)
    //    E = edge(im, method, thresh, direction)
    //    E = edge(im, method, thresh, sigma)
    //    [E, thresh] = edge(im, method, ...)
    //
    // Parameters
    //    im : Input image which must be a single channel image.
    //    method : may be 'sobel'(default), 'prewitt', 'log', 'fftderiv' or 'canny'. Other methods will appear in the future.
    //    thresh : sets the threshold level, from 0 to 1. Defaults to 0.2. If negative, then the output image, E , will have the un-thresholded gradient image.
    //    direction : may be 'horizontal', 'vertical' or 'both'(default). This determines the direction to compute the image gradient.
    //    sigma : Controls the ammount of high-frequency attenuation in some methods (only the 'fftderiv' method uses this parameter). This can be used to obtain different levels of detail and to filter out high-frequency noise.
    //    E : edge image which is boolean matrix and has the same size as im . If thresh<0 , E is a double un-thresholded image.
    //
    // Description
    //    The function edge performs edge detection on a grayscale intensity image. The user may set the method, the threshold level, the direction of the edge detection, etc.
    //
    //    E=edge(im, 'sobel', thresh, direction)
    //    Detects edges in im , using the sobel gradient estimator.
    //
    //    E=edge(im, 'prewitt', thresh, direction)
    //    Detects edges in im , using the prewitt gradient estimator.
    //
    //    E=edge(im, 'log', thresh, sigma)
    //    Detects edges in im , using the the Laplacian of Gaussian method. sigma is the standard deviation of the LoG filter and the size of the LoG filter is nxn, where n = ceil(sigma*3)*2+1. The default value for sigma is 2.
    //
    //    E=edge(im, 'fftderiv', thresh, direction, sigma)
    //    Detects edges in im , using the FFT gradient method, default sigma 1.0
    //
    //    E=edge(im, 'canny', thresh, sigma)
    //    Detects edges in im , using Canny method. thresh is a two-element vector, in which the fist element is the low threshold and the seond one is the high threshold. If thresh is a scalar, the low threshold is 0.4*thresh and the high one is thresh . Besides, thresh can not be negative scalar. sigma is the Aperture parameter for canny operator, which must be 1, 3, 5 or 7. default thresh 0.2; default sigma 3.
    //
    // Supported classes: INT8, UINT8, INT16, UINT16, INT32, DOUBLE.
    //
    // Examples
    //    im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //    im = rgb2gray(im);
    //    E = edge(im, 'sobel');
    //    imshow(E);
    //    
    //    E = edge(im, 'canny', [0.06, 0.2]);
    //    imshow(E);
    //    
    //    E = edge(im, 'prewitt');
    //    imshow(mat2gray(E));    
    //
    // See also
    //    fspecial
    //    imfilter
    //    filter2
    //
    // Authors
    //    Shiqi Yu (SIVP)
    //    Ricardo Fabbri (SIP)
    //    Tan Chin Luh (IPCV)


    if argn(2)==0 then
        error('Invalid number of arguments.')
    end

    //check image channel
    if size( size(Img),2) <> 2  then
        error('The input image should be a single channel image.');
    end

    if ~exists('method','local') then
        method='sobel'
    end

    if ~exists('thresh','local') then
        thresh=0.2;
    end

    direction='both'; //default value
    sigma = []; //default value

    if exists('dir_or_sig', 'local') then
        if( typeof(dir_or_sig) == 'string') then
            direction = dir_or_sig;
        elseif (typeof(dir_or_sig) == 'constant') then
            sigma = dir_or_sig;
        end
    end

    if exists('sig', 'local') then
        sigma = sig;
    end

    select method,
    case 'sobel' then
        //mask = fspecial('sobel');
        if(direction=='horizontal') then
            border=int_sobel(Img, 0, 1);
        elseif(direction=='vertical') then
            border=int_sobel(Img, 1, 0);
        elseif(direction=='both') then         // Modified by Trity 12-July-2012 
            //border1=int_sobel(Img, 0, 1);
            //border2=int_sobel(Img, 1, 0);      
            //border = border1 | border2;  
            border=int_sobel(Img, 1, 1);    
        else
            error('Invalid direction');
        end

        if (thresh > 0) then
            border=im2bw(border, thresh);
        else
            border=double(border);
        end
        //End sobel
        return; 
    case 'prewitt' then
        mask = fspecial('prewitt');
    case 'log' then
        if isempty(sigma) then
            sigma=2;
        end
        direction = 'horizontal'; //to prevent filter two times

        mask = fspecial('log', ceil(sigma*3)*2+1, sigma);
    case 'canny' then
        
        // Issue 1739: Error function "edge" with method "canny" 
        if type(Img) == 1
            Img = im2uint8(Img);
        end
        
        //set default thresh value
        //negative value is invalid here

        
        if thresh < 0 then
            thresh = 0.3;
        end

        if(length(thresh)==1) then
            low_th=thresh*0.4;
            high_th=thresh;
        elseif (length(thresh)==2) then
            low_th=thresh(1);
            high_th=thresh(2);
        else
            error('Invalid threshold for Canny method: Can not be negative.');
        end

        if isempty(sigma) then
            sigma=3;
        end
        if and(sigma <> [1,3,5,7]) then
            error('sigma for canny must be 1, 3, 5 or 7.');
        end

        border = int_canny(Img, [low_th*255, high_th*255], sigma);
        border = im2bw(border, 0.5);

        //END of CANNY
        return;
    case 'fftderiv' // fourier gradient
        if isempty(sigma) then
            sigma=1;
        end

        Img = double(Img);

        [r,c] = size(Img)
        fu = [0:c-1]*(1/c)
        fv = [0:r-1]*(1/r)
        fu(int(c/2):c) = fu(int(c/2):c) - 1;
        fv(int(r/2):r) = fv(int(r/2):r) - 1;

        if sigma == 0
            gf = ones(r,c)
        else
            gf = ones(r,1) * exp(-(sigma*%pi*fu).^2)
            gv = exp(-(sigma*%pi*fv').^2) * ones(1,c)
            gf = gf .* gv
        end

        select direction
        case 'horizontal'
            fvp = %i*2*%pi*fv' * ones(1,c)
            Dyf = fft(Img,-1) .* gf .* fvp
            border = abs(fft(Dyf,1))
        case 'vertical'
            fup = ones(r,1) * %i*2*%pi*fu
            Dxf = fft(Img,-1) .* gf .* fup
            border = abs(fft(Dxf,1))
        case 'both'
            fup = ones(r,1) * %i*2*%pi*fu
            fvp = %i*2*%pi*fv' * ones(1,c)
            Dxf = fft(Img,-1) .* gf .* fup
            Dyf = fft(Img,-1) .* gf .* fvp

            Dx = abs(fft(Dxf,1))
            Dy = abs(fft(Dyf,1))

            border = sqrt(Dx.^2 + Dy.^2)
        else
            error('Invalid direction.');
        end

        if thresh >=0 then
            scale_thresh = min(border) * (1-thresh) + max(border)*thresh;
            border=border > scale_thresh;
        end
        // END
        return
    else
        error('Invalid edge detection method.')
    end

    select direction
    case 'horizontal'
        //mx=filter2(mask, Img);
        mx=filter2(Img,mask);
        border=abs(mx)
    case 'vertical'
        //my=filter2(mask', Img);
        mx=filter2(Img,mask');
        border=abs(my)
    case 'both'
        //mx=filter2(mask, Img);
        //my=filter2(mask',Img);
        mx=filter2(Img,mask);
        my=filter2(Img,mask');
        border=sqrt(mx.*mx + my.*my);
    else
        error('Invalid direction.');
    end

    if thresh >=0 then
        scale_thresh = min(border) * (1-thresh) + max(border)*thresh;
        border=border > scale_thresh;
    end

endfunction

