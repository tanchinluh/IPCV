function limits = imstretchlim(image, lowHigh)
    // Calculate robust low and high intensity limits.
    //
    // Syntax
    //    limits = imstretchlim(image)
    //    limits = imstretchlim(image, [low high])
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/Lena_dark.png"));
    //    image = im2double(image);
    //    limits = imstretchlim(image, [0.01 0.99]);
    //    out = imadjust(image, limits, [0 1]);
    //    imshow(out);
    //
    // See also
    //    imadjust
    //    imnormalize
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imstretchlim: Wrong number of input arguments."); end
    if rhs < 2 then lowHigh = [0.01 0.99]; end
    if size(lowHigh, "*") <> 2 | lowHigh(1) < 0 | lowHigh(2) > 1 | lowHigh(1) >= lowHigh(2) then error("imstretchlim: lowHigh must be [low high] in [0 1]."); end
    image = im2double(image);
    dims = size(image);
    channels = 1;
    if size(dims, "*") == 3 then channels = dims(3); end
    limits = zeros(2, channels);
    for c = 1:channels
        if channels == 1 then values = gsort(matrix(image, -1, 1), "g", "i"); else values = gsort(matrix(image(:, :, c), -1, 1), "g", "i"); end
        n = size(values, "*");
        limits(1, c) = values(max(1, round(lowHigh(1) * (n - 1)) + 1));
        limits(2, c) = values(min(n, round(lowHigh(2) * (n - 1)) + 1));
    end
    if channels == 1 then limits = limits(:); end
endfunction
