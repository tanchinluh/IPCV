function mosaic = imtile(images, gridSize)
    // Arrange a list of images into a display mosaic.
    //
    // Syntax
    //    mosaic = imtile(images)
    //    mosaic = imtile(images, [rows cols])
    //
    // images is a Scilab list. Grayscale inputs are converted to RGB and all
    // tiles are resized to the largest input dimensions. The output is uint8.
    //
    // Examples
    //    image1 = imread(fullpath(getIPCVpath() + "/images/baboon.png"));
    //    image2 = imread(fullpath(getIPCVpath() + "/images/peppers.png"));
    //    image3 = imread(fullpath(getIPCVpath() + "/images/hand.jpg"));
    //    images = list(image1, image2, image3);
    //    mosaic = imtile(images, [1 3]);
    //    imshow(mosaic);
    //
    // See also
    //    imresize
    //    imshow
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.

    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imtile: Wrong number of input arguments."); end
    if typeof(images) <> "list" then error("imtile: images must be a Scilab list."); end
    count = length(images);
    if count == 0 then error("imtile: images must not be empty."); end
    if rhs < 2 then
        gridSize = [ceil(sqrt(count)) ceil(count / ceil(sqrt(count)))];
    end
    if size(gridSize, "*") <> 2 | min(gridSize) < 1 then error("imtile: gridSize must be [rows cols]."); end
    tileRows = round(gridSize(1)); tileCols = round(gridSize(2));
    if tileRows * tileCols < count then error("imtile: grid is too small for the image list."); end

    tiles = list();
    tileHeight = 0; tileWidth = 0;
    for i = 1:count
        tile = images(i);
        if size(size(tile), "*") == 2 then tile = gray2rgb(im2uint8(tile)); else tile = im2uint8(tile); end
        tiles(i) = tile;
        tileHeight = max(tileHeight, size(tile, 1));
        tileWidth = max(tileWidth, size(tile, 2));
    end
    mosaic = uint8(zeros(tileRows * tileHeight, tileCols * tileWidth, 3));
    for i = 1:count
        tile = tiles(i);
        if size(tile, 1) <> tileHeight | size(tile, 2) <> tileWidth then tile = imresize(tile, [tileHeight tileWidth]); end
        r = floor((i - 1) / tileCols) * tileHeight + 1;
        c = modulo(i - 1, tileCols) * tileWidth + 1;
        mosaic(r:r + tileHeight - 1, c:c + tileWidth - 1, :) = tile;
    end
endfunction
