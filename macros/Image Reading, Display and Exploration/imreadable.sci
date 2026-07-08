//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
//=============================================================================
function supported = imreadable(filename)
    //    Check whether OpenCV can read an image file
    //
    //    Syntax
    //      supported = imreadable(filename)
    //
    //    Parameters
    //      filename : A string, the image filename to check.
    //      supported : Boolean value. %t means OpenCV has a reader for the file and can open it.
    //
    //    Description
    //      imreadable checks OpenCV image reader support without decoding the full image.
    //
    //    Examples
    //      filename = fullpath(getIPCVpath() + "/images/" + "baboon.png");
    //      imreadable(filename)
    //
    //    See also
    //      imread
    //      imwritable
    //
    //    Authors
    //      Tan Chin Luh

    rhs = argn(2);
    if rhs <> 1 then
        error("imreadable: Expect one input argument, image filename.");
    end
    if typeof(filename) <> "string" | size(filename, "*") <> 1 then
        error("imreadable: filename must be a scalar string.");
    end

    supported = int_imreadable(filename);
endfunction
