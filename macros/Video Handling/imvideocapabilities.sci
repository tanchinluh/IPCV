function capabilities = imvideocapabilities()
    // Report currently exposed video/camera capabilities.
    //
    // Syntax
    //    capabilities = imvideocapabilities()
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs <> 0 then
        error("imvideocapabilities: Wrong number of input arguments.");
    end
    capabilities.openVideo = %t;
    capabilities.readFrame = %t;
    capabilities.writeVideo = %t;
    capabilities.openCamera = %t;
    capabilities.readCamera = %t;
    capabilities.propertyGetSet = %f;
    capabilities.propertyGetSetReason = "No video/camera property gateway is exposed in this IPCV build.";
endfunction
