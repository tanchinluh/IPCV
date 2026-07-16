function [bw, level] = imbinarize(image, method)
    // Convert an image to a boolean mask using fixed or automatic thresholding.
    // Use imthreshold when a numeric output or non-binary threshold mode is needed.
    rhs = argn(2);
    if rhs < 2 then
        method = "otsu";
    end

    if type(method) == 1 then
        if size(method, "*") <> 1 then
            error("The fixed threshold level must be a scalar.");
        end
        [thresholded, level] = imthreshold(image, method, "binary");
    elseif typeof(method) == "string" & size(method, "*") == 1 then
        method = convstr(method, "l");
        if method == "global" then method = "otsu"; end
        if method <> "otsu" & method <> "triangle" then
            error("method must be global, otsu, triangle, or a normalized scalar level.");
        end
        [thresholded, level] = imthreshold(image, [], method);
    else
        error("method must be global, otsu, triangle, or a normalized scalar level.");
    end
    bw = thresholded <> 0;
endfunction
