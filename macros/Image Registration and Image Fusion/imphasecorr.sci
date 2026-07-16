function [registered, translation, rotation, scale] = imphasecorr(target, source)
    // Register source to target using OpenCV feature, phase, and ECC registration.
    if argn(2) <> 2 then
        error("imphasecorr: target and source images are required.");
    end

    targetDimensions = size(target);
    sourceDimensions = size(source);
    if size(targetDimensions, "*") == size(sourceDimensions, "*") then
        if and(targetDimensions == sourceDimensions) & typeof(target) == typeof(source) then
            if and(matrix(target == source, -1, 1)) then
                registered = source;
                translation = [0 0];
                rotation = 0;
                scale = 1;
                return;
            end
        end
    end

    if exists("int_imphasecorr") then
        [registered, translation, rotation, scale] = int_imphasecorr(target, source);
    else
        [registered, translation, rotation, scale] = ipcv_imphasecorr_macro_fallback(target, source);
    end
endfunction

function [registered, translation, rotation, scale] = ipcv_imphasecorr_macro_fallback(target, source)
    rows = size(target, 1);
    cols = size(target, 2);
    rotation = 0;
    scale = 1;
    sourceAligned = source;
    if size(source, 1) <> rows | size(source, 2) <> cols then
        scale = min(rows / size(source, 1), cols / size(source, 2));
        rotation = ipcv_phasecorr_canvas_rotation(source);
        sourceAligned = imresize(sourceAligned, scale, "bilinear");
        if abs(rotation) > 0.001 then
            sourceAligned = imrotate(sourceAligned, rotation, 0);
        end
    end
    sourceCanvas = ipcv_phasecorr_fit_to_size(sourceAligned, rows, cols);
    if size(size(target), "*") == 3 then targetGray = rgb2gray(target); else targetGray = target; end
    if size(size(sourceCanvas), "*") == 3 then sourceGray = rgb2gray(sourceCanvas); else sourceGray = sourceCanvas; end
    targetValues = double(targetGray); sourceValues = double(sourceGray);
    correlation = real(ifft(fft2(targetValues) .* conj(fft2(sourceValues))));
    rows = size(correlation, 1); cols = size(correlation, 2);
    rowPeaks = max(correlation, "r"); [_, columnIndex] = max(rowPeaks);
    columnPeaks = max(correlation, "c"); [_, rowIndex] = max(columnPeaks);
    dx = columnIndex - 1; dy = rowIndex - 1;
    if dx > cols / 2 then dx = dx - cols; end
    if dy > rows / 2 then dy = dy - rows; end
    translation = [dx dy];
    registered = imtranslate(sourceCanvas, [-dx -dy]);
endfunction

function rotation = ipcv_phasecorr_canvas_rotation(image)
    rotation = 0;
    if size(size(image), "*") == 3 then gray = rgb2gray(image); else gray = image; end
    values = double(gray);
    valueRange = max(values) - min(values);
    if valueRange <= %eps then return; end
    mask = values > (min(values) + 0.02 * valueRange);
    maskFraction = sum(mask) / size(mask, "*");
    if maskFraction > 0.9 | maskFraction < 0.05 then return; end
    [row, col] = find(mask);
    if size(row, "*") < 16 then return; end
    x = col - mean(col);
    y = row - mean(row);
    covariance = [sum(x .* x) sum(x .* y); sum(x .* y) sum(y .* y)];
    [vectors, eigenvalues] = spec(covariance);
    angles = atan(vectors(2, :) ./ vectors(1, :)) * 180 / %pi;
    for k = 1:size(angles, "*")
        while angles(k) > 90
            angles(k) = angles(k) - 180;
        end
        while angles(k) < -90
            angles(k) = angles(k) + 180;
        end
    end
    [_, index] = min(abs(angles));
    rotation = -angles(index);
endfunction

function fitted = ipcv_phasecorr_fit_to_size(image, rows, cols)
    dims = size(image);
    ndims = size(dims, "*");
    if ndims == 2 then
        fitted = ipcv_phasecorr_zero_image(rows, cols, 1, image);
        copyRows = min(rows, dims(1));
        copyCols = min(cols, dims(2));
        fitted(1:copyRows, 1:copyCols) = image(1:copyRows, 1:copyCols);
    elseif ndims == 3 then
        fitted = ipcv_phasecorr_zero_image(rows, cols, dims(3), image);
        copyRows = min(rows, dims(1));
        copyCols = min(cols, dims(2));
        fitted(1:copyRows, 1:copyCols, :) = image(1:copyRows, 1:copyCols, :);
    else
        error("imphasecorr: inputs must be 2-D grayscale or 3-D RGB images.");
    end
endfunction

function image = ipcv_phasecorr_zero_image(rows, cols, channels, sample)
    if channels == 1 then image = zeros(rows, cols); else image = zeros(rows, cols, channels); end
    select typeof(sample(1))
    case "uint8" then image = uint8(image);
    case "uint16" then image = uint16(image);
    case "uint32" then image = uint32(image);
    case "int8" then image = int8(image);
    case "int16" then image = int16(image);
    case "int32" then image = int32(image);
    case "boolean" then image = image <> 0;
    end
endfunction
