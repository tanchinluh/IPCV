function peaks = imhoughpeaks(accumulator, count, threshold, suppression)
    // Extract local peaks from a Hough accumulator.
    //
    // Syntax
    //    peaks = imhoughpeaks(accumulator, count, threshold, suppression)
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/2lines.png"));
    //    [accumulator, rho, theta] = imhough(image);
    //    peaks = imhoughpeaks(accumulator, 10);
    //    disp(peaks);
    //
    // See also
    //    imhough
    //    imhoughlines
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    rhs = argn(2); if rhs < 2 | rhs > 4 then error("imhoughpeaks: invalid arguments."); end
    if rhs < 3 then threshold = 0; end
    if rhs < 4 then suppression = [9 9]; end
    if size(suppression, "*") <> 2 then error("imhoughpeaks: suppression must be [rows cols]."); end
    work = double(accumulator); peaks = zeros(2, 0); n = round(count);
    for k = 1:n
        best = max(matrix(work, -1, 1));
        if best <= threshold then break; end
        index = find(matrix(work, -1, 1) == best); index = index(1);
        r = modulo(index - 1, size(work, 1)) + 1; c = floor((index - 1) / size(work, 1)) + 1;
        peaks(:, $ + 1) = [r; c];
        r1 = max(1, r - floor(suppression(1) / 2)); r2 = min(size(work, 1), r + floor(suppression(1) / 2));
        c1 = max(1, c - floor(suppression(2) / 2)); c2 = min(size(work, 2), c + floor(suppression(2) / 2));
        work(r1:r2, c1:c2) = 0;
    end
endfunction
