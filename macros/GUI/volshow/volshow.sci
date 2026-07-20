//=============================================================================
// IPCV - Interactive GPU volume viewer
//=============================================================================
function viewer = volshow(source, options, info)
    function defaults = volshow_defaults()
        defaults = struct( ..
            "RenderingStyle", "volume", ..
            "Colormap", "gray", ..
            "Opacity", 0.65, ..
            "Threshold", 0.16, ..
            "Quality", 192, ..
            "Window", [%nan %nan], ..
            "VoxelSpacing", [1 1 1], ..
            "Title", "IPCV Volume Viewer");
    endfunction

    function target = volshow_merge_options(target, sourceOptions)
        names = fieldnames(sourceOptions);
        for fieldIndex = 1:size(names, "*")
            name = names(fieldIndex);
            if isfield(target, name) then
                target(name) = sourceOptions(name);
            end
        end
    endfunction

    function tf = volshow_is_metadata(value)
        tf = isfield(value, "PixelSpacing") | isfield(value, "SliceThickness") | ..
            isfield(value, "SpacingBetweenSlices") | isfield(value, "Modality") | ..
            isfield(value, "PhotometricInterpretation");
    endfunction

    function text = volshow_scalar_string(value)
        text = msprintf("%.12g", value);
    endfunction

    rhs = argn(2);
    if rhs < 1 | rhs > 3 then
        error("volshow: expected source and optional options and DICOM info.");
    end

    metadata = struct();
    settings = volshow_defaults();
    if type(source) == 10 then
        if size(source, "*") <> 1 then
            error("volshow: source filename must be a scalar string.");
        end
        [volume, metadata] = dicomread(source);
        settings.Title = "IPCV DICOM Volume Viewer";
    else
        volume = source;
    end

    if rhs >= 2 then
        if typeof(options) <> "st" then
            error("volshow: options must be a structure.");
        end
        if volshow_is_metadata(options) then
            metadata = options;
        else
            settings = volshow_merge_options(settings, options);
        end
    end
    if rhs >= 3 then
        if typeof(info) <> "st" then
            error("volshow: DICOM info must be a structure.");
        end
        metadata = info;
    end

    if size(size(volume), "*") <> 3 then
        error("volshow: source must be a 3-D scalar volume.");
    end
    if or(size(volume) <= 0) then
        error("volshow: source volume must not be empty.");
    end

    if type(settings.RenderingStyle) <> 10 | size(settings.RenderingStyle, "*") <> 1 then
        error("volshow: RenderingStyle must be a scalar string.");
    end
    style = convstr(settings.RenderingStyle, "l");
    if style == "volumerendering" then style = "volume"; end
    if style == "maximumintensityprojection" then style = "mip"; end
    if style == "sliceplanes" then style = "slices"; end
    if style == "slice" | style == "2-d" then style = "2d"; end
    if ~or(style == ["volume" "mip" "isosurface" "slices" "2d"]) then
        error("volshow: RenderingStyle must be volume, mip, isosurface, slices, or 2d.");
    end
    colormapName = convstr(settings.Colormap, "l");
    if ~or(colormapName == ["gray" "bone" "hot" "turbo"]) then
        error("volshow: Colormap must be gray, bone, hot, or turbo.");
    end
    if size(settings.Opacity, "*") <> 1 | size(settings.Threshold, "*") <> 1 | ..
            size(settings.Quality, "*") <> 1 then
        error("volshow: Opacity, Threshold, and Quality must be scalar.");
    end
    opacity = min(max(double(settings.Opacity), 0.01), 2);
    threshold = min(max(double(settings.Threshold), 0), 1);
    quality = min(max(round(double(settings.Quality)), 32), 256);

    windowRange = double(matrix(settings.Window, 1, -1));
    if size(windowRange, "*") <> 2 then
        error("volshow: Window must contain [low high].");
    end
    spacing = double(matrix(settings.VoxelSpacing, 1, -1));
    if size(spacing, "*") <> 3 | or(spacing <= 0) | or(isnan(spacing)) then
        error("volshow: VoxelSpacing must contain three positive values.");
    end

    invert = %f;
    modality = "";
    description = "";
    spacingSource = "VoxelSpacing option";
    if typeof(metadata) == "st" then
        if isfield(metadata, "PixelSpacing") then
            if size(metadata.PixelSpacing, "*") >= 2 then
                pixelSpacing = double(matrix(metadata.PixelSpacing, 1, -1));
                if ~or(isnan(pixelSpacing(1:2))) & and(pixelSpacing(1:2) > 0) then
                    spacing(1:2) = pixelSpacing(1:2);
                    spacingSource = "DICOM PixelSpacing + VoxelSpacing Z";
                end
            end
        end
        spacingSet = %f;
        if isfield(metadata, "SpacingBetweenSlices") then
            if ~isnan(metadata.SpacingBetweenSlices) & metadata.SpacingBetweenSlices > 0 then
                spacing(3) = metadata.SpacingBetweenSlices;
                spacingSet = %t;
                spacingSource = "DICOM PixelSpacing + SpacingBetweenSlices";
            end
        end
        if ~spacingSet & isfield(metadata, "SliceThickness") then
            if ~isnan(metadata.SliceThickness) & metadata.SliceThickness > 0 then
                spacing(3) = metadata.SliceThickness;
                spacingSource = "DICOM PixelSpacing + SliceThickness";
            end
        end
        if isfield(metadata, "WindowCenter") then
            if isfield(metadata, "WindowWidth") then
                if ~isnan(metadata.WindowCenter) & ~isnan(metadata.WindowWidth) & ..
                        metadata.WindowWidth > 0 & or(isnan(windowRange)) then
                    windowRange = [metadata.WindowCenter - metadata.WindowWidth / 2, ..
                        metadata.WindowCenter + metadata.WindowWidth / 2];
                end
            end
        end
        if isfield(metadata, "PhotometricInterpretation") then
            invert = convstr(metadata.PhotometricInterpretation, "u") == "MONOCHROME1";
        end
        if isfield(metadata, "Modality") then modality = metadata.Modality; end
        if isfield(metadata, "SeriesDescription") then
            description = metadata.SeriesDescription;
        elseif isfield(metadata, "StudyDescription") then
            description = metadata.StudyDescription;
        end
    end

    [dataUri, textureDimensions, intensityRange] = ..
        int_volshowencode(volume, quality, windowRange, bool2s(invert));
    sourceDimensions = [size(volume, 1) size(volume, 2) size(volume, 3)];
    physicalSize = [sourceDimensions(2) * spacing(2), ..
        sourceDimensions(1) * spacing(1), sourceDimensions(3) * spacing(3)];

    global IPCV_VOLSHOW_SOURCE_VOLUME;
    global IPCV_VOLSHOW_ORIGINAL_VOLUME;
    global IPCV_VOLSHOW_PREVIOUS_VOLUME;
    global IPCV_VOLSHOW_ENCODE_QUALITY;
    global IPCV_VOLSHOW_LAST_EXPORT_NAME;
    global IPCV_VOLSHOW_LAST_EXPORT_LAYER;
    IPCV_VOLSHOW_SOURCE_VOLUME = volume;
    IPCV_VOLSHOW_ORIGINAL_VOLUME = volume;
    IPCV_VOLSHOW_PREVIOUS_VOLUME = [];
    IPCV_VOLSHOW_ENCODE_QUALITY = quality;
    IPCV_VOLSHOW_LAST_EXPORT_NAME = "";
    IPCV_VOLSHOW_LAST_EXPORT_LAYER = [];

    guiDirectory = fullpath(getIPCVpath() + "/macros/GUI/volshow/");
    templateFile = guiDirectory + "volshow.html";
    if ~isfile(templateFile) then
        error("volshow: GUI HTML file not found: " + templateFile);
    end

    runtimeDirectory = tempname("ipv");
    if isfile(runtimeDirectory) then mdelete(runtimeDirectory); end
    mkdir(runtimeDirectory);
    if ~isdir(runtimeDirectory) then
        error("volshow: could not create the temporary runtime directory.");
    end
    runtimeHtml = fullfile(runtimeDirectory, "volshow.html");
    payloadFile = fullfile(runtimeDirectory, "volshow_payload.js");
    payload = struct( ..
        "dataUri", dataUri, ..
        "sourceDimensions", sourceDimensions, ..
        "textureDimensions", textureDimensions, ..
        "physicalSize", physicalSize, ..
        "spacing", spacing, ..
        "spacingSource", spacingSource, ..
        "intensityRange", intensityRange, ..
        "style", style, ..
        "colormap", colormapName, ..
        "opacity", opacity, ..
        "threshold", threshold, ..
        "title", settings.Title, ..
        "modality", modality, ..
        "description", description);
    mputl("window.IPCV_VOLSHOW_PAYLOAD = " + toJSON(payload) + ";", payloadFile);
    htmlLines = mgetl(templateFile);
    htmlLines = strsubst(htmlLines, "__IPCV_VOLSHOW_PAYLOAD__", "volshow_payload.js");
    mputl(htmlLines, runtimeHtml);

    old = findobj("tag", "ipcv_volshow");
    if old <> [] then
        delete(old);
    end
    figureHandle = figure( ..
        "figure_name", settings.Title, ..
        "infobar_visible", "off", ..
        "toolbar_visible", "off", ..
        "dockable", "off", ..
        "menubar", "none", ..
        "default_axes", "off", ..
        "position", [55 45 1240 820], ..
        "layout", "border", ..
        "tag", "ipcv_volshow", ..
        "visible", "off");
    frame = uicontrol(figureHandle, ..
        "style", "frame", ..
        "backgroundcolor", [0.07 0.08 0.09], ..
        "layout", "border");
    uicontrol(frame, ..
        "style", "browser", ..
        "debug", "off", ..
        "string", runtimeHtml, ..
        "callback", "ipcv_volshow_callback", ..
        "tag", "ipcv_volshow_browser");
    figureHandle.visible = "on";

    viewer = struct( ..
        "Figure", figureHandle, ..
        "SourceDimensions", sourceDimensions, ..
        "TextureDimensions", textureDimensions, ..
        "IntensityRange", intensityRange, ..
        "VoxelSpacing", spacing, ..
        "PhysicalSize", physicalSize, ..
        "RenderingStyle", style, ..
        "RuntimeDirectory", runtimeDirectory);
endfunction
