//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================
function [A, BB, ctr] = imblobprop(imin)
    // Calculate blobs properties from labeled image
    //
    // Syntax
    //    [A, BB, ctr] = imblobprop(imin)
    //
    // Parameters
    //    imin : Source Image
    //    A : Area of the blob
    //    BB : Bounding box for the blob
    //    ctr : Centroid of the blob
    //
    // Description
    //    This function find components properties, for now, area and bounding box.
    //
    // Examples
    //    A = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //    A_edge = edge(A,'canny');
    //    se = imcreatese('ellipse',15,15);
    //    A_dilate = imdilate(A_edge,se);
    //    [A_labeled,n] = imlabel(A_dilate);
    //    imshow(A_labeled,jet(n));
    //    [Area, BB, ctr] = imblobprop(A_labeled);
    //    imrects(BB,[255,0,0]);
    //
    // See also
    //     imlabel
    //
    // Authors
    //    Tan Chin Luh



    n = double(max(imin));

    A = zeros(1,n);
    BB = zeros(4,n);
    ctr = zeros(2,n);    
    for cnt = 1:n
        //disp(cnt);
        A(cnt) =  sum(imin==cnt);
        if A(cnt) == 0 then
            minx = 1;
            maxx = 1;
            miny = 1;
            maxy = 1;
            avgx = 1;
            avgy = 1;
            w = 1;
            h = 1;
        else
            [r,c] = find(imin==cnt);
            minx = min(c);
            maxx = max(c);
            miny = min(r);
            maxy = max(r);
            avgx = mean(c);
            avgy = mean(r);
            w = maxx-minx+1;
            h = maxy-miny+1;
        end

        BB(:,cnt) = [minx miny w h]';
        ctr(:,cnt) = [avgx avgy]';
        //disp(cnt);
    end



endfunction
