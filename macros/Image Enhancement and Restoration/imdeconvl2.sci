//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imdeconvl2(imin,f,lambda)
    // Deconvolution with L2 Regularization
    //
    // Syntax
    //     imout = imdeconvl2(imin,psf,lambda)
    //
    // Parameters
    //    imin : Source Image
    //    f : Blur function
    //    lamda : Regularization parameter
    //    imout : Deblurred Image
    //
    // Description
    //    Deconvolution is obtained by dividing the Fourier transform of :
    //      <para><latex>$[f^\star(\omega) = \frac{\hat y(\omega)}{\hat h(\omega)} = \hat f_0(\omega) + \hat w(\omega)/{\hat h(\omega)}]$</latex>  </para>
    //    To avoid this explosion, we consider a simple regularization. 
    //    <para><latex>$[f^{\star} = \text{argmin}_f \: \|y-\Phi f\|^2 + \lambda \|f\|^2]$</latex>  </para>
    //    Since the filtering is diagonalized over Fourier, the solution is simply computed over the Fourier domain as: 
    //    <para><latex>$[\hat f^\star(\omega) = \frac{\hat y(\omega) \hat h(\omega)}{ \|\hat h(\omega)\|^2 + \lambda }]$</latex>  </para>
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
    //    S = im2double(S);
    //    h = fspecial('motion',25,45);
    //    S2 = imfilter(S,h,'circular');
    //    imshow(S2);
    //    S3 = imdeconvl2(S2,h,0);
    //    scf;imshow(S3);
    //
    // See also
    //    imdeconvsobolev
    //    imdeconvwiener
    //
    // Authors
    //    Tan Chin Luh
    //
    // Bibliography
    // 1. Advanced Signal, Image and Surface Processing, Ceremade, Université Paris-Dauphine
    fftw_forget_wisdom();
    IMIN = fft2(imin);
    sz = size(imin);
    szf = size(f); 
    szf_half = floor(szf./2);

    new_f = PadImage(f,0,0,sz(2)-szf(2),0,sz(1)-szf(1)); 
    new_f2 = [new_f(szf_half(1)+1:$,:);new_f(1:szf_half(1),:)];
    new_f3 = [new_f2(:,szf_half(2)+1:$) new_f2(:,1:szf_half(2))];
    fftw_forget_wisdom();
    PSF = fft2(new_f3);

    //hF = H;
    fftw_forget_wisdom();
    IMIN2 = real( ifft( IMIN .* conj(PSF) ./ ( abs(PSF).^2 + lambda) ) );

    imout = (IMIN2-min(IMIN2))/(max(IMIN2)-min(IMIN2));

    //ShowImage(A,'');
    //scf;ShowImage(S,'');
endfunction

