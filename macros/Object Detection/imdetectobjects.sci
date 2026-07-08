////////////////////////////////////////////////////////////
//
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//
////////////////////////////////////////////////////////////
function [r] = imdetectobjects(S,cfn,fac,minNB,minSz,maxSz)
    // Detect Objects In an Image with Cascade Classification
    //
    // Syntax
    //      r = imdetectobjects(S,cfn)
    //      r = imdetectobjects(S,cfn,fac)
    //      r = imdetectobjects(S,cfn,fac,minNB)
    //      r = imdetectobjects(S,cfn,fac,minNB,minSz)
    //      r = imdetectobjects(S,cfn,fac,minNB,minSz,maxSz) 
    //
    // Parameters
    //      S : Source image.
    //      cfn : Classifier file name, in xml format.
    //      fac : Parameter specifying how much the image size is reduced at each image scale. Default value is 1.1
    //      minNB : Parameter specifying how many neighbors each candidate rectangle should have to retain it. Default value is 3
    //      minSz : Minimum possible object size. Objects smaller than that are ignored. In [w h] format. Default value is [30 30]
    //      maxSz : Maximum possible object size. Objects larger than that are ignored. In [w h] format. Default value not set will be unlimited
    //
    // Description
    //      imdetectobjects Detects objects of different sizes in the input image. The detected objects are returned as a list of rectangles.
    //
    // Examples
    //      S = imread(fullpath(getIPCVpath() + "/images/people2.jpg"));
    //      cfn = fullpath(getIPCVpath() + "/demos/haarcascade_frontalface_alt.xml");
    //      r = imdetectobjects(S,cfn);
    //      imshow(S);
    //      imrects(r,[0 255 0]);
    //
    // See also
    //      imrects
    //
    // Authors
    //      Tan Chin Luh

    rhs=argn(2);

    if rhs < 2; error("Expect at least 2 arguments, S and cfn");end
    if rhs < 3; fac = 1.1;end
    if rhs < 4; minNB = 3; end
    if rhs < 5; minSz = [30 30]; end
    if rhs < 6; maxSz = [size(S,2),size(S,1)]; end

    if fac == [] ; fac = 1.1;end
    if minNB == []; minNB = 3; end
    if minSz == []; minSz = [30 30]; end
    if maxSz == []; maxSz = [size(S,2),size(S,1)]; end


    r = int_detectobjects(S,cfn,fac,minNB,minSz,maxSz);

    r = double(r);

endfunction
