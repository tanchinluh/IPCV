//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imdeconvwiener(imin,f,noisefct)
    // Deconvolution with Wiener method
    //
    // Syntax
    //     imout = imdeconvl2(imin,psf,lambda)
    //
    // Parameters
    //    imin : Source Image
    //    f : Blur function
    //    noisefct : Noise Factor
    //    imout : Deblurred Image
    //
    // Description
    //    In mathematics, Wiener deconvolution is an application of the Wiener filter 
    //    to the noise problems inherent in deconvolution. It works in the frequency domain, 
    //    attempting to minimize the impact of deconvoluted noise at frequencies which 
    //    have a poor signal-to-noise ratio.
    //    The Wiener deconvolution method has widespread use in image deconvolution applications, 
    //    as the frequency spectrum of most visual images is fairly well behaved and may be estimated easily.
    //    Wiener deconvolution is named after Norbert Wiener.
    //    The Wiener deconvolution filter provides such a g(t)
    //    The filter is most easily described in the frequency domain:
    //    <para><latex>$\ G(f) = \frac{H(f) S(f)}{ \|H(f)\|^2 S(f)+ N(f) }\$</latex></para>
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/balloons_gray.png"));
    //    S = im2double(S);
    //    h = fspecial('motion',25,45);
    //    S2 = imfilter(S,h,'circular');
    //    imshow(S2);
    //    S3 = imdeconvwiener(S2,h,0);
    //    figure;imshow(S3);
    //
    // See also
    //    imdeconvl2
    //    imdeconvsobolev
    //
    // Authors
    //    Tan Chin Luh
    //
    // Bibliography
    // 1. Wikipedia : http://en.wikipedia.org/wiki/Wiener_deconvolution
    // 2. OpenCV Example : http://gigadom.wordpress.com/category/opencv/ 
    //
ieeestatus = ieee();
ieee(2);
    sz = size(imin);
    szf = size(f); 
    szf_half = floor(szf./2);
fftw_forget_wisdom();

    // 1. Perform DFT of original image
    imin;
    dft_A = fft2(imin);

    // 2. Perform DFT on blur kernel. Also perform inverse DFT to get back original contents. 
    // Make sure that the line for performing the inverse is commented out as it overwrites the DFT array.
fftw_forget_wisdom();
    new_f = PadImage(f,0,0,sz(2)-szf(2),0,sz(1)-szf(1)); //PadImage(Image, PadValue, Left, Right, Up, Down);
    new_f2 = [new_f(szf_half(1)+1:$,:);new_f(1:szf_half(1),:)];
    new_f3 = [new_f2(:,szf_half(2)+1:$) new_f2(:,1:szf_half(2))];
    dft_B = fft2(new_f3);

    // 3. Multiply the DFT of image with the complex conjugate of the DFT of the blur kernel
    dft_C = dft_A.*conj(dft_B);

    // 4. Compute A**2 + B**2    
    image_ReC = real(dft_C); image_ImC = imag(dft_C);
    image_ReB = real(dft_B); image_ImB = imag(dft_B);    
    image_ReB = image_ReB.^2 + image_ImB.^2;

    // 5. Divide numerator with A**2 + B**2
    image_ReB = image_ReB.*1;
    image_ReB = image_ReB + noisefct;
    image_ReC = image_ReC./image_ReB;
    image_ImC = image_ImC./image_ReB;

    // 6.Merge real and imaginary parts, Merge Real and complex parts
    complex_ImC = image_ReC + image_ImC*%i;
fftw_forget_wisdom();
    // 7.Finally perform Inverse DFT
    S = ifft(complex_ImC);
    S1 = real(S);
    imout = im2uint8(S1); //(S1-min(S1))/(max(S1)-min(S1));
    
    ieee(ieeestatus);


endfunction



