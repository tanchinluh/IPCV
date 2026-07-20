function [labels, count] = imlabeln(image, connectivity)
    // Label connected components in a 2D image or 3D binary volume.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imlabeln: invalid arguments."); end
    dimensions = size(size(image), "*");
    if dimensions <> 2 & dimensions <> 3 then
        error("imlabeln: input must be a 2D image or 3D scalar volume.");
    end
    if rhs < 2 then
        if dimensions == 2 then connectivity = 8; else connectivity = 26; end
    end
    if typeof(image) == "boolean" then mask = image; else mask = image <> 0; end
    if dimensions == 2 then
        if connectivity <> 4 & connectivity <> 8 then
            error("imlabeln: 2D connectivity must be 4 or 8.");
        end
        [labels, count] = imconnectedcomponents(mask, connectivity);
    else
        if connectivity <> 6 & connectivity <> 18 & connectivity <> 26 then
            error("imlabeln: 3D connectivity must be 6, 18, or 26.");
        end
        [labels, count] = int_imlabeln3(mask, connectivity);
    end
endfunction