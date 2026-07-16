function out = imtranslate(image, offset)
    // Translate an image by [x y] pixels.
    //
    // Syntax
    //    out = imtranslate(image, offset)
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //    out = imtranslate(image, [20 10]);
    //    imshow(out);
    //
    // See also
    //    imtransform
    //    imflip
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    if argn(2) <> 2 then error("imtranslate: image and [x y] offset are required."); end
    if size(offset, "*") <> 2 then error("imtranslate: offset must be [x y]."); end
    sz = size(image);
    matrix = [1 0 offset(1); 0 1 offset(2)];
    out = imtransform(image, matrix, "affine", sz(2), sz(1));
endfunction
