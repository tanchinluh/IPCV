//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
//=============================================================================
function supported = imwritable(filename)
    //    Check whether OpenCV can write an image format
    //
    //    Syntax
    //      supported = imwritable(filename)
    //      supported = imwritable(extension)
    //
    //    Parameters
    //      filename : A string, the image filename or extension to check.
    //      extension : A string with a leading period, such as ".png" or ".jpg".
    //      supported : Boolean value. %t means OpenCV has a writer for the format.
    //
    //    Description
    //      imwritable checks OpenCV image writer support for a filename or extension.
    //
    //    Examples
    //      imwritable(".png")
    //      imwritable(".jpg")
    //
    //    See also
    //      imwrite
    //      imreadable
    //
    //    Authors
    //      Tan Chin Luh

    rhs = argn(2);
    if rhs <> 1 then
        error("imwritable: Expect one input argument, image filename or extension.");
    end
    if typeof(filename) <> "string" | size(filename, "*") <> 1 then
        error("imwritable: filename must be a scalar string.");
    end

    supported = int_imwritable(filename);
endfunction
