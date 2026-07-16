function [xCoordinates, yCoordinates, zCoordinates, values] = improfile3(volume, points)
    // Sample a 3D volume along a polyline using nearest-neighbor samples.
    if argn(2) <> 2 then error("improfile3: volume and an N-by-3 point list are required."); end
    if size(size(volume), "*") <> 3 then error("improfile3: a 3D volume is required."); end
    if size(points, 2) <> 3 | size(points, 1) < 2 then error("improfile3: points must be an N-by-3 [x y z] matrix."); end
    rows = size(volume, 1); cols = size(volume, 2); slices = size(volume, 3);
    xCoordinates = []; yCoordinates = []; zCoordinates = []; values = [];
    for segment = 1:size(points, 1) - 1
        p0 = points(segment, :); p1 = points(segment + 1, :);
        sampleCount = max([abs(p1(1) - p0(1)), abs(p1(2) - p0(2)), abs(p1(3) - p0(3))]) + 1;
        xLine = round(linspace(p0(1), p1(1), sampleCount));
        yLine = round(linspace(p0(2), p1(2), sampleCount));
        zLine = round(linspace(p0(3), p1(3), sampleCount));
        for sample = 1:sampleCount
            xi = min(max(xLine(sample), 1), cols); yi = min(max(yLine(sample), 1), rows); zi = min(max(zLine(sample), 1), slices);
            isNew = %t;
            if ~isempty(xCoordinates) & xi == xCoordinates($) & yi == yCoordinates($) & zi == zCoordinates($) then isNew = %f; end
            if isNew then
                xCoordinates($ + 1) = xi; yCoordinates($ + 1) = yi; zCoordinates($ + 1) = zi;
                values($ + 1, 1) = double(volume(yi, xi, zi));
            end
        end
    end
    xCoordinates = matrix(xCoordinates, -1, 1); yCoordinates = matrix(yCoordinates, -1, 1); zCoordinates = matrix(zCoordinates, -1, 1);
endfunction
