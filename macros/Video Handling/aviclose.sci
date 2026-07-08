// function aviclose
//    Close a video file. 
//    
//    Syntax
//    aviclose(n)
//    
//    Parameters
//    n : The opened file/camera index.
//    
//    Description
//    aviclose close an opened video file or camera.
//    
//    Video support for IPCV is only available when IPCV is compiled with OpenCV which support video I/O.
//    
//    Examples
//    n = aviopen(fullpath(getIPCVpath() + "/images/video.avi"));
//    im = avireadframe(n); //get a frame
//    imshow(im);
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
//    
//    Authors
//    Shiqi Yu 
//    Tan Chin Luh
//
