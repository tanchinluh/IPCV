//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================

function out = imcaminfo(dev)
    // Show the supported raw resolution for an USB camera (linux only)
    //
    // Syntax
    //    out = imcaminfo(dev)
    //
    // Parameters
    //    dev : USB bus number and device number for the connected device in string
    //    out : Strings containing the list of supported resolution for the camera
    //
    // Description
    //    The function show the supported raw resolution for an USB camera connected to the given device and bus numbers(linux only)
    // 
    // Examples
    //    out = imcaminfo('001:005')
    //
    // See also
    //    imlsusb
    //
    // Authors
    //    Tan Chin Luh

    out = unix_g('lsusb -s '+ dev +' -v | egrep ""Width|Height""');

endfunction
