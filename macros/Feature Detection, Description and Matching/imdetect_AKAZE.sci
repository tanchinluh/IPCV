function fobj = imdetect_AKAZE(image)
    // Detect AKAZE keypoints using OpenCV.
    if argn(2)<>1 then error("imdetect_AKAZE: image is required."); end
    if typeof(image)<>"uint8" then image=im2uint8(image); end
    fobj=ipcv_keypoint_object(int_imdetect_AKAZE(image),"AKAZE");
endfunction
