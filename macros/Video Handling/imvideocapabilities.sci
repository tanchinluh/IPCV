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
    capabilities.propertyGetSet = %t;
    capabilities.seekVideo = %t;
    capabilities.propertyGetSetReason = "OpenCV backend support varies by property and device.";
endfunction
