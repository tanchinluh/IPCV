//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
//=============================================================================
function count = imcount(filename)
    //    Count pages or frames in an image file
    //
    //    Syntax
    //      count = imcount(filename)
    //
    //    Parameters
    //      filename : A string, the image filename to inspect.
    //      count : Number of pages or frames in the image file. Single-page images return 1.
    //
    //    Description
    //      imcount returns the page or frame count reported by OpenCV. It is useful before calling imreadmulti on TIFF and other multi-page formats.
    //
    //    Examples
    //      filename = fullpath(getIPCVpath() + "/images/" + "img_multipage.tiff");
    //      count = imcount(filename);
    //
    //    See also
    //      imfinfo
    //      imreadmulti
    //      imread
    //
    //    Authors
    //      Tan Chin Luh

    rhs = argn(2);
    if rhs <> 1 then
        error("imcount: Expect one input argument, image filename.");
    end

    info = imfinfo(filename);
    count = info(4);
endfunction
