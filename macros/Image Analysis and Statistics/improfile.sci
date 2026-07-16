function [xCoordinates, yCoordinates, values] = improfile(image, points)
    // Sample image values along one or more line segments.
    if argn(2) <> 2 then error("improfile: explicit N-by-2 points are required."); end
    if size(points, 2) <> 2 | size(points, 1) < 2 then error("improfile: points must be an N-by-2 matrix of [x y] coordinates."); end
    rows = size(image, 1); cols = size(image, 2); dims = size(image); channels = 1;
    if size(dims, "*") == 3 then channels = dims(3); end
    xCoordinates = []; yCoordinates = []; values = [];
    for segment = 1:size(points, 1) - 1
        x0 = points(segment, 1); y0 = points(segment, 2); x1 = points(segment + 1, 1); y1 = points(segment + 1, 2);
        sampleCount = max(abs(x1 - x0), abs(y1 - y0)) + 1;
        xLine = round(linspace(x0, x1, sampleCount)); yLine = round(linspace(y0, y1, sampleCount));
        for sample = 1:sampleCount
            xi = min(max(xLine(sample), 1), cols); yi = min(max(yLine(sample), 1), rows);
            isNew = %t;
            if ~isempty(xCoordinates) then
                if xi == xCoordinates($) & yi == yCoordinates($) then isNew = %f; end
            end
            if isNew then
                xCoordinates($ + 1) = xi; yCoordinates($ + 1) = yi;
                if channels == 1 then
                    values($ + 1, 1) = double(image(yi, xi));
                else
                    pixel = matrix(image(yi, xi, :), 1, channels);
                    values($ + 1, :) = double(pixel);
                end
            end
        end
    end
    xCoordinates = matrix(xCoordinates, -1, 1); yCoordinates = matrix(yCoordinates, -1, 1);
endfunction
