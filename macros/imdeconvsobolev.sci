//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imdeconvsobolev(imin,f,lambda)
    // Deconvolution by Sobolev Regularization
    //
    // Syntax
    //     imout = imdeconvsobolev(imin,psf,lambda)
    //
    // Parameters
    //    imin : Source Image
    //    f : Blur function
    //    lamda : Regularization parameter
    //    imout : Deblurred Image
    //
    // Description
    //    L2 regularization did not perform any denoising. To remove some noise, 
    //    we can penalize high frequencies using Sobolev regularization (quadratic grow). 
    //    
    //    The Sobolev prior reads (note the conversion from spacial domain to Fourier domain)
    //    <para><latex> $[J(f) = \sum_x \|\nabla f(x)\|^2 = \sum_{\omega} S(\omega) \|\hat f(\omega)\|^2 ] where S(\omega)=\|\omega\|^2)$</latex></para>
    //    
    //    Since this prior can be written over the Fourier domain, one can compute the 
    //    solution to the deblurring with Sobolev prior simply with the Fourier coefficients: 
    //    <para><latex>$[\hat f^\star(\omega) = \frac{\hat y(\omega) \hat h(\omega)}{ \|\hat h(\omega)\|^2 + \lambda S(\omega) }]$</latex></para>
    //    Compute the Sobolev prior penalty S (rescale to [0,1]).  
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
    //    S = im2double(S);
    //    h = fspecial('motion',25,45);
    //    S2 = imfilter(S,h,'circular');
    //    imshow(S2);
    //    S3 = imdeconvsobolev(S2,h,0);
    //    scf;imshow(S3);
    //
    // See also
    //    imdeconvl2
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

    //IMIN2 = real( ifft( IMIN .* PSF ./ ( abs(PSF).^2 + lambda) ) );


    n = sz(1);
    m = sz(2);
    x = [0:n/2-1, -n/2:-1];
    y = [0:m/2-1, -m/2:-1];
    [Y,X] = meshgrid(y,x);
    rho = (X.^2 + Y.^2)*(2/n)^2;
    // Perform the sobolev inversion.
    fftw_forget_wisdom();
    IMIN2 = real( ifft( IMIN .* conj(PSF) ./ ( abs(PSF).^2 + lambda*rho) ) );

    imout = (IMIN2-min(IMIN2))/(max(IMIN2)-min(IMIN2));

    //ShowImage(A,'');
    //scf;ShowImage(S,'');
endfunction

