// function aviaddframe
//    Add a frame to the video file. 
//    
//    Syntax
//    n = aviaddframe(n, im)
//    
//    Parameters
//    n : The opened video file index, the return value of avifile .
//    im : The input image which must be UINT8 RGB image. If the image size is not the same with the argument dims of function avifile , the image will be resized to dims .
//    
//    Description
//    aviaddframe appends one frame to the writer opened by avifile.
//    The writer must have been created successfully and must remain open.
//    
//    Video support for IPCV is only available when IPCV is compiled with OpenCV which support video I/O.
//    
//    Examples
//    image = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
//    outputFile = fullfile(TMPDIR, "aviaddframe_zoom.avi");
//    if isfile(outputFile) then mdelete(outputFile); end
//    writer = avifile(outputFile, [300; 300], 30, "MJPG");
//
//    for frameIndex = 1:90
//        margin = round((frameIndex - 1) * 1.5);
//        cropped = image(1 + margin:$ - margin, 1 + margin:$ - margin, :);
//        frame = imresize(cropped, [300 300], "area");
//        aviaddframe(writer, frame);
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
