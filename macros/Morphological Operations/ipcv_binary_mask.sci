function mask = ipcv_binary_mask(image, functionName)
    if typeof(image) == "boolean" then
        mask = image;
    else
        mask = image <> 0;
    end
    dims = size(mask);
    if size(mask, "*") == 0 | size(dims, "*") <> 2 then
        error(functionName + ": image must be a non-empty 2D image.");
    end
endfunction
