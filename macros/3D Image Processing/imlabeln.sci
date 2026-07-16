function [labels, count] = imlabeln(image, connectivity)
    // Label connected components in a binary image.
    //
    // Syntax
    //    [labels, count] = imlabeln(image)
    //    [labels, count] = imlabeln(image, connectivity)
    //
    // The current Scilab gateway supports 2D inputs with 4- or 8-connectivity.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/circbw.tif"));
    //    [labels, count] = imlabeln(image, 8);
    //    disp(count);
    //
    // See also
    //    imconnectedcomponents
    //    imbweuler
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    if argn(2) < 1 | argn(2) > 2 then error("imlabeln: invalid arguments."); end
    if argn(2) < 2 then connectivity = 8; end
    if size(size(image), "*") <> 2 then error("imlabeln: 2D input is required by the current Scilab gateway."); end
    if connectivity <> 4 & connectivity <> 8 then error("imlabeln: connectivity must be 4 or 8 for 2D input."); end
    [labels, count] = imconnectedcomponents(image, connectivity);
endfunction
