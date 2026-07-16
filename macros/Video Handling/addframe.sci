// function addframe
//    Add a frame to the video file. (Deprecated alias of aviaddframe.)
//    
//    Syntax
//    n = addframe(n, im)
//    
//    Parameters
//    n : The opened video file index, the return value of avifile .
//    im : The input image which must be UINT8 RGB image. If the image size is not the same with the argument dims of function avifile , the image will be resized to dims .
//    
//    Description
//    addframe is retained for compatibility and calls the same writer gateway
//    as aviaddframe. New code should use aviaddframe.
//    
//    Video support for IPCV is only available when IPCV is compiled with OpenCV which support video I/O.
//    
//    Examples
//    image = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
//    outputFile = fullfile(TMPDIR, "addframe_compatibility.avi");
//    if isfile(outputFile) then mdelete(outputFile); end
//    writer = avifile(outputFile, [300; 300], 30, "MJPG");
//
//    for frameIndex = 1:30
//        frame = imrotate(image, 2 * (frameIndex - 1));
//        frame = imresize(frame, [300 300], "area");
//        addframe(writer, frame);
//    end
//
//    aviclose(writer);
//    disp(outputFile);
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
