//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function [S,TR,ROT,SC]=imphasecorr(I1,I2)
    // Detection and automatic image registration for translation, rotation and scale using phase correlation method.
    //
    // Syntax
    //    [S,TR,ROT,SC]=imphasecorr(I1,I2)
    //
    // Parameters
    //    I1 : Target image
    //    I2 : Source image
    //    S : Registed Image
    //    TR : Translation 
    //    ROT : Rotation
    //    SC : Scale
    //
    // Description
    //    Detection and automatic image registration for translation, rotation and scale using phase correlation method.
    //
    // Examples
    //    I1 = imread(fullpath(getIPCVpath() + "/images/lena.bmp"));
    //    I2 = imread(fullpath(getIPCVpath() + "/images/lena7030.bmp"));
    //    [S,TR,ROT,SC]=imphasecorr(I1,I2);
    //    imshow(S);
    //
    // See also
    //    imfeaturematch
    // 
    // Authors
    //    Tan Chin Luh
    //


    //    

    if length(size(I1)) == 3;
        I1 = rgb2gray(I1);
    end

    if length(size(I2)) == 3;
        I2 = rgb2gray(I2);
    end

    sz = size(I1);

    // Checking for Scale and Rotation transformation
    FA = fftshift(fft2pad((I1),sz(1),sz(2)));
    FB = fftshift(fft2pad((I2),sz(1),sz(2)));

    // Highpass filter    
    h = mkfftfilter(FA,'gauss',0.3,0.3);
    IA = (1-h).*abs(FA);  
    IB = (1-h).*abs(FB);  

    // Transform the high passed FFT phase to Log Polar space
    fac=max(sz);
    M = round(fac/(log(fac/2)));
    rho = logspace(log10(1),log10(fac/2-1),fac)';

    L1= imlogpolar(IA,M);
    L2 = imlogpolar(IB,M);

    THETA_F1 = fft2(L1);
    THETA_F2 = fft2(L2);

    // Compute cross power spectrum of F1 and F2
    a1 = angle(THETA_F1);
    a2 = angle(THETA_F2);

    THETA_CROSS = exp(%i * (a1 - a2));
    THETA_PHASE = real(ifft(THETA_CROSS));
    [m,n] = max(THETA_PHASE);

    DPP = 360 / size(THETA_PHASE, 2); 
    ROT = DPP * (n(1) - 1);

    // decode the scale
    if (n(2) > size(THETA_PHASE,1)/2)    
        dsi = size(THETA_PHASE,1)-n(2)+2;    
    else                            
        dsi = n(2);
    end

    if(dsi<=1)
        scale_neighbourhood = [%nan; rho(dsi); rho(dsi+1)];
    elseif (dsi>=length(rho))
        scale_neighbourhood = [rho(dsi-1); rho(dsi); %nan];
    else
        scale_neighbourhood = [rho(dsi-1);rho(dsi); rho(dsi+1)];
    end
    if (n(2) > size(THETA_PHASE,1)/2)    // then input2 has been scaled DOWN wrt input1
        scale_neighbourhood = 1 ./ scale_neighbourhood;
    end
    SC = scale_neighbourhood(2);
    ////

    disp('Scale Factor = '+string(SC));
    disp('Rotation Factor = '+string(ROT));

    R1 = imresize(I2,1/SC, 'bilinear');
    R2 = imrotate(R1,-ROT);

    // To crop the black region
    xx = find(sum(R2,1)>10);
    yy = find(sum(R2,2)>10);
    x1 = xx(1);
    y1 = yy(1);
    w = xx($) - xx(1);
    h = yy($) - yy(1);
    R2 = imcrop(R2,[x1 y1 w h]);

    // Mapping to the same size of Target Image
    R3 = uint8(zeros(I1));
    R3(1:h,1:w) = R2;

    // Translation Checking
    sz1 = size(I1);
    sz2 = size(R3);
    sz3(1) = max(sz1(1),sz2(1));
    sz3(2) = max(sz1(2),sz2(2));
    F1 = fft2pad(im2double(I1),sz3(1),sz3(2));
    F2 = fft2pad(im2double(R3),sz3(1),sz3(2));
    R = (F1.*conj(F2))./abs(F1.*F2);
    r = ifft(R);
    r_norm = real(r);
    [m,n] = max(r_norm);

    if n(2)>sz3(2)/2 then
        n(2) = sz3(2) - n(2) + 1;
    else
        n(2) = n(2) - 1;
    end

    if n(1)>sz3(1)/2 then
        n(1) = sz3(1) - n(1) + 1;
    else
        n(1) = n(1) - 1;
    end

    aa = [1 0;0 1;n(2) n(1)];
    S = imtransform(R2,aa,'affine',sz(2),sz(1));
    //imshow(R2);
    //S = THETA_PHASE;
    TR = n;

    disp('Transition Factor x = '+string(n(2))+" y = " + string(n(1)));

endfunction











