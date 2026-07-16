function out = imbwdist(image, metric)
    // Distance to the nearest background pixel.
    rhs = argn(2);
    if rhs < 1 | rhs > 2 then error("imbwdist: invalid arguments."); end
    if size(size(image), "*") <> 2 then error("imbwdist: a 2D image is required."); end
    if rhs < 2 then metric = "euclidean"; end
    method = 2;
    if typeof(metric) == "string" then
        select convstr(metric, "l")
        case "cityblock" then method = 1;
        case "euclidean" then method = 2;
        case "chessboard" then method = 3;
        else error("imbwdist: metric must be cityblock, euclidean, or chessboard.");
        end
    else
        method = round(metric);
        if method < 1 | method > 3 then error("imbwdist: numeric metric must be 1, 2, or 3."); end
    end
    if typeof(image) == "boolean" then
        mask = image;
    else
        mask = image <> 0;
    end

    out = int_imdistransf(mask, method);
endfunction
