function props = imregionprops(labels)
    // Measure connected regions in a label image.
    //
    // Syntax
    //    props = imregionprops(labels)
    //
    // props is a Scilab list of structures with Area, Centroid, BoundingBox,
    // Perimeter, Extent, and PixelIdxList fields. Centroid and BoundingBox use
    // [x y] and [x y width height], with x increasing rightward and y downward.
    //
    // Examples
    //    image = imread(fullpath(getIPCVpath() + "/images/coins_gray.jpg"));
    //    mask = imthreshold(image, 100) > 0;
    //    [labels, count] = imconnectedcomponents(mask, 8);
    //    props = imregionprops(labels);
    //    disp(props(1).Area);
    //    imshow(imlabel2rgb(labels));
    //
    // See also
    //    imconnectedcomponents
    //    imarea
    //    imcentroid
    //    imbwboundaries
    //
    // Authors
    //    Tan Chin Luh
    //
    // History
    //    5.0.0: Function introduced.

    if argn(2) <> 1 then error("imregionprops: one label image is required."); end
    if size(size(labels), "*") <> 2 then error("imregionprops: labels must be a 2D matrix."); end
    count = max(matrix(double(labels), -1, 1));
    props = list();
    for i = 1:count
        mask = labels == i;
        [rows, cols] = find(mask);
        if isempty(rows) then continue; end
        area = size(rows, "*");
        minX = min(cols); maxX = max(cols); minY = min(rows); maxY = max(rows);
        width = maxX - minX + 1; height = maxY - minY + 1;
        p = struct("Area", area, ..
                   "Centroid", [mean(cols) mean(rows)], ..
                   "BoundingBox", [minX minY width height], ..
                   "Perimeter", imperimeter(mask), ..
                   "Extent", area / (width * height), ..
                   "PixelIdxList", rows + (cols - 1) * size(labels, 1));
        props(i) = p;
    end
endfunction
