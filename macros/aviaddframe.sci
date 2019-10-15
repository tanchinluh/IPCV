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
//    addframe add a frame to video file n.
//    
//    Video support for IPCV is only available when IPCV is compiled with OpenCV which support video I/O.
//    
//    Examples
//    im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
//    n = avifile('baboon.avi', [300;300], 30,'xvid');
//    for ii=1:200
//        ims = im(ii:512-ii, ii:512-ii, :);
//        aviaddframe(n, ims);
//    end
//    
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
