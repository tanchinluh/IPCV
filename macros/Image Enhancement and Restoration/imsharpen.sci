function out = imsharpen(image, radius, amount)
    // Apply an unsharp-mask enhancement and return uint8 output.
    rhs = argn(2);
    if rhs < 2 then radius = 1; end
    if rhs < 3 then amount = 1; end
    if type(radius) <> 1 | size(radius, "*") <> 1 | radius <= 0 then error("radius must be a positive scalar."); end
    if type(amount) <> 1 | size(amount, "*") <> 1 | amount < 0 then error("amount must be a nonnegative scalar."); end
    ksize = max(3, 2 * ceil(radius * 2) + 1);
    source = im2uint8(image);
    blurred = imgaussianblur(source, [ksize ksize], radius, radius);
    sharpened = double(source) + amount .* (double(source) - double(blurred));
    sharpened(sharpened < 0) = 0;
    sharpened(sharpened > 255) = 255;
    out = uint8(round(sharpened));
endfunction
