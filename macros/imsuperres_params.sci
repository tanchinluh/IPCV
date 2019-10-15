////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
////////////////////////////////////////////////////////////
function params = imsuperres_params()
    // Super Resolution with Image Sequences Parameters
    //
    // Syntax
    //   params = imsuperres_params()
    //
    // Parameters
    //  params : A structure which consist of following fields, used for imsuperres.
    //	     rfactor : Magnification factor. The default is 4.
    //	     iter : Number of iteration. The default is 50.
    //	     beta1 :  Asymptotic value of steepest descent method. The default is 1.3
    //	     lambda : Weight parameter to balance data term and smoothness term. The default is 0.03
    //	     alpha : Perform wave effect correction. The default is 0.7. btv kernel size is 7.
    //
    // Description
    //   This function is used to create the initial parameters structure with initial values. The fields value could be easily changed and it will affect the super resolution result.
    //
    // Examples
    //
    // See also
    //   imsuperres
    //  
    // Authors
    //   Tan Chin Luh    
    
    params = struct();
    params.rfactor = 4;
    params.iter = 50;
    params.beta1 = 1.3;
    params.lambda = 0.03;
    params.alpha = 0.7;   
    
endfunction
