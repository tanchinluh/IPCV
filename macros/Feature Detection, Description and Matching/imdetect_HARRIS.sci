function fobj = imdetect_HARRIS(image, maxCorners, qualityLevel, minDistance, blockSize, k)
    // Detect Harris corners using OpenCV's GFTT Harris mode.
    rhs=argn(2); if rhs<1 then error("imdetect_HARRIS: image is required."); end
    if rhs<2 then maxCorners=500; end; if rhs<3 then qualityLevel=0.01; end; if rhs<4 then minDistance=1; end; if rhs<5 then blockSize=2; end; if rhs<6 then k=0.04; end
    if typeof(image)<>"uint8" then image=im2uint8(image); end
    r=int_imdetect_HARRIS(image,maxCorners,qualityLevel,minDistance,blockSize,k);
    fobj=ipcv_keypoint_object(r,"HARRIS");
endfunction
