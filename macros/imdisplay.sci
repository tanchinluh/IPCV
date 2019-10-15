// function imdisplay
//    Display image using highgui for faster frame rate
//    
//    Syntax
//    imdisplay(im, wn)
//    
//    Parameters
//    im : Input image which should be in RGB format.
//    wn : Graphic window name to differentiate one from another.
//    
//    Description
//    This is a special function to display the sequences of images from webcam for better speed. This graphic window must be close by : 1. Pressing Esc key with the window on focus. 2. Calling imdestroy(windowname)
//    
//    Examples
//    im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
//    imdisplay(im,'MyImage');
//    imdestroy('MyImage');
//     
//     
//    
//    See also
//    imread
//    imdestroy
//    imdestroyall
//    
//    Authors
//    Tan Chin Luh
