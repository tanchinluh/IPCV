// function camclose
//    Close a camera
//    
//    Syntax
//    camclose(n)
//    
//    Parameters
//    n : The opened camera index.
//    
//    Description
//    camclose close an opened camera.
//    
//    Video support for IPCV is only available when IPCV is compiled with OpenCV which support video I/O.
//    
//    Examples
//    n = camopen(0);
//    sleep(200);
//    im = camread(n); //get a frame
//    imshow(im);
//    camclose(n);
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
