// function camread
//    Grabs and returns a frame from a camera
//    
//    Syntax
//    im = camread(n)
//    
//    Parameters
//    n : The opened video file/camera index.
//    im : The returned frame/image. If no frame, return 0.
//    
//    Description
//    camread grabs and returns a frame from a camera.
//    
//    Video support for IPCV is only available when IPCV is compiled with OpenCV which support video I/O.
//    
//    Examples
//    n = camopen(0);
//    sleep(200);
//    im = camread(n); //get a frame
//    imshow(im);
//    camcloseall();
//     
//    See also
//    camclose
//    camcloseall
//    camlistopened
//    camopen
//    camread
//    
//    Authors
//    Tan Chin Luh

