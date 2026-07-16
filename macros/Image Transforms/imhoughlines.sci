function lines = imhoughlines(rho, theta, peaks, imageSize)
    // Convert Hough peak indices to image-border line segments.
    //
    // Syntax
    //    lines = imhoughlines(rho, theta, peaks, imageSize)
    //
    // peaks contains [row; column] indices into rho and theta.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/2lines.png"));
    //    [accumulator, rho, theta] = imhough(image);
    //    peaks = imhoughpeaks(accumulator, 4);
    //    lines = imhoughlines(rho, theta, peaks, size(image));
    //    disp(lines);
    //
    // See also
    //    imhough
    //    imhoughpeaks
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    if argn(2) <> 4 then error("imhoughlines: rho, theta, peaks, and imageSize are required."); end
    h = imageSize(1); w = imageSize(2); lines = zeros(size(peaks, 2), 4);
    for i = 1:size(peaks, 2)
        r = peaks(1, i);
        t = theta(peaks(2, i));
        q = rho(r);
        co = cos(t * %pi / 180);
        si = sin(t * %pi / 180);
        candidates = zeros(0, 2);
        if abs(si) > %eps then
            candidates($ + 1, :) = [1 (q - co) / si];
            candidates($ + 1, :) = [w (q - co * w) / si];
        end
        if abs(co) > %eps then
            candidates($ + 1, :) = [(q - si) / co 1];
            candidates($ + 1, :) = [(q - si * h) / co h];
        end

        points = zeros(0, 2);
        for j = 1:size(candidates, 1)
            x = candidates(j, 1);
            y = candidates(j, 2);
            if x >= 1 - 1d-8 & x <= w + 1d-8 & y >= 1 - 1d-8 & y <= h + 1d-8 then
                x = min(w, max(1, x));
                y = min(h, max(1, y));
                duplicate = %f;
                for k = 1:size(points, 1)
                    if norm(points(k, :) - [x y]) < 1d-6 then duplicate = %t; break; end
                end
                if ~duplicate then points($ + 1, :) = [x y]; end
            end
        end
        if size(points, 1) >= 2 then lines(i, :) = [points(1, 1) points(1, 2) points(2, 1) points(2, 2)]; end
    end
endfunction
