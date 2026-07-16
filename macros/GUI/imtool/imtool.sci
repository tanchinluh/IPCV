//=============================================================================
// IPCV - Scilab Image Processing and Computer Vision toolbox
// Browser-based image and video inspection tool
//=============================================================================
function imtool(image)
    rhs = argn(2);
    if rhs > 1 then
        error("imtool: Wrong number of input arguments.");
    end

    global IPCV_IMTOOL_INITIAL_FILE;
    global IPCV_IMTOOL_INITIAL_VIDEO;
    global IPCV_IMTOOL_VIDEO_HANDLE;
    global IPCV_IMTOOL_VIDEO_FRAME_FILE;
    global IPCV_IMTOOL_RECORD_ACTIVE;
    global IPCV_IMTOOL_RECORD_FILE;
    global IPCV_IMTOOL_RECORD_FRAMES;
    IPCV_IMTOOL_INITIAL_FILE = "";
    IPCV_IMTOOL_INITIAL_VIDEO = "";
    if IPCV_IMTOOL_VIDEO_HANDLE == [] then
        IPCV_IMTOOL_VIDEO_HANDLE = -1;
    end
    if IPCV_IMTOOL_VIDEO_FRAME_FILE == [] then
        IPCV_IMTOOL_VIDEO_FRAME_FILE = "";
    end
    if IPCV_IMTOOL_RECORD_ACTIVE == [] then
        IPCV_IMTOOL_RECORD_ACTIVE = %f;
        IPCV_IMTOOL_RECORD_FILE = "";
        IPCV_IMTOOL_RECORD_FRAMES = 0;
    end

    if rhs == 1 then
        if typeof(image) == "string" then
            if size(image, "*") <> 1 then
                error("imtool: The media filename must be a scalar string.");
            end
            if ~isfile(image) then
                error("imtool: Media file not found: " + image);
            end
            [media_path, media_name, media_extension] = fileparts(image);
            video_extensions = [".mp4" ".m4v" ".mov" ".mkv" ".webm" ".avi" ".mpg" ".mpeg" ".wmv" ".hevc" ".h265"];
            if or(convstr(media_extension, "l") == video_extensions) then
                IPCV_IMTOOL_INITIAL_VIDEO = fullpath(image);
            else
                IPCV_IMTOOL_INITIAL_FILE = fullpath(image);
            end
        else
            IPCV_IMTOOL_INITIAL_FILE = tempname("ipc") + ".png";
            imwrite(image, IPCV_IMTOOL_INITIAL_FILE);
        end
    end

    gui_dir = fullpath(getIPCVpath() + "/macros/GUI/imtool/");
    html_file = gui_dir + "imtool.html";

    if ~isfile(html_file) then
        error("imtool: GUI HTML file not found: " + html_file);
    end
    runtime_html = tempname("ipc") + ".html";
    copyfile(html_file, runtime_html);

    old = findobj("tag", "ipcv_imtool");
    if old <> [] then
        set(old, "visible", "on");
        browser = findobj("tag", "ipcv_imtool_browser");
        if browser <> [] then
            set(browser, "string", runtime_html);
        end
        return;
    end

    f = figure( ...
        "figure_name", "IPCV Image Tool", ...
        "infobar_visible", "off", ...
        "toolbar_visible", "off", ...
        "dockable", "off", ...
        "menubar", "none", ...
        "default_axes", "off", ...
        "position", [60 60 1180 780], ...
        "layout", "border", ...
        "tag", "ipcv_imtool", ...
        "visible", "off");

    frame = uicontrol(f, ...
        "style", "frame", ...
        "backgroundcolor", [1 1 1], ...
        "layout", "border");

    uicontrol(frame, ...
        "style", "browser", ...
        "debug", "off", ...
        "string", runtime_html, ...
        "callback", "ipcv_imtool_callback", ...
        "tag", "ipcv_imtool_browser");

    f.visible = "on";
endfunction
