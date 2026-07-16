function value = imbweuler(image, connectivity)
    // Compute the Euler number of a binary image.
    //
    // Syntax
    //    value = imbweuler(image)
    //    value = imbweuler(image, connectivity)
    //
    // Examples
    //    [x, y] = meshgrid(1:260, 1:180);
    //    solid = (x - 45).^2 + (y - 50).^2 <= 25^2;
    //    ring = ((x - 125).^2 + (y - 50).^2 <= 30^2) & ((x - 125).^2 + (y - 50).^2 >= 13^2);
    //    plate = (x >= 130) & (x <= 235) & (y >= 105) & (y <= 165);
    //    holes = ((x - 160).^2 + (y - 135).^2 < 12^2) | ((x - 205).^2 + (y - 135).^2 < 12^2);
    //    mask = solid | ring | (plate & ~holes);
    //    value = imbweuler(mask, 8);
    //    imshow(mask);
    //    xtitle(msprintf("3 objects - 3 holes: Euler number = %d", value));
    //
    // See also
    //    imconnectedcomponents
    //    imfillholes
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.
    if argn(2) < 1 | argn(2) > 2 then error("imbweuler: Wrong number of input arguments."); end
    if argn(2) < 2 then connectivity = 8; end
    mask = ipcv_binary_mask(image, "imbweuler");
    [labels, objects] = imconnectedcomponents(mask, connectivity);
    padded = impadarray(~mask, [1 1], "constant", %t);
    [bgLabels, bgObjects] = imconnectedcomponents(padded, connectivity);
    holes = max(0, bgObjects - 1);
    value = objects - holes;
endfunction
