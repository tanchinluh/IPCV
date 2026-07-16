function json = ipcv_imtool_video_open_json(filename, frame_index)
    rhs = argn(2);
    if rhs < 2 then
        frame_index = 1;
    end
    global IPCV_IMTOOL_VIDEO_HANDLE;
    global IPCV_IMTOOL_VIDEO_FILENAME;
    global IPCV_IMTOOL_VIDEO_FRAME_FILE;
    global IPCV_IMTOOL_VIDEO_FRAME_COUNT;
    global IPCV_IMTOOL_VIDEO_WIDTH;
    global IPCV_IMTOOL_VIDEO_HEIGHT;
    global IPCV_IMTOOL_VIDEO_FPS;
    global IPCV_IMTOOL_VIDEO_GENERATION;

    ipcv_imtool_video_release();

    if filename == "" then
        filename = uigetfile("*", "", "Select a video for IPCV Image Tool", %f);
        if isempty(filename) then
            json = ipcv_imtool_status_json("cancel", "Video selection cancelled.");
            return;
        end
    end

    filename = fullpath(filename);
    try
        [frame_count, width, height, fps] = aviinfo(filename);
        handle = aviopen(filename);
    catch
        json = ipcv_imtool_status_json("error", "OpenCV could not decode this video: " + lasterror());
        return;
    end

    if fps <= 0 then
        fps = 30;
    end
    if frame_count <= 0 then
        frame_count = 1;
    end

    IPCV_IMTOOL_VIDEO_HANDLE = handle;
    IPCV_IMTOOL_VIDEO_FILENAME = filename;
    IPCV_IMTOOL_VIDEO_FRAME_FILE = "";
    IPCV_IMTOOL_VIDEO_FRAME_COUNT = round(frame_count);
    IPCV_IMTOOL_VIDEO_WIDTH = round(width);
    IPCV_IMTOOL_VIDEO_HEIGHT = round(height);
    IPCV_IMTOOL_VIDEO_FPS = fps;
    IPCV_IMTOOL_VIDEO_GENERATION = 0;
    [video_path, video_name, video_extension] = fileparts(filename);

    frame_index = max(1, min(IPCV_IMTOOL_VIDEO_FRAME_COUNT, round(frame_index)));
    frame_response = fromJSON(ipcv_imtool_video_frame_json(frame_index));
    if frame_response.status <> "ok" then
        ipcv_imtool_video_release();
        json = ipcv_imtool_status_json("error", "OpenCV could not decode the requested frame.");
        return;
    end
    normalized_filename = strsubst(filename, "\", "/");

    json = "{" + ..
        """status"":""ok""," + ..
        """name"":""" + ipcv_imtool_json_escape(video_name + video_extension) + """," + ..
        """path"":""" + ipcv_imtool_json_escape(normalized_filename) + """," + ..
        """frameCount"":" + msprintf("%d", IPCV_IMTOOL_VIDEO_FRAME_COUNT) + "," + ..
        """width"":" + msprintf("%d", IPCV_IMTOOL_VIDEO_WIDTH) + "," + ..
        """height"":" + msprintf("%d", IPCV_IMTOOL_VIDEO_HEIGHT) + "," + ..
        """fps"":" + msprintf("%.12g", IPCV_IMTOOL_VIDEO_FPS) + "," + ..
        """frame"":" + msprintf("%d", frame_response.frame) + "," + ..
        """uri"":""" + ipcv_imtool_json_escape(frame_response.uri) + """" + ..
        "}";
endfunction
