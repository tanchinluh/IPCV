function camopen()
//    Open a camera. 
//    
//    Syntax
//    n = camopen(i)
//    n = camopen(i,[width, height])
//    
//    Parameters
//    i : The i'th camera.
//    [width, height] : Desired camera resolution.
//    n : A number, the opened video file/camera index.
//    
//    Description
//    camopen open a camera, but it does not read frames from the camera. Please use im=camread(n) to get a frame from the n'th opened video file. Remember to close the opened camera using camclose(n) or camcloseall() .
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
//    Shiqi Yu
//    Tan Chin Luh
//
endfunction
