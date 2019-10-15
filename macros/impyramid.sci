// function impyramid
//    Image pyramid reduction and expansion
//    
//    Syntax
//    imout = imresize(imin, direction)
//    
//    Parameters
//    imin : An image which will be downsampled or upsampled.
//    direction : Can be 'reduce' or 'expand'. If direction is 'reduce', impyramid computes a Gaussian pyramid reduction of imin by one level. If direction is 'expand', impyramid computes a Gaussian pyramid expansion of imin by one level. Gaussian 5x5 filter is currently supported.
//    imout : The output reduced or expanded image.
//    
//    Description
//    imout=impyramid(imin,direction) computes a Gaussian pyramid reduction or expasion of imin by one level. Direction can be 'reduce' or 'expand'. If imin is mxn and direction is 'reduce', then the size of imout is ceil(m/2)xceil(n/2). If direction is 'expand', then the size of imout is (2xm)x(2xn).
//    
//    Examples
//    //Compute a four-level multiresolution pyramid of the 'lena' image.
//    
//    im0 = imread(fullpath(getIPCVpath() + "/images/" + 'baboon.png'));
//    im1 = impyramid(im0, 'reduce');
//    im2 = impyramid(im1, 'reduce');
//    im3 = impyramid(im2, 'reduce');
//    
//    imshow(im0);
//    imshow(im1);
//    imshow(im2);
//    imshow(im3);
//    
//    See also
//    imresize 
//    
//    Authors
//    Jia Wu
//    Tan Chin Luh
