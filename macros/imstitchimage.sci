////////////////////////////////////////////////////////////
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
////////////////////////////////////////////////////////////
function imout = imstitchimage(imvec,params)
    // Stitch Images Stored in List
    //
    // Syntax
    //   imout = imstitchimage(imvec)
    //   imout = imstitchimage(imvec,params)
    //
    // Parameters
    //  params : A structure which consist of following fields, could be created with imstitchimage_params
    //	     RegistrationResol : Resolution for image registration step. The default is 0.6 Mpx
    //	     SeamEstimationResol : Resolution for seam estimation step. The default is 0.1 Mpx
    //	     CompositingResol : Resolution for compositing step. Use -1 for original resolution.The default is 1
    //	     PanoConfidenceThresh : Threshold for two images are from the same panorama confidence. The default is 1
    //	     WaveCorrection : Perform wave effect correction. The default is 1
    //       BlenderBands : Then number of bands for MultiBandBlender. The default is 100
    //
    // Description
    //   imstitchimage tries to stitch images saved in Scilab list together to form a panaromic image.
    //
    // Examples
    //    S = list();
    //    S(1) = imread(fullpath(getIPCVpath() + "/images/stitching/sk1.jpg"));
    //    S(2) = imread(fullpath(getIPCVpath() + "/images/stitching/sk2.jpg"));
    //    S(3) = imread(fullpath(getIPCVpath() + "/images/stitching/sk3.jpg"));
    //    S(4) = imread(fullpath(getIPCVpath() + "/images/stitching/sk4.jpg"));
    //    S(5) = imread(fullpath(getIPCVpath() + "/images/stitching/sk5.jpg"));
    //    S(6) = imread(fullpath(getIPCVpath() + "/images/stitching/sk6.jpg"));
    //    St  = imstitchimage(S);
    //    subplot(321);imshow(S(1));
    //    subplot(322);imshow(S(2));
    //    subplot(323);imshow(S(3));
    //    subplot(324);imshow(S(4));
    //    subplot(325);imshow(S(5));
    //    subplot(326);imshow(S(6));    
    //    scf();imshow(St);
    //
    //
    // See also
    //   imstitchimage_params
    //  
    // Authors
    //   Tan Chin Luh
    
    [lhs ,rhs]=argn();
    
  
    if rhs <1 then error('At least 1 argument required, a List of images'); end
    if rhs <2 then  params = imstitchimage_params(); end
    
    RegistrationResol = params.RegistrationResol;
    SeamEstimationResol = params.SeamEstimationResol;
    CompositingResol = params.CompositingResol;
    PanoConfidenceThresh = params.PanoConfidenceThresh;
    WaveCorrection = params.WaveCorrection;
    BlenderBands = params.BlenderBands;
    
imout  = int_imstitchImage(S,RegistrationResol,SeamEstimationResol,CompositingResol,PanoConfidenceThresh,WaveCorrection,BlenderBands);


endfunction
