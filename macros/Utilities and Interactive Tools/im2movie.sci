//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function err = im2movie(mvfn,sz,fps,fourcc,repeat)
    // Create movie from sequence of images
    //
    // Syntax
    //    err = im2movie(mvfn,imfn,sz,fps,fourcc)
    //
    // Parameters
    //    mvfn : Output moive filename
    //    sz : A 1x2 vector, which indicates the frame size (width, height).
    //    fps : Frame pre second
    //    fourcc : 4-character code of codec used to compress the frames
    //    repeat : How many times to repeat the sequence images
    //    err : Error message if any
    //
    // Description
    //    This function convert sequence of images to movie with given setting.
    //
    // Examples
    //    err = im2movie('test.avi',[1000 600],30,'xvid');
    //
    // See also
    //     avifile
    //     addframe
    //
    // Authors
    //    Copyright (C) 2012 - Trity Technologies.
    //


    rhs=argn(2);
    if rhs < 1; error("Expect at least 1 argument, movie filename"); end    
    if rhs <5 then repeat = 1; end
    if rhs <4 then fourcc = 0; end
    if rhs <3 then fps = 10; end
    if rhs <2 then sz = [100 100]; end


    n = avifile(mvfn, [sz(1);sz(2)], fps,fourcc);

    imgsq = uigetfile("*","", "Choose images to convert to movie", %t);

    imgnum = size(imgsq,2);

    for cnt = 1:repeat
        for num=1:imgnum
            S = imread(imgsq(num));
            addframe(n, S);
        end
    end


    aviclose(n);

    err = lasterror;
endfunction
