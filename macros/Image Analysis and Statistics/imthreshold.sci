function [out, level] = imthreshold(image, level, mode, maxValue)
    // Apply fixed or automatic thresholding to a grayscale or RGB image.
    // Unlike imbinarize, this preserves OpenCV's numeric threshold modes.
    rhs = argn(2);
    if rhs < 2 then level = []; end
    if rhs < 3 then mode = "otsu"; end
    if rhs < 4 then maxValue = 255; end

    if typeof(level) == "string" then
        mode = level;
        level = [];
    end
    if typeof(mode) <> "string" | size(mode, "*") <> 1 then
        error("mode must be a scalar string.");
    end
    if type(maxValue) <> 1 | size(maxValue, "*") <> 1 | maxValue < 0 | maxValue > 255 then
        error("maxValue must be a scalar in the range 0 to 255.");
    end

    dims = size(image);
    if size(dims, "*") == 3 then
        if dims(3) <> 3 then
            error("image must be a 2D grayscale or M-by-N-by-3 RGB image.");
        end
        image = rgb2gray(image);
    elseif size(dims, "*") <> 2 then
        error("image must be a 2D grayscale or M-by-N-by-3 RGB image.");
    end
    image = im2uint8(image);

    mode = convstr(mode, "l");
    select mode
    case "binary" then modeValue = 0;
    case "binary_inv" then modeValue = 1;
    case "trunc" then modeValue = 2;
    case "tozero" then modeValue = 3;
    case "tozero_inv" then modeValue = 4;
    case "otsu" then modeValue = 8;
    case "triangle" then modeValue = 16;
    else
        error("Unsupported mode. Expected binary, binary_inv, trunc, tozero, tozero_inv, otsu, or triangle.");
    end

    automatic = modeValue == 8 | modeValue == 16;
    if automatic then
        rawLevel = 0;
    else
        if isempty(level) | type(level) <> 1 | size(level, "*") <> 1 | level < 0 | level > 1 then
            error("A normalized scalar level in the range 0 to 1 is required for fixed threshold modes.");
        end
        rawLevel = round(level * 255);
    end

    [out, usedLevel] = int_imthreshold(image, rawLevel, round(maxValue), modeValue);
    if automatic then
        level = usedLevel / 255;
    end
endfunction
