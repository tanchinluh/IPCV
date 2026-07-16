function json = ipcv_imtool_record_start_json(source_fps, speed)
    global IPCV_IMTOOL_RECORD_ACTIVE;
    global IPCV_IMTOOL_RECORD_FILE;
    global IPCV_IMTOOL_RECORD_FRAMES;

    ipcv_imtool_record_release();
    filename = uiputfile( ..
        ["*.mp4", "MP4 video"; "*.avi", "AVI video"], ..
        "", ..
        "Save IPCV analysis recording");
    if isempty(filename) then
        json = ipcv_imtool_status_json("cancel", "Recording cancelled.");
        return;
    end

    [record_path, record_name, record_extension] = fileparts(filename);
    if record_extension == "" then
        filename = filename + ".mp4";
    end
    filename = fullpath(filename);
    output_fps = source_fps * speed;
    try
        int_imtoolrecord("start", filename, output_fps);
    catch
        json = ipcv_imtool_status_json("error", "Could not start recording: " + lasterror());
        return;
    end

    IPCV_IMTOOL_RECORD_ACTIVE = %t;
    IPCV_IMTOOL_RECORD_FILE = filename;
    IPCV_IMTOOL_RECORD_FRAMES = 0;
    json = "{" + ..
        """status"":""ok""," + ..
        """path"":""" + ipcv_imtool_json_escape(strsubst(filename, "\", "/")) + """," + ..
        """fps"":" + msprintf("%.12g", output_fps) + ..
        "}";
endfunction
