function layer = ipcv_volshow_extract_layer(volume, axisName, layerIndex)
    // Extract a full-resolution orthogonal layer from a scalar volume.
    if size(size(volume), "*") <> 3 then
        error("volshow: the export source must be a 3-D scalar volume.");
    end
    if type(axisName) <> 10 | size(axisName, "*") <> 1 then
        error("volshow: export axis must be axial, coronal, or sagittal.");
    end

    axisName = convstr(axisName, "l");
    layerIndex = round(layerIndex);
    select axisName
    case "axial" then
        if layerIndex < 1 | layerIndex > size(volume, 3) then
            error("volshow: axial layer index is outside the volume.");
        end
        layer = volume(:, :, layerIndex);
    case "coronal" then
        if layerIndex < 1 | layerIndex > size(volume, 1) then
            error("volshow: coronal layer index is outside the volume.");
        end
        layer = matrix(volume(layerIndex, :, :), size(volume, 2), size(volume, 3));
    case "sagittal" then
        if layerIndex < 1 | layerIndex > size(volume, 2) then
            error("volshow: sagittal layer index is outside the volume.");
        end
        layer = matrix(volume(:, layerIndex, :), size(volume, 1), size(volume, 3));
    else
        error("volshow: export axis must be axial, coronal, or sagittal.");
    end
endfunction
