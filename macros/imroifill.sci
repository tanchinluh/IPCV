//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Copyright (C) 2017  Tan Chin Luh
//=============================================================================

function result = imroifill(imin,mask)
    // Fill and image using the border color of the selected region
    //
    // Syntax
    //     result = imroifill(imin,mask)
    //
    // Parameters
    //     imin : Input Image
    //     mask : Input mask
    //     result : Output Image
    //
    // Description
    //    This function is to fill the selected region with the borders' value, which 
    //    would remove an object from an image/
    //    
    // Examples
    //    S = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //    mask = imroi(S);
    //    imout = imroifill(S,mask);
    //    imshow(S);
    //    figure(); imshow(imout);
    //
    // See also
    //    imroi
    //    imroifilt
    //    
    // Authors
    //    Tan Chin Luh
    //


    //

    result = imin;
    ///
    maskb = im2bw(mask,0.5);
    perimeter=bwborder(maskb);

    interior = im2bw(mask,0.5) & ~im2bw(perimeter,0.5);

    idx = find(interior);

    grid = zeros(mask);
    grid(idx) = 1:length(idx);
    [M,N] = size(grid);
    perimValues = zeros(M,N);
    perimIdx = find(perimeter); 
    perimValues(perimIdx) = imin(perimIdx)
    rightside = zeros(M,N);

    rightside(2:(M-1),2:(N-1)) = perimValues(1:(M-2),2:(N-1)) + ...
    perimValues(3:M,2:(N-1)) + perimValues(2:(M-1),1:(N-2)) + ...
    perimValues(2:(M-1),3:N);

    rightside = rightside(idx);
    i = grid(idx);
    j = grid(idx);
    s = 4*ones(idx)';            
    idx = idx';
    for k = [-1 M 1 -M]
        // Possible neighbors in the k-th direction
        Q = grid(idx+k);
        // Index of points with interior neighbors
        q = find(Q)';
        // Connect interior points to neighbors with -1's.
        i = [i; grid(idx(q))]; //#ok<AGROW>
        j = [j; Q(q)];
        s = [s; -ones(length(q),1)];
    end

    D = sparse([i,j],s);
    x = D \ rightside;
    result(idx) = x;
    //end

endfunction

