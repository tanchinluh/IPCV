// function filter2
//    2D digital filtering
//    
//    Syntax
//      inf = filter2(im,F)
//    
//    Parameters
//      im : An image/matrix which will be filterd. The image can be INT8, UINT8, INT16, UINT16, INT32, DOUBLE.
//      F : A double 2D filter.
//      imf : The filtered image which has the same size with imf and the class double.
//    
//    Description
//      filter2 filters an image im with filter F. When im is a mult-channel image, each channel can be filtered with F seperately. Input image pixel values outside the bounds of the image are assumed to equal the nearest array border value.
//    
//      The only diffence of filter2 with imfilter is the output of filter2 is double matrix, and the output of imfilter has the same type as input and the elements in the output matrix that exceed the range of the integer type will be truncated.
//    
//    Examples
//      im = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
//      filter = fspecial('sobel');
//      imf = filter2(im,filter);
//      imshow(imf);
//     
//    See also
//      fspecial
//      imfilter
//     
//    Authors
//      Shiqi Yu
//      Tan Chin Luh
//
