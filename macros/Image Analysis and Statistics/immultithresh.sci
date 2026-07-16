function edges = immultithresh(image, count)
    // Estimate multiple intensity thresholds using histogram quantiles.
    //
    // Syntax
    //    edges = immultithresh(image, count)
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/peppers.png"));
    //    edges = immultithresh(image, 3);
    //    labels = imquantize(image, edges);
    //    imshow(imlabel2rgb(labels));
    //
    // See also
    //    imquantize
    //    imthreshold
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    if argn(2) <> 2 | count < 1 | count <> round(count) then error("immultithresh: count must be a positive integer."); end
    gray = im2uint8(image);
    if size(size(gray), "*") == 3 then gray = rgb2gray(gray); end
    [counts, cells] = imhist(gray, 256);
    cdf = cumsum(counts) / sum(counts);
    edges = zeros(1, count);
    for i = 1:count
        index = find(cdf >= i / (count + 1));
        if isempty(index) then edges(i) = 255; else edges(i) = cells(index(1)); end
    end
endfunction
