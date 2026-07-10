function mask = ipcv_binary_mask(image, functionName)
    dims = size(image);
    if size(image, "*") == 0 | size(dims, "*") <> 2 then
        error(functionName + ": image must be a non-empty 2D image.");
    end
    if typeof(image) == "boolean" then
        mask = image;
    else
        mask = zeros(dims(1), dims(2)) == 1;
        indices = find(image <> 0);
        if ~isempty(indices) then mask(indices) = %t; end
    end
endfunction
