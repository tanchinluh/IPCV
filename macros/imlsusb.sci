//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================

function out = imlsusb()
    // List all USB devices connected to PC (linux only)
    //
    // Syntax
    //    out = imlsusb()
    //
    // Parameters
    //    out : Strings containing the devices information
    //
    // Description
    //    The function list all the devices connected to the PC through USB ports. 
    // 
    // Examples
    //    imlsusb()
    //
    // See also
    //    imcaminfo
    //
    // Authors
    //    Tan Chin Luh
    //
        
    out = unix_g("lsusb");
endfunction
