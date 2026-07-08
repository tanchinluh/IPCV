// function aviopen
//    Open a video file.
//    
//    Syntax
//    n = aviopen(filename)
//    
//    Parameters
//    filename : A string, the video filename to be read.
//    n : A number, the opened video file index.
//    
//    Description
//    aviopen open a video file, but it does not read frames from the file. 
//    
//    Please use im=avireadframe(n) to get a frame from the n'th opened video file. 
//    
//    Remember to close the opened file using aviclose(n) or avicloseall().
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
//    Authors
//    Shiqi Yu
//    Tan Chin Luh
