function mask = poly2mask(x, y, rows, cols)
    // Rasterize a polygon using image row/column coordinates.
    if argn(2) <> 4 then error("poly2mask requires x, y, rows, and cols."); end
    if size(x, "*") <> size(y, "*") | size(x, "*") < 3 then error("x and y must contain at least three matching vertices."); end
    if type(rows) <> 1 | type(cols) <> 1 | rows < 1 | cols < 1 then error("rows and cols must be positive scalars."); end
    mask = zeros(round(rows), round(cols)) == 1;
    vertexCount = size(x, "*");
    for row = 1:round(rows)
        for col = 1:round(cols)
            inside = %f;
            previous = vertexCount;
            for current = 1:vertexCount
                crosses = (y(current) > row) <> (y(previous) > row);
                if crosses then
                    crossingCol = (x(previous) - x(current)) * (row - y(current)) / (y(previous) - y(current)) + x(current);
                    if col < crossingCol then inside = ~inside; end
                end
                previous = current;
            end
            mask(row, col) = inside;
        end
    end
endfunction
