////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
////////////////////////////////////////////////////////////
function S = imsuperres(imvec,params)
    // Super Resolution with Image Sequences
    // 
    // Syntax
    //   imout = imsuperres(imvec)
    //   imout = imsuperres(imvec,params)
    //
    // Parameters
    //  params : A structure which consist of following fields, could be created with imsuperres_params
    //	     rfactor : Magnification factor. The default is 4.
    //	     iter : Number of iteration. The default is 50.
    //	     beta1 :  Asymptotic value of steepest descent method. The default is 1.3
    //	     lambda : Weight parameter to balance data term and smoothness term. The default is 0.03
    //	     alpha : Perform wave effect correction. The default is 0.7. btv kernel size is 7.
    //
    // Description
    //   imsuperres using image sequences to produce higher resolution image. 
    //
    // Examples
    //    S = list();
    //    S(1) = imread(fullpath(getIPCVpath() + "/images/superres/input001.png"));
    //    S(2) = imread(fullpath(getIPCVpath() + "/images/superres/input002.png"));
    //    S(3) = imread(fullpath(getIPCVpath() + "/images/superres/input003.png"));
    //    S(4) = imread(fullpath(getIPCVpath() + "/images/superres/input004.png"));
    //    S(5) = imread(fullpath(getIPCVpath() + "/images/superres/input005.png"));
    //    S(6) = imread(fullpath(getIPCVpath() + "/images/superres/input006.png"));
    //    S(7) = imread(fullpath(getIPCVpath() + "/images/superres/input007.png"));
    //    S(8) = imread(fullpath(getIPCVpath() + "/images/superres/input008.png"));
    //    S(9) = imread(fullpath(getIPCVpath() + "/images/superres/input009.png"));
    //    S(10) = imread(fullpath(getIPCVpath() + "/images/superres/input010.png"));   
    //    St  = imsuperres(S);
    //    subplot(221);imshow(S(1));title("Original Image 1 of 10");
    //    subplot(222);imshow(S(2));title("Original Image 2 of 10");
    //    subplot(223);imshow(S(3));title("Original Image 3 of 10");
    //    subplot(224);imshow(St);title("Super Resolution");     
    //
    // See also
    //   imsuperres_params
    //  
    // Authors
    //   Tan Chin Luh
    
    [lhs ,rhs]=argn();
    
  
    if rhs <1 then error('At least 1 argument required, a List of images'); end
    if rhs <2 then  params = imsuperres_params(); end
    
    rfactor = params.rfactor;
    iter = params.iter;
    beta1 = params.beta1;
    lambda = params.lambda;
    alpha = params.alpha;

    
S = int_imsuperres(imvec,rfactor,iter,beta1,lambda,alpha);


endfunction
