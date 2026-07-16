function fobj = imdetect_KAZE(image)
    // Detect KAZE keypoints using OpenCV.
    if argn(2)<>1 then error("imdetect_KAZE: image is required."); end
    if typeof(image)<>"uint8" then image=im2uint8(image); end
    fobj=ipcv_keypoint_object(int_imdetect_KAZE(image),"KAZE");
endfunction
