function json = ipcv_imtool_video_frame_json(frame_index)
    global IPCV_IMTOOL_VIDEO_HANDLE;
    global IPCV_IMTOOL_VIDEO_FRAME_FILE;
    global IPCV_IMTOOL_VIDEO_FRAME_COUNT;
    global IPCV_IMTOOL_VIDEO_GENERATION;

    if IPCV_IMTOOL_VIDEO_HANDLE <= 0 then
        json = ipcv_imtool_status_json("error", "No native video is open.");
        return;
    end

    frame_index = max(1, min(IPCV_IMTOOL_VIDEO_FRAME_COUNT, round(frame_index)));
    next_frame_file = tempname("ipc") + ".png";
    try
        uri = int_imvideoexportframe(IPCV_IMTOOL_VIDEO_HANDLE, frame_index, next_frame_file);
    catch
        if isfile(next_frame_file) then
            mdelete(next_frame_file);
        end
        json = ipcv_imtool_status_json("error", "OpenCV could not read frame " + string(frame_index) + ": " + lasterror());
        return;
    end

    if isfile(next_frame_file) then
        mdelete(next_frame_file);
    end
    IPCV_IMTOOL_VIDEO_FRAME_FILE = "";

    IPCV_IMTOOL_VIDEO_GENERATION = IPCV_IMTOOL_VIDEO_GENERATION + 1;
    json = "{" + ..
        """status"":""ok""," + ..
        """frame"":" + msprintf("%d", frame_index) + "," + ..
        """uri"":""" + ipcv_imtool_json_escape(uri) + """" + ..
        "}";
endfunction
