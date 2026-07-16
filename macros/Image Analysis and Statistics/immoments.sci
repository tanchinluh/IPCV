function moments = immoments(image)
    // Calculate raw and central moments of a grayscale image.
    if argn(2) <> 1 then error("immoments: one image input is required."); end
    values = im2double(image); if size(size(values), "*") == 3 then values = rgb2gray(values); end
    [rows, cols] = size(values); [x, y] = ndgrid(1:cols, 1:rows); weights = values';
    m00 = sum(matrix(weights, -1, 1)); if m00 <= %eps then moments = struct("M00", 0, "M10", 0, "M01", 0, "M20", 0, "M02", 0, "M11", 0, "Mu20", 0, "Mu02", 0, "Mu11", 0); return; end
    m10 = sum(matrix(x .* weights, -1, 1)); m01 = sum(matrix(y .* weights, -1, 1)); m20 = sum(matrix(x.^2 .* weights, -1, 1)); m02 = sum(matrix(y.^2 .* weights, -1, 1)); m11 = sum(matrix(x .* y .* weights, -1, 1));
    cx = m10 / m00; cy = m01 / m00; mu20 = sum(matrix((x - cx).^2 .* weights, -1, 1)); mu02 = sum(matrix((y - cy).^2 .* weights, -1, 1)); mu11 = sum(matrix((x - cx) .* (y - cy) .* weights, -1, 1));
    moments = struct("M00", m00, "M10", m10, "M01", m01, "M20", m20, "M02", m02, "M11", m11, "Mu20", mu20, "Mu02", mu02, "Mu11", mu11);
endfunction
