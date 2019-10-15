////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
////////////////////////////////////////////////////////////
function params = imstitchimage_params()
    // Image Stitching Parameters
    //
    // Syntax
    //   params = imstitchimage_params()
    //
    // Parameters
    //  params : A structure which consist of following fields, used for imstitchimage.
    //	     RegistrationResol : Resolution for image registration step. The default is 0.6 Mpx
    //	     SeamEstimationResol : Resolution for seam estimation step. The default is 0.1 Mpx
    //	     CompositingResol : Resolution for compositing step. Use -1 for original resolution.The default is 1
    //	     PanoConfidenceThresh : Threshold for two images are from the same panorama confidence. The default is 1
    //	     WaveCorrection : Perform wave effect correction. The default is 1
    //       BlenderBands : Then number of bands for MultiBandBlender. The default is 100
    //
    // Description
    //   This function is used to create the initial parameters structure with initial values. The fields value could be easily changed and it will affect the stitching result.
    //
    // Examples
    //
    // See also
    //   imstitchimage
    //  
    // Authors
    //   Tan Chin Luh    
    
    params = struct();
    params.RegistrationResol = 0.6;
    params.SeamEstimationResol = 0.1;
    params.CompositingResol = 1;
    params.PanoConfidenceThresh = 1;
    params.WaveCorrection = 1;
    params.BlenderBands = 100;
    
    
endfunction
