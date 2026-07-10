function [gx, gy] = imgradientxy(image)
    // Return Sobel horizontal and vertical derivatives.
    dims = size(image);
    if size(dims, "*") == 3 then
        if dims(3) <> 3 then error("image must be grayscale or RGB."); end
        image = rgb2gray(image);
    elseif size(dims, "*") <> 2 then
        error("image must be grayscale or RGB.");
    end
    image = im2uint8(image);
    gx = double(int_sobel(image, 1, 0));
    gy = double(int_sobel(image, 0, 1));
endfunction
