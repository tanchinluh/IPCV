function view = dicomshow(source, slices, infoMode, info)
    // Display selected DICOM frames with optional per-slice or general metadata.

    function metadata = dicomshow_default_info(volume)
        metadata = struct( ..
            "Filename", "", ..
            "Rows", size(volume, 1), ..
            "Columns", size(volume, 2), ..
            "Frames", size(volume, 3), ..
            "Modality", "", ..
            "PhotometricInterpretation", "MONOCHROME2", ..
            "WindowCenter", %nan, ..
            "WindowWidth", %nan, ..
            "PixelSpacing", [%nan %nan], ..
            "SliceThickness", %nan, ..
            "SpacingBetweenSlices", %nan, ..
            "RescaleSlope", 1, ..
            "RescaleIntercept", 0, ..
            "RescaleApplied", %f, ..
            "SeriesDescription", "", ..
            "StudyDescription", "", ..
            "TransferSyntaxUID", "");
    endfunction

    function image = dicomshow_window(frame, metadata, globalLow, globalHigh)
        low = globalLow;
        high = globalHigh;
        if isfield(metadata, "WindowCenter") & isfield(metadata, "WindowWidth") then
            if ~isnan(metadata.WindowCenter) & ~isnan(metadata.WindowWidth) & metadata.WindowWidth > 0 then
                low = metadata.WindowCenter - metadata.WindowWidth / 2;
                high = metadata.WindowCenter + metadata.WindowWidth / 2;
            end
        end
        values = (double(frame) - low) / (high - low);
        values(find(values < 0)) = 0;
        values(find(values > 1)) = 1;
        image = uint8(round(values * 255));
        if isfield(metadata, "PhotometricInterpretation") then
            if convstr(metadata.PhotometricInterpretation, "u") == "MONOCHROME1" then
                image = uint8(255 - double(image));
            end
        end
    endfunction

    function lines = dicomshow_general_lines(metadata, volume)
        lines = ["DICOM information"; ..
            msprintf("Size: %d x %d x %d", size(volume, 1), size(volume, 2), size(volume, 3))];
        if isfield(metadata, "Modality") & metadata.Modality <> "" then
            lines($ + 1) = "Modality: " + metadata.Modality;
        end
        if isfield(metadata, "SeriesDescription") & metadata.SeriesDescription <> "" then
            lines($ + 1) = "Series: " + metadata.SeriesDescription;
        elseif isfield(metadata, "StudyDescription") & metadata.StudyDescription <> "" then
            lines($ + 1) = "Study: " + metadata.StudyDescription;
        end
        if isfield(metadata, "PixelSpacing") & size(metadata.PixelSpacing, "*") >= 2 then
            if ~or(isnan(metadata.PixelSpacing(1:2))) then
                lines($ + 1) = msprintf("Pixel spacing: %.4g x %.4g mm", metadata.PixelSpacing(1), metadata.PixelSpacing(2));
            end
        end
        if isfield(metadata, "SliceThickness") & ~isnan(metadata.SliceThickness) then
            lines($ + 1) = msprintf("Slice thickness: %.4g mm", metadata.SliceThickness);
        end
        if isfield(metadata, "TransferSyntaxUID") & metadata.TransferSyntaxUID <> "" then
            lines($ + 1) = "Transfer syntax:";
            lines($ + 1) = metadata.TransferSyntaxUID;
        end
        if isfield(metadata, "RescaleApplied") & metadata.RescaleApplied then
            lines($ + 1) = msprintf("Rescale: x %.4g + %.4g", metadata.RescaleSlope, metadata.RescaleIntercept);
        end
    endfunction

    rhs = argn(2);
    if rhs < 1 | rhs > 4 then
        error("dicomshow: expected source, optional slices, infoMode, and info.");
    end

    if type(source) == 10 then
        if size(source, "*") <> 1 then error("dicomshow: source filename must be scalar."); end
        [volume, metadata] = dicomread(source);
    else
        volume = source;
        if rhs >= 4 then metadata = info; else metadata = dicomshow_default_info(volume); end
    end
    if size(size(volume), "*") <> 3 then
        error("dicomshow: source must contain a 3-D scalar volume.");
    end

    frameCount = size(volume, 3);
    if rhs < 2 | slices == [] then slices = ceil(frameCount / 2); end
    if type(slices) <> 1 | ~isreal(slices) | size(slices, "*") < 1 then
        error("dicomshow: slices must be a numeric scalar or vector.");
    end
    slices = round(matrix(slices, 1, -1));
    if or(slices < 1) | or(slices > frameCount) then
        error(msprintf("dicomshow: slice indices must be between 1 and %d.", frameCount));
    end

    if rhs < 3 then infoMode = "slice"; end
    if type(infoMode) == 4 then
        if infoMode then infoMode = "slice"; else infoMode = "none"; end
    end
    if type(infoMode) <> 10 | size(infoMode, "*") <> 1 then
        error("dicomshow: infoMode must be none, slice, general, or a boolean.");
    end
    infoMode = convstr(infoMode, "l");
    if ~or(infoMode == ["none" "slice" "general"]) then
        error("dicomshow: infoMode must be none, slice, or general.");
    end

    finiteValues = matrix(double(volume), -1, 1);
    finiteValues = finiteValues(find(~isnan(finiteValues) & ~isinf(finiteValues)));
    if finiteValues == [] then error("dicomshow: volume has no finite values."); end
    globalLow = min(finiteValues);
    globalHigh = max(finiteValues);
    if globalHigh <= globalLow then globalHigh = globalLow + 1; end

    panelCount = size(slices, "*");
    if infoMode == "general" then panelCount = panelCount + 1; end
    gridRows = max(ceil(sqrt(panelCount)), 1);
    gridCols = ceil(panelCount / gridRows);

    figureHandle = scf();
    figureHandle.figure_name = "IPCV DICOM Viewer";
    displayed = list();
    for index = 1:size(slices, "*")
        sliceIndex = slices(index);
        image = dicomshow_window(volume(:, :, sliceIndex), metadata, globalLow, globalHigh);
        displayed(index) = image;
        subplot(gridRows, gridCols, index);
        imshow(image);
        if infoMode == "slice" then
            titleLines = msprintf("Slice %d / %d", sliceIndex, frameCount);
            if isfield(metadata, "Modality") & metadata.Modality <> "" then
                titleLines = [titleLines; metadata.Modality + " | " + msprintf("%d x %d", size(volume, 1), size(volume, 2))];
            end
            if isfield(metadata, "SpacingBetweenSlices") & ~isnan(metadata.SpacingBetweenSlices) then
                titleLines = [titleLines; msprintf("Frame spacing: %.4g mm", metadata.SpacingBetweenSlices)];
            elseif isfield(metadata, "SliceThickness") & ~isnan(metadata.SliceThickness) then
                titleLines = [titleLines; msprintf("Slice thickness: %.4g mm", metadata.SliceThickness)];
            end
            title(titleLines);
        elseif infoMode == "general" then
            title(msprintf("Slice %d / %d", sliceIndex, frameCount));
        end
    end

    if infoMode == "general" then
        subplot(gridRows, gridCols, panelCount);
        plot2d([], []);
        axesHandle = gca();
        axesHandle.axes_visible = "off";
        axesHandle.box = "off";
        axesHandle.data_bounds = [0 0; 1 1];
        lines = dicomshow_general_lines(metadata, volume);
        lineStep = min(0.1, 0.82 / max(size(lines, "*"), 1));
        for lineIndex = 1:size(lines, "*")
            xstring(0.05, 0.92 - (lineIndex - 1) * lineStep, lines(lineIndex));
        end
    end

    view = struct("Figure", figureHandle, "Slices", slices, ..
        "InfoMode", infoMode, "Info", metadata, "Images", displayed);
endfunction
