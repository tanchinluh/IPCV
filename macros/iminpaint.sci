//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = iminpaint(imin,mask,rad,method)
    // Restores the selected region in an image using the region neighborhood
    //
    // Syntax
    //     imout = iminpaint(imin,mask,rad,method)
    //
    // Parameters
    //     imin : Input Image
    //     mask : Input mask
    //     rad : Radius of a circular neighborhood of each point inpainted that is considered by the algorithm
    //     method : Inpainting method that could be either 0 --> Navier-Stokes based method or 1 --> Method by Alexandru Telea
    //     imout : Output Image
    //
    // Description
    //    The function reconstructs the selected image area from the pixel near the area boundary. 
    //    The function may be used to remove dust and scratches from a scanned photo, or to remove undesirable objects from still images or video. 
    //    
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //    mask = imroi(S);
    //    imout = iminpaint(S,mask,1,1);
    //    imshow(S);
    //    figure(); imshow(imout);
    //
    // See also
    //    imroi
    //    imroifilt
    //    
    // Authors
    //    Tan Chin Luh
    //
    // Bibliography
    // 1. http://en.wikipedia.org/wiki/Inpainting 
    //

    // Error Checking
    rhs=argn(2);
    if typeof(imin(1)) ~= 'uint8' | typeof(mask(1)) ~= 'uint8' 
        error('Input image and the mask image must be type of uint8');
    end

    if rhs < 2; error("Expect at least 2 arguments, input image and mask"); end
    if rhs < 3; rad = 1; end
    if rhs < 4; method = 1; end
    if rad == []; rad = 1; end
    if method == []; method = 1; end
    // End of Error Checking




    imout = int_iminpaint(imin,mask,rad,method);


endfunction


