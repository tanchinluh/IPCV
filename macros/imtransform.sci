//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function imout = imtransform(imin,warpmat,tf_type,width,height)
    // Image affine transformation 
    //
    // Syntax
    //    imout = imtransform(imin,warpmat,tf_type, width,height)
    //
    // Parameters
    //    imin : Source Image
    //    warpmat : Affine transform matrix
    //    tf_type : Transformation type, affine or perspective
    //    width : Output image width
    //    height : Output image height
    //    imout : Transformed Image
    //
    // Description
    //    Applies an affine transformation or perspective transformation to an image.
    //
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/measure_gray.jpg"));
    //    src = [261 412; 170 348; 213 282];
    //    tgt = [175 412; 170 308; 251 308];
    //    mat = imgettransform(src,tgt,'affine')
    //    S2 = imtransform(S,mat,'affine');
    //    imshow(S);
    //    figure();imshow(S2);
    //
    // See also
    //    warpmatselect
    //    imrotate
    //    imgettransform
    //
    // Authors
    //    Tan Chin Luh
    //


    //

    rhs=argn(2);
    sz = size(imin);
    if rhs < 3; error("Expect at least 3 arguments, source image, transformation matrix, and transformation type."); end    
    if rhs < 4; width = sz(2),height = sz(1); end    


    select tf_type
    case 'affine'
        imout = int_affinetransform(imin,warpmat,width,height);   
    case 'perspective'
        imout = int_perspectivetransform(imin,warpmat,width,height);   
    else
        error('Transformation type must be either ''affine'' or ''perspective''.');

    end



endfunction















