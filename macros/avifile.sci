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
//    For e.g.: 'xvid', 'mjpg', 'pim1', 'mp42', 'divx','flv1', etc.
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
//    In order to use certain codec, the codec must be installed. 
//    
//    For e.g., xvid required xvid codec (http://www.xvid.org) while the mpg required ffdshow codec. (http://www.free-codecs.com/ffdshow_download.htm)
//    avifile create a new video file. 
//    
//    After the video file is created, addframe can be used to add frame to the file. Remember to close the opened file using aviclose(n) or avicloseall().
//    
//    Video support for IPCV is only available when IPCV is compiled with OpenCV which support video I/O.
//    
//    Examples
//    im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
//    n = avifile('baboon.avi', [300;300], 30,'xvid');
//    
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
