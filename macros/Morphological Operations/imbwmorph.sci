function out = imbwmorph(image, operation, iterations)
    // Dispatch common binary morphology operations through IPCV primitives.
    rhs = argn(2);
    if rhs < 2 then error("imbwmorph requires an image and operation."); end
    if rhs < 3 then iterations = 1; end
    if type(operation) <> 10 | size(operation, "*") <> 1 then error("operation must be a scalar string."); end
    if type(iterations) <> 1 | size(iterations, "*") <> 1 | iterations < 1 then error("iterations must be a positive scalar."); end
    mask = ipcv_binary_mask(image, "imbwmorph");
    operation = convstr(operation, "l");
    se = imcreatese("cross", 3, 3);
    select operation
    case "thin" then out = imbwthin(mask, "zhang-suen");
    case "skel" then out = imbwthin(mask, "zhang-suen");
    case "fill" then out = imfillholes(mask);
    case "erode" then out = double(imerode(mask, se, iterations)) <> 0;
    case "dilate" then out = double(imdilate(mask, se, iterations)) <> 0;
    case "open" then out = double(immorphologyex(mask, se, "open", iterations)) <> 0;
    case "close" then out = double(immorphologyex(mask, se, "close", iterations)) <> 0;
    case "tophat" then out = double(immorphologyex(mask, se, "tophat", iterations)) <> 0;
    case "bothat" then out = double(immorphologyex(mask, se, "blackhat", iterations)) <> 0;
    case "hitmiss" then out = imbwhitmiss(mask, se, iterations);
    else error("Unsupported operation. Use thin, skel, fill, erode, dilate, open, close, tophat, bothat, or hitmiss.");
    end
endfunction
