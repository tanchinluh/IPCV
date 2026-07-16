// function avifile
//    Create a new video file to write. 
//    
//    Syntax
//    n = avifile(filename, dims)
//    n = avifile(filename, dims, fps)
//    n = avifile(filename, dims, fps, fourcc)
//    
//    Parameters
//    filename : A string, the video filename to be created.
//    dims : A 1x2 vector, which indicates the frame size (width, height).
//    fps : Frame per second.
//    fourcc : 4-character code of codec used to compress the frames.
//    
//    For example: "MJPG", "XVID", "DIVX", or "mp4v". Available codecs
//    depend on the OpenCV video backend. "MJPG" is recommended for AVI.
//    
//    Under windows:
//    
//    Value 0 indicating uncompressed avi
//    
//    Value -1 to choose compression method and additional compression parameters from dialog.
//    
//    n : A number, the opened video file index.
//    
//    Description
//    
//    The output directory must exist and be writable. Relative filenames are
//    resolved from pwd(); use fullfile() when the destination must be explicit.
//    avifile creates a new video file.
//    
//    After the video file is created, addframe can be used to add frame to the file. Remember to close the opened file using aviclose(n) or avicloseall().
//    
//    Video support for IPCV is only available when IPCV is compiled with OpenCV which support video I/O.
//    
//    Examples
//    image = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
//    outputFile = fullfile(TMPDIR, "baboon_zoom.avi");
//    if isfile(outputFile) then mdelete(outputFile); end
//    n = avifile(outputFile, [300; 300], 30, "MJPG");
//
//    for frameIndex = 1:90
//        margin = round((frameIndex - 1) * 1.5);
//        cropped = image(1 + margin:$ - margin, 1 + margin:$ - margin, :);
//        frame = imresize(cropped, [300 300], "area");
//        aviaddframe(n, frame);
//    end
//
//    aviclose(n);
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
