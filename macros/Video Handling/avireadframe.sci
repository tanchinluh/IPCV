// function avireadframe
//    Grabs and returns a frame from a opened video file or camera.
//    
//    Syntax
//    im = avireadframe(n, fnum)
//    
//    Parameters
//    n : The opened video file/camera index.
//    fnum : Frame number, specify which frame to be retrived
//    im : The returned frame/image. If no frame, return 0.
//    
//    Description
//    avireadframe grabs and returns a frame from an opened video file or camera. We could specified which frame to be retrived at the second input argument.
//    
//    Video support for IPCV is only available when IPCV is compiled with OpenCV which support video I/O.
//    
//    Examples
//    n = aviopen(fullpath(getIPCVpath() + "/images/video.avi"));
//    im = avireadframe(n,100); //get a frame
//    imshow(im);
//    
//    avilistopened()
//    aviclose(n);
//     
//    See also
//    avifile
//    aviopen
//    aviaddframe
//    aviclose
//    avicloseall
//    avilistopened
//    avireadframe 
//    
//    Authors
//    Shiqi Yu
//    Tan Chin Luh

