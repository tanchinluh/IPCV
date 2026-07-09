function value = imssim(im1, im2, peak)
    // Compute a global structural similarity score between two images.
    //
    // Syntax
    //    value = imssim(im1, im2)
    //    value = imssim(im1, im2, peak)
    //
    // Parameters
    //    im1 : First image.
    //    im2 : Second image with the same size as im1.
    //    peak : Peak signal value. Default is inferred from the input type.
    //    value : Mean global SSIM score over channels.
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 3 then
        error("imssim: Wrong number of input arguments.");
    end
    if or(size(im1) <> size(im2)) then
        error("imssim: Input images must have the same size.");
    end
    if rhs < 3 then
        t = typeof(im1);
        if t == "uint16" then
            peak = 65535;
        elseif t == "uint8" then
            peak = 255;
        else
            if max(double(im1)) <= 1 & max(double(im2)) <= 1 then
                peak = 1;
            else
                peak = 255;
            end
        end
    end

    dims = size(im1);
    if size(dims, "*") < 3 then
        channels = 1;
    else
        channels = dims(3);
    end
    c1 = (0.01 * peak) ^ 2;
    c2 = (0.03 * peak) ^ 2;
    scores = zeros(1, channels);

    for c = 1:channels
        if channels == 1 then
            x = matrix(double(im1), -1, 1);
            y = matrix(double(im2), -1, 1);
        else
            x = matrix(double(im1(:, :, c)), -1, 1);
            y = matrix(double(im2(:, :, c)), -1, 1);
        end
        ux = mean(x);
        uy = mean(y);
        vx = mean((x - ux) .^ 2);
        vy = mean((y - uy) .^ 2);
        vxy = mean((x - ux) .* (y - uy));
        scores(c) = ((2 * ux * uy + c1) * (2 * vxy + c2)) / ((ux ^ 2 + uy ^ 2 + c1) * (vx + vy + c2));
    end
    value = mean(scores);
endfunction
