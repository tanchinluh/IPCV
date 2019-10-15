// function avilistopened
//    Show all opened video files. 
//    
//    Syntax
//    I=avilistopened()
//    
//    Parameters
//    I : A vector, the opened video file/camera indices.
//    
//    Description
//    avilistopenedlist all opened files and cameras.
//    
//    Video support for IPCV is only available when IPCV is compiled with OpenCV which support video I/O.
//    
//    Examples
//    n = aviopen(fullpath(getIPCVpath() + "/images/video.avi"));
//    im = avireadframe(n); //get a frame
//    imshow(im);
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
//    
//        
//
