function magnitude = imgradientmagnitude(image)
    // Return the Sobel gradient magnitude.
    [gx, gy] = imgradientxy(image);
    magnitude = sqrt(gx .^ 2 + gy .^ 2);
endfunction
