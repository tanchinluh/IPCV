function value = impsnr(im1, im2, peak)
    // Compute peak signal-to-noise ratio between two images.
    //
    // Syntax
    //    value = impsnr(im1, im2)
    //    value = impsnr(im1, im2, peak)
    //
    // Parameters
    //    im1 : First image.
    //    im2 : Second image with the same size as im1.
    //    peak : Peak signal value. Default is inferred from the input type.
    //    value : PSNR value in dB.
    //
    // Authors
    //    Tan Chin Luh

    rhs = argn(2);
    if rhs < 2 | rhs > 3 then
        error("impsnr: Wrong number of input arguments.");
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

    mse = immse(im1, im2);
    if mse == 0 then
        value = %inf;
    else
        value = 10 * log10((peak * peak) / mse);
    end
endfunction
