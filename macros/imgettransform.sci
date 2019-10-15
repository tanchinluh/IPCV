//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function mat = imgettransform(src,tgt,tf_type)
    // Get transformation matrix from given source and destination points
    //
    // Syntax
    //    mat = imgettransform(src,tgt)
    //
    // Parameters
    //    src : Source points
    //    tgt : Target points
    //    tf_type : Transformation type, affine or perspective
    //    mat : Transformation matrix
    //
    // Description
    //    This functions create the transformation matrix for affine and perspective transform operation.
    //
    // Examples
    //    src = [261 412; 170 348; 213 282];
    //    tgt = [175 412; 170 308; 251 308];
    //    mat = imgettransform(src,tgt,'affine')
    // 
    // See also
    //     warpmatselect
    //     imtransform
    //     
    // Authors
    //    Tan Chin Luh
    //


    //

    rhs=argn(2);
    if rhs < 3; error("Expect at least 3 arguments, source points, target points, and transformation type."); end    

    select tf_type
    case 'affine'
        mat = int_getaffinetransform(src,tgt);
    case 'perspective'
        mat = int_getperspectivetransform(src,tgt);
    else
        error('Transformation type must be either ''affine'' or ''perspective''.');

    end

    mat = mat';

endfunction








