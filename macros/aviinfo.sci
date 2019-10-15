// function aviinfo
//    Retrieve video file information 
//    
//    Syntax
//    [frames,width,height,fps]=aviinfo(filename)
//    
//    Parameters
//    filename : Video filename.
//    frames : Total number of frames in the video.
//    width : Width of the frame.
//    height : Height of the frame.
//    fps : Frame per second for the video.
//    
//    Description
//    addframe add a frame to video file n.
//    
//    Retrieve video file information. This function return 4 important information for a video file to be used in other functions.
//    
//    Examples
//    [frames,width,height,fps]=aviinfo(fullpath(getIPCVpath() + "/images/video.avi"));
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
//    Tan Chin Luh
//
