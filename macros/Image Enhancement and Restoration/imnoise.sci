function out = imnoise(image, noiseType, param1, param2)
    // Add controlled synthetic noise while preserving the input image class.
    rhs = argn(2);
    if rhs < 2 | rhs > 4 then error("imnoise: image and noise type are required."); end
    if typeof(noiseType) <> "string" then error("imnoise: noise type must be a string."); end
    sourceType = typeof(image(1));
    values = im2double(image);
    kind = convstr(noiseType, "l");
    if kind == "salt and pepper" then kind = "salt & pepper"; end
    oldRandom = rand("info");
    select kind
    case "gaussian" then
        meanValue = 0; variance = 0.01;
        if rhs >= 3 then meanValue = param1; end
        if rhs >= 4 then variance = param2; end
        if size(meanValue, "*") <> 1 | size(variance, "*") <> 1 | variance < 0 then error("imnoise: Gaussian mean must be scalar and variance must be nonnegative."); end
        rand("normal");
        out = values + meanValue + sqrt(variance) .* rand(values);
    case "salt & pepper" then
        density = 0.05;
        if rhs >= 3 then density = param1; end
        if size(density, "*") <> 1 | density < 0 | density > 1 then error("imnoise: salt-and-pepper density must be in [0, 1]."); end
        rand("uniform");
        probability = rand(values);
        out = values;
        out(probability < density / 2) = 0;
        out(probability >= density / 2 & probability < density) = 1;
    case "speckle" then
        variance = 0.04;
        if rhs >= 3 then variance = param1; end
        if size(variance, "*") <> 1 | variance < 0 then error("imnoise: speckle variance must be nonnegative and scalar."); end
        rand("normal");
        out = values + values .* sqrt(variance) .* rand(values);
    case "localvar" then
        if rhs < 3 then error("imnoise: localvar requires a variance image."); end
        if rhs == 3 then
            if size(param1, 1) <> size(values, 1) | size(param1, 2) <> size(values, 2) then error("imnoise: local variance must match the image size."); end
            localVariance = param1;
        else
            if size(param1, "*") <> size(param2, "*") then error("imnoise: intensity and variance lookup vectors must match."); end
            if min(param2) < 0 then error("imnoise: lookup variances must be nonnegative."); end
            clipped = min(max(values, min(param1)), max(param1));
            localVariance = matrix(interp1(param1(:), param2(:), clipped(:)), size(values));
        end
        if min(localVariance) < 0 then error("imnoise: local variance must be nonnegative."); end
        rand("normal");
        out = values + sqrt(localVariance) .* rand(values);
    case "poisson" then
        // Normal approximation in normalized image units; exact integer Poisson
        // sampling is intentionally left to a future native random backend.
        rand("normal");
        out = values + sqrt(max(values, 0)) .* rand(values);
    else
        rand(oldRandom);
        error("imnoise: unsupported type. Use gaussian, salt & pepper, speckle, localvar, or poisson.");
    end
    rand(oldRandom);
    out = min(max(out, 0), 1);
    select sourceType
    case "uint8" then out = im2uint8(out);
    case "int8" then out = im2int8(out);
    case "uint16" then out = im2uint16(out);
    case "int16" then out = im2int16(out);
    case "int32" then out = im2int32(out);
    case "constant" then out = double(out);
    else error("imnoise: unsupported image class " + sourceType + ".");
    end
endfunction
