function out = imflip(image, direction)
    // Flip an image around a horizontal, vertical, or both axes.
    //
    // Syntax
    //    out = imflip(image)
    //    out = imflip(image, direction)
    //
    // direction is "horizontal", "vertical", or "both". Horizontal flips
    // reverse columns; vertical flips reverse rows. Image coordinates remain
    // top-left based, as they are for imcrop and the OpenCV drawing APIs.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //    out = imflip(image, "horizontal");
    //    imshow(out);
    //
    // See also
    //    imrotate
    //    imcrop
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.

    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imflip: Wrong number of input arguments."); end
    if rhs < 2 then direction = "horizontal"; end
    direction = convstr(direction, "l");
    dims = size(size(image), "*");
    if dims <> 2 & dims <> 3 then error("imflip: image must be 2D or 3D."); end

    select direction
    case "horizontal" then
        if dims == 2 then out = image(:, $:-1:1); else out = image(:, $:-1:1, :); end
    case "vertical" then
        if dims == 2 then out = image($:-1:1, :); else out = image($:-1:1, :, :); end
    case "both" then
        if dims == 2 then out = image($:-1:1, $:-1:1); else out = image($:-1:1, $:-1:1, :); end
    else
        error("imflip: direction must be horizontal, vertical, or both.");
    end
endfunction
